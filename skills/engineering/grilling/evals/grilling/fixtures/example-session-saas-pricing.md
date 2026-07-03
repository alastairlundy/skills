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

A compliant opener:

> No existing Decision Ledger on pricing — fresh file at
> `docs/decisions/DECISIONS-saas-pricing.md`. Confirm the path and I'll
> open Branch A.

## Branch A — Pricing model

**Agent (turn 1):**

`For D001 – pricing model: pick an option, or provide your answer.`

- **Option 1 — Flat subscription.** What it is: a single monthly fee per account regardless of seats. Benefit: simplest plan to explain, lowest sales friction. Cost: under-monetizes teams and creates seat-sharing workarounds. Risk: revenue ceiling per account; weak expansion story for the SaaS's growth phase.
- **Option 2 — Per-seat pricing.** What it is: charge per active user per month, tiered by feature. Benefit: aligns price to value delivered, scales revenue with account growth. Cost: every new "user" becomes a procurement conversation; risk of seat-stuffing complaints. Risk: friction at the bottom of the market (solo buyers priced out).
- **Option 3 — Hybrid (flat base + per-seat above threshold).** What it is: flat fee for the first N seats, per-seat beyond N. Benefit: protects the solo/SMB segment while capturing expansion. Cost: two concepts to explain in the pricing page. Risk: more configuration in the billing system; harder to forecast.

`Recommendation: Option 3 — Hybrid (flat base + per-seat above threshold).`
`Reasoning: the user said "small SaaS", which signals the SMB segment is in scope, but per-seat is the standard growth vector; hybrid captures both without forcing a choice today.`
`Forward risk: if the billing system cannot model a threshold cleanly, the operational cost of Option 3 erodes the segment benefit; revisit in Branch C.`

**Quality expectations this turn satisfies:**

- Locked question format used verbatim (`For D001 – pricing model: pick an option, or provide your answer.`).
- Three options, each with the four required fields (What it is, Benefit, Cost, Risk) at one sentence per field.
- Recommendation uses the three-field breakdown with the option name copied verbatim.
- No evaluative opener ("Good", "Great", "Nice", etc.).
- No forbidden filler word.

## Record and Continue

After the user picks Option 3, the agent should immediately:

1. Append a `D001` record to the Decision Ledger using the inline template:
   `Resolved Answer`, `Normalized Requirement`, `Constraints`.
2. Open Branch B without re-asking what the user just said.

A compliant continuation:

> Resolved: Option 3 — Hybrid (flat base + per-seat above threshold).
> Recorded as `D001` in `docs/decisions/DECISIONS-saas-pricing.md`.

`For D002 – seat threshold for the flat tier: pick an option, or provide your answer.`

**Quality expectations this turn satisfies:**

- Decision Ledger record appended immediately after the resolution (no batching at session end).
- Branch transition uses the structural `Resolved:` opener (no praise, no neutral mirroring that paraphrases the answer).
- Next question uses the locked format with the new `Dxxx` ID and branch name.

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
- [ ] One Decision Ledger record was appended immediately after every resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`, `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID incremented from the highest existing one.
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx` line in `Constraints` rather than amending the prior record.
- [ ] Every question offered all natural options (typically 2–4) with the four required fields (What it is, Benefit, Cost, Risk) at one sentence per field.
- [ ] Every recommendation used the three-field breakdown (`Recommendation: Option N — <name>.`, `Reasoning: ...`, `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every question used the locked format `For [Dxxx] – [branch name]: pick an option, or provide your answer.` with the `Dxxx` and name verbatim.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn (`basically`, `essentially`, `actually`, `just`, `simply`, `in order to`, `it is important to note`, `it's worth noting`, `keep in mind`, `note that`, `needless to say`, `at the end of the day`, `when all is said and done`).
- [ ] Convergence was declared only when all four checks passed.
- [ ] No diverge mode occurred (no paraphrasing the verbatim answer, no skipping a branch, no bundling options, no accepting a contradictory answer without a `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path so downstream skills (memos, tickets, specialized grilling) can cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger file used the `filename#Dxxx` format (e.g., `DECISIONS-saas-pricing.md#D001`), not a bare `Dxxx` ID.
