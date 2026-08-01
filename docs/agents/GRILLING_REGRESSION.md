# Grilling Skill Regressions — Mirror Plan

This file records three regressions found in `skills/engineering/grilling/`
during a session on 2026-07-11, the fixes applied to the parent grilling
skill, and the changes that still need to be mirrored into
`skills/engineering/domain-grilling/` and
`skills/engineering/code-implementation-grilling/`.

The two specialized skills share the four-part locked question format via
`../grilling/references/`, so the **reference-level** fixes
(`locked-question-format.md`, `options-format.md`, `recommendation-format.md`,
`tone-and-output.md`) are already shared automatically. The
**workflow-level** fixes (turn boundaries, hard stops, three-turn
structure, validation checks) live in `grilling/SKILL.md` and must be
mirrored by hand.

## Regressions found

### R1 — Two questions in one turn

The agent emitted the ledger-state summary, the path-confirmation prompt,
and the first branch question (with options and recommendation) in the
**same agent turn**. The user was asked to do two things at once: confirm
the path *and* answer the D001 question. Violates the
"asking multiple questions in one turn" diverge mode recorded in
`grilling/references/convergence-test.md`.

### R2 — Context block + Socratic elicitation question skipped on re-asks

When the agent re-asked D001 (because the user had only confirmed the
path, not answered D001), it emitted the locked question line, the
options, and the recommendation, but omitted the **context block** (Part
1) and the **Socratic elicitation question** (Part 2). Violates the
four-part sequence in `grilling/references/locked-question-format.md`
and the "no skipping a branch" / "no asking multiple questions in one
turn" diverge modes.

### R3 — Context block replaced with free-form prose

When the user explicitly asked the agent to "apply the rules regarding
context", the agent produced a "Current state of the type" prose
reading (a code investigation) **in place of** the four-element context
block. The context block template specifies a structured bullet list
with exactly four items in a fixed order; the agent substituted its own
prose format. Violates the format spec in Part 1 of
`grilling/references/locked-question-format.md`.

## Fixes applied to `grilling/`

All applied in this session. The file is `+146/-30` lines across five
files. The summary below is the agent-readable anchor; the full diffs
are in git history (look for the two follow-up commits after
`a54c9eb`).

### Workflow (SKILL.md)

- **Step 2** — added a hard stop after the path confirmation. The path
  confirmation, the goal discovery (Step 3), and the first branch
  (Step 4) are now explicitly three separate turns.
- **Step 3** — reworded "the first turn after the ledger state summary"
  to "the first turn after the user has confirmed the ledger path in
  Step 2", and added a hard stop before opening any branch question.
- **Step 4** — replaced the four-part list with an explicit **three-turn
  structure**: Turn 1 emits Parts 1+2 (context block + Socratic
  elicitation question) and waits; Turn 2 emits Part 3 (locked question
  line) and waits; Turn 3 emits Part 4 (options + recommendation).
  Re-asks restart at Turn 1 — never skip to Turn 2 or Turn 3.
- **Step 4** — added a "you = user" convention: "you" and "your" inside
  any user-facing template (Socratic question, locked question line,
  reference-set preamble) refer to the **user**, not the LLM. Each
  user-facing template is now in a fenced code block to fence it off
  from the surrounding free-form instructions.
- **Validation** — added a checklist item for the three-turn structure
  on re-asks, and strengthened the context-block check to forbid
  prose, code-reading, or "current state" substitutes.

### References

- `locked-question-format.md` — added a "Convention: 'you' in this
  reference" header; converted the Socratic elicitation question from a
  blockquote to a fenced code block; strengthened Part 1's description
  to forbid prose substitutes; added a "Counter-example" section showing
  the wrong form (the R3 prose reading) and the right form (the
  four-element bullet list) side by side; added a Rules bullet for the
  same anti-pattern.
- `options-format.md` — added a "Convention: 'you' in this reference"
  header; converted the reference-set preamble from a blockquote to a
  fenced code block.
- `recommendation-format.md` — added a "Convention: 'you' in this
  reference" header (the existing "your goal" usage in the Reasoning
  template is now explicitly named in the note).
- `tone-and-output.md` — added a "Convention: 'you' in this reference"
  header (the existing "You're saying" usage in the neutral-mirroring
  template is now explicitly named in the note).

