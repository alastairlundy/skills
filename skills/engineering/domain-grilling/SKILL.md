---
name: domain-grilling
description: >-
  A relentless interviewing skill focused on Domain-Driven Design (DDD) alignment. Use for vague ideas with no spec or PRD, domain modeling, terminology alignment, or conceptual design before any spec exists. Walks through the design tree iteratively, resolves terms against a glossary (CONTEXT.md), and documents critical architectural decisions (ADRs).   Defer to `code-implementation-grilling` once a spec or PRD is present and technical decisions (language, framework, dependencies, project structure) are the goal.
license: MIT
---

# Domain Grilling

## When to Use
- When the user has a vague idea with no spec or PRD and conceptual design must happen before any spec exists.
- When domain modeling or terminology alignment is the goal (the "what" and the shared language, not the "how").
- When starting a new feature or architectural change that requires deep conceptual alignment.
- When the domain language is evolving or "fuzzy" and needs a canonical glossary.
- When you want to stress-test a design against existing codebase realities and architectural trade-offs.
- When user input would clarify the request, invoke ask-questions

## When Not to Use
- When a spec or PRD is already present and the goal is technical decisions (language, framework, dependencies, project structure, sub-projects, project type) — defer to `code-implementation-grilling`.
- For trivial code changes or bug fixes where the domain model is not in question.
- When the goal is a rapid prototype where formal DDD alignment is not required.
- When you are in the implementation phase and simply need a code review.

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. 

**Never collapse the decision space.** For every decision point, present the full range of natural options before recommending one. The user must see the landscape of choices — not just the agent's preferred path — to make an informed decision.

For every question you ask, you must provide:

1. **All natural options**: Enumerate the viable alternatives (typically 2-4). Each option must be a genuinely defensible choice, not a strawman. Each option is a structured block with these four fields, **one sentence per field**. Write in Professional Minimalist style: punchy, direct, clear. No filler:
   - **What it is** — one sentence describing the option.
   - **Benefit** — one sentence describing the gain if this option is chosen. Answers: "What do I get?"
   - **Cost** — one sentence describing the realistic/actual sacrifice. Answers: "What do I definitely give up?"
   - **Risk** — one sentence describing what might go wrong later. Answers: "What could happen in the future?"
   - *Worked example (per-option block)*:
     - **Option 1 — Format-locked recommendation.** What it is: the recommendation line follows a strict template. Benefit: deterministic and easy to lint automatically. Cost: slightly rigid phrasing for edge cases. Risk: a future LLM may paraphrase the option name.

2. **Your recommendation**: the recommendation is a **two-field breakdown** with explicit labels:
   - `Recommendation: Option N — <name>.` — `<name>` is copied **verbatim** from the option's heading above. Do not paraphrase, abbreviate, or re-order the name. Do not modify, augment, combine, or qualify the option. If a clause is essential, promote it to a *separate* option first, then recommend that option.
   - `Reasoning: <one-to-two sentences>.` — why this option's trade-offs and risks are acceptable in this specific context. Justify the recommended option only; do not re-justify the rejected options.
   - *Worked example* — violation: `Recommendation: Option 1 with a "spirit-of-the-rule" extension clause.` Correction: either drop the clause and recommend `Option 1 — Explicit phrasing lists.` cleanly, or promote the clause to a new `Option 5` and recommend that.

3. **Strategic Risk/Pattern Alert**: if the decision involves a known architectural risk or a high-level pattern (e.g., Consistency risks, Boundary leakage, Distributed transactions), explain the long-term implication regardless of which option is selected. Keep it brief and direct.

Ask questions one at a time, waiting for feedback on each before continuing. If a question can be answered by exploring the codebase, do that first.

**Locked question format.** When asking the user to choose between options, use the exact template on its own line, separated by blank lines from surrounding text:

**For [branch label] – [branch name]: pick an option, or provide your answer.**

- `[branch label]` is the short stable identifier the LLM introduced when opening the branch (e.g., `Branch B`).
- `[branch name]` is the human-readable name the LLM gave the branch (e.g., `where the gate lives`).
- Use the same label and name verbatim in every question for that branch. Do not rephrase, abbreviate, or rename mid-session.
- The `: pick an option, or provide your answer.` suffix is fixed; do not vary it. The user is always permitted to push back, modify, or replace the options.

### Conciseness and Clarity

