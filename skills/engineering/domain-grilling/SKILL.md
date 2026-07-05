---
name: domain-grilling
description: >-
  Relentless Socratic interviewing focused on Domain-Driven Design (DDD)
  alignment — bounded contexts, ubiquitous language, glossary, terminology.
  Use when the user has a vague idea and conceptual/terminology alignment
  is the goal. Do not use for non-DDD decisions — use `grilling`
  instead. Do not use for code/technical implementation choices — use
  `code-implementation-grilling` instead.
license: MIT
---

# Domain Grilling

A relentless Socratic interviewing skill, focused on Domain-Driven
Design (DDD) alignment. This skill specializes `grilling` for the case
where the user is establishing the *vocabulary* of a domain — its
bounded contexts, ubiquitous language, and the boundary between
concepts.

The core grilling machinery (Decision Ledger, options/recommendation
formats, locked question format, tone discipline, convergence test) is
owned by the `grilling` skill. This skill adds DDD-specific
initialization (glossary/ADR scan) and Term Resolution (writing terms
to `CONTEXT.md`).

## When to Use

### Triggers

- When the user has a vague idea and needs conceptual/terminology
  alignment — clarifying the "what" and the shared language, not the
  "how".
- When the user explicitly wants domain-modeling work — establishing
  bounded contexts, ubiquitous language, glossary terms, or
  terminology boundaries.
- When starting a new feature or architectural change that requires
  deep conceptual alignment before implementation can proceed.
- When user input would clarify the request, invoke ask-questions

### Examples

- Bounded contexts, ubiquitous language, glossary building,
  terminology disambiguation.

## When Not to Use

- For non-DDD decisions (business, product, process, design) that do
  not need conceptual alignment — defer to `grilling`.
- For code/technical implementation choices when a spec/PRD exists —
  defer to `code-implementation-grilling`.
- For trivial code changes or bug fixes where the domain model is not
  in question.
- For rapid prototypes where formal DDD alignment is not required.

## Workflow

### Step 1: Load the references

Before the first user question, load and read in full:

- `../grilling/references/decision-ledger.md`
- `../grilling/references/options-format.md`
- `../grilling/references/recommendation-format.md`
- `../grilling/references/locked-question-format.md`
- `../grilling/references/tone-and-output.md`
- `../grilling/references/convergence-test.md`
- `references/ddd-initialization.md`
- `references/term-resolution.md`
- `references/ADR-FORMAT.md`

Apply the formats from those files verbatim throughout the session.
If any file is missing or unreadable, abort the session and report
the missing file to the user.

### Step 2: DDD initialization

Follow `references/ddd-initialization.md` to:

1. Scan the repo for `CONTEXT.md`, `docs/adr/`, and any existing
   Decision Ledger. Summarize the current known domain state to the
   user *before* the first question.
2. If `CONTEXT.md` is missing, suggest the
   `setup-matt-pocock-skills` skill but do not pre-emptively create
   the file.
3. Confirm the Decision Ledger path before the first write.

### Step 3: Open branches, ask questions, record decisions

Walk the design tree branch-by-branch using the locked question format
and the options/recommendation format from
`../grilling/references/*`. After each resolution, append a `Dxxx`
record to the Decision Ledger in real time.

Use the DDD-specific techniques in
`references/ddd-initialization.md` § "Session Guidelines" to:

- When the user uses a term that conflicts with `CONTEXT.md`, load and
  apply the procedure in
  `references/ddd-initialization.md` §
  "Challenge against the glossary".
- When the user uses an overloaded term, load and apply the procedure
  in `references/ddd-initialization.md` § "Sharpen fuzzy language".
- When the user discusses concrete scenarios that stress-test domain
  relationships, load and apply the procedure in
  `references/ddd-initialization.md` § "Discuss concrete scenarios".
- When the user states how something works, load and apply the
  procedure in `references/ddd-initialization.md` §
  "Cross-reference with code".
- When all three criteria in `references/ADR-FORMAT.md` hold, load and
  apply the procedure in
  `references/ddd-initialization.md` § "Offer ADRs sparingly".

### Step 4: Term Resolution

Term Resolution does not require a running checklist because it is a side effect of branch resolution, not a primary loop.

When a resolved branch introduces a new glossary term, follow
`references/term-resolution.md`:

1. Propose the term and the working definition to the user.
2. On acceptance, write the term to `CONTEXT.md` immediately
   (creating the file lazily if needed).
3. Update `CONTEXT.md` if the user revises the definition later.

### Step 5: Convergence

Run the four-check convergence test from
`../grilling/references/convergence-test.md`. If any check fails,
continue grilling or re-open the affected branch. When all four
pass, declare: "We have reached a shared understanding."

### Step 6: Exit gate and exit paths

Before listing exits, ask: "Will resolving this require writing
code?" with options `Yes` / `No` / `I'm not sure`. Skip the
question if the problem type is unambiguous from context.

- **`Yes`** — lead with the `code-implementation-grilling` exit, then
  present the other non-technical exits.
- **`No`** — skip the `code-implementation-grilling` exit; lead with
  "document the decision" as the recommended path.
- **`I'm not sure`** — present all available exits (including
  `code-implementation-grilling`) without a recommendation; do not
  ask a follow-up.

Every exit that drives downstream implementation work must include
the Decision Ledger path so downstream skills can cite records as
`filename#Dxxx`:

| Path | Drives downstream work? | Ledger path required? |
|------|------------------------|------------------------|
| 1 — Create a plan/PRD document | Yes | Yes |
| 2 — Hand off to `code-implementation-grilling` | Yes | Yes |
| 3 — Break into tickets (`spec-to-tickets`) | Yes | Yes |
| 4 — Handoff to another agent | Yes | Yes |
| 5 — Custom Save | No | No |

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All nine reference files were loaded and read in full before
      the first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] DDD domain state summary was given to the user before the
      first question (per `references/ddd-initialization.md`).
- [ ] Decision Ledger path was derived (or located) and confirmed
      with the user before the first write.
- [ ] One Decision Ledger record was appended immediately after
      every resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Re-opened branches produced a new record with a `Supersedes:
      Dxxx` line in `Constraints`.
- [ ] Every question offered all natural options (typically 2–4)
      that passed the four-field defensibility test.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every question used the locked format
      `For [Dxxx] – [branch name]: pick an option, or provide your answer.`
      with the `Dxxx` and name verbatim.
- [ ] No sentence began with a word whose function is to praise or
      judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn
      (`basically`, `essentially`, `actually`, `just`, `simply`,
      `in order to`, `it is important to note`, `it's worth noting`,
      `keep in mind`, `note that`, `needless to say`,
      `at the end of the day`, `when all is said and done`).
- [ ] Every glossary term was proposed to the user before being
      written to `CONTEXT.md`.
- [ ] `CONTEXT.md` was created lazily on the first write if it did
      not already exist.
- [ ] Every glossary term is in `CONTEXT.md` with the same
      definition as in the Decision Ledger record.
- [ ] Convergence was declared only when all four checks passed.
- [ ] No diverge mode occurred (no paraphrasing, no skipped
      branches, no bundled options, no accepted contradictions
      without a `Supersedes: Dxxx` record).
- [ ] The exit gate confirmation question was asked (unless the
      answer was unambiguous from context) and the answer was used
      to select the recommended exit per the per-answer branching
      rules.
- [ ] The chosen exit was handed off with the Decision Ledger path
      so downstream skills (PRD, tickets, blueprint) can cite
      records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger
      file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
