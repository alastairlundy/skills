# Worked Example Session: Freelancer-Client Platform

This fixture documents a canonical good session for the `domain-grilling` skill.
Use it as reference material when evaluating whether an agent followed the
workflow correctly. Each step is annotated with the quality expectation it
satisfies.

## Context

User prompt (matches `tasks/trigger-vague-idea-domain-modeling.yaml`):

> I have an idea for a platform that connects freelancers with clients, but
> I'm not sure how to model the domain. Help me think through the concepts.

**Trigger outcome:** `trigger` — vague idea, no spec, goal is domain modeling.

## Pre-Grilling Baseline

Before the first question, the agent should:

1. **Load the reference file.** Read `references/initialization-and-domain-awareness.md` and complete the infrastructure check.
2. **Summarize domain state.** State explicitly that `CONTEXT.md` and `docs/adr/` are not present in the workspace, and offer the `setup-matt-pocock-skills` skill as a one-line suggestion (per the Lazy Creation rule, do not create them yet).

A compliant opener:

> No prior domain state — `CONTEXT.md` and `docs/adr/` are absent. If you want
> the glossary/ADR infrastructure scaffolded now, load `setup-matt-pocock-skills`.
> Otherwise, I'll create `CONTEXT.md` lazily on the first resolved term.

## Branch A — Who is the buyer of the freelancer's work?

**Agent (turn 1):** "Resolved: open Branch A (`who hires whom`)."

**For Branch A – who hires whom: pick an option, or provide your answer.**

- **Option 1 — Client-as-buyer.** What it is: the client (the entity paying) is the counterparty to the freelancer. Benefit: matches common B2B invoicing flows. Cost: blurs the client (organization) and the contact (person) into one term. Risk: tax/invoicing rules that distinguish payer from contact get awkward.
- **Option 2 — Contact-on-behalf-of-client.** What it is: the contact is a person acting for a client organization; the client organization is the payer. Benefit: cleanly separates invoicing target from conversational contact. Cost: extra term to maintain in the glossary. Risk: friction when the platform's UI is built around the contact as the user.
- **Option 3 — Two-sided marketplace, no client abstraction.** What it is: the freelancer and the client are peers, no organization layer. Benefit: simpler model. Cost: no place to model enterprise clients with multiple contacts. Risk: not viable for B2B segments.

`Recommendation: Option 2 — Contact-on-behalf-of-client.`
`Reasoning: the platform description ("platform that connects freelancers with clients") suggests both individual buyers and organizational buyers are in scope; without the contact/client split, the model collapses under the first enterprise customer.`

**Quality expectations this turn satisfies:**

- Locked question format used verbatim (Branch A – who hires whom).
- Three options, each with the four required fields (What it is, Benefit, Cost, Risk) at one sentence per field.
- Recommendation uses the two-field breakdown with the option name copied verbatim.
- No evaluative opener ("Good", "Great", "Nice", etc.).
- No forbidden filler word.

## Term Resolution Mid-Session

After the user picks Option 2, the agent should immediately:

1. Propose the new terms — `Contact`, `Client Organization` — to the user with their working definitions.
2. On acceptance, write them to `CONTEXT.md` (creating the file lazily if it does not exist, per the Lazy Creation rule).
3. Cite the file path so the user can see the write.

A compliant continuation:

> Resolved: Option 2 — Contact-on-behalf-of-client. Understood. You're
> saying the platform distinguishes the human (contact) from the org
> that pays (client organization).
>
> Two new glossary terms to write: **Contact** — the person messaging
> the freelancer; **Client Organization** — the legal entity that
> invoices and pays. Confirm both before I write to `CONTEXT.md`.

**Quality expectations this turn satisfies:**

- No evaluative opener on the branch transition (uses `Resolved:` and `Understood. You're saying…` per the structural rules).
- Term proposed before write, per the Term Resolution step.
- Contact/Client Organization written to `CONTEXT.md` only after the user confirms.

## Convergence Declaration

After all branches are resolved, the agent should:

1. Apply the convergence test from `references/initialization-and-domain-awareness.md` § Convergence:
   - All branches resolved.
   - No contradictions between resolved branches.
   - No new question in the last three turns.
2. Declare convergence explicitly: "We have reached a shared understanding."
3. Ask the exit gate question (unless the problem type is unambiguous).
4. Per the per-answer branching rules:
   - **`Yes`** (code/technical) → recommend `code-implementation-grilling`.
   - **`No`** (not code/technical) → recommend `to-prd`.
   - **`I'm not sure`** → list all exits without a recommendation; do not ask a follow-up.

## Workflow Quality Checklist

When reviewing any `domain-grilling` transcript, check each item against the
output:

- [ ] Reference file loaded before the first question.
- [ ] Domain state summary given before the first question.
- [ ] Every question used the locked format with the branch label and name verbatim.
- [ ] Every option block had What it is / Benefit / Cost / Risk at one sentence each.
- [ ] Every recommendation used the two-field breakdown with the option name copied verbatim.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn.
- [ ] Every glossary term was proposed to the user before being written to `CONTEXT.md`.
- [ ] `CONTEXT.md` was created lazily on first write (not pre-emptively).
- [ ] Convergence was declared only after all three checks passed.
- [ ] The exit gate question was asked (unless context made the answer unambiguous) and the answer was used to pick the recommended exit per the per-answer branching rules.
