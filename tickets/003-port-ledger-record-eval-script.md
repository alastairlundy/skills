---
title: Port the ledger-record eval script into technical-grilling
classification: Independent
blocked_by: []
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 003 - Port the ledger-record eval script into technical-grilling

## Goal

Inherit the strongest verification the deleted skill owned - the mechanical ledger-record gate - into `technical-grilling`'s eval suite, reworked for the dual `Dxxx`/`Txxx` record stream.

## What to build

- Port `skills/engineering/grilling/evals/grilling/scripts/check-ledger-record.ps1` to `skills/engineering/technical-grilling/evals/technical-grilling/scripts/check-ledger-record.ps1`, reworked for the dual stream - `technical-grilling` ledgers carry 3 sentinels (`next-d`, `next-t`, `next-i`) and both `Dxxx` and `Txxx` records must validate.
- Wire the script check into `skills/engineering/technical-grilling/evals/technical-grilling/eval.yaml`, following the wiring pattern used in `skills/engineering/grilling/evals/grilling/eval.yaml`.
- Do NOT port the example-session fixture (`skills/engineering/grilling/evals/grilling/fixtures/example-session-saas-pricing.md`) - rejected per D005. `technical-grilling` keeps its own fixture (`example-session-freelancer-platform.md`). The remaining grilling eval tasks are deleted with the skill in 005-delete-grilling-skill.

## Size

- **Files** - 2 (1 created, 1 edited)

## Recommended Workflow

### Step 1 - Read the source script and its wiring

Where: `skills/engineering/grilling/evals/grilling/`

- Read `scripts/check-ledger-record.ps1` and its `eval.yaml` wiring.

Verify: the check's inputs and pass/fail behaviour are understood.

### Step 2 - Port and rework the script

Where: `skills/engineering/technical-grilling/evals/technical-grilling/scripts/check-ledger-record.ps1`

- Create the reworked script validating both `Dxxx` and `Txxx` streams and the 3-sentinel format.

Verify: running the script against `docs/decisions/DECISIONS-skills-grilling-consolidation.md` parses both streams.

### Step 3 - Wire the check into eval.yaml

Where: `skills/engineering/technical-grilling/evals/technical-grilling/eval.yaml`

- Add the script check following the grilling `eval.yaml` wiring pattern.

Verify: `eval.yaml` references the ported script path correctly.

## Context pointers

##### Files

- `skills/engineering/grilling/evals/grilling/scripts/check-ledger-record.ps1` - source script
- `skills/engineering/grilling/evals/grilling/eval.yaml` - wiring pattern source
- `skills/engineering/technical-grilling/evals/technical-grilling/` - target directory
- `docs/decisions/DECISIONS-skills-grilling-consolidation.md` - live dual-stream ledger usable as a test subject

##### ADRs

None - no ADR constrains this port.

##### Domain terms

- **Pass/Fail Gate** - the script is a mechanical gate, not a self-assessment.
- **Skill Evaluator** - the tool that operates on the skill directory and will run this check.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D005` - port the script, wire it into eval.yaml, rework for the dual stream; fixture not ported.

## Acceptance criteria

- [ ] `evals/technical-grilling/scripts/check-ledger-record.ps1` exists and validates both `Dxxx` and `Txxx` streams (D005).
- [ ] `eval.yaml` wires the script check (D005).
- [ ] The grilling example-session fixture is not ported (D005).

## Dependencies

**Blocked by** - None - can start immediately
