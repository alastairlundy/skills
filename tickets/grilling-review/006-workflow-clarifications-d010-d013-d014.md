---
title: Add workflow clarifications for open follow-ups, abort, and write errors
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Make three small clarifications to the Workflow body in `grilling/SKILL.md`: define "open follow-up" inline, document abort as a passive no-op, and add an explicit error path for ledger write failures.

## What to build

Three additions to `skills/engineering/grilling/SKILL.md`:

1. **D010 — "Open follow-up" definition (Step 4)**: add a one-line definition. "Open follow-up: a branch left intentionally unresolved at session end, captured in the ledger with `Resolved Answer = 'DEFERRED'` and a `Constraints` line noting why." Child skills (e.g., `domain-grilling`) may reference but not redefine this term; this skill's definition is the source of truth.

2. **D013 — Abort rule (Step 4 or Step 5)**: add a single line. "If the user aborts the session, stop grilling. Do not write a record. Do not run the convergence test. The partial ledger state is preserved as-is until the user decides to delete or continue it."

3. **D014 — Write error path (Step 4)**: add an explicit error path. "If the write fails — permissions error, race with another process, or the parent directory does not exist — abort the branch transition, report the failure to the user (with the failure mode and the affected ledger path), and offer three recovery options: retry the write, skip the append and continue, or save the record locally for later back-fill. Do not proceed to the next branch until the user picks a recovery option."

The error path is a hard stop — no automatic retry, no silent fall-through. The user picks the recovery option.

## Recommended Workflow

### Step 1 — Add the "open follow-up" definition

Where: `skills/engineering/grilling/SKILL.md` Step 4

- Add a short paragraph or callout with the one-line definition.
- Add the note that child skills may reference but not redefine this term, and that this skill's definition is the source of truth.

Verify: The definition appears in Step 4 with the canonical phrasing and the source-of-truth note.

### Step 2 — Add the abort rule

Where: `skills/engineering/grilling/SKILL.md` Step 4 or Step 5

- Add a short paragraph titled "Abort rule" with the four behaviours: stop grilling, no record, no convergence test, partial ledger preserved.

Verify: The abort rule appears with all four behaviours stated.

### Step 3 — Add the write error path

Where: `skills/engineering/grilling/SKILL.md` Step 4

- Add a paragraph titled "Write failure" that names the three failure modes (permissions, race, missing parent dir).
- Specify the three recovery options and the no-proceed-until-picked rule.

Verify: The error path names the three failure modes, the three recovery options, and the no-proceed rule.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — Steps 4 and 5
- `skills/engineering/grilling/references/decision-ledger.md` — the `Dxxx` record format (relevant to the open follow-up template)

**ADRs**: None.

**Domain terms**:
- Open follow-up — a branch left intentionally unresolved at session end
- Abort — a user-initiated stop of the session
- Lazy creation — the ledger file is created on the first resolved decision

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D010` — inline "open follow-up" definition
- `docs/decisions/DECISIONS-skills-grilling-review.md#D013` — abort as passive no-op
- `docs/decisions/DECISIONS-skills-grilling-review.md#D014` — write error path

## Acceptance criteria

- [ ] Step 4 includes the one-line "open follow-up" definition with the canonical phrasing and a source-of-truth note.
- [ ] Step 4 or 5 includes the abort rule with all four behaviours.
- [ ] Step 4 includes the write error path naming the three failure modes, three recovery options, and no-proceed rule.
- [ ] Child skills (e.g., `domain-grilling`) are told they may reference but not redefine the term.

## Dependencies

**Blocked by**: None — can start immediately.
