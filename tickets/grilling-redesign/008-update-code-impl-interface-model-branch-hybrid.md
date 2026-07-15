---
title: Update code-impl interface-and-model-branch to hybrid format
classification: Independent
blocked_by: ["003-add-spec-section-5th-element-code-impl"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Update `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md` so per-decision questions (architectural decisions, source-of-truth conflicts, type introductions) follow the parent grilling skill's locked question format with the 5-element code-impl context block (per `TK003` / D011), while phase-transition meta-questions (count questions, ready-to-move questions) keep their lightweight format.

## What to build

In `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`:

- Identify the per-decision questions and the phase-transition meta-questions.
- For per-decision questions: reformat each instance to use the parent grilling skill's locked question format:
  - 5-element context block (per `TK003` / D011: Goal, Prior decisions, Stakes, Scope, Spec section).
  - Optional Socratic question (per `TK001` / D003 wording).
  - Locked question line (per `TK001` / D004 wording).
  - Options + recommendation.
- For phase-transition meta-questions: keep the current lightweight format (for example, "How many architectural decisions do you want to resolve? (0-3)" and "Ready to move to Source of Truth?").
- Add an explicit instruction that distinguishes phase-transition meta-questions (not subject to the locked question format) from per-decision questions (subject to the locked question format).
- Update any worked examples in the file to reflect the hybrid format.

What NOT to do:

- Do not convert phase-transition meta-questions to the locked question format — keep them lightweight.
- Do not restructure the file's branch model (for example, introducing formal branches for the meta-questions).
- Do not change the 5-element context block format itself (that is `TK003`'s scope; this ticket applies the 5-element format to per-decision questions).

## Recommended Workflow

### Step 1 — Read the current interface-and-model-branch file

Where: `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`

- Identify each question in the file.
- Classify each as: per-decision (architectural decision, source-of-truth conflict, type introduction) or phase-transition meta-question (count question, ready-to-move question).
- Note the line range for each question.

Verify: A list of every question, classified, with line ranges.

### Step 2 — Read the parent locked question format

Where: `skills/engineering/grilling/references/locked-question-format.md`

- Capture the 2-turn sequence (per `TK001`): Turn 1 = context block plus optional Socratic; Turn 2 = locked question plus options plus recommendation.
- Capture the 5-element code-impl context block (per `TK003`).

Verify: Both formats are captured for application.

### Step 3 — Reformat per-decision questions to the locked question format

Where: `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`

- For each per-decision question identified in Step 1, reformat to the 2-turn sequence with the 5-element context block.
- Preserve the question's specific content (the actual decision being asked about) — only the format changes.

Verify: Per-decision questions use the 2-turn sequence; phase-transition meta-questions are unchanged.

### Step 4 — Add the explicit meta-question vs. per-decision instruction

Where: `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md`

- Add an instruction block at the top (or in a "Format" section) that distinguishes:
  - Phase-transition meta-questions: NOT subject to the locked question format (keep current lightweight format).
  - Per-decision questions: subject to the locked question format (2-turn sequence with 5-element context block).

Verify: The instruction block is present and clear.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md` — primary edit target
- `skills/engineering/grilling/references/locked-question-format.md` — source of the 2-turn sequence (read-only; updated by `TK001`)
- `skills/engineering/code-implementation-grilling/SKILL.md` — read-only; the 5-element context block may be defined here (per `TK003`)

**ADRs**: None.

**Domain terms**:
- Per-decision question — a question about a specific decision (architectural decision, source-of-truth conflict, type introduction); subject to the locked question format
- Phase-transition meta-question — a lightweight question that paces the workflow (for example, count questions, ready-to-move questions); NOT subject to the locked question format
- Hybrid format — the per-decision / meta-question split within a single reference file

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D012` — the hybrid format requirement
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D011` — the 5-element context block (applied via `TK003`)

## Acceptance criteria

- [ ] Per-decision questions in `interface-and-model-branch.md` use the parent grilling skill's locked question format (2-turn sequence with 5-element context block).
- [ ] Phase-transition meta-questions (count questions, ready-to-move questions) keep their current lightweight format.
- [ ] The file includes an explicit instruction that distinguishes phase-transition meta-questions (not subject to the locked question format) from per-decision questions (subject to the locked question format).
- [ ] Worked examples in the file reflect the hybrid format.
- [ ] The 5-element context block format itself is unchanged (per `TK003`).
- [ ] The branch model in the file is not restructured.

## Dependencies

**Blocked by**: `003-add-spec-section-5th-element-code-impl` — `TK008` applies the 5-element context block established by `TK003`.
