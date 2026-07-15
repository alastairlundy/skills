---
title: Add Spec section as 5th element in code-impl context block
classification: Independent
blocked_by: ["002-diagnose-code-impl-context-block-deviation"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Extend the code-impl context block to five elements (parent's 4 plus "Spec section" with inline citation) at the file identified by `TK002` (the diagnosis). Update the validation check to verify the 5th element is present for code-impl branches.

## What to build

Two coordinated edits — one in the file that defines the code-impl context block format, one in the code-impl validation reference.

In the file identified by `TK002` as the code-impl context block definition (likely `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md` or `skills/engineering/code-implementation-grilling/SKILL.md`, depending on the diagnosis):

- Extend the context block from 4 elements to 5 elements by appending "Spec section" as the 5th element.
  - The 5th element is named "Spec section" and is one sentence.
  - The 5th element names the spec file path and the specific section or functional requirement the branch addresses, with an inline citation such as `specs/feature-x.md §3.2`.
  - The 5th element is required for every code-impl branch (not optional).
- Add an explicit instruction that the 5th element is required for every code-impl branch and that the citation format is fixed.
- Update any worked example in the file to include the 5th element with a real or illustrative citation.

In `skills/engineering/code-implementation-grilling/references/validation.md`:

- Add or update a check that verifies the 5th element ("Spec section") is present for every code-impl branch.
- The check should verify the 5th element is one sentence and includes the spec file path and section or requirement.

What NOT to do:

- Do not modify the parent's 4 elements.
- Do not change the 4-element format elsewhere — only add the 5th element to the code-impl context block.
- Do not invent a 5th element name other than "Spec section".

## Recommended Workflow

### Step 1 — Read the TK002 diagnosis output

Where: the diagnosis file from `TK002`

- Identify the file path and section that define the code-impl context block format.
- Identify any other locations that emit the context block.

Verify: The file and section to edit are identified.

### Step 2 — Add the 5th element to the code-impl context block definition

Where: the file identified in Step 1

- Add a 5th element to the context block template: "Spec section" (one sentence, with the citation format).
- Add an explicit instruction that the 5th element is required for every code-impl branch and the citation format is fixed.
- Update any worked example to include the 5th element with a real or illustrative citation.

Verify: The code-impl context block now has 5 elements; the parent's 4 elements are unchanged; the worked example includes the 5th element with a citation.

### Step 3 — Update the validation check

Where: `skills/engineering/code-implementation-grilling/references/validation.md`

- Add a check that verifies the 5th element ("Spec section") is present for every code-impl branch.
- The check should verify the 5th element is one sentence and includes the spec file path and section or requirement.

Verify: The validation check verifies the 5th element is present and correctly formatted.

## Context pointers

**Files**:
- The file identified by `TK002` as the code-impl context block definition (primary edit target)
- `skills/engineering/code-implementation-grilling/references/validation.md` — validation check update

**ADRs**: None.

**Domain terms**:
- 5-element code-impl context block — Goal, Prior decisions, Stakes, Scope, Spec section (the 5th element is purely additive to the parent's 4)
- Spec section citation — the inline citation format for the 5th element, for example `specs/feature-x.md §3.2` (file path plus section or requirement)

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D011` — the 5th element requirement, including the verbatim naming and the citation format

## Acceptance criteria

- [ ] The code-impl context block has 5 elements: Goal, Prior decisions, Stakes, Scope, Spec section (in that order).
- [ ] The 5th element is named "Spec section" and is one sentence.
- [ ] The 5th element includes an inline citation such as `specs/feature-x.md §3.2` (file path plus section or requirement).
- [ ] The 5th element is required for every code-impl branch (not optional).
- [ ] The parent's 4 elements (Goal, Prior decisions, Stakes, Scope) are unchanged in name, order, and shape.
- [ ] The validation check in `references/validation.md` verifies the 5th element is present and correctly formatted.
- [ ] The skill file where the context block is defined includes an explicit instruction that the 5th element is required and the citation format is fixed.

## Dependencies

**Blocked by**: `002-diagnose-code-impl-context-block-deviation` — the diagnosis must identify the file to edit.
