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

Load `references/initialization-and-domain-awareness.md` before the first user question. That reference owns the domain state summary, infrastructure check, and session guidelines.

### Decision Ledger

The session maintains a **Decision Ledger** at `docs/decisions/DECISIONS-<repo>-<feature>.md` that captures every materially resolved interview branch. The ledger is the durable source of truth downstream skills (PRDs, tickets, blueprints, verification) cite by stable ID.

- **Real-time:** append after every resolved interview branch, not at session end. Do not batch the writes.

**Initiation.** When the user opens Branch A, derive the ledger path:

- `<repo>` is the directory name of the repository the agent is working in.
- `<feature>` is a short kebab-case slug derived from the feature or change being grilled (e.g., `tab-session-restore`).

If `docs/decisions/` does not exist, create it lazily (per the Lazy Creation rule in [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md)). Confirm the resolved path with the user before the first write.

**Per-branch record.** Immediately after the user resolves an interview branch — and before opening the next one — append one record to the ledger using this inline template:

```md
### [Dxxx] — <branch name>

- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
```

- `Dxxx` is a zero-padded sequence: `D001`, `D002`, `D003`, … Scan the existing ledger file and increment from the highest existing `Dxxx` number. Do not reuse IDs.
- `Resolved Answer` is the user's exact wording (or a close paraphrase the user has explicitly accepted). It is not the agent's summary.
- `Normalized Requirement` is a single concise, testable statement an implementer or verifier can act on. The "testable" bar is the same as a PRD acceptance criterion.
- `Constraints` are negative requirements, edge cases, or defaults the user named (e.g., "Do not collapse multiple tabs into one session", "All open tabs must survive restart"). If none, write `None.`

The user can spot a missing or weakened entry at the next branch and correct it before drift compounds.

**Soft cap.** If a single Decision Ledger reaches ~30 records, consider closing it and opening a new one for the next phase of the interview. The cap is a trigger for reflection, not a hard limit; override with reasoning if the interview genuinely needs more.

**Re-opens.** If an interview branch is re-opened later in the session (because a new discovery invalidates the earlier decision), do not amend the prior record. Add a new record with a fresh `Dxxx` ID and a `Supersedes: Dxxx` line in `Constraints`. The superseded record stays in the ledger for traceability.

**Glossary terms.** When a resolved interview branch introduces a new glossary term, the `Normalized Requirement` line is the place to record the term's working definition inline. The full term is also written to `CONTEXT.md` per the Term Resolution step below. The two writes are independent — do not skip one because the other exists.

Interview the user relentlessly about every aspect of the plan until reaching a shared understanding. Walk down each interview branch of the design tree, resolving dependencies between decisions one-by-one.

**Never collapse the decision space.** For every decision point, present the full range of natural options before recommending one. The user must see the landscape of choices — not just the agent's preferred path — to make an informed decision.

For every question asked, provide:

1. **All natural options**: Enumerate the viable alternatives (typically 2-4). An option is defensible if all four fields — What it is, Benefit, Cost, Risk — can be filled with non-trivial, option-specific content. If any field would read `TBD`, `same as Option N`, or `none`, the option is not defensible. Each option is a structured block with these four fields, **one sentence per field**. Write in Professional Minimalist style: punchy, direct, clear. No filler:
   - **What it is** — one sentence describing the option.
   - **Benefit** — one sentence describing the gain if this option is chosen. Answers: "What do I get?"
   - **Cost** — one sentence describing the realistic/actual sacrifice. Answers: "What do I definitely give up?"
   - **Risk** — one sentence describing what might go wrong later. Answers: "What could happen in the future?"
   - *Worked example* — `**Option 1 — Format-locked recommendation.** What it is: the recommendation line follows a strict template. Benefit: deterministic and easy to lint automatically. Cost: slightly rigid phrasing for edge cases. Risk: a future LLM may paraphrase the option name.`

2. **Your recommendation**: the recommendation is a **three-field breakdown** with explicit labels:
   - `Recommendation: Option N — <name>.` — `<name>` is copied **verbatim** from the option's heading above. Do not paraphrase, abbreviate, or re-order the name. Do not modify, augment, combine, or qualify the option. If a clause is essential, promote it to a *separate* option first, then recommend that option.
   - `Reasoning: <one-to-two sentences>.` — why this option's trade-offs and risks are acceptable in this specific context. Justify the recommended option only; do not re-justify the rejected options.
   - `Forward risk: <one sentence naming the most likely failure mode of the chosen option>.`
   - *Worked example* — violation: `Recommendation: Option 1 with a "spirit-of-the-rule" extension clause.`

Ask questions one at a time, waiting for feedback on each before continuing. If a question can be answered by exploring the codebase, do that first.

**Locked question format.** When asking the user to choose between options, use the exact template on its own line, separated by blank lines from surrounding text:

**For [Dxxx] – [branch name]: pick an option, or provide your answer.**

