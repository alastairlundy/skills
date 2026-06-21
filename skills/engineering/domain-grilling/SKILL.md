---
name: domain-grilling
description: >-
  A relentless interviewing skill focused on Domain-Driven Design (DDD) alignment. Use for expanding upon vague ideas without a spec, helping the user think through ideas, terminology, or concepts. Do not use for implementation decisions, trivial code changes or bug fixes.
license: MIT
---

# Domain Grilling

## When to Use

- When the user has a vague idea with no spec or PRD and conceptual design must happen before any spec exists.
- When domain modeling or terminology alignment is the goal (the "what" and the shared language, not the "how").
- When starting a new feature or architectural change that requires deep conceptual alignment.
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- When a spec or PRD is already present and the goal is technical decisions (language, framework, dependencies, project structure, sub-projects, project type) — defer to `code-implementation-grilling`.
- For trivial code changes or bug fixes where the domain model is not in question.
- When the goal is a rapid prototype where formal DDD alignment is not required.
- When you are in the implementation phase and simply need a code review.

## Workflow

Load `references/initialization-and-domain-awareness.md` before the first user question. That reference owns the domain state summary, infrastructure check, session guidelines, and the convergence test.

### Decision Ledger (Real-Time Recording)

The session maintains a **Decision Ledger** at `docs/decisions/DECISIONS-<repo>-<feature>.md` that captures every materially resolved branch. The ledger is the durable source of truth downstream skills (PRDs, tickets, blueprints, verification) cite by stable ID.

**Initiation.** When the user opens Branch A, derive the ledger path:

- `<repo>` is the directory name of the repository the agent is working in.
- `<feature>` is a short kebab-case slug derived from the feature or change being grilled (e.g., `tab-session-restore`).

If `docs/decisions/` does not exist, create it lazily (per the Lazy Creation rule in [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md)). Confirm the resolved path with the user before the first write.

**Per-branch record.** Immediately after the user resolves a branch — and before opening the next branch — append one record to the ledger using this inline template:

```md
### [Dxxx] — <Branch label> (<branch name>)

- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
```

- `Dxxx` is a zero-padded sequence: `D001`, `D002`, `D003`, … Scan the existing ledger file and increment from the highest existing `Dxxx` number. Do not reuse IDs.
- `Resolved Answer` is the user's exact wording (or a close paraphrase the user has explicitly accepted). It is not the agent's summary.
- `Normalized Requirement` is a single concise, testable statement an implementer or verifier can act on. The "testable" bar is the same as a PRD acceptance criterion.
- `Constraints` are negative requirements, edge cases, or defaults the user named (e.g., "Do not collapse multiple tabs into one session", "All open tabs must survive restart"). If none, write `None.`

Do not batch the writes. Append immediately after each resolved branch so both the user and the agent have a persistent, up-to-date record. The user can spot a missing or weakened entry at the next branch and correct it before drift compounds.

**Re-opens.** If a branch is re-opened later in the session (because a new discovery invalidates the earlier decision), do not amend the prior record. Add a new record with a fresh `Dxxx` ID and a `Supersedes: Dxxx` line in `Constraints`. The superseded record stays in the ledger for traceability.

**Glossary terms.** When a resolved branch introduces a new glossary term, the `Normalized Requirement` line is the place to record the term's working definition inline. The full term is also written to `CONTEXT.md` per the Term Resolution step below. The two writes are independent — do not skip one because the other exists.

Interview the user relentlessly about every aspect of the plan until reaching a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

**Never collapse the decision space.** For every decision point, present the full range of natural options before recommending one. The user must see the landscape of choices — not just the agent's preferred path — to make an informed decision.

For every question asked, provide:

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

- `[branch label]` is the short stable identifier introduced when opening the branch (e.g., `Branch B`).
- `[branch name]` is the human-readable name given to the branch (e.g., `where the gate lives`).
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

- **No evaluative openers.** Do not begin a sentence (especially a branch transition) with any word whose primary function is to praise or judge the user's prior input. Examples include: `Good`, `Great`, `Nice`, `Excellent`, `Perfect`, `Solid`, `Cool`, `Fair enough`, `Lovely`, `Brilliant`. The rule binds on the function (praise or judgement of prior input), not on the enumerated examples.
- **Acknowledgement openers are permitted.** `Right`, `OK`, `Got it`, `Understood` are neutral confirmations of what the user said, not evaluative reactions. They are allowed.
- **Neutral Mirroring.** After acknowledging, summarize the user's point in their own terminology before moving on. This confirms understanding and keeps the domain language grounded in the user's mental model. Template: `Understood. You're saying [summarized point using user's terms].` Then transition to the next branch or question.
- **Branch transitions begin structurally.** A new branch must begin with one of: `Resolved: …`, `Next: …`, `Moving to branch <label> (<name>): …`, or directly with the question itself. Do not pad the transition with evaluative reactions to the previous answer.
- *Worked example* — violation: `Good — Option 2 sets the precondition. Now: where does the gate get encoded?` Correction: `Understood. You're saying Option 2 sets the precondition. Next: where does the gate get encoded?`

