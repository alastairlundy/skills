# Worked Example Session: SaaS Pricing Pivot

This fixture documents a canonical good session for the `grilling` skill. Use
it as reference material when evaluating whether an agent followed the
workflow correctly. Each step is annotated with the quality expectation it
satisfies.

## Context

User prompt (matches `tasks/trigger-vague-business-decision.yaml`):

> I run a small SaaS and I'm not sure whether to keep our flat $20/month
> pricing or pivot to a per-seat model. There are trade-offs in both
> directions. Help me think it through.

**Trigger outcome:** `trigger` — vague business strategy decision, no spec,
not code/tech and not domain modeling, goal is decision extraction.

## Pre-Grilling Baseline

Before the first question, the agent should:

1. **Load the references.** Read all six reference files in full:
   `decision-ledger.md`, `options-format.md`, `recommendation-format.md`,
   `locked-question-format.md`, `tone-and-output.md`, `convergence-test.md`.
2. **Decision Ledger state summary.** Scan `docs/decisions/DECISIONS-*.md`
   for any existing ledger on pricing. If found, summarize the highest
   `Dxxx` number and any unresolved contradictions. If none, derive the
   path (e.g., `docs/decisions/DECISIONS-saas-pricing.md`) and confirm
   with the user before the first append.
3. **Goal discovery.** Ask the goal-discovery question: "What are your
   goals for this idea?" The user may provide one goal or multiple goals.
   Record the response as D001 (the goal record) in the Decision Ledger.

A compliant opener:

> No existing Decision Ledger on pricing — fresh file at
> `docs/decisions/DECISIONS-saas-pricing.md`. Confirm the path and I'll
> open Branch A.
>
> **What are your goals for this idea?** You may provide one goal or
> multiple goals.

**User:** I want to find a pricing model that supports growth without
alienating our existing small-business customers.

> Recorded as D001 in `docs/decisions/DECISIONS-saas-pricing.md`.

## Branch A — Pricing model

**Agent (turn 1):**

- **Goal**: find a pricing model that supports growth without alienating
  existing small-business customers (D001).
- **Prior decisions**: D001 established the session goal.
- **Stakes**: the choice determines whether the SaaS can scale revenue
  while retaining the SMB segment.
- **Scope**: this decision covers the pricing model structure; it does
  not cover the specific price points or threshold values.

**What are you working toward in this decision?**

**User:** I want to capture expansion revenue from growing teams without
pricing out solo buyers.

**For D002 – pricing model: required — state your answer before the LLM
presents options. You may also pick an option, or provide your answer.**

**User:** I'm leaning toward a hybrid model with a flat base and per-seat
above a threshold.

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

- **Option 1 — Flat subscription.** What it is: a single monthly fee per account regardless of seats. Benefit: simplest plan to explain, lowest sales friction. Cost: under-monetizes teams and creates seat-sharing workarounds. Risk: revenue ceiling per account; weak expansion story for the SaaS's growth phase.
- **Option 2 — Per-seat pricing.** What it is: charge per active user per month, tiered by feature. Benefit: aligns price to value delivered, scales revenue with account growth. Cost: every new "user" becomes a procurement conversation; risk of seat-stuffing complaints. Risk: friction at the bottom of the market (solo buyers priced out).
- **Option 3 — Hybrid (flat base + per-seat above threshold).** What it is: flat fee for the first N seats, per-seat beyond N. Benefit: protects the solo/SMB segment while capturing expansion. Cost: two concepts to explain in the pricing page. Risk: more configuration in the billing system; harder to forecast.

`Recommendation: Option 3 — Hybrid (flat base + per-seat above threshold).`
`Reasoning: a hybrid model aligns with your goal of capturing expansion
revenue from growing teams while retaining solo buyers — the flat base
protects the SMB segment, and the per-seat tier captures growth.`
`Forward risk: if the billing system cannot model a threshold cleanly,
the operational cost of Option 3 erodes the segment benefit; revisit in
Branch C.`

