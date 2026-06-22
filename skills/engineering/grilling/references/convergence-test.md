# Convergence Test

Convergence is the final step of the workflow. The session may declare a
shared understanding and offer exit paths only when all four checks below
hold. The test is observable in the recent exchange history and in the
ledger file — not in the agent's sense that things feel resolved.

## The four checks

### 1. All branches resolved

Every branch opened during the session has a recorded decision, or has
been explicitly closed by the user. A branch with no `Dxxx` record and
no explicit close is a silent skip; re-open it or close it before
declaring convergence.

### 2. No contradictions

Re-open any branch whose recorded decision contradicts another branch's
recorded decision, and resolve the contradiction first. A `Dxxx` record
that depends on a fact another `Dxxx` record denies is a contradiction.

### 3. No new question in the last three turns

The most recent three exchanges have not introduced a new branch,
surfaced a contradiction, or required a glossary revision. If a new
question or contradiction appeared in the last three turns, the session
is not yet convergent — continue grilling.

### 4. Decision Ledger complete

Read the Decision Ledger file and verify that every branch resolved
during this session has a corresponding `Dxxx` record, and that every
re-opened branch has a fresh `Supersedes: Dxxx` record. A branch that is
resolved in conversation but missing from the ledger is a silent loss;
re-open it, write the record, and re-verify before declaring
convergence. Do not allow convergence on the strength of conversational
memory alone.

## Declaration

When all four checks pass, declare: "We have reached a shared
understanding." Do not declare convergence based on intent or partial
progress.

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
- **Accepting a contradictory answer.** The user gives an answer that
  contradicts a previously resolved decision, and the agent accepts it
  without flagging the conflict or creating a `Supersedes: Dxxx` record.

The recovery for the first three is to revisit the affected branch and
re-record. The recovery for the fourth is to apply the supersede rule
(re-open gets a new `Dxxx`) and resolve the contradiction explicitly.
