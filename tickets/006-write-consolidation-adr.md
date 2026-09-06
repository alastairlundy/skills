---
title: Write the consolidation ADR
classification: Independent
blocked_by: []
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 006 - Write the consolidation ADR

## Goal

Record why the consolidation happened in a standalone ADR, so the motivation survives post-implementation ledger cleanup and the skill lineage has a single home.

## What to build

Create `docs/adr/0004-grilling-consolidation.md` (path resolved via ledger interaction I012 - the ledger's D006-named 0003 slot is occupied by the skill-architect ADR):

- **Motivation** - one grilling skill instead of a parent/child pair; `technical-grilling` must not depend on a separate generic skill's reference files (D001).
- **Alternatives** - keeping the parent/child pair; keeping `grilling` as a non-technical home; adding a conversational-fallback line - all rejected per D002 and D007.
- **Consequences** - non-technical vague decisions have no dedicated skill; the over-trigger boundary is enforced empirically by the no-trigger eval tasks (D002, D009).
- **Lineage narrative** - absorb the former `domain-grilling` / `code-implementation-grilling` merge story and the parent/child relationship as the sole lineage record (D010).
- Cite ADR 0002 as historical context without superseding it; ADR 0002's text stays unchanged beyond 004-sweep-live-docs-grilling-references's appended status note (D008).

Also: do not delete or trim `docs/decisions/DECISIONS-skills-grilling-consolidation.md` - the ledger persists until implementation completes (D006).

## Size

- **Files** - 1 (created)

## Recommended Workflow

### Step 1 - Read the source material

Where: `docs/adr/0002-trigger-discipline-for-grilling-skills.md`, `docs/decisions/DECISIONS-skills-grilling-consolidation.md`

- Read ADR 0002 and the ledger's D-records for motivation, alternatives, and consequences.

Verify: source material understood.

### Step 2 - Draft the ADR

Where: `docs/adr/0004-grilling-consolidation.md`

- Write motivation, alternatives, consequences, and the lineage narrative per What to build.

Verify: all four content areas present; ADR 0002 cited as context.

### Step 3 - Check the neighbours

Where: `docs/adr/`

- Confirm ADR 0002 is not marked superseded and no other ADR was modified.

Verify: the working tree shows only the new file added.

## Context pointers

##### Files

- `docs/adr/0002-trigger-discipline-for-grilling-skills.md` - cited as context
- `docs/decisions/DECISIONS-skills-grilling-consolidation.md` - source of the D-record content
- `README.md` technical-grilling row - lineage narrative being absorbed (row rewritten by 004)

##### ADRs

- `docs/adr/0002-trigger-discipline-for-grilling-skills.md` - cited as historical context, not superseded (D008).

##### Domain terms

- **Domain model**, **Code implementation plan** - glossary terms whose producer is technical-grilling; the lineage narrative touches their history.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D006` - the ADR shall exist; the ledger persists until implementation completes.
- `DECISIONS-skills-grilling-consolidation.md#D008` - standalone ADR; ADR 0002 cited as context, not superseded.
- `DECISIONS-skills-grilling-consolidation.md#D010` - sole lineage record.

## Acceptance criteria

- [ ] `docs/adr/0004-grilling-consolidation.md` exists with motivation, alternatives, and consequences (D006).
- [ ] ADR 0002 is cited as context and is not marked superseded; its text is unchanged by this ticket (D008).
- [ ] The ADR is the sole lineage record - the parent/child and former-skill merge narrative lives here, not in live docs (D010).
- [ ] The Decision Ledger remains in `docs/decisions/` (D006).

## Dependencies

**Blocked by** - None - can start immediately
