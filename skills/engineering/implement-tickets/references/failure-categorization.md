# Failure Categorization and Routing

Per `DECISIONS-skills-ticket-implementer.md#D009`, every failure encountered
during a run is categorized and routed. The circuit breaker applies regardless
of category. This file is the source of truth for the categorization rules;
the SKILL workflow references it on first failure.

## The four categories

| Category    | Definition                                                                                  | Default route              |
|-------------|---------------------------------------------------------------------------------------------|----------------------------|
| transient   | Time-bounded environmental issue; expected to clear on retry.                               | Auto-retry (Phase 3.2).    |
| persistent  | Code-level or design-level issue; retrying without a change in input will fail identically. | Auto-skip with reason.     |
| dependency  | A prerequisite the ticket depends on is missing, broken, or not yet done.                   | Auto-skip; mark downstream.|
| ambiguous   | Failure does not fit the other three, or the message is too vague to route safely.          | Escalate to user.          |

The categories are mutually exclusive at decision time; one failure gets one
category. If two categories seem to fit, prefer the more specific one
(`dependency` over `persistent`; `persistent` over `transient`).

## Classification rules

Classify by **what caused the failure**, not by the failure message alone. Use
the table below as a deterministic lookup; the `Signal` column is what the
coordinator inspects, the `Category` column is the verdict.

### Transient

A failure is transient when all of the following hold:

- The error originated outside the code being changed (network, CI runner,
  package registry, file system race, process resource).
- The same command, run again with no other change, has a non-trivial
  probability of succeeding.
- No application logic in the diff explains the failure.

Signals that fall here:

- `ECONNRESET`, `ETIMEDOUT`, `ENOTFOUND`, `EAI_AGAIN` from network calls.
- `429 Too Many Requests`, `502 Bad Gateway`, `503 Service Unavailable`,
  `504 Gateway Timeout` from HTTP endpoints.
- `Unable to acquire lock`, `Another git process runs`, `index.lock exists`.
- `npm ERR! network`, `nuget ERR!`, `cargo: network failure` with no
  application-level cause.
- `Could not resolve host`, `Temporary failure in name resolution`.

### Persistent

A failure is persistent when the code being changed produces the error, and
re-running without a code change will not fix it. Signals that fall here:

- `TypeError`, `NullReferenceException`, `panic`, `SyntaxError`,
  `IndentationError`, `cannot find symbol`, `CS####` compiler errors.
- `Expected X, got Y` in test output where X and Y are both application values.
- `Schema validation failed`, `migration checksum mismatch`, `unmet peer
  dependency` between two packages the diff installed.
- The sub-agent returns `status: error` with a code-level message in `notes`.

### Dependency

A failure is a dependency failure when the ticket cannot proceed because
something it depends on is not in the expected state. Signals that fall here:

- A `Blocked by` ticket is missing from the run, has `status: skipped`, or
  has not been committed yet.
- A file or directory the ticket's `Files` context pointer names does not
  exist at the starting commit and was not produced by an earlier ticket in
  the run.
- A package, binary, or runtime the ticket assumes is not installed and not
  installable by the sub-agent's own workflow.
- The judge returns `reject-with-feedback` whose `feedback` cites a file or
  module the ticket does not own (cross-ticket contamination).

### Ambiguous

A failure is ambiguous when none of the above categories produce a confident
fit. The default for any unrecognized error is ambiguous. Examples:

- The sub-agent returns `status: error` with a free-form message that does
  not match any signal above.
- The judge returns `reject-with-ambiguity` (the judge has already decided
  the ticket is ambiguous; the coordinator's route is the same).
- A tool or command exits with a non-zero code and produces no stdout or
  stderr.
- Two categories seem to apply equally and the tie-breaker rules above do
  not resolve the conflict.

### Identity mismatch

A failure is an identity mismatch when the post-commit identity check
(referenced from `SKILL.md` Step 3.6) returns a non-match on the author
string or, for the co-author policy, on the `Co-authored-by:` trailer.

- Signal: the verbatim line `[DEVIATION] ticket=<id> author=<actual> expected=<expected>`.
- Category: `persistent`. A wrong identity is a real error; the same
  commit, re-run with the same inputs, will produce the same wrong
  identity. It is not transient.
- Route: `auto-skip with reason`. The run summary records the failure
  under `Failures` with `task: commit-identity-verify` and the deviation
  line as `signal`.
- Strike counter: increments on each occurrence; the circuit breaker
  applies per `SKILL.md` Step 4.

## Routing rules

Per `DECISIONS-skills-ticket-implementer.md#D009`:

| Category    | Route                                                                                                            | Strike cap before circuit breaker? |
|-------------|------------------------------------------------------------------------------------------------------------------|------------------------------------|
| transient   | Auto-retry. Up to 3 retries with exponential backoff (1s, 4s, 16s). On the 4th attempt, treat as persistent.     | Yes — 3 retries.                   |
| persistent  | Auto-skip. Record the failure in the run summary under `Failures` with the category and one-line reason.         | No — single attempt.               |
| dependency  | Auto-skip the failing ticket; mark every ticket in the DAG that depends on it as `blocked` in the run summary.   | No — single attempt.               |
| ambiguous   | Escalate to the user (Collaborative) or auto-skip with a recorded reason (Self-Contained).                       | No — single attempt.               |

The strike cap is per-ticket per-task. The circuit breaker (Phase 3.3) tracks
strikes across categories; once any task on a ticket exceeds `N` strikes
(default 3 per the SKILL's Phase 0 resolution), the ticket escalates or the
run aborts regardless of category.

## Recording

Every classification, the route taken, and the result of the route is recorded
in the run summary under `Failures` with this shape:

```
- ticket: <id>
  task: <sub-agent-dispatch | judge-call | commit | file-edit | other>
  category: <transient | persistent | dependency | ambiguous>
  signal: <verbatim error line, truncated to 200 chars>
  route: <auto-retry | auto-skip | mark-blocked | escalate>
  result: <recovered | skipped | escalated | circuit-broken>
  strikes: <n>
```

The shape is identical for transient retries that ultimately succeed or fail;
the `result` field tells the user which.

## Conflicts with other references

If a future revision of `references/conflict-resolution.md` introduces a
category that overlaps with this file (e.g., a "cross-batch conflict"
category), the two references must be updated together. The
`failure-categorization.md` is the source of truth for *task* failures; the
`conflict-resolution.md` is the source of truth for *merge* conflicts. They do
not overlap by design.
