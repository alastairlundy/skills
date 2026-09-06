---
title: Sweep live docs of grilling references
classification: Independent
blocked_by: []
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 004 - Sweep live docs of grilling references

## Goal

Leave no dangling live reference to the `grilling` skill - every live file either stops naming it or is rewritten to standalone wording, and ADR 0002 records the removal. Scope covers D004's original 4 files plus the 3 extra files confirmed in ledger interaction I013.

## What to build

Edit 8 files (all edited, none created):

1. `skills/alignment/ask-questions/SKILL.md` (line ~146) - remove both hand-off clauses ("or hand off to `grilling` for structured decision-making" and "The hand-off to `grilling` is the preferred escape hatch..."). The three-round soft cap stands alone; add no replacement handoff target (D007).
2. `README.md` (lines ~30-31) - delete the grilling row; rewrite the technical-grilling row to standalone wording with no "Generic parent" or "Specializes grilling; merges the former..." lineage (D010). The merge narrative moves to the consolidation ADR (006-write-consolidation-adr).
3. `docs/agents/domain.md` (line ~26) - remove the `grilling/SKILL.md` line from the repo tree.
4. `skills/skills-meta/setup-alastairlundy-skills/SKILL.md` (line ~148) - reword the skill-mapping example so `decision-ledger-audit.md` no longer lists `grilling` as a reader; substituting `technical-grilling` is factually accurate since it produces ledgers. Edit the repo source copy only - never the installed copy under `.agents/skills/`.
5. `docs/adr/0002-trigger-discipline-for-grilling-skills.md` - append a status note recording the grilling removal; do not rewrite existing text (D004).
6. `skills/engineering/spec-to-tickets/SKILL.md` (lines ~4, 25, 66, 68, 332-334) - remove every instruction to use or recommend `grilling`; align with the existing "check whether the user has access to a skill...; recommend it if available, otherwise name no specific skill" pattern; invent no replacement skill (D002).
7. `skills/engineering/spec-to-tickets/references/decision-ledger.md` (lines ~4, 7, 14, 18, 296, 311) - reword the canonical-path citation to `technical-grilling`'s local copy, drop "the child of `grilling`" lineage, rename the "Grilling group" wording, drop the grilling storage-table row.
8. `skills/skills-meta/skill-architect/references/decision-ledger.md` (lines ~4, 7, 14, 18, 289, 304) - same rewording pattern as file 7.

Untouched by design: `CHANGELOG.md` historical text (line ~19) and ADR 0002's existing body (D004 constraints).

## Size

- **Files** - 8 (all edited)

## Recommended Workflow

### Step 1 - Apply the per-file changes

Where: the 8 files listed in What to build

- Apply each file's change as specified.

Verify: each file no longer names the grilling skill (except ADR 0002's appended note and historical body).

### Step 2 - Append the ADR 0002 status note

Where: `docs/adr/0002-trigger-discipline-for-grilling-skills.md`

- Append a short status note recording that the grilling skill was removed and technical-grilling consolidated (the full record is 006-write-consolidation-adr).

Verify: existing ADR 0002 text is unchanged; only an appended note is present.

### Step 3 - Repo-wide sweep check

Where: repo root

- Search for bare `grilling` mentions outside `skills/engineering/technical-grilling/`, excluding `CHANGELOG.md`, ADR 0002's historical body, `docs/decisions/`, and the new consolidation ADR.

Verify: no live file instructs use of a grilling skill or claims technical-grilling lineage (D004, D010).

## Context pointers

##### Files

- The 8 files listed in What to build
- `skills/engineering/technical-grilling/SKILL.md` - post-002 wording to stay consistent with

##### ADRs

- `docs/adr/0002-trigger-discipline-for-grilling-skills.md` - append-only target for the status note.

##### Domain terms

None beyond the ledger vocabulary.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D002` - pointers removed or rewritten without inventing a replacement skill.
- `DECISIONS-skills-grilling-consolidation.md#D004` - full sweep; ADR 0002 status note; CHANGELOG untouched.
- `DECISIONS-skills-grilling-consolidation.md#D007` - ask-questions handoff sentence dropped; soft cap stands alone.
- `DECISIONS-skills-grilling-consolidation.md#D010` - lineage erased from live docs.

## Acceptance criteria

- [ ] ask-questions names no grilling skill; the three-round soft cap remains as the escape-hatch boundary (D007).
- [ ] README has no grilling row and the technical-grilling row is standalone wording (D010).
- [ ] `domain.md` tree and the setup-alastairlundy-skills mapping no longer name grilling (D004).
- [ ] ADR 0002 carries an appended status note and its existing text is unchanged (D004).
- [ ] spec-to-tickets `SKILL.md`, its `decision-ledger.md` reference, and skill-architect's `decision-ledger.md` reference no longer instruct use of grilling or claim lineage (D004, D010, D002).
- [ ] `CHANGELOG.md` historical text is untouched (D004).
- [ ] Repo-wide sweep shows no live file instructing use of a grilling skill (D004).

## Dependencies

**Blocked by** - None - can start immediately
