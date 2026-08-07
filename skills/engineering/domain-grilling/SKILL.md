---
name: domain-grilling
description: >-
  Relentless Socratic interviewing focused on Domain-Driven Design (DDD)
  alignment — bounded contexts, ubiquitous language, glossary, terminology.
  Use when the user has a vague idea and conceptual/terminology alignment
  is the goal. When non-DDD decisions, use `grilling`. When code/tech
  with a spec, use `code-implementation-grilling`.
license: MIT
---

# Domain `grilling`

A relentless Socratic interviewing skill, focused on Domain-Driven
Design (DDD) alignment. This skill specializes `grilling` for the case
where the user is establishing the *vocabulary* of a domain — its
bounded contexts, ubiquitous language, and the boundary between
concepts.

The core `grilling` machinery (Decision Ledger, options/recommendation
formats, locked question format, tone discipline, convergence test) is
owned by the `grilling` skill. This skill adds DDD-specific
initialization (glossary/ADR scan) and Term Resolution (writing terms
to `GLOSSARY.md`).

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

- Do not use when non-DDD decisions (business, product, process, design) that do
  not need conceptual alignment.
- Do not use when code/technical implementation choices when a spec/PRD exists.
- For trivial code changes or bug fixes where the domain model is not
  in question.
- For rapid prototypes that are known to be throwaway (spike code, demo code, time-boxed experiments).

## Convention: "you" in this skill

