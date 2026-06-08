---
name: domain-grilling
description: A relentless interviewing skill focused on Domain-Driven Design (DDD) alignment. It ensures a shared understanding of a plan by walking through the design tree linearly, resolving terms against a glossary (CONTEXT.md), and documenting critical architectural decisions (ADRs).
---

## When to Use
- When starting a new feature or architectural change that requires deep conceptual alignment.
- When the domain language is evolving or "fuzzy" and needs a canonical glossary.
- When you want to stress-test a design against existing codebase realities and architectural trade-offs.

## When Not to Use
- For trivial code changes or bug fixes where the domain model is not in question.
- When the goal is a rapid prototype where formal DDD alignment is not required.
- When you are in the implementation phase and simply need a code review.

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. 

**Never collapse the decision space.** For every decision point, present the full range of natural options before recommending one. The user must see the landscape of choices — not just the agent's preferred path — to make an informed decision.

For every question you ask, you must provide:
1. **All natural options**: Enumerate the viable alternatives (typically 2-4). Each option must be a genuinely defensible choice, not a strawman. For each option, state:
   - What it is (one sentence)
   - Its trade-offs (what it gains and what it costs)
   - Its risks (what could go wrong, long-term implications)
2. **Your recommendation**: State which option you recommend and why. The recommendation must be one of the enumerated options — not a separate thing. Explain why this option's trade-offs and risks are acceptable in this specific context, and why the other options' trade-offs and risks are not.
3. **Strategic Risk/Pattern Alert**: If the decision involves a known architectural risk or a high-level pattern (e.g., Consistency risks, Boundary leakage, Distributed transactions), explain the long-term implication of this choice regardless of which option is selected.

Ask questions one at a time, waiting for feedback on each before continuing. If a question can be answered by exploring the codebase, do that first.

### Term Resolution
During the session, if you identify a term that belongs in the domain glossary:
1. Propose the term and your understood meaning to the user.
2. If accepted, queue this term for the glossary.
3. Do NOT write to `CONTEXT.md` during the questioning phase; batch all resolved terms for a single update once convergence is reached.

Once convergence is detected (all branches resolved and no new dependencies surfaced), explicitly declare: "We have reached a shared understanding." 

Perform the final glossary update to `CONTEXT.md` using the batched terms.

Finally, offer the user the following exit paths:
1. **Create a plan/PRD**: Use the `to-prd` skill. If unavailable, manually generate a high-level Product Requirements Document reflecting the shared understanding.
2. **Break into tickets**: Use the `spec-to-tickets` skill when dependency ordering, HITL/AFK classification, or local markdown output is needed. Use the `to-issues` skill for simpler flat decomposition to an issue tracker. If neither is available, manually decompose the plan into implementation tickets.
3. **Handoff**: Handoff the shared understanding to another agent.
4. **Custom Save**: Save the shared understanding in another way.

</what-to-do>

<supporting-info>

## Initialization and Setup

Upon activation:
1. **Domain State Summary**: Scan the repository for `CONTEXT.md` and `docs/adr/`. Summarize the current known domain state to the user *before* asking the first question. This establishes the baseline and prevents redundant questioning.
2. **Infrastructure Check**: If `CONTEXT.md` is missing, inform the user and suggest the `setup-matt-pocock-skills` skill to establish the glossary and ADR infrastructure.

## Domain Awareness

During codebase exploration, analyze the following:

### File structure
Most repos follow a single-context layout:
```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```
If a `CONTEXT-MAP.md` exists at the root, the repo uses multiple contexts. The map identifies the location of each.

### Documentation Policy
- **Lazy Creation**: If the user chooses not to use the setup skill, create `CONTEXT.md` or `docs/adr/` only when the first term or ADR is actually resolved and ready to be written.
- **Glossary Purity**: `CONTEXT.md` must stay devoid of implementation details (e.g., no table names, class names, or API endpoints). If a user suggests adding implementation details, challenge them to find the underlying domain concept.

## Session Guidelines

### Linear Dependency Resolution
- Identify all "branches" (conceptual areas/decisions) of the design tree.
- Resolve these branches sequentially.
- Transition to the next branch only after the current one is fully resolved.

### Challenge against the glossary
When the user uses a term that conflicts with `CONTEXT.md`, present the conflict as a choice between the glossary definition and the user's apparent meaning. "Your glossary defines 'cancellation' as X (voiding the order before payment), but you seem to mean Y (refunding after payment). These have different domain boundaries. Which is correct for your context — or do you need both terms?"

### Sharpen fuzzy language
When the user uses a vague or overloaded term, present the possible meanings as options with their implications. "You're saying 'account' — this could mean the Customer (the entity that owns the subscription) or the User (the person logging in). Those have different boundaries. Which fits your domain?"

### Discuss concrete scenarios
Stress-test domain relationships with specific scenarios. Invent edge cases that force the user to be precise about boundaries between concepts.

### Cross-reference with code
If the user states how something works, verify it against the code. Surface any contradictions immediately.

### Offer ADRs sparingly
Only offer to create an ADR when all three are true:
1. **Hard to reverse** — the cost of changing your mind later is meaningful.
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and one was picked for specific reasons.

When suggesting an ADR, explicitly state which of these three criteria triggered the suggestion. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
