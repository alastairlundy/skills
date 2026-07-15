# Judge Review Template

The prompt template below is sent to a fresh-context judge LLM after a
sub-agent finishes a dispatch unit. The judge reviews the sub-agent's diff
against the ticket's completion criteria and returns one of three verdicts per
`DECISIONS-skills-ticket-implementer.md#D008`: `approve`, `reject-with-feedback`,
or `reject-with-ambiguity`.

The judge has the same blind spots as the implementer per the D008 constraints;
the judge may miss subtle bugs. The judge is a second pass, not a guarantee.

## Variables

The coordinator fills these placeholders before sending the prompt:

- `<RUN_ID>` — the unique run id.
- `<TICKET_IDS>` — comma-separated ticket ids in the dispatch unit.
- `<NORMALIZED_TICKETS>` — the full normalized ticket body or bodies.
- `<COMPLETION_CRITERIA>` — the resolved criteria list (Acceptance criteria or
  Definition of Done).
- `<SUB_AGENT_RESPONSE>` — the verbatim structured response from the sub-agent
  (the `status` / `files_changed` / `criteria_check` / `notes` block).
- `<STAGING_DIFF>` — the staging area's `git diff <STARTING_COMMIT>..HEAD` for
  the dispatch unit, verbatim.
- `<PRIOR_FEEDBACK>` — empty on the first judge call; on re-dispatch after a
  prior rejection, the verbatim prior `reject-with-feedback` verdict so the
  judge can verify the feedback was addressed.

## Prompt

```
You are reviewing the work of a sub-agent that just implemented one or more
tickets. You have a fresh context; you did not see the implementation, only
the inputs below. Your job is to compare the sub-agent's diff against the
ticket's completion criteria and return a single verdict.

## Run id
<RUN_ID>

## Tickets
<TICKET_IDS>

## Ticket body
<NORMALIZED_TICKETS>

## Completion criteria
<COMPLETION_CRITERIA>

## Sub-agent's self-report
<SUB_AGENT_RESPONSE>

## Sub-agent's diff
<STAGING_DIFF>

## Prior feedback (empty on first review)
<PRIOR_FEEDBACK>

## How to decide

For each criterion in <COMPLETION_CRITERIA>:

1. Search the diff for the change that satisfies the criterion. If the criterion
   is behaviour-based (e.g., "the API returns 200 on success"), look for the
   code path that produces the behaviour and reason about whether it would
   actually produce it. The diff alone may not prove behaviour; use the
   ticket's test or verification step if present.
2. Classify the criterion as one of:
   - `met` — the diff clearly satisfies the criterion.
   - `unmet` — the diff clearly does not satisfy the criterion.
   - `partial` — the diff partially satisfies the criterion; note what's
     missing in your feedback.
   - `unverifiable-from-diff` — the criterion cannot be confirmed from the
     diff alone (e.g., runtime behaviour, UI output, external integration).
     Mark it `unverifiable-from-diff` and note what would be needed to verify.

## Verdicts

Return exactly one of:

- `approve` — every criterion is `met` or `unverifiable-from-diff`. The
  `unverifiable-from-diff` cases are acceptable for approve; they are not
  blocking. The coordinator's run summary will list them so the user can
  verify out-of-band.
- `reject-with-feedback` — at least one criterion is `unmet` or `partial` AND
  the gap is concrete enough that a re-dispatch can fix it. Provide specific,
  actionable feedback that tells the sub-agent what to change.
- `reject-with-ambiguity` — the gap is unclear from the diff and the
  ticket (e.g., the criterion is ambiguous, the diff introduces a behaviour
  the ticket does not specify, or the sub-agent's `notes` reveal a missing
  decision). The user must resolve the ambiguity before re-dispatch.

Do not invent a fourth verdict. Do not use `approve` when any criterion is
`unmet`.

## What to return

Return a single structured response, in plain text, in this exact shape:

```
verdict: approve | reject-with-feedback | reject-with-ambiguity
tickets: <TICKET_IDS>
criterion_results:
  - <criterion verbatim> — met | unmet | partial | unverifiable-from-diff
    evidence: <one-line: which file/line in the diff, or "needs runtime check">
  - <criterion verbatim> — met | unmet | partial | unverifiable-from-diff
    evidence: <one-line>
feedback: <if reject-with-feedback: numbered list of concrete, actionable
           changes the sub-agent should make on re-dispatch; if
           reject-with-ambiguity: the specific question or decision the user
           must resolve; if approve: empty>
unverifiable:
  - <criterion verbatim> — <one-line: what would be needed to verify>
notes: <free-form notes for the coordinator, including any deviation from
        the ticket's Recommended Workflow the sub-agent reported>
```

## Constraints

- One verdict per dispatch unit. Do not split.
- `feedback` is mandatory on rejections; it is the only signal the sub-agent
  gets on re-dispatch. Vague feedback ("looks wrong", "doesn't seem right")
  is a contract violation; do not return it.
- Do not propose new acceptance criteria. You are checking the existing ones.
- Do not propose refactors outside the ticket's scope. If you see
  out-of-scope improvements, put them in `notes`; do not include them in
  `feedback`.
```

## Coordinator-side validation

After the judge responds, the coordinator:

1. Verifies the verdict is one of the three valid values.
2. Verifies that every criterion in `<COMPLETION_CRITERIA>` appears in
   `criterion_results` exactly once.
3. On `reject-with-feedback`: confirms `feedback` is non-empty and each
   numbered item names a specific file, line, or change. If `feedback` is
   empty or vague, the coordinator treats the verdict as
   `reject-with-ambiguity` and surfaces it to the user.
4. On `reject-with-ambiguity`: surfaces the question to the user (Collaborative)
   or auto-skips with a recorded reason (Self-Contained).
5. Records the verdict, criterion results, and feedback in the per-ticket run
   summary, including for `unverifiable-from-diff` cases.