In this skill, "you" and "your" inside a backticked template, a fenced
code block, or a user-facing prompt **always refer to the user**, not
the LLM. The locked question line, the reference-set preamble, the
neutral-mirroring template, and any other text the agent emits to the
user are addressed to the user. Emit them verbatim and wait for the
user to respond before proceeding. Free-form instructions to the agent
in this skill use "the LLM" or "the agent" to refer to the agent. The
shared references (../`grilling`/references/*) state this rule
explicitly under their own "Convention" headers.

## Workflow

### Step 1: Load the references

Before the first user question, load and read in full:

- ../`grilling`/references/decision-ledger.md
- ../`grilling`/references/options-format.md
- ../`grilling`/references/recommendation-format.md
- ../`grilling`/references/locked-question-format.md
- ../`grilling`/references/tone-and-output.md
- ../`grilling`/references/convergence-test.md
- references/ddd-initialization.md
- references/term-resolution.md
- references/ADR-FORMAT.md

Apply the formats from those files verbatim throughout the session.
If any file is missing or unreadable, abort the session and report
the missing file to the user.

### Step 2: DDD initialization

Follow 
references/ddd-initialization.md to:

1. Scan the repo for `GLOSSARY.md`, `docs/adr/`, and any existing
   Decision Ledger. Summarize the current known domain state to the
   user *before* the first question.
2. If `GLOSSARY.md` is missing, suggest the
   `setup-matt-pocock-skills` skill but do not pre-emptively create
   the file.
3. Confirm the Decision Ledger path before the first write.

**Stop and wait for the user to confirm or change the path before
proceeding.** The path confirmation and the goal discovery in Step 3
are separate turns.

### Step 3: Goal discovery and branch opening

The first turn after the user has confirmed the ledger path is an
open question to surface the goal of the session. If the user has
pre-stated a goal, acknowledge it and ask for confirmation. If not,
ask the goal-discovery question:

> **What are your goals for this idea?**

Record the response as the goal record in the Decision Ledger.

Then open branches in rounds using the 1-turn wrapper from
../`grilling`/references/locked-question-format.md. Each branch
resolves in a single agent turn: round header, frontier statement,
context block (3-row table: Goal, Prior decisions, Scope), conflict
callout (if any), options table, recommendation.

Use the DDD-specific techniques in

references/ddd-initialization.md § "Session Guidelines" to:

- When the user uses a term that conflicts with `GLOSSARY.md`, load
  and apply the procedure in 
references/ddd-initialization.md §
  "Challenge against the glossary".
- When the user uses an overloaded term, load and apply the procedure
  in 
references/ddd-initialization.md § "Sharpen fuzzy language".
- When the user discusses concrete scenarios that test boundaries
  between concepts, load and apply the procedure in
  
references/ddd-initialization.md § "Discuss concrete scenarios".
- When the user states how something works, load and apply the
  procedure in 
references/ddd-initialization.md §
  "Cross-reference with code".
- When all three criteria in 
references/ADR-FORMAT.md hold, load
  and apply the procedure in 
references/ddd-initialization.md §
  "Offer ADRs sparingly".

### Step 4: Post-pick and Term Resolution

After the user resolves a branch, run the post-pick step (write `Dxxx`,
read-back, complete `Ixxx`). Then, if the resolved branch introduces a
new glossary term, follow 
references/term-resolution.md:

1. Propose the term and the working definition to the user.
2. On acceptance, write the term to `GLOSSARY.md` immediately
   (creating the file lazily if needed).
3. Update `GLOSSARY.md` if the user revises the definition later.

Term Resolution is a post-pick step, not part of the per-branch turn
sequence.

### Step 5: Per-round convergence

After the last branch in a round, run the 5-check convergence test
from ../`grilling`/references/convergence-test.md. If any check fails,
continue `grilling` or re-open the affected branch. When all five pass,
the agent may prompt for close-out; the user decides.

### Step 6: Exit gate and exit paths

Before listing exits, ask: "Will resolving this require writing
code?" with options Yes / No / I'm not sure. Skip the
question if the problem type is unambiguous from context.

- **Yes** — lead with the code-implementation-`grilling` exit, then
  present the other non-technical exits.
- **No** — skip the code-implementation-`grilling` exit; lead with
  "document the decision" as the recommended path.
- **I'm not sure** — present all available exits (including
  code-implementation-`grilling`) without a recommendation; do not
  ask a follow-up.

Every exit that drives downstream implementation work must include
the Decision Ledger path so downstream skills can cite records as
ilename#`Dxxx`:

| Path | Drives downstream work? | Ledger path required? |
|------|------------------------|------------------------|
| 1 — Create a plan/PRD document | Yes | Yes |
| 2 — Hand off to code-implementation-`grilling` | Yes | Yes |
| 3 — Break into tickets (`spec-to-tickets`) | Yes | Yes |
| 4 — Handoff to another agent | Yes | Yes |
| 5 — Custom Save | No | No |

### Step 7: Post-session deletion reminder

Per the Lifecycle by skill group table in
../`grilling`/references/decision-ledger.md, this skill's Decision
Ledger is **persisted by default**. After the user accepts the
chosen exit, remind the user in a single short turn that the Decision
Ledger is still on disk and can be deleted once implementation is
complete. The reminder is non-blocking. When the exit hands off to
`spec-to-tickets`, suppress the reminder.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All nine reference files were loaded and read in full before
      the first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported.
- [ ] DDD domain state summary was given before the first question.
- [ ] Decision Ledger path was confirmed before the first write.
- [ ] One Decision Ledger record was appended immediately after
      every resolved branch (no batching). In multi-pick rounds,
      all records were written in one tool call.
- [ ] Every record used the inline template and a fresh `Dxxx` ID.
- [ ] Every branch question followed the 1-turn wrapper: round
      header, frontier statement, context block (3-row table),
      conflict callout (if any), options table, recommendation.
      No Socratic elicitation question was emitted.
- [ ] Every context block was the 3-row table (Goal, Prior decisions,
      Scope), each element one sentence.
- [ ] Conflict detection ran before each branch resolution.
- [ ] Term Resolution ran as a post-pick step, not in the per-branch
      turn sequence.
- [ ] Every glossary term was proposed before being written to
      `GLOSSARY.md`.
- [ ] `GLOSSARY.md` was created lazily on the first write.
- [ ] Convergence was a per-round check; the agent offered close-out
      but the user decided.
- [ ] The exit gate question was asked and used to select the exit.
- [ ] The chosen exit was handed off with the Decision Ledger path.
- [ ] Every citation used the filename#`Dxxx` format.
- [ ] Post-session deletion reminder was emitted (suppressed for
      `spec-to-tickets` handoff).