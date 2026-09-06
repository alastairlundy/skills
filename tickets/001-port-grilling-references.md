---
title: Port the grilling reference set into technical-grilling
classification: Independent
blocked_by: []
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 001 - Port the grilling reference set into technical-grilling

## Goal

Give `technical-grilling` a complete local reference set so it no longer depends on the generic `grilling` skill's files. Five non-colliding parent references are ported as reworded single-skill copies, and the parent 4-row question table is merged into the local 5-row `locked-question-format.md`.

## What to build

Create reworded copies of these parent references in `skills/engineering/technical-grilling/references/`:

- `tone-and-output.md` (from `skills/engineering/grilling/references/tone-and-output.md`)
- `recommendation-format.md` (from `skills/engineering/grilling/references/recommendation-format.md`)
- `options-format.md` (from `skills/engineering/grilling/references/options-format.md`)
- `decision-ledger.md` (from `skills/engineering/grilling/references/decision-ledger.md`)
- `convergence-test.md` (from `skills/engineering/grilling/references/convergence-test.md`)

Rewording rules for every ported file (per `DECISIONS-skills-grilling-consolidation.md#D003`):

- Replace "grilling group" and parent-child language with single-skill terms - `technical-grilling` only.
- In the ported `decision-ledger.md`, the canonical-reference claim moves to this copy, the storage table keeps only the `technical-grilling` row, and the sentinel rules describe `technical-grilling` only (3 sentinels - `next-d`, `next-t`, `next-i`).
- No `../grilling/` relative path may appear in any ported file.

Edit `skills/engineering/technical-grilling/references/locked-question-format.md` - merge the parent 4-row question table (from `skills/engineering/grilling/references/locked-question-format.md`) into the local 5-row table so the file is self-contained and no longer points at `../grilling/references/locked-question-format.md`. Remove the "extends the parent grilling skill" framing while merging.

## Size

- **Files** - 6 (5 created, 1 edited)

## Recommended Workflow

### Step 1 - Read the parent reference set

Where: `skills/engineering/grilling/references/`

- Read all 6 parent reference files (tone-and-output, recommendation-format, options-format, locked-question-format, decision-ledger, convergence-test).
- Note every parent-child or "grilling group" phrasing that needs rewording.

Verify: all 6 files read and the rewording targets identified.

### Step 2 - Port the 5 non-colliding references

Where: `skills/engineering/technical-grilling/references/`

- Create the 5 reworded copies listed in What to build.
- Apply the rewording rules; keep the instructional content otherwise faithful.

Verify: no "grilling group", parent-child phrasing, or `../grilling/` path in the new files.

### Step 3 - Merge the question table

Where: `skills/engineering/technical-grilling/references/locked-question-format.md`

- Merge the parent 4-row table into the local 5-row table.
- Remove the pointer to `../grilling/references/locked-question-format.md` and the parent-skill framing.

Verify: the file is self-contained and contains the merged table rows.

### Step 4 - Sweep the touched files

Where: `skills/engineering/technical-grilling/references/`

- Search the 6 touched files for `../grilling/` and `grilling group`.

Verify: zero matches.

## Context pointers

##### Files

- `skills/engineering/grilling/references/` - the source set (read-only here; the directory is deleted later by 005-delete-grilling-skill)
- `skills/engineering/technical-grilling/references/locked-question-format.md` - local file to merge into
- `skills/engineering/technical-grilling/SKILL.md` - consumer of these references (rewired by 002-rewire-technical-grilling, not by this ticket)

##### ADRs

None - no ADR constrains this port.

##### Domain terms

- **load trigger** - references are loaded on demand; keep load-trigger sentences intact in ported content.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D003` - port-and-consolidate decision; rewording and no-`../grilling/`-path constraints.
- `DECISIONS-skills-grilling-consolidation.md#D001` - the self-containment goal this port serves.

## Acceptance criteria

- [ ] The 5 non-colliding parent references exist in `skills/engineering/technical-grilling/references/` as reworded single-skill copies (D003).
- [ ] `references/locked-question-format.md` contains the merged question table and no longer references `../grilling/references/` (D003).
- [ ] The ported `decision-ledger.md` describes `technical-grilling` sentinel rules only (`next-d`, `next-t`, `next-i`) and keeps only the `technical-grilling` storage row (D003).
- [ ] None of the 6 touched files contains "grilling group", parent-child phrasing, or a `../grilling/` path (D003).

## Dependencies

**Blocked by** - None - can start immediately
