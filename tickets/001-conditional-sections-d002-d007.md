---
title: Make Output Mode and Transitions conditional; add waza-skill-evaluator two-phase note
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Update the canonical skill schema (in `skill-architect`'s Step 4 and Validation list, and in the repo's `AGENTS.md`) so Output Mode and Transitions are recognized as conditional sections, included only when the design needs them — and add a one-sentence note to the Transitions list explaining the two-phase nature of the `waza-skill-evaluator` dependency.

## What to build

This ticket implements two decisions from the ledger:

- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D002` — Output Mode and Transitions are not always-mandatory sections. The schema in `skill-architect`'s Step 4 and the Validation list both update from "7 sections always present" to "5 mandatory + 2 conditional". `AGENTS.md` gets the same conditional rule so the foundation doc and the meta-skill agree.
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D007` — the Transitions list keeps both `waza-skill-evaluator` entries but adds a one-sentence note explaining the difference (Phase 1: generate the suite; Phase 2: run baseline).

Encode the conditional triggers as a concrete pattern:

- Include **Output Mode** if the design has a non-default output behaviour (i.e., the design intentionally deviates from the default of "draft in conversation, optionally save").
- Include **Transitions** if the design depends on a downstream tool or skill (e.g., `waza-skill-evaluator`, `saving-the-skill.md`, or any other named dependency).

## Recommended Workflow

### Step 1 — Update `skill-architect`'s Step 4 schema description

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 4 "Compliance Mapping", current lines 59–64)

- In the Step 4 bullet list, change from "Frontmatter / When to Use / When Not to Use / Output Mode / Workflow / Transitions / Validation" (7 always-present) to "Frontmatter / When to Use / When Not to Use / Workflow / Validation" (5 always-present) plus a separate bullet group for "Output Mode (conditional — include when the design has a non-default output behaviour)" and "Transitions (conditional — include when the design depends on a downstream tool or skill)".
- Reorder the list so the 5 mandatory sections appear first, then the 2 conditional ones, so the priority is visible at a glance.

Verify: Reading the Step 4 bullets top-to-bottom, the first 5 are the always-present sections and the last 2 are explicitly labelled "conditional" with the trigger condition stated.

### Step 2 — Update `skill-architect`'s Validation list

Where: `skills/skills-meta/skill-architect/SKILL.md` (Validation section, current line 86)

- In the "Structural Integrity" Validation bullet, change the parenthetical from "(Frontmatter, When to Use, When Not to Use, Output Mode, Workflow, Transitions, Validation)" to the same 5 + 2 conditional structure used in Step 4.
- Add an inline note clarifying that the 2 conditional sections are checked only when their trigger condition applies — Output Mode is required only if the design has a non-default output behaviour; Transitions is required only if the design depends on a downstream tool or skill.

Verify: The Structural Integrity bullet enumerates exactly 5 mandatory sections in its pass/fail criterion, and the 2 conditional sections are gated by a stated trigger.

### Step 3 — Sync `AGENTS.md` to the conditional schema

Where: `AGENTS.md` (Skill file conventions section)

- Update the "Every `SKILL.md` must have" enumeration to match the 5 + 2 conditional structure. The current `AGENTS.md` lists 5 sections in the bullet list (Frontmatter, When to Use, When Not to Use, Workflow, Validation); Output Mode and Transitions are not mentioned.
- Add a brief rule explaining the conditional pattern — "Output Mode is included when the skill's design has a non-default output behaviour; Transitions is included when the skill depends on a downstream tool or skill" — so future skill authors understand when to include them.
- The wording must be consistent with the conditional rule applied in Step 1 and Step 2.

Verify: `AGENTS.md`'s section-list enumeration matches the 5 + 2 conditional structure used in `skill-architect`'s Step 4, and the conditional rule is stated in plain language.

### Step 4 — Add the two-phase note to the Transitions list

Where: `skills/skills-meta/skill-architect/SKILL.md` (Transitions section, current lines 76–81)

- Keep the existing 3-entry list: `references/saving-the-skill.md`, `waza-skill-evaluator`, `waza-skill-evaluator`.
- Add a one-sentence parenthetical or sub-bullet to the second `waza-skill-evaluator` entry that says: "Phase 1: generate the suite. Phase 2: run baseline." Do not expand into a multi-paragraph explanation.
- The list is still structurally a 3-item chain; the note clarifies the two-phase nature of the second dependency.

Verify: The Transitions list has 3 entries, the second and third are both `waza-skill-evaluator`, and the difference between them is stated in a single sentence.

## Context pointers

**Files**:
- `skills/skills-meta/skill-architect/SKILL.md` — the meta-skill being updated (Step 4 Compliance Mapping, Validation section, Transitions section)
- `AGENTS.md` — the foundation doc that defines the canonical schema

**ADRs**: None.

**Domain terms**:
- **Waza Eval Suite** — the eval format AGENTS.md mandates: `eval.yaml` + `tasks/` + `fixtures/`. The two-phase `waza-skill-evaluator` reference (Phase 1: generate the suite; Phase 2: run baseline) is part of the downstream chain.

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D002` — Output Mode and Transitions are conditional sections; the schema updates from 7-always-present to 5-mandatory-plus-2-conditional
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D007` — add a one-sentence note explaining the two-phase nature of the `waza-skill-evaluator` Transitions entries

## Acceptance criteria

- [ ] `skills/skills-meta/skill-architect/SKILL.md` Step 4 lists exactly 5 mandatory sections (Frontmatter, When to Use, When Not to Use, Workflow, Validation) plus 2 conditional sections (Output Mode, Transitions), each conditional section labelled with its trigger condition.
- [ ] `skills/skills-meta/skill-architect/SKILL.md` Validation → Structural Integrity bullet uses the same 5 + 2 conditional structure.
- [ ] `AGENTS.md`'s schema description is consistent with the 5 + 2 conditional rule (the conditional rule is stated in plain language so future skill authors understand when to include the 2 conditional sections).
- [ ] The Transitions list in `skill-architect` has 3 entries; the difference between the two `waza-skill-evaluator` entries is stated in a single sentence (Phase 1: generate the suite; Phase 2: run baseline).
- [ ] No other section in `SKILL.md` or `AGENTS.md` contradicts the 5 + 2 conditional structure.

## Dependencies

**Blocked by**: None — can start immediately.
