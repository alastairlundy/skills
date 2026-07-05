---
title: Add pre-flight existence check for the six references
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Catch missing or unreadable reference files before Step 1 attempts to load them. The current abort-on-missing rule fires after a load failure; the pre-flight fires before any read, making the load failure unmissable.

## What to build

Insert a "Pre-flight — verify all six references exist" subsection as Step 1.0 of `skills/engineering/grilling/SKILL.md`, before the current load step. The pre-flight walks an ordered list of the six reference files, confirms each is readable on disk, and aborts the session on any miss with a single combined list of all missing paths.

The six references to check, in order:

1. `references/decision-ledger.md`
2. `references/options-format.md`
3. `references/recommendation-format.md`
4. `references/locked-question-format.md`
5. `references/tone-and-output.md`
6. `references/convergence-test.md`

The pre-flight is a single ordered procedure, not a paragraph. Format it as a numbered list with explicit checks for each file. On any miss: collect every missing path into one list, abort the session, and report the list to the user. Do not load any reference until the pre-flight passes for all six.

## Recommended Workflow

### Step 1 — Add the pre-flight subsection

Where: `skills/engineering/grilling/SKILL.md` (insert as Step 1.0, before the existing load step)

- Add an H4 heading "1.0 Pre-flight — verify all six references exist".
- Add a single ordered procedure that walks the 6 reference files.
- State the failure behaviour: "If any entry is missing or unreadable, stop, collect every missing path into a single list, abort the session, and report the list to the user."
- Add the gate: "Do not load any reference until the pre-flight passes for all six."

Verify: The pre-flight subsection appears as Step 1.0 with the 6 references in order and a single combined abort path.

### Step 2 — Verify the abort path

Where: `skills/engineering/grilling/SKILL.md`

- Mentally walk the pre-flight: if any reference is deleted, the agent must collect ALL missing paths into one list, abort, and report the list.
- Confirm the abort message is one combined list (not one abort per file).
- Confirm no reference is loaded until the pre-flight passes.

Verify: The pre-flight lists all 6 files and describes a single combined abort path that precedes any load.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — Step 1 insertion point
- `skills/engineering/grilling/references/` — the six files to pre-flight

**ADRs**: None.

**Domain terms**:
- Pre-flight — a check that runs before the actual operation to surface failures loudly

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D002` — the pre-flight requirement

## Acceptance criteria

- [ ] Step 1.0 lists all 6 reference files in order.
- [ ] Each file has an existence and readability check.
- [ ] On any miss, the procedure collects all missing paths into a single list, aborts the session, and reports the list.
- [ ] The pre-flight runs before any reference is loaded.

## Dependencies

**Blocked by**: None — can start immediately.