Write tight. Every sentence must earn its place. Cut filler words, hedge words, and redundant qualifiers.

**Professional Minimalist style:** punchy, direct sentences. Prioritize clarity and brevity. If a sentence can be shorter without losing meaning, shorten it. No rigid word counts or punctuation bans — let natural professional phrasing carry the content.

For optional style guidance, patterns, and before/after examples, see [CONCISE-WRITING.md](./references/CONCISE-WRITING.md).

### Forbidden Filler Words

Never use these words or phrases: `basically`, `essentially`, `actually`, `just`, `simply`, `in order to`, `it is important to note`, `it's worth noting`, `keep in mind`, `note that`, `needless to say`, `at the end of the day`, `when all is said and done`.

### Tone and Output Discipline

Maintain a neutral, non-evaluative tone throughout the session. Treat the user's previous answer as **data**, not as something to react to emotionally.

- **No evaluative openers.** Do not begin a sentence (especially a branch transition) with subjective judgement. Examples of evaluative openers to avoid: `Good`, `Great`, `Nice`, `Excellent`, `Perfect`, `Solid`, `Cool`, `Fair enough`, `Lovely`, `Brilliant`. The list is **illustrative, not exhaustive** — the rule binds on the *category* (evaluative opener), not on the enumerated words.
- **Acknowledgement openers are permitted.** `Right`, `OK`, `Got it`, `Understood` are neutral confirmations of what the user said, not evaluative reactions. They are allowed.
- **Neutral Mirroring.** After acknowledging, summarize the user's point in their own terminology before moving on. This confirms understanding and keeps the domain language grounded in the user's mental model. Template: `Understood. You're saying [summarized point using user's terms].` Then transition to the next branch or question.
- **Branch transitions begin structurally.** A new branch must begin with one of: `Resolved: …`, `Next: …`, `Moving to branch <label> (<name>): …`, or directly with the question itself. Do not pad the transition with evaluative reactions to the previous answer.
- *Worked example* — violation: `Good — Option 2 sets the precondition. Now: where does the gate get encoded?` Correction: `Understood. You're saying Option 2 sets the precondition. Next: where does the gate get encoded?`

### Term Resolution
During the session, if you identify a term that belongs in the domain glossary:
1. Propose the term and your understood meaning to the user.
2. If accepted, write the term to `CONTEXT.md` immediately. Do not batch — immediate writes prevent drift and give both you and the user a persistent, up-to-date record to reference in later branches.
3. If the user revises the definition during a later branch, update the `CONTEXT.md` entry at that point.

Once the convergence check passes (all branches resolved, mutually consistent, and no new dependencies surfaced), explicitly declare: "We have reached a shared understanding." 

Before listing exits, ask the user a single explicit confirmation question to determine whether the problem is code/technical: "Is this a code/technical problem — a problem whose resolution requires a programming/code related or technical solution?" with options `Yes` / `No` / `I'm not sure`. Use the answer to tailor which exit is recommended most prominently. Skip the question if the problem type is unambiguous from context.

Finally, offer the user the following exit paths:
1. **Create a plan/PRD**: Use the `to-prd` skill. If unavailable, manually generate a high-level Product Requirements Document reflecting the shared understanding.
2. **Hand off to `code-implementation-grilling`** *(only if the problem is a code/technical problem — a problem whose resolution requires a programming/code related or technical solution)*: Use the `code-implementation-grilling` skill to turn the shared understanding into a technical implementation plan. If the problem is not a code/technical problem, skip this exit.
3. **Break into tickets**: Use the `spec-to-tickets` skill when dependency ordering, HITL/AFK classification, or local markdown output is needed. Use the `to-issues` skill for simpler flat decomposition to an issue tracker. If neither is available, manually decompose the plan into implementation tickets.
4. **Handoff**: Handoff the shared understanding to another agent.
5. **Custom Save**: Save the shared understanding in another way.

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

### Iterative Dependency Resolution
- Identify all "branches" (conceptual areas/decisions) of the design tree.
- Resolve these branches sequentially, but **re-open any resolved branch** if a later discovery reveals a conceptual contradiction or dependency that invalidates an earlier decision.
- When re-opening a branch, state which new information triggered it and what specifically needs revisiting.
- **Convergence Check**: before declaring convergence, verify that all resolved branches remain mutually consistent. If any branch contradicts another, re-open the conflicting branches and resolve the contradiction before proceeding.

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
