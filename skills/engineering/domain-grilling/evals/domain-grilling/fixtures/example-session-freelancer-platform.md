# Worked Example Session: Freelancer-Client Platform

This fixture documents a canonical good session for the domain-grilling skill.
Use it as reference material when evaluating whether an agent followed the
workflow correctly. Each step is annotated with the quality expectation it
satisfies.

## Context

User prompt (matches 	asks/trigger-vague-idea-domain-modeling.yaml):

> I have an idea for a platform that connects freelancers with clients, but
> I'm not sure how to model the domain. Help me think through the concepts.

**Trigger outcome:** 	rigger — vague idea, no spec, goal is domain modeling.

## Pre-Grilling Baseline

Before the first question, the agent should:

1. **Load the reference files.** Read all nine reference files in full.
2. **Summarize domain state.** State explicitly that GLOSSARY.md and docs/adr/ are not present in the workspace, and offer the setup-matt-pocock-skills skill as a one-line suggestion.
3. **Confirm the Decision Ledger path.**

A compliant opener:

> No prior domain state — GLOSSARY.md and docs/adr/ are absent. If you want
> the glossary/ADR infrastructure scaffolded now, load setup-matt-pocock-skills.
> Otherwise, I'll create GLOSSARY.md lazily on the first resolved term.
>
> Fresh file at docs/decisions/DECISIONS-freelancer-platform.md. Confirm the path.

## Goal Discovery

> **What are your goals for this idea?**

**User:** I want to establish the core domain vocabulary — who the actors are, how they relate, and what the boundaries between concepts are.

Recorded as D001 in the Decision Ledger.

## Branch A — Who is the buyer of the freelancer's work?

**Agent (turn 1):**

### Round 1

2 branches remain, 1 unblocked this round.

| Element          | Content                                                                  |
|------------------|--------------------------------------------------------------------------|
| **Goal**         | Establish the core domain vocabulary for the freelancer-client platform (D001). |
| **Prior decisions** | No prior branch decisions yet.                                        |
| **Scope**        | This branch covers who the buyer is; it does not cover payment flow.    |

**For D002 – who hires whom: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Client-as-buyer** | The client (entity paying) is the counterparty to the freelancer. | Matches common B2B invoicing flows. | Blurs client (org) and contact (person) into one term. | Tax rules distinguishing payer from contact get awkward. |
| B — Contact-on-behalf-of-client | The contact is a person acting for a client organization; the org is the payer. | Cleanly separates invoicing target from conversational contact. | Extra term to maintain in the glossary. | Friction when UI is built around contact as user. |
| C — Two-sided marketplace | Freelancer and client are peers, no organization layer. | Simpler model. | No place to model enterprise clients with multiple contacts. | Not viable for B2B segments. |

**Recommendation: B.**
**Reasoning:** The platform description suggests both individual and organizational buyers are in scope; without the contact/client split, the model collapses under the first enterprise customer.

**Quality expectations this turn satisfies:**

- 1-turn wrapper: round header, frontier statement, 3-row context block, options table, recommendation.
- No Socratic elicitation question emitted.
- Three options, each with the five required columns (What it is, Benefit, Cost, Risk).
- Recommendation uses the 2-line format with goal-aligned reasoning.
- No evaluative opener ("Good", "Great", "Nice", etc.).
- No forbidden filler word.

## Term Resolution Mid-Session

After the user picks Option B, the agent should:

1. Propose the new terms — Contact, Client Organization — to the user with their working definitions.
2. On acceptance, write them to GLOSSARY.md (creating the file lazily if it does not exist).
3. Cite the file path so the user can see the write.

A compliant continuation:

> Resolved: Contact-on-behalf-of-client. Understood. You're
> saying the platform distinguishes the human (contact) from the org
> that pays (client organization).
>
> Two new glossary terms to write: **Contact** — the person messaging
> the freelancer; **Client Organization** — the legal entity that
> invoices and pays. Confirm both before I write to GLOSSARY.md.

**Quality expectations this turn satisfies:**

- No evaluative opener on the branch transition (uses Resolved: per the structural rules).
- Term proposed before write, per the Term Resolution step.
- Contact/Client Organization written to GLOSSARY.md only after the user confirms.

## Per-Round Convergence

After the last branch in a round, the agent runs the 5-check convergence
test. If all five pass, the agent may prompt for close-out:

> All checks pass. Ready to close out, or shall we open the next round?

The user decides whether to stop.

## Exit Gate

Before listing exits, ask: "Will resolving this require writing
code?" with options Yes / No / I'm not sure.

- **Yes** → recommend code-implementation-grilling.
- **No** → recommend 	o-prd.
- **I'm not sure** → list all exits without a recommendation.

## Workflow Quality Checklist

When reviewing any domain-grilling transcript, check each item against the
output:

- [ ] Reference files loaded before the first question.
- [ ] Domain state summary given before the first question.
- [ ] Every question used the 1-turn wrapper: round header, frontier statement, context block (3-row table), options table, recommendation. No Socratic elicitation question.
- [ ] Every context block was the 3-row table (Goal, Prior decisions, Scope).
- [ ] Every options block was the 5-column table format.
- [ ] Every recommendation used the 2-line format.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn.
- [ ] Every glossary term was proposed to the user before being written to GLOSSARY.md.
- [ ] GLOSSARY.md was created lazily on first write (not pre-emptively).
- [ ] Convergence was a per-round check; the agent offered close-out but the user decided.
- [ ] The exit gate question was asked (unless context made the answer unambiguous) and the answer was used to pick the recommended exit.