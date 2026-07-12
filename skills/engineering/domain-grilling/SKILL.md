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

- Do not use when non-DDD decisions (business, product, process, design) that do
  not need conceptual alignment.
- Do not use when code/technical implementation choices when a spec/PRD exists.
- For trivial code changes or bug fixes where the domain model is not
  in question.
- For rapid prototypes that are known to be throwaway (spike code, demo code, time-boxed experiments).

## Convention: "you" in this skill

In this skill, "you" and "your" inside a backticked template, a fenced
code block, or a user-facing prompt **always refer to the user**, not
the LLM. The Socratic elicitation question, the locked question line,
the reference-set preamble, the neutral-mirroring template, and any
other text the agent emits to the user are addressed to the user. Emit
them verbatim and wait for the user to respond before proceeding.
Free-form instructions to the agent in this skill use "the LLM" or
"the agent" to refer to the agent. The shared references
(`../grilling/references/*`) state this rule explicitly under their
own "Convention" headers.

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

**Stop and wait for the user to confirm or change the path before
proceeding.** The path confirmation, the first branch in Step 3, and
each part of the four-part sequence within a branch are all separate
turns. Do not emit the first branch question in the same turn as the
path confirmation, and do not collapse the context block, Socratic
elicitation question, locked question line, and options into a single
turn.

### Step 3: Open branches, ask questions, record decisions

Open each decision branch using the four-part locked question sequence
from `../grilling/references/locked-question-format.md`. The four
parts are emitted across three separate agent turns with mandatory
waits between them. The agent must not collapse them into a single
turn and must not skip the context block or Socratic elicitation
question, even on a re-ask or a follow-up after the user has answered
earlier parts.

In the four-part sequence, "you" and "your" always refer to the
**user**, not the LLM. The locked question line, the Socratic
elicitation question, the reference-set preamble, and any other
user-facing prompt are addressed to the user. The agent emits them
verbatim and waits for the user to respond.

The three turns are:

1. **Turn 1 — Context block (Part 1) + Socratic elicitation question
   (Part 2).** Present the fixed context block (goal, prior decisions,
   stakes, scope), each element one sentence, citing the goal record
   (D001) and any prior branch records. Then ask the Socratic
   elicitation question verbatim. **Stop and wait for the user's
   response.**

   The Socratic elicitation question is:

   ```
   **What are you working toward in this decision?**
   ```

2. **Turn 2 — Locked question line (Part 3).** After the user answers
   the Socratic elicitation question, present the locked question line
   verbatim. **Stop and wait for the user's answer.**

   The locked question line is:

   ```
   **For [Dxxx] – [branch name]: required — state your answer before
   the LLM presents options. You may also pick an option, or provide
   your answer.**
   ```

   The `[Dxxx]` is `max(existing Dxxx) + 1`. The `[branch name]` is a
   short, descriptive, stable name for the branch (do not embed the
   full question in it). The "you" and "your" inside the template
   refer to the user.

3. **Turn 3 — Options and recommendation (Part 4).** After the user
   answers the locked question, present the options block (with the
   reference-set preamble from `../grilling/references/options-format.md`)
   and the recommendation (with goal-aligned reasoning from
   `../grilling/references/recommendation-format.md`).

   The reference-set preamble is:

   ```
   Here are options to help you refine or confirm your answer. Pick
   one, reject all, or hybridize.
   ```

   Again, the "you" and "your" inside the preamble refer to the user.

The user may confirm their answer, revise it in light of the options,
or hybridize. The user's own answer is the anchor; the options are a
reference set.

Walk the user through one branch at a time. For every branch, the
three turns above are mandatory. Re-asking a branch (because the user
did not answer, asked for clarification, or because of a follow-up)
restarts at Turn 1 with a fresh context block and Socratic elicitation
question — do not skip straight to the locked question line or the
options.

On first use of a `Dxxx` record in this skill, load the record format
from `../grilling/references/decision-ledger.md` § "Per-branch record
template". After each resolution, append a `Dxxx` record to the
Decision Ledger in real time.

Use the DDD-specific techniques in
`references/ddd-initialization.md` § "Session Guidelines" to:

- When the user uses a term that conflicts with `CONTEXT.md`, load and
  apply the procedure in
  `references/ddd-initialization.md` §
  "Challenge against the glossary".
- When the user uses an overloaded term, load and apply the procedure
  in `references/ddd-initialization.md` § "Sharpen fuzzy language".
- When the user discusses concrete scenarios that test boundaries between
  concepts, load and apply the procedure in
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
- [ ] Every record used the inline template (`Driver`, `Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Every record's `Driver` field captured the user's underlying
      principle or motivation, distinct from `Resolved Answer` (the
      what) and `Normalized Requirement` (the testable outcome).
- [ ] Re-opened branches produced a new record with a `Supersedes:
      Dxxx` line in `Constraints`.
- [ ] Every branch question followed the four-part locked question
      sequence: context block, Socratic elicitation question, locked
      question line with explicit required framing, options and
      recommendation.
- [ ] Every branch question, including re-asks and follow-ups, emitted
      the full four-part sequence across three separate agent turns:
      a context block + Socratic elicitation question turn, a locked
      question line turn, and an options + recommendation turn. The
      agent did not skip the context block or Socratic elicitation
      question on a re-ask, and did not collapse the four parts into
      a single turn.
- [ ] Every context block was emitted as the four-element bullet list
      (Goal, Prior decisions, Stakes, Scope) in that order, each
      element exactly one sentence, with ledger citations. The context
      block was not replaced with a free-form prose summary, a "current
      state" investigation, a code reading, a domain-glossary recap,
      or any other kind of analysis.
- [ ] Every context block included all four mandatory elements (goal,
      prior decisions, stakes, scope), each one sentence, with ledger
      citations.
- [ ] Every Socratic elicitation question used the fixed phrasing:
      "What are you working toward in this decision?"
- [ ] Every locked question line included the explicit required framing:
      `required — state your answer before the LLM presents options.`
- [ ] Every options block was preceded by the reference-set preamble:
      "Here are options to help you refine or confirm your answer. Pick
      one, reject all, or hybridize."
- [ ] Every question offered all natural options (typically 2–4)
      that passed the four-field defensibility test.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every recommendation's `Reasoning` field was goal-aligned (not
      option-comparison), explaining why the recommended option serves
      the user's stated goal.
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
- [ ] Term Store Consistency verified (per `references/term-resolution.md` § Term Store Consistency).
- [ ] Convergence was declared only when all four checks passed.
- [ ] No diverge mode occurred (no paraphrasing, no skipped
      branches, no bundled options, no multiple questions in one
      turn, no accepted contradictions without a `Supersedes: Dxxx`
      record).
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
