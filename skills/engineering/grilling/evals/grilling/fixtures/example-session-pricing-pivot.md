# Worked Example Session: Pricing Pivot Decision

This fixture documents a canonical good session for the generic `grilling`
skill. Use it as reference material when evaluating whether an agent
followed the workflow correctly. Each step is annotated with the quality
expectation it satisfies.

## Context

User prompt (matches `tasks/trigger-vague-business-decision.yaml`):

> I run a small SaaS and I'm not sure whether to keep our flat $20/month
> pricing or pivot to a per-seat model. There are trade-offs in both
> directions. Help me think it through.

**Trigger outcome:** `trigger` — vague decision, neither code/tech nor
domain modeling. Falls into `grilling` (not `domain-grilling` or
`code-implementation-grilling`).

## Pre-Grilling Baseline

Before the first question, the agent should:

1. **Load the seven references in full.** Read
   `references/decision-ledger.md`, `references/options-format.md`,
   `references/recommendation-format.md`,
   `references/locked-question-format.md`,
   `references/branch-starting-prompt.md`,
   `references/tone-and-output.md`, and
   `references/convergence-test.md`. Apply their formats verbatim.
2. **State the Decision Ledger state summary.** Scan
   `docs/decisions/DECISIONS-*.md` for any matching ledger. For a new
   session, no match exists; derive the path
   `docs/decisions/DECISIONS-acme-store-pricing-pivot.md` and confirm
   it with the user before the first write.

A compliant opener:

> Decision Ledger state: no existing ledger for the pricing pivot. The
> ledger will live at
> `docs/decisions/DECISIONS-acme-store-pricing-pivot.md` — confirm the
> path and I'll create `docs/decisions/` lazily on the first resolved
> branch.

## Branch A — flat-fee vs per-seat anchor

### Turn 1: open with the open-ended branch-starting prompt

**Agent (turn 1):** The LLM paraphrases the user's aim, then asks the
canonical D010 prompt. The LLM does **not** lead with options.

> Understood — you're weighing whether the flat-fee anchor is still
> the right one given that the trade-off you've named is the scaling
> story. Within that, the part of the work is whether the flat-fee
> model is still the right anchor. What's your thinking on how
> pricing should scale as accounts grow, and what would "good" look
> like for you there?

**Quality expectations this turn satisfies:**