- `[Dxxx]` is the stable identifier from the Decision Ledger template.
- `[branch name]` is the human-readable name of the branch.
- Use the same Dxxx and name verbatim in every question for that branch. Do not rephrase, abbreviate, or rename mid-session.
- The `: pick an option, or provide your answer.` suffix is fixed; do not vary it. The user is always permitted to push back, modify, or replace the options.

### Conciseness and Clarity

Write tight. Every sentence must earn its place. Cut filler words, hedge words, and redundant qualifiers.

**Professional Minimalist style:** punchy, direct sentences. Prioritize clarity and brevity. If a sentence can be shorter without losing meaning, shorten it. The locked question format above is a hard rule with length constraints; everything else falls under Professional Minimalist style and is not subject to rigid word counts or punctuation bans — let natural professional phrasing carry the content.

For optional style guidance, patterns, and before/after examples, see [CONCISE-WRITING.md](./references/CONCISE-WRITING.md).

### Forbidden Filler Words

Never use these words or phrases: `basically`, `essentially`, `actually`, `just`, `simply`, `in order to`, `it is important to note`, `it's worth noting`, `keep in mind`, `note that`, `needless to say`, `at the end of the day`, `when all is said and done`.

Before submitting any question, the LLM scans its own prose for each word in this list. If any appears, rewrite the sentence to remove it.

### Tone and Output Discipline

Maintain a neutral, non-evaluative tone throughout the session. Treat the user's previous answer as **data**, not as something to react to emotionally.

- **No evaluative openers.** Do not begin a sentence (especially a branch transition) with any word whose primary function is to praise or judge the user's prior input. Examples include: `Good`, `Great`, `Nice`, `Excellent`, `Perfect`, `Solid`, `Cool`, `Fair enough`, `Lovely`, `Brilliant`. The rule binds on the function (praise or judgement of prior input), not on the enumerated examples.
- **Acknowledgement openers are permitted.** `Right`, `OK`, `Got it`, `Understood` are neutral confirmations of what the user said, not evaluative reactions. They are allowed.
- **Neutral Mirroring.** After acknowledging, summarize the user's point in their own terminology before moving on. This confirms understanding and keeps the domain language grounded in the user's mental model. Template: `Understood. You're saying [summarized point using user's terms].` Then transition to the next branch or question.
- **Branch transitions begin structurally.** A new branch must begin with one of: `Resolved: …`, `Next: …`, `Moving to branch <Dxxx> (<name>): …`, or directly with the question itself. Do not pad the transition with evaluative reactions to the previous answer.
- *Worked example* — violation: `Good — Option 2 sets the precondition. Now: where does the gate get encoded?` Correction: `Understood. You're saying Option 2 sets the precondition. Next: where does the gate get encoded?`

### Term Resolution

During the session, if a term is identified that belongs in the domain glossary:
1. Propose the term and the understood meaning to the user.
2. If accepted, write the term to `CONTEXT.md` immediately. Do not batch — immediate writes prevent drift and give both the user and the agent a persistent, up-to-date record to reference in later branches. If `CONTEXT.md` does not exist, create it now (per the Lazy Creation rule in [initialization-and-domain-awareness.md](./references/initialization-and-domain-awareness.md)).
3. If the user revises the definition during a later branch, update the `CONTEXT.md` entry at that point.

Completion criterion: every glossary term is in `CONTEXT.md` with the same definition as in the Decision Ledger.

### Convergence

Convergence is the final step of the workflow. The session may declare a shared understanding and offer exit paths only when all four checks below hold.

- **All branches resolved.** Every interview branch opened during the session has a recorded decision, or has been explicitly closed by the user.
- **No contradictions.** Re-open any interview branch whose recorded decision contradicts another interview branch's recorded decision, and resolve the contradiction first.
- **No new question in the last three turns.** The most recent three exchanges have not introduced a new branch, surfaced a contradiction, or required a glossary revision. If a new question or contradiction appeared in the last three turns, the session is not yet convergent — continue grilling.
- **Decision Ledger complete.** Read the Decision Ledger file and verify that every branch resolved during this session has a corresponding `Dxxx` record, and that every re-opened branch has a fresh `Supersedes: Dxxx` record. A branch that is resolved in conversation but missing from the ledger is a silent loss; re-open it, write the record, and re-verify before declaring convergence. Do not allow convergence on the strength of conversational memory alone.

When all four checks pass, declare: "We have reached a shared understanding." Do not declare convergence based on intent or partial progress; the test is observable in the recent exchange history and in the ledger file.

### Diverge Modes

The convergence test is the *positive* bar. The following failure modes are the *negative* bar — explicit divergences the agent must avoid.

- **Paraphrasing the verbatim answer.** The agent rewords what the user said instead of recording it as the `Resolved Answer`. The Decision Ledger captures the agent's summary, not the user's words.
- **Skipping an interview branch.** A branch is opened, but the agent moves on without resolving it or explicitly closing it. The branch has no `Dxxx` record.
- **Bundling options.** A 3-option question is asked as a 5-option question, or a 5-option question is asked as a 3-option one. The user sees a different decision space than the agent's working set.
- **Accepting a contradictory answer.** The user gives an answer that contradicts a previously resolved decision, and the agent accepts it without flagging the conflict or creating a `Supersedes: Dxxx` record.