You can ask for the goal-aligned rejection rationale for the other
options.

**Quality expectations this turn satisfies:**

- Context block presented with all four mandatory elements (goal, prior
  decisions, stakes, scope), each one sentence, with ledger citations.
- Socratic elicitation question used the fixed phrasing: "What are you
  working toward in this decision?"
- Locked question line included the explicit required framing:
  `required — state your answer before the LLM presents options.`
- Options block preceded by the reference-set preamble.
- Three options, each with the four required fields (What it is, Benefit,
  Cost, Risk) at one sentence per field.
- Recommendation uses the three-field breakdown with the option name
  copied verbatim and goal-aligned reasoning.
- Post-pick reminder included: "You can ask for the goal-aligned
  rejection rationale for the other options."
- No evaluative opener ("Good", "Great", "Nice", etc.).
- No forbidden filler word.

## Record and Continue (gated step)

After the user picks Option 3, the agent runs the post-pick step. The
post-pick step is a **gated step**: the next branch must not open until
both the write and the read-back have succeeded.

1. Confirm the pick in one sentence.
2. Remind the user they can ask for the goal-aligned rejection rationale
   for the other options.
3. Issue a tool call to append a `D002` record to the Decision Ledger
   using the inline template (`Driver`, `Resolved Answer`,
   `Normalized Requirement`, `Constraints`). The write is **bound to a
   successful tool-call result** — a narrative statement that the
   file was updated is not a write.
4. **Read-back verification.** After the tool call returns success,
   re-read the ledger file and confirm the new `D002` line is the
   last record in the file (tolerating benign differences such as
   trailing newlines and byte-order). The next branch must not open
   until the read-back confirms the new record is last.
5. Open Branch B without re-asking what the user just said.

