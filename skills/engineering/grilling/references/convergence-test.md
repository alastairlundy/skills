# Convergence Test

Convergence is the final step of the workflow. The session may declare a
shared understanding and offer exit paths only when all checks for the
current cadence pass. The test is observable in the recent exchange
history and in the ledger file — not in the agent's sense that things
feel resolved.

## The four universal checks

The convergence test runs at two cadences with different bullet counts:

- **Per-item** — runs after each Address item is resolved. Four
  universal bullets.
- **End-of-grilling** — runs once after the last Address item. The
  four universal bullets plus the fifth cross-record consistency
  bullet.

### 1. Implementability

Can a new contributor apply the change from the new D-record and its
Cites alone, without re-asking the originating user? If the answer
requires session-specific context that the record and its Cites do
not capture, the change is not yet implementable — re-open the branch
and tighten the record.

### 2. Enforceability

Are the new `Constraints` checkable by an objective mechanism — write
time, CI, lint, or an external test — rather than relying on agent
judgment? A constraint that is "be reasonable" or "use good judgment"
is not enforceable. Restate it as a checkable rule or relax it.

### 3. Internal consistency

Does the new D-record preserve every `Constraint` of every cited
prior record? Nothing in the new D-record may contradict a cited
`Dxxx`. If a contradiction appears, the new record is rejected
automatically and the branch must be re-opened with a
`Supersedes: Dxxx` line in `Constraints` against the contradicted
record.

### 4. Format compliance

Is the new content under the format caps defined in the relevant
format references? Each format reference (options-format,
recommendation-format, locked-question-format, recording-decisions)
defines its own cap; the convergence check verifies the new content
sits under the cap the format reference requires.

## Fifth bullet (end-of-grilling only)

### 5. Cross-record consistency

Do all `N` D-records fit together without internal contradictions? The
per-item checks verify each record against the records it cites. The
end-of-grilling check verifies the **set** against itself: every
implied consequence of any D-record holds across the whole ledger. If
two non-citing records imply mutually exclusive facts, re-open the
later record and add a `Supersedes: Dxxx` line.

## Declaration

When all checks for the current cadence pass, declare: "We have
reached a shared understanding." Do not declare convergence based on
intent or partial progress.

## Diverge modes

The convergence test is the *positive* bar. The following failure modes
are the *negative* bar — explicit divergences the agent must avoid.

- **Paraphrasing the verbatim answer.** The agent rewords what the user
  said instead of recording it as the `Resolved Answer`. The Decision
  Ledger captures the agent's summary, not the user's words.
- **Skipping a branch.** A branch is opened, but the agent moves on
  without resolving it or explicitly closing it. The branch has no
  `Dxxx` record.
- **Bundling options.** A 3-option question is asked as a 5-option
  question, or a 5-option question is asked as a 3-option one. The
  user sees a different decision space than the agent's working set.
- **Asking multiple questions in one turn.** The agent emits more than
  one locked question before stopping. The user receives a wall of
  questions instead of a single focused prompt.
- **Accepting a contradictory answer.** The user gives an answer that
  contradicts a previously resolved decision, and the agent accepts it
  without flagging the conflict or creating a `Supersedes: Dxxx` record.

The recovery for the first four is to revisit the affected branch and
re-record. The recovery for the fifth is to apply the supersede rule
(re-open gets a new `Dxxx`) and resolve the contradiction explicitly.
