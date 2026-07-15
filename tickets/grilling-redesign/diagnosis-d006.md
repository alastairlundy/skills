# Diagnosis D006 — code-implementation-grilling context block deviation

Topic: Diagnose the specific deviation in
`code-implementation-grilling`'s context block relative to the parent
`grilling` skill's 4-element format. This diagnosis is the input for the
follow-up fix tickets (TK003, TK004, TK008). Read-only — no edits to
either skill or its references.

## 1. Parent 4-element block (reference format)

Source: `skills/engineering/grilling/references/locked-question-format.md`
Part 1, and `skills/engineering/grilling/SKILL.md` Step 4 (Turn 1).

Verbatim template:

```md
- **Goal**: <one sentence — the goal of the overall decision, citing D001>
- **Prior decisions**: <one sentence — the prior decisions that affect
  this branch, with ledger citations (e.g., D002, D003)>
- **Stakes**: <one sentence — why this decision matters>
- **Scope**: <one sentence — what is in and out of this decision>
```

Constraints (per `references/locked-question-format.md` Part 1 and the
parent SKILL.md validation list):

- **Order is fixed**: Goal, Prior decisions, Stakes, Scope.
- **Element count is fixed**: exactly four elements, no element may be
  omitted.
- **Each element is exactly one sentence.**
- **Ledger citations** are required in the **Goal**, **Prior
  decisions**, and **Stakes** items (the `Scope` item names what is in
  and out of scope and does not require a citation).
- The context block is a **structured bullet list**. It is not a
  free-form prose summary, a "current state" reading, a code
  investigation, a domain-glossary recap, or any other kind of
  analysis.
- The validation check in the parent SKILL.md (lines 418-423) is
  verbatim: *"Every context block was emitted as the four-element
  bullet list (Goal, Prior decisions, Stakes, Scope) in that order,
  each element exactly one sentence, with ledger citations. The
  context block was not replaced with a free-form prose summary, a
  'current state' investigation, a code reading, a domain-glossary
  recap, or any other kind of analysis."*

The parent SKILL.md and `references/locked-question-format.md` both
enforce this as the locked format for every branch question.

## 2. Code-impl current context block

The code-implementation-grilling skill **does not define its own
context block format**. The 4-element block is referenced but never
explicitly redefined for code-impl. The relevant locations:

### 2.1 `skills/engineering/code-implementation-grilling/SKILL.md`

- Workflow intro (lines 34-44): "Every branch question in this skill
  follows the three-turn locked question sequence from
  `../grilling/references/locked-question-format.md`. The skill's
  steps (4, 5, 6) call the sequence, but the format itself — context
  block, Socratic elicitation question, locked question line, options
  + recommendation — is defined by that reference. The shared
  references (`../grilling/references/*`) also define the 'you'
  convention, tone discipline, options format, and recommendation
  format. This skill defers to those references for all of those
  formats."
- Step 4 (lines 96-110, Foundation Establishment): "Resolve one-by-one
  using the three-turn locked question sequence from
  `../grilling/references/locked-question-format.md`. For each
  foundation item, emit a context block, Socratic elicitation
  question, locked question line, and options + recommendation across
  three separate agent turns."
- Step 5.3 (lines 128-129, TDP resolution): "Grill on each TDP using
  the three-turn sequence from
  `../grilling/references/locked-question-format.md`."
- Step 6 (lines 137-143, Interface & Model Branch): "Follow
  `references/interface-and-model-branch.md`. The phases are
  sequential, not nested. Use the three-turn locked question sequence
  from `../grilling/references/locked-question-format.md` for each
  architectural decision, source-of-truth conflict, and type
  introduction."
- Step 7 (lines 145-148, Output Selection): "Follow
  `references/output-selection.md`. Present the two-part choice one
  part at a time, using the three-turn sequence for each part."
- Validation list (lines 198-203): includes the 4-element context
  block check (verbatim text from the parent).

The SKILL.md references the context block by name and defers to the
parent for its definition. It does not redefine the 4-element block,
nor does it add a 5th element for code-impl.

### 2.2 `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`

- Lines 30-32 (Phase 1, per-decision text): "Present each decision
  with 2-4 options, trade-offs, and a recommendation. Wait for the
  user's response before presenting the next decision." — **No
  context block emitted**, no Socratic question, no locked question
  line. The per-decision questions in Phase 1 do not use the locked
  question format.
