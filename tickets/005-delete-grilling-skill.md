---
title: Delete the grilling skill
classification: Independent
blocked_by: [001-port-grilling-references, 002-rewire-technical-grilling, 003-port-ledger-record-eval-script, 004-sweep-live-docs-grilling-references]
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 005 - Delete the grilling skill

## Goal

Remove the generic `grilling` skill once nothing depends on it - the confirmed, non-negotiable half of the consolidation goal (D001).

## What to build

Delete `skills/engineering/grilling/` in its entirety (17 files):

- `SKILL.md`
- `references/` - `tone-and-output.md`, `recommendation-format.md`, `options-format.md`, `locked-question-format.md`, `decision-ledger.md`, `convergence-test.md`
- `evals/grilling/` - `eval.yaml`, 7 task files, `scripts/check-ledger-record.ps1`, `fixtures/example-session-saas-pricing.md`

Prerequisites - all four content tickets merged first:

- 001 ported the reference set; 002 rewired technical-grilling to local paths; 003 ported the eval script; 004 swept live docs. Nothing may still reference the deleted tree when this lands.

## Size

- **Files** - 17 (all deleted)

## Recommended Workflow

### Step 1 - Confirm prerequisites

Where: N/A

- Check 001, 002, 003, and 004 are complete.

Verify: no open dependency.

### Step 2 - Delete the skill directory

Where: `skills/engineering/grilling/`

- Remove the directory tree.

Verify: the path no longer exists.

### Step 3 - Final reference sweep

Where: repo root

- Search for `skills/engineering/grilling/`, `../grilling/`, and bare grilling-skill instructions.

Verify: zero live matches - `CHANGELOG.md` history, ADR 0002's historical body, `docs/decisions/`, and the consolidation ADR's narrative are expected historical exceptions.

## Context pointers

##### Files

- `skills/engineering/grilling/` - the deletion target
- `skills/engineering/technical-grilling/` - must remain fully functional standalone after the deletion

##### ADRs

None - no ADR constrains this deletion.

##### Domain terms

None beyond the ledger vocabulary.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D001` - deletion is fixed, not negotiable; the repo shall contain a single grilling-family skill.

## Acceptance criteria

- [ ] `skills/engineering/grilling/` no longer exists (D001).
- [ ] No live repo file references the deleted path or instructs use of the grilling skill (D001, D004).
- [ ] technical-grilling works standalone - all its references resolve locally (D001).

## Dependencies

**Blocked by** - 001-port-grilling-references, 002-rewire-technical-grilling, 003-port-ledger-record-eval-script, 004-sweep-live-docs-grilling-references
