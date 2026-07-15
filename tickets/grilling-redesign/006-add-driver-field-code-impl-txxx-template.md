---
title: Add Driver field to code-impl Txxx record template
classification: Independent
blocked_by: ["002-diagnose-code-impl-context-block-deviation"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Update `skills/engineering/code-implementation-grilling/references/recording-decisions.md` so the Txxx template has five fields in the order: `Driver` (one to two sentences, write "None." if no principle is articulated), `Resolved Answer`, `Normalized Requirement`, `Constraints`, `Cites`. The `Driver` field is required, not optional.

## What to build

In `skills/engineering/code-implementation-grilling/references/recording-decisions.md`:

- Update the Txxx record template to have five fields in order:
  1. `Driver` — one to two sentences capturing the user's underlying principle or motivation, matching the parent's Dxxx template; write `None.` if no principle is articulated.
  2. `Resolved Answer` — verbatim user choice.
  3. `Normalized Requirement` — concise, testable statement.
  4. `Constraints` — negative requirements, edge cases, or defaults.
  5. `Cites` — Dxxx or earlier Txxx ids whose constraints the answer respects.
- Add an explicit instruction that the `Driver` field is required (not optional).
- Add an explicit instruction that the `Driver` must be specific to the user's stated principle, not a generic restatement of the resolved answer.
- Update any worked example in the file to include the `Driver` field (matching the parent's `Driver` style: either a one-to-two-sentence principle or `None.`).

What NOT to do:

- Do not use code-impl-specific `Driver` wording — match the parent.
- Do not make the `Driver` field optional.
- Do not change the existing `Cites` field semantics (per D009's deferral of the Cites deviation; `Cites` stays as-is).

## Recommended Workflow

### Step 1 — Read the parent's Dxxx template

Where: `skills/engineering/grilling/references/decision-ledger.md`

- Capture the verbatim Dxxx template and the `Driver` field guidance.

Verify: A copy of the parent's Dxxx template is in hand.

### Step 2 — Read the current code-impl Txxx template

Where: `skills/engineering/code-implementation-grilling/references/recording-decisions.md`

- Identify the current field structure and order.
- Note the line range for the template.

Verify: The current Txxx template structure is captured.

### Step 3 — Update the Txxx template

Where: `skills/engineering/code-implementation-grilling/references/recording-decisions.md`

- Reorder the fields so `Driver` is first, followed by `Resolved Answer`, `Normalized Requirement`, `Constraints`, `Cites`.
- Add the explicit instructions (required, not optional; specific to the user's stated principle).
- Update any worked example to include the `Driver` field.

Verify: The Txxx template has five fields in the required order; the `Driver` field instructions are present; the `Cites` field is unchanged; any worked example includes the `Driver` field.

## Context pointers

**Files**:
- `skills/engineering/grilling/references/decision-ledger.md` — source of the verbatim `Driver` field guidance (read-only)
- `skills/engineering/code-implementation-grilling/references/recording-decisions.md` — primary edit target

**ADRs**: None.

**Domain terms**:
- Txxx record — a code-impl Decision Ledger record for a technical decision (analog to the parent's Dxxx for functional decisions)
- `Driver` field — the user's underlying principle or motivation, distinct from `Resolved Answer` (the what) and `Normalized Requirement` (the testable outcome)

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D009` — the Txxx template `Driver` field requirement

## Acceptance criteria

- [ ] The Txxx template has five fields in order: `Driver`, `Resolved Answer`, `Normalized Requirement`, `Constraints`, `Cites`.
- [ ] The `Driver` field guidance matches the parent: "one to two sentences — the user's underlying principle or motivation; write `None.` if no principle is articulated."
- [ ] The `Driver` field is marked as required (not optional).
- [ ] The `Driver` field instruction includes the specificity rule: "the `Driver` must be specific to the user's stated principle, not a generic restatement of the resolved answer."
- [ ] The `Cites` field semantics are unchanged (per D009's deferral of the Cites deviation).
- [ ] Any worked example in the file includes the `Driver` field.

## Dependencies

**Blocked by**: `002-diagnose-code-impl-context-block-deviation` — the diagnosis confirms the file path and current state.