- Lines 42-46 (Phase 2, per-conflict text): "For each conflict,
  present the two plausible sources and ask the user which is
  canonical. Wait for the user's response before presenting the next
  conflict." — **No context block emitted**, no Socratic question, no
  locked question line. Per-conflict questions do not use the locked
  question format.
- Lines 56-67 (Phase 3, type introduction): "Introduce exactly one
  named type per turn. For each type: 1. Present the type's full
  signature, fields or properties, and a 1-2 sentence rationale for
  why it exists." — **No context block emitted**, no Socratic
  question, no locked question line. Type introductions do not use
  the locked question format.
- The meta-questions ("How many architectural decisions do you want
  to resolve? (0-3)", "Ready to move to Source of Truth?", "Ready to
  move to the type loop?", "Any more, or ready to move on?") are
  phase-transition meta-questions and intentionally lightweight.

### 2.3 `skills/engineering/code-implementation-grilling/references/recording-decisions.md`

- Lines 6-13: Txxx record template. No context block definition or
  emission.

### 2.4 `skills/engineering/code-implementation-grilling/references/output-selection.md`

- Lines 6-56: Output Selection Part A (Option A and Option B). No
  context block definition or emission.

### 2.5 `skills/engineering/code-implementation-grilling/references/validation.md`

- Lines 10-18: Three-turn procedure check (will become stale after
  the parent moves to 2-turn per TK001).
- **No 4-element context block check** in the file. The 4-element
  check exists in the code-impl SKILL.md validation list (lines
  198-203) but is missing from `references/validation.md`.

### 2.6 `skills/engineering/code-implementation-grilling/references/terminal-output.md`

- No context block definition or emission. Terminal handoff templates
  only.

## 3. Differences

### 3.1 Missing elements (parent has, code-impl does not)

- **4-element context block check in `references/validation.md`.**
  The parent SKILL.md has the check (verbatim). The code-impl
  SKILL.md validation list has the check (verbatim copy). The
  code-impl `references/validation.md` does **not** have the check.
  This is a gap: a validating agent that only reads
  `references/validation.md` will not catch a non-parity context
  block emission. **Fix**: TK004 adds the verbatim parent check to
  `references/validation.md`.

- **5-element code-impl context block (Goal, Prior decisions, Stakes,
  Scope, Spec section).** The parent defines a 4-element block. The
  code-impl needs a 5th element ("Spec section") to capture the spec
  file path and the specific section or functional requirement the
  branch addresses (per D011). Neither the code-impl SKILL.md nor
  any code-impl reference currently defines or emits this 5th
  element. **Fix**: TK003 adds the 5th element definition (in the
  file identified in §4 below) and updates the validation check.

### 3.2 Extra elements (code-impl has, parent does not)

- None identified. The code-impl does not define any extra context
  block elements beyond the parent's 4. It does not emit its own
  context block format anywhere; it defers to the parent.

### 3.3 Different ordering

- N/A. The code-impl does not define or emit a context block, so
  there is no ordering to compare against the parent's fixed order
  (Goal, Prior decisions, Stakes, Scope). When the code-impl emits
  context blocks (via the parent's 3-turn sequence, which is now
  2-turn per TK001), it inherits the parent's order by reference.

### 3.4 Inconsistent application

- **Per-decision questions in `interface-and-model-branch.md` do not
  use the locked question format.** Phase 1 architectural decisions,
  Phase 2 source-of-truth conflicts, and Phase 3 type introductions
  are all per-decision questions that should follow the parent's
  locked question format (context block + optional Socratic + locked
  question line + options + recommendation). The current file
  presents these decisions without a context block, without a
  Socratic question, and without a locked question line. The
  phase-transition meta-questions ("How many architectural decisions
  do you want to resolve? (0-3)", "Ready to move to Source of
  Truth?", "Ready to move to the type loop?", "Any more, or ready to
  move on?") are intentionally lightweight and correctly stay that
  way. **Fix**: TK008 adds a "Format" section that distinguishes
  phase-transition meta-questions (not subject to the locked
  question format) from per-decision questions (subject to the locked
  question format with the 5-element code-impl context block from
  TK003), and reformats the per-decision questions accordingly.

- **Stale 3-turn references in the code-impl SKILL.md and Step 5.2
  text.** The parent has moved to 2-turn per TK001, but the code-impl
  SKILL.md still uses "three-turn sequence" and "three separate
  agent turns" in Step 4, Step 5.3, Step 6, Step 7, and the
  validation list. The code-impl `references/validation.md` also
  has the stale 3-turn check. **Out of scope for this diagnosis**;
  the propagation to code-impl is not part of TK001-TK008. This is
  a known follow-up to be tracked separately.

## 4. Where the format is defined in code-impl

The code-impl context block format is **not explicitly defined** in
the code-impl skill. The code-impl SKILL.md defers to the parent's
`../grilling/references/locked-question-format.md` for the 4-element
block. No code-impl reference (interface-and-model-branch.md,
output-selection.md, recording-decisions.md, validation.md,
terminal-output.md) defines or re-emits the 4-element block.

**Recommended location for the 5-element code-impl definition**:
`skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`.
Rationale: this is the file where per-decision questions are
reformatted to use the locked question format (TK008). The
5-element code-impl context block is most relevant to the
per-decision questions in that file, and TK008 needs the 5-element
definition in hand. Adding the 5-element definition here (as a
"Format" section or "Code-impl context block (5 elements)" section)
keeps the format co-located with its primary use site. An
alternative is the code-impl SKILL.md (a new section between Step 1
and Step 2, or as a note in Step 4); TK003's ticket notes that the
file is "likely `interface-and-model-branch.md` or `SKILL.md`,
depending on the diagnosis."

**Selected**: `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`
— the 5-element definition lives in the same file as the per-decision
questions that use it (TK008 then references the definition).

## 5. Where the format is applied in code-impl

The 4-element context block (parent format) is **referenced** in
code-impl at the following sites, but **not applied** at any
per-decision site:

- **Referenced (not emitted):**
  - `skills/engineering/code-implementation-grilling/SKILL.md` lines
    34-44, 96-110, 128-129, 137-143, 145-148, 198-203. These
    references instruct the agent to use the parent's 3-turn
    (now 2-turn per TK001) locked question sequence, which includes
    the 4-element context block.
  - `skills/engineering/code-implementation-grilling/SKILL.md` lines
    198-203: the validation list verifies the 4-element context
    block check.
- **Not applied (per-decision questions skip the locked question
  format):**
  - `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`
    Phase 1 (architectural decisions, lines 30-32), Phase 2
    (source-of-truth conflicts, lines 42-46), Phase 3 (type
    introductions, lines 56-67). These are per-decision questions
    that should follow the locked question format but currently do
    not. TK008 reformats them.

Per the code-impl SKILL.md, the locked question format is intended to
apply to all branch questions (foundation items in Step 4, TDPs in
Step 5, architectural decisions / source-of-truth conflicts / type
introductions in Step 6, output format choice in Step 7). The
deviation is concentrated in Step 6 (the Interface & Model Branch
phases), where the per-decision questions skip the context block,
Socratic, and locked question line.

## 6. Summary

| Concern | Status in code-impl today | Fix ticket |
|---|---|---|
| 4-element context block definition | Not defined in code-impl; defers to parent | None needed (parent definition is correct) |
| 4-element context block check in `references/validation.md` | Missing | TK004 |
| 5-element code-impl context block (Spec section) | Not defined or emitted | TK003 |
| Per-decision questions use locked question format | Not applied in `interface-and-model-branch.md` | TK008 |
| Phase-transition meta-questions stay lightweight | Correctly lightweight today | None needed (TK008 preserves this) |
| Stale 3-turn references in code-impl SKILL.md | Many (Step 4, Step 5.3, Step 6, Step 7, validation list) | Out of scope for TK001-TK008; tracked separately |

**Bottom line**: The code-impl skill's primary deviations from the
parent context block format are (a) the missing 4-element check in
`references/validation.md` (fix: TK004), (b) the missing 5th element
"Spec section" (fix: TK003), and (c) the per-decision questions in
`interface-and-model-branch.md` that skip the locked question format
(fix: TK008). The phase-transition meta-questions are correctly
lightweight and should stay that way.