## What to mirror into `domain-grilling/`

`domain-grilling/SKILL.md` references the four-part sequence at
`../grilling/references/*`, so the reference-level fixes are already
shared. The workflow-level fixes that still need to be mirrored:

1. **Three-turn structure for branches.** `Step 3: Open branches, ask
   questions, record decisions` currently says "Walk the design tree
   branch-by-branch using the locked question format" but does not
   enforce the three turns. Mirror the new `grilling/SKILL.md` Step 4:
   - Turn 1: context block + Socratic elicitation question, then stop.
   - Turn 2: locked question line, then stop.
   - Turn 3: options + recommendation.
   - Re-asks restart at Turn 1.

2. **Hard stop between the Decision Ledger path confirmation and the
   first branch.** `Step 2: DDD initialization` ends with "Confirm the
   Decision Ledger path before the first write." Add a hard-stop
   sentence after that: the path confirmation, the first branch, and
   each part of the four-part sequence are all separate turns.

3. **"you = user" disambiguation in the workflow.** Add a one-line
   convention note in `Step 3` (or in a new "Convention" section near
   the top of the SKILL) that mirrors the one in
   `grilling/SKILL.md` Step 4. The references are already fixed; the
   workflow just needs to be consistent.

4. **Validation: context-block check.** Strengthen the existing
   "Every context block included all four mandatory elements …" check
   (line 183) to the same wording as the new `grilling/SKILL.md`
   validation: explicit prohibition on prose, code-reading, or
   "current state" substitutes.

5. **Validation: re-ask check.** Add a peer to the new
   `grilling/SKILL.md` validation item: "Every branch question,
   including re-asks and follow-ups, emitted the full four-part
   sequence across three separate agent turns."

6. **No changes to `references/ddd-initialization.md` or
   `references/term-resolution.md`.** These don't have user-facing
   templates with "you" usages and don't define the four-part sequence.

## What to mirror into `code-implementation-grilling/`

`code-implementation-grilling/SKILL.md` already has a "Core Constraint"
at line 34 ("Ask exactly one question per turn — hard stop. Emit one
locked question, then stop generating.") and references the shared
references, so the spirit of the fix is partially there. The
workflow-level fixes that still need to be mirrored:

1. **Three-turn structure for branches.** `Step 4: Spec-Driven
   Technical Extraction` (and any other step that emits a branch
   question) currently emits the full four-part sequence at once. The
   "one locked question per turn" Core Constraint is correct, but the
   constraint reads as "one branch per turn"; it should also cover
   "one part per turn" within a branch. Mirror the new
   `grilling/SKILL.md` Step 4 three-turn structure verbatim.

2. **"you = user" disambiguation in the workflow.** Add a one-line
   convention note mirroring the one in `grilling/SKILL.md` Step 4.

3. **Validation: context-block check.** `code-implementation-grilling`
   has no Validation section today. Add one with at least:
   - Four-part sequence followed (context block, Socratic elicitation
     question, locked question line, options + recommendation).
   - Context block is the four-element bullet list, not a prose
     substitute.
   - Re-asks restart at Turn 1, not Turn 2 or Turn 3.
   - "you" inside user-facing templates refers to the user.

4. **No changes to the shared references.** Same as domain-grilling.

## Verification

After mirroring into both specialized skills, the following should hold
across all three skills:

- A user prompt that triggers a branch question produces **exactly
  three** agent turns before the user is asked to answer the locked
  question: one with the context block and Socratic elicitation
  question, one with the locked question line, and one with the
  options and recommendation. This holds for first emissions *and*
  re-asks.
- A user prompt asking the agent to "apply the context block rule"
  produces the four-element bullet list with `Dxxx` citations, not a
  prose summary or code reading.
- A user prompt that triggers the path confirmation (in grilling and
  domain-grilling) does not also open a branch question in the same
  turn.
- The "you" and "your" inside every user-facing template are
  unambiguously addressed to the user, both because the surrounding
  context makes it clear and because the new "Convention" header
  states the rule.

A waza eval task per regression (R1, R2, R3) would let the
`waza run` / `waza run --baseline` tooling catch a re-introduction.
The existing `skills/engineering/grilling/evals/` directory has the
pattern.
