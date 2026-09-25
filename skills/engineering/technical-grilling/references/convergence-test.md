# Convergence Test

Convergence is a per-round check. After the user resolves the last branch
in a round, the agent runs the six checks before opening the next round.
If all six pass, the agent may prompt for close-out rather than opening
the next round - the user is the final authority. The test is observable
in the recent exchange history and in the ledger file - not in the agent's
sense that things feel resolved.

## The six universal checks

The convergence test runs after the last branch in each round. All six
checks apply at every round boundary.

### 1. Implementability

Can a new contributor apply the change from the new D-record and its
Cites alone, without re-asking the originating user? Verify this
mechanically, not by impression: read the record's `Normalized
Requirement` and `Constraints` as a standalone implementer would, and
mark every load-bearing term the record leaves defined only by
this session's earlier conversation. Each marked term must be either
resolved on the record itself, captured in a cited record's
`Constraints`, or - if no record can carry it - re-open the branch and
tighten the record. "Defined by the conversation" is not an outcome;
the record must stand alone.

### 2. Enforceability

Are the new `Constraints` checkable by an objective mechanism - write
time, CI, lint, or an external test - rather than relying on agent
judgment? A constraint that is "be reasonable" or "use good judgment"
is not enforceable. Restate it as a checkable rule or relax it.

### 3. Internal consistency

Does the new D-record preserve every Constraint of every cited
prior record? Nothing in the new D-record may contradict a cited
`Dxxx`. If a contradiction appears, the agent surfaces a fixed
"Contradiction detected" callout and the branch
is re-opened with a Supersedes: `Dxxx` line in `Constraints`.
The user owns the resolution.

### 4. Format compliance

Is the new content under the format caps defined in the relevant
format references? Each format reference (options-format,
recommendation-format, locked-question-format, recording-decisions)
defines its own cap; the convergence check verifies the new content
sits under the cap the format reference requires.

### 5. Cross-record consistency

Do all `N` D-records fit together without internal contradictions? The
first four checks verify each record against the records it cites. The
cross-record check verifies the **set** against itself: every
implied consequence of any D-record holds across the whole ledger. If
two non-citing records imply mutually exclusive facts, the agent
surfaces a "Conflict detected" callout and re-opens the
later record with a Supersedes: `Dxxx` line.

### 6. Coverage

Every surface item maps to one of three outcomes: Resolved, Deferred,
or Out of scope. The decision surface and the outcomes are defined in
`references/coverage-sweep.md`. Verify with the walkthrough, item by
item: each spec section/functional requirement (or named goal-record
area) and each taxonomy category maps to a record citation, a
DEFERRED/DECLINED record with its fallback default, or a supported
out-of-scope entry. Any miss fails the check: open the missing branch,
record the explicit out-of-scope entry, or add the missing fallback
default, then re-run the check. This check audits the decisions the
skill never asked about - checks 1-5 audit the records that exist.

## Diverge modes

The convergence test is the *positive* bar. The following failure modes
are the *negative* bar - explicit divergences the agent must avoid.

- **Paraphrasing the verbatim answer.** The agent rewords what the user
  said instead of recording it as the Resolved Answer. The Decision
  Ledger captures the agent's summary, not the user's words.
- **Skipping a branch.** A branch is opened, but the agent moves on
  without resolving it or explicitly closing it. The branch has no
  `Dxxx` record.
- **Bundling options.** A 3-option question is asked as a 5-option
  question, or a 5-option question is asked as a 3-option one. The
  user sees a different decision space than the agent's working set.
- **Asking more than 3 questions in one turn.** The agent emits
  more than 3 locked questions in one round, or emits questions on
  unrelated decisions in one turn. Up to 3 branches in a single
  round is valid; beyond that, the user receives an overwhelming
  wall of questions.
- **Accepting a contradictory answer.** The user gives an answer that
  contradicts a previously resolved decision, and the agent accepts it
  without surfacing the "Contradiction detected" callout or
  creating a Supersedes: `Dxxx` record.
- **Treating clarification as resolution.** The user corrects the
  agent's understanding of an option's mechanics or meaning - e.g.,
  "Option B just adds a Start method; it doesn't encode a lifecycle"  - 
  and the agent treats the correction as a selection of that option.
  A clarification of what an option *is* is not a choice of which
  option to take. The agent must mirror the clarification and either
  continue probing remaining concerns or explicitly re-ask the locked
  question.
- **Close-out without the residual inventory.** The close-out prompt
  is emitted without the residual inventory table from
  `references/coverage-sweep.md`, or the user confirms close-out with
  surface items still mapping to no outcome (Resolved, Deferred, or
  Out of scope). The user's sign-off is uninformed in both cases.

The recovery for paraphrasing, skipping a branch, bundling options,
and asking more than 3 questions in one turn is to revisit the
affected branch and re-record. The recovery for accepting a
contradictory answer is to apply the conflict-detection mechanic:
surface the "Contradiction detected" callout, re-open with a
Supersedes: `Dxxx` record, and resolve explicitly. The recovery for
treating clarification as resolution is to mirror the clarification
and re-ask the locked question. The recovery for close-out without
the residual inventory is to emit the inventory - recording any
missing out-of-scope entries first - and re-present the close-out
prompt.

## Declaration

When all six checks pass at the end of a round, the agent may prompt
for close-out. The close-out prompt is invalid without the residual
inventory table from `references/coverage-sweep.md`. The user decides
whether to stop. Do not declare convergence based on intent or partial
progress.

## User sign-off (mandatory)

The LLM must never declare "converged" as a statement. It must
always present the convergence evidence as a question, accompanied by
the residual inventory:

"All six checks pass. [N] records are in the ledger. See the residual
inventory above; [K] items are Deferred or Out of scope. Ready to
close out, or shall we open the next round?"

The session remains open until the user explicitly confirms
close-out. A silence, a new question, or a follow-up request means
the session is not closed.