A compliant continuation (the `(tool call: ...)` and `(read-back: ...)`
lines are illustrative of the agent's actions, not user-facing text):

> Resolved: Option 3 — Hybrid (flat base + per-seat above threshold).
> You can ask for the goal-aligned rejection rationale for the other
> options.
>
> *(tool call: append `D002` block to
> `docs/decisions/DECISIONS-saas-pricing.md` — tool returned success)*
>
> *(read-back: re-read the file; `D002` is the last `### [Dxxx]`
> block. Verified.)*
>
> Recorded as `D002` in `docs/decisions/DECISIONS-saas-pricing.md`.

- **Goal**: find a pricing model that supports growth without alienating
  existing small-business customers (D001).
- **Prior decisions**: D002 established the hybrid pricing model.
- **Stakes**: the threshold value determines where the flat tier ends and
  per-seat pricing begins, affecting both SMB retention and expansion
  revenue.
- **Scope**: this decision covers the threshold value; it does not cover
  the per-seat price or feature tiering.

**What are you working toward in this decision?**

**User:** I want the threshold to be high enough that solo buyers and
small teams stay on the flat tier.

**For D003 – seat threshold for the flat tier: required — state your
answer before the LLM presents options. You may also pick an option, or
provide your answer.**

**Quality expectations this turn satisfies:**

- Post-pick step ran as a **gated step** and did not open Branch B
  until both the write and the read-back succeeded: (1) one-sentence
  confirmation, (2) reminder that the user can ask for the
  goal-aligned rejection rationale, (3) tool call to append the `D002`
  record (bound to a successful tool-call result), (4) read-back
  verification confirming `D002` is the last record in the file,
  (5) transition to Branch B.
- Decision Ledger record appended immediately after the resolution (no
  batching at session end).
- Branch transition uses the structural `Resolved:` opener (no praise,
  no neutral mirroring that paraphrases the answer).
- Next question follows the four-part locked question sequence: context
  block, Socratic elicitation question, locked question line with
  explicit required framing.

## Convergence Declaration

After all branches are resolved, the agent should:

1. Run the four-check convergence test from `references/convergence-test.md`:
   - All branches resolved.
   - No contradictions between resolved branches.
   - No new question in the last three turns.
   - Decision Ledger complete (one record per resolution, no missing `Dxxx`).
2. Declare convergence explicitly: "We have reached a shared understanding."
3. Offer the exit paths appropriate to the type of decision reached. For a
   resolved business decision with downstream action, the relevant exits are:
   - **Document the decision** — write a decision memo citing records as `DECISIONS-saas-pricing.md#D001`.
   - **Hand off to `code-implementation-grilling`** — if a spec/PRD needs to be authored to drive the billing-system implementation (the Branch C risk surfaces a real code/tech decision).
   - **Break into tickets or issues** — via `spec-to-tickets` (with the ledger) or `to-issues` for flat decomposition.

## Workflow Quality Checklist

When reviewing any `grilling` transcript, check each item against the output:

- [ ] All six reference files were loaded and read in full before the first user question.
- [ ] If any reference file was missing or unreadable, the session aborted and the missing file was reported to the user.
- [ ] Decision Ledger path was derived (or located) and confirmed with the user before the first write.
- [ ] Existing Decision Ledger state was summarized to the user before the first question.
- [ ] The goal-discovery question ("What are your goals for this idea?") was asked as Step 3, and the user's response was recorded as D001 (the goal record) in the Decision Ledger.
- [ ] One Decision Ledger record was appended immediately after every resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Driver`, `Resolved Answer`, `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID incremented from the highest existing one.
- [ ] Every record's `Driver` field captured the user's underlying principle or motivation, distinct from `Resolved Answer` (the what) and `Normalized Requirement` (the testable outcome).
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx` line in `Constraints` rather than amending the prior record.
- [ ] Every branch question followed the four-part locked question sequence: context block, Socratic elicitation question, locked question line with explicit required framing, options and recommendation.
- [ ] Every context block included all four mandatory elements (goal, prior decisions, stakes, scope), each one sentence, with ledger citations.
- [ ] Every Socratic elicitation question used the fixed phrasing: "What are you working toward in this decision?"
- [ ] Every locked question line included the explicit required framing: `required — state your answer before the LLM presents options.`
- [ ] Every options block was preceded by the reference-set preamble: "Here are options to help you refine or confirm your answer. Pick one, reject all, or hybridize."
- [ ] Every question offered all natural options (typically 2–4) with the four required fields (What it is, Benefit, Cost, Risk) at one sentence per field.
- [ ] Every recommendation used the three-field breakdown (`Recommendation: Option N — <name>.`, `Reasoning: ...`, `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every recommendation's `Reasoning` field was goal-aligned (not option-comparison), explaining why the recommended option serves the user's stated goal.
- [ ] The post-pick step ran as a **gated step** and did not open the next branch until both the write and the read-back succeeded: (1) one-sentence confirmation, (2) reminder that the user can ask for the goal-aligned rejection rationale, (3) tool call to append the `Dxxx` record (bound to a successful tool-call result — a narrative statement is not a write), (4) read-back verification confirming the new `Dxxx` is the last record in the file (tolerating benign differences such as trailing newlines and byte-order), (5) transition to the next branch.
- [ ] When the user asked for the recommendation rationale, the agent provided concise goal-aligned rejection reasoning for the other options (not option-comparison).
- [ ] When the user's goal changed mid-session, the change was documented as a new goal record with a `Supersedes: Dxxx` line linking to the prior goal record, open branches were re-asked, and the user was asked whether closed branches need revisiting.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn (`basically`, `essentially`, `actually`, `just`, `simply`, `in order to`, `it is important to note`, `it's worth noting`, `keep in mind`, `note that`, `needless to say`, `at the end of the day`, `when all is said and done`).
- [ ] Convergence was declared only when all four checks passed.
- [ ] No diverge mode occurred (no paraphrasing the verbatim answer, no skipping a branch, no bundling options, no accepting a contradictory answer without a `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path so downstream skills (memos, tickets, specialized grilling) can cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger file used the `filename#Dxxx` format (e.g., `DECISIONS-saas-pricing.md#D001`), not a bare `Dxxx` ID.