The recovery for the first three is to revisit the affected branch and re-record. The recovery for the fourth is to apply the supersede rule (re-open gets a new `Dxxx`) and resolve the contradiction explicitly.

Before listing exits, ask the user a single explicit confirmation question to determine whether the problem is code/technical: "Is this a code/technical problem — a problem whose resolution requires a programming/code related or technical solution?" with options `Yes` / `No` / `I'm not sure`. Use the answer to branch on the recommended exit. Skip the question if the problem type is unambiguous from context.

- **`Yes`** — the problem is code/technical. Lead with the `code-implementation-grilling` exit as the recommended path, then present the other non-technical exits.
- **`No`** — the problem is not code/technical. Skip the `code-implementation-grilling` exit. Lead with `to-prd` as the recommended path, then present the other non-technical exits.
- **`I'm not sure`** — present all available exit options (including `code-implementation-grilling`) without a recommendation, and do not ask a follow-up question.

**Every exit that drives downstream implementation work must include the Decision Ledger path** so the downstream skill can cite records by ID:

| Path | Drives downstream work? | Ledger action |
|------|------------------------|---------------|
| 1 — Create a plan/PRD | Yes | Include ledger path |
| 2 — Hand off to `code-implementation-grilling` (code/technical only) | Yes | Include ledger path |
| 3 — Break into tickets | Yes | Include ledger path |
| 4 — Handoff | Yes | Include ledger path |
| 5 — Custom Save | No | — |

#### Path 1 — Create a plan/PRD

Use the `to-prd` skill, passing the Decision Ledger path as a context pointer (e.g., "Decision Ledger: `docs/decisions/DECISIONS-<repo>-<feature>.md` — every acceptance criterion and constraint must cite a `Dxxx` record."). If unavailable, manually generate a high-level Product Requirements Document that maps every user story, acceptance criterion, and constraint back to a `Dxxx` record.

#### Path 2 — Hand off to `code-implementation-grilling` (code/technical only)

Use the `code-implementation-grilling` skill, passing the Decision Ledger path so it can append `Txxx` records to the same ledger. Skip this exit if the problem is not a code/technical problem.

#### Path 3 — Break into tickets

Use the `spec-to-tickets` skill, passing the Decision Ledger path so every ticket's acceptance criteria and constraints cite a `Dxxx` (or later `Txxx`) record. Use the `to-issues` skill for simpler flat decomposition to an issue tracker, also passing the ledger path. If neither is available, manually decompose the plan into implementation tickets whose acceptance criteria cite ledger IDs.

#### Path 4 — Handoff

Handoff the shared understanding to another agent, including the Decision Ledger path as the source of truth for resolved answers.

#### Path 5 — Custom Save

Save the shared understanding in another way, citing the Decision Ledger path so the records stay linked to whatever artifact is produced.

## Validation

After completing the workflow, verify each item against the session transcript:

- [ ] `references/initialization-and-domain-awareness.md` was loaded before the first user question.
- [ ] Domain state summary was given to the user before the first question.
- [ ] Decision Ledger path was derived (`docs/decisions/DECISIONS-<repo>-<feature>.md`) and confirmed with the user before the first write.
- [ ] One Decision Ledger record was appended immediately after every resolved interview branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`, `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID incremented from the highest existing one.
- [ ] Re-opened interview branches produced a new record with a `Supersedes: Dxxx` line in `Constraints` rather than amending the prior record.
- [ ] Every question offered all natural options (typically 2-4) that passed the four-field defensibility test (all four fields filled with non-trivial, option-specific content).
- [ ] Every recommendation used the three-field breakdown (`Recommendation: Option N — <name>.`, `Reasoning: ...`, `Forward risk: ...`) with the option name copied verbatim.
- [ ] No sentence began with a word whose function is to praise or judge the user's prior input.
- [ ] Forbidden filler words were avoided (see "Forbidden Filler Words" above).
- [ ] Every glossary term was proposed to the user before being written to `CONTEXT.md`.
- [ ] `CONTEXT.md` was created lazily on the first write if it did not already exist.
- [ ] Every glossary term is in `CONTEXT.md` with the same definition as in the Decision Ledger.
- [ ] Convergence was declared only when all four checks (all branches resolved, no contradictions, no new question in the last three turns, Decision Ledger complete) passed.
- [ ] No diverge mode occurred (no paraphrasing, no skipped branches, no bundled options, no accepted contradictions without a supersede record).
- [ ] The exit gate confirmation question was asked (unless the answer was unambiguous from context) and the answer was used to select the recommended exit per the per-answer branching rules.
- [ ] The chosen exit was handed off with the Decision Ledger path so downstream skills (PRD, tickets, blueprint) can cite records by ID.