- Seven references loaded (including `branch-starting-prompt.md`).
- Two-part structure: aim paraphrase (LLM's own voice) +
  dimension-led open question joined by a comma (not an em-dash).
- No options surfaced. No recommendation. No pre-suggest.
- No evaluative opener. No forbidden filler word.

### Turn 2: user responds

**User:** "I want it to scale with adoption, but I don't want to lose
the small accounts who are price-sensitive. A flat-fee with a seat
cap, then per-seat beyond, is the shape I have in mind — but I want
to make sure I'm not missing a third path."

### Turn 3: translate and present options (no recommendation)

**Agent (turn 3):** The LLM runs the pre-option checks: the user's
answer is concrete (not fuzzy), the scope fits in 2–4 options (not
too broad), and the answer is not over-constrained (the user has
named a hybrid, but a hybrid surfaced from the user's own answer is
permitted per `options-format.md` and the hybrid does not foreclose
the pure flat-fee or pure per-seat paths). The LLM surfaces the
options via the locked question format and **stops**.

> **For D001 – flat-fee vs per-seat anchor: pick an option, or
> provide your answer.**
>
> - **Option 1 — Keep flat $20/month.** What it is: every account
>   pays $20/month regardless of seats. Benefit: simple to explain
>   and quote; current revenue is predictable. Cost: caps revenue
>   growth on accounts that would pay for more seats. Risk: larger
>   customers churn to per-seat competitors that align cost with
>   usage.
> - **Option 2 — Pivot to per-seat.** What it is: pricing is per
>   active user, with volume tiers. Benefit: revenue scales with
>   adoption; the product becomes a line item in the customer's
>   budget. Cost: sales motion and billing infrastructure both
>   change. Risk: small customers churn to flat-fee competitors
>   that feel cheaper.
> - **Option 3 — Hybrid: flat-fee below a seat cap, per-seat
>   above.** What it is: keep flat for accounts with up to N seats,
>   switch to per-seat beyond. Benefit: protects small customers
>   while letting large accounts scale. Cost: two pricing rules to
>   maintain and explain. Risk: customers game the threshold.

**Quality expectations this turn satisfies:**

- Locked question format used verbatim (`For D001 – <name>:`).
- Three options, each with the four required fields at one sentence
  per field.
- Each option satisfies the eight concrete-natural-option criteria
  in `options-format.md` § Concrete Natural Option.
- **No recommendation block in the default flow** (per
  `recommendation-format.md` and `docs/adr/0003-recommendations-on-demand-only.md`).
- **No pre-suggest** ("would you like my take?").
- LLM stops and waits for the user to pick, push back, or ask for
  the LLM's opinion.

### Turn 4: user picks (no recommendation needed)

**User:** "Option 3 — Hybrid."

### Turn 5: on-request recommendation (example only)

If instead the user had replied: "Option 3 — Hybrid. By the way,
what's your take?", the LLM would produce the three-field
breakdown on request (not in the default flow). Example only — the
default flow does not include a recommendation.

> `Recommendation: Option 3 — Hybrid: flat-fee below a seat cap,
> per-seat above.`
> `Reasoning: the trade-off between simple flat-fee and scaling
> per-seat collapses when both are present at different seat counts;
> this matches how SaaS customers actually segment by size.`
> `Forward risk: the seat-cap threshold becomes a chokepoint that
> customers negotiate against in every sales call.`

**Quality expectations this turn satisfies:**

- Recommendation produced only because the user asked.
- Three-field breakdown format used verbatim.
- Option name copied verbatim from the option block.

## Recording the Decision

After the user picks Option 3, the agent should immediately append the
`D001` record to the ledger and proceed.

```md
### [D001] — flat-fee vs per-seat anchor

- **Resolved Answer**: "hybrid: keep flat-fee up to N seats, switch to
  per-seat beyond."
- **Normalized Requirement**: Pricing shall be flat-fee for accounts
  with up to N seats, and per-seat for accounts above N.
- **Constraints**: The seat cap N must be configurable without code
  change.
```

A compliant continuation:

> Resolved: Option 3 — Hybrid. Understood. You're saying the price
> model has a flat-fee tier below a seat cap and a per-seat tier
> above it. I'll record D001 and open the next branch.
>
> ### [D001] — flat-fee vs per-seat anchor
> ...

## Convergence Declaration

After all branches are resolved, the agent should:

1. Apply the four-check convergence test from
   `references/convergence-test.md`:
   - All branches resolved.
   - No contradictions between resolved branches.
   - No new question in the last three turns.
   - Decision Ledger complete (every resolved branch has a `Dxxx`
     record).
2. Declare convergence explicitly: "We have reached a shared
   understanding."
3. Offer the exit paths from `SKILL.md` Step 8, with the Decision
   Ledger path included on every path that drives downstream action.

## Workflow Quality Checklist

When reviewing any `grilling` transcript, check each item against the
output:

- [ ] All seven reference files were loaded and read in full before
      the first user question.
- [ ] Decision Ledger path was derived (or located) and confirmed with
      the user before the first write.
- [ ] Existing Decision Ledger state was summarized to the user before
      the first question.
- [ ] Every branch was opened with the canonical open-ended
      branch-starting prompt from `references/branch-starting-prompt.md`,
      and no options were surfaced before the user responded.
- [ ] Every set of options contained 2–4 concrete natural options
      satisfying the eight criteria in `options-format.md` § Concrete
      Natural Option.
- [ ] The fuzzy-intent clarifying loop was applied when the user's
      answer was fuzzy; no options were surfaced while a fuzzy intent
      was unresolved.
- [ ] The scope-too-broad meta-question was applied when the answer
      translated to more than four natural options; the chosen scope
      preceded option generation.
- [ ] The over-constrained trade-off branch was applied when the
      answer translated to a single defensible option.
- [ ] No recommendation was produced in the default flow of any
      branch. A recommendation appeared only if the user explicitly
      asked for one; the LLM did not pre-suggest ("would you like my
      take?").
- [ ] When a recommendation was produced on request, it used the
      three-field breakdown with the option name copied verbatim.
- [ ] Every question used the locked format with the `Dxxx` and name
      verbatim.
- [ ] Every option block had `What it is / Benefit / Cost / Risk` at
      one sentence each.
- [ ] No sentence began with a word whose function is to praise or
      judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn.
- [ ] Convergence was declared only after all four checks passed.
- [ ] No diverge mode occurred (no paraphrasing, no skipped branches,
      no bundled options, no accepted contradictions without a
      `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path.
