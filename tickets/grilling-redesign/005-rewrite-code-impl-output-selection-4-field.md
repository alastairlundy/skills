---
title: Rewrite code-impl output-selection Part A to parent's 4-field format
classification: Independent
blocked_by: ["002-diagnose-code-impl-context-block-deviation"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Rewrite Part A of `skills/engineering/code-implementation-grilling/references/output-selection.md` so both Option A (Implementation Blueprint) and Option B (PRD Augmentation) use the parent grilling skill's 4-field format (What it is, Benefit, Cost, Risk), one sentence per field. Rename "Trade-offs" to "Benefit" and "Risks" to "Risk" to match the parent.

## What to build

In `skills/engineering/code-implementation-grilling/references/output-selection.md` Part A (Output format):

- For Option A (Implementation Blueprint) and Option B (PRD Augmentation): use the parent grilling skill's 4-field format with the following fields in order:
  - "What it is" — one sentence describing the option.
  - "Benefit" — one sentence describing the gain.
  - "Cost" — one sentence describing the sacrifice.
  - "Risk" — one sentence describing the most likely failure mode.
- Rename "Trade-offs" to "Benefit" everywhere in Part A.
- Rename "Risks" to "Risk" everywhere in Part A.
- Add an explicit instruction that each field is one sentence and that all four fields are required.

Part B (Downstream consumer) is unchanged.

What NOT to do:

- Do not introduce a code-impl-specific 4-field format — use the verbatim parent format.
- Do not keep the "Trade-offs" or "Risks" naming in Part A.
- Do not change Part B.

## Recommended Workflow

### Step 1 — Read the parent's options format

Where: `skills/engineering/grilling/references/options-format.md`

- Capture the verbatim 4-field template and the "one sentence per field" rule.

Verify: A copy of the parent's 4-field template and the one-sentence rule is in hand.

### Step 2 — Read the current code-impl output-selection Part A

Where: `skills/engineering/code-implementation-grilling/references/output-selection.md` Part A

- Identify the current field structure (likely "What / Trade-offs / Risks" or similar).
- Note the line ranges for Option A and Option B.

Verify: The current field structure and line ranges are captured.

### Step 3 — Rewrite Option A and Option B

Where: `skills/engineering/code-implementation-grilling/references/output-selection.md` Part A

- For both options, replace the field structure with the parent's 4-field format (What it is, Benefit, Cost, Risk).
- Rewrite each field to be one sentence.
- Add the explicit "one sentence per field, all four required" instruction.

Verify: Both Option A and Option B use the parent's 4-field format; the field names match the parent; each field is one sentence; no "Trade-offs" or "Risks" naming remains in Part A.

## Context pointers

**Files**:
- `skills/engineering/grilling/references/options-format.md` — source of the verbatim 4-field format (read-only)
- `skills/engineering/code-implementation-grilling/references/output-selection.md` — primary edit target (Part A only)

**ADRs**: None.

**Domain terms**:
- 4-field option format — the parent's per-option shape: What it is, Benefit, Cost, Risk (in order, one sentence each)
- Output Selection Part A — the "Output format" sub-section in code-impl's `output-selection.md`, which describes the two output options (Implementation Blueprint, PRD Augmentation)
- Output Selection Part B — the "Downstream consumer" sub-section in code-impl's `output-selection.md`, unchanged by this ticket

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D008` — the verbatim 4-field format requirement, including the rename from "Trade-offs" to "Benefit" and "Risks" to "Risk"

## Acceptance criteria

- [ ] Both Option A and Option B in `output-selection.md` Part A use the parent's 4-field format: "What it is" / "Benefit" / "Cost" / "Risk" (in that order).
- [ ] No instance of "Trade-offs" remains in Part A.
- [ ] No instance of "Risks" remains in Part A (only "Risk").
- [ ] Each field in both options is exactly one sentence.
- [ ] The "one sentence per field, all four required" instruction is present.
- [ ] Part B (Downstream consumer) is unchanged.

## Dependencies

**Blocked by**: `002-diagnose-code-impl-context-block-deviation` — the diagnosis confirms the file path and current state.