### Term Resolution

During the session, if a term is identified that belongs in the domain glossary:
1. Propose the term and the understood meaning to the user.
2. If accepted, write the term to `CONTEXT.md` immediately. Do not batch — immediate writes prevent drift and give both the user and the agent a persistent, up-to-date record to reference in later branches. If `CONTEXT.md` does not exist, create it now (per the Lazy Creation rule in [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md)).
3. If the user revises the definition during a later branch, update the `CONTEXT.md` entry at that point.

Once the convergence check passes (see [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md) § Convergence), explicitly declare: "We have reached a shared understanding." The convergence check verifies, among other things, that the Decision Ledger contains one record for every resolved branch (or one `Supersedes` chain per re-opened branch). A session that converges with a missing or stale ledger record is not convergent — re-open the affected branch and write the record before declaring.

Before listing exits, ask the user a single explicit confirmation question to determine whether the problem is code/technical: "Is this a code/technical problem — a problem whose resolution requires a programming/code related or technical solution?" with options `Yes` / `No` / `I'm not sure`. Use the answer to branch on the recommended exit. Skip the question if the problem type is unambiguous from context.

- **`Yes`** — the problem is code/technical. Lead with the `code-implementation-grilling` exit as the recommended path, then present the other non-technical exits.
- **`No`** — the problem is not code/technical. Skip the `code-implementation-grilling` exit. Lead with `to-prd` as the recommended path, then present the other non-technical exits.
- **`I'm not sure`** — present all available exit options (including `code-implementation-grilling`) without a recommendation, and do not ask a follow-up question.

Finally, offer the user the exit paths appropriate to the branch above. Each exit that drives downstream implementation work **must include the Decision Ledger path** so the downstream skill can cite records by ID:

1. **Create a plan/PRD**: Use the `to-prd` skill, passing the Decision Ledger path as a context pointer (e.g., "Decision Ledger: `docs/decisions/DECISIONS-<repo>-<feature>.md` — every acceptance criterion and constraint must cite a `Dxxx` record."). If unavailable, manually generate a high-level Product Requirements Document that maps every user story, acceptance criterion, and constraint back to a `Dxxx` record.
2. **Hand off to `code-implementation-grilling`** *(only if the problem is a code/technical problem — a problem whose resolution requires a programming/code related or technical solution)*: Use the `code-implementation-grilling` skill, passing the Decision Ledger path so it can append `Txxx` records to the same ledger. If the problem is not a code/technical problem, skip this exit.
3. **Break into tickets**: Use the `spec-to-tickets` skill, passing the Decision Ledger path so every ticket's acceptance criteria and constraints cite a `Dxxx` (or later `Txxx`) record. Use the `to-issues` skill for simpler flat decomposition to an issue tracker, also passing the ledger path. If neither is available, manually decompose the plan into implementation tickets whose acceptance criteria cite ledger IDs.
4. **Handoff**: Handoff the shared understanding to another agent, including the Decision Ledger path as the source of truth for resolved answers.
5. **Custom Save**: Save the shared understanding in another way, citing the Decision Ledger path so the records stay linked to whatever artifact is produced.

## Validation

After completing the workflow, verify each item against the session transcript:

- [ ] `references/initialization-and-domain-awareness.md` was loaded before the first user question.
- [ ] Domain state summary was given to the user before the first question.
- [ ] Decision Ledger path was derived (`docs/decisions/DECISIONS-<repo>-<feature>.md`) and confirmed with the user before the first write.
- [ ] One Decision Ledger record was appended immediately after every resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`, `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID incremented from the highest existing one.
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx` line in `Constraints` rather than amending the prior record.
- [ ] Every question offered all natural options (typically 2-4) with the four required fields (What it is, Benefit, Cost, Risk).
- [ ] Every recommendation used the two-field breakdown (`Recommendation: Option N — <name>.` and `Reasoning: ...`) with the option name copied verbatim.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] Forbidden filler words were avoided (see "Forbidden Filler Words" above).
- [ ] Every glossary term was proposed to the user before being written to `CONTEXT.md`.
- [ ] `CONTEXT.md` was created lazily on the first write if it did not already exist.
- [ ] Convergence was declared only when all four checks passed, including the Decision Ledger completeness check (see [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md) § Convergence).
- [ ] The exit gate confirmation question was asked (unless the answer was unambiguous from context) and the answer was used to select the recommended exit per the per-answer branching rules.
- [ ] The chosen exit was handed off with the Decision Ledger path so downstream skills (PRD, tickets, blueprint) can cite records by ID.
