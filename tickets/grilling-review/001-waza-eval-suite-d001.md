---
title: Complete Waza Eval Suite for grilling
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Satisfy the AGENTS.md evaluation-format requirement by creating `eval.yaml` and a `fixtures/` directory, wired to the six existing task files. This is the only skill in the repo with an incomplete eval suite — a real AGENTS.md violation.

## What to build

Create two artefacts under `skills/engineering/grilling/evals/grilling/`:

- `eval.yaml` — the eval configuration. Crib the structure from `skills/engineering/domain-grilling/evals/domain-grilling/eval.yaml`: `name`, `description`, `skill`, `version`, `config` (trials_per_task, timeout_seconds, executor), and a `tasks:` glob that pulls in all six task files.
- `fixtures/` — directory containing at least one sample input that exercises the Decision Ledger workflow (e.g., a sample session transcript or user prompt). This is the test-input directory AGENTS.md requires.

The six task files already exist in `evals/grilling/tasks/`: `no-trigger-clear-decision.yaml`, `no-trigger-code-decision.yaml`, `no-trigger-terminology-decision.yaml`, `trigger-vague-business-decision.yaml`, `trigger-vague-process-decision.yaml`, `trigger-vague-product-direction.yaml`. Confirm they still parse and match the `eval.yaml` glob.

## Recommended Workflow

### Step 1 — Create eval.yaml

Where: `skills/engineering/grilling/evals/grilling/eval.yaml`

- Copy the structure from `domain-grilling/evals/domain-grilling/eval.yaml` as the template.
- Set `name: grilling` and `skill: grilling`.
- Set `config.executor: mock` (matches the convention in domain-grilling's eval).
- Set the `tasks:` field to a glob that resolves to the 6 task files.
- Write a `description:` that summarises what the suite evaluates (trigger discipline plus workflow compliance — Decision Ledger, locked question format, options/recommendation formats, tone discipline, convergence test, exit path handoff).

Verify: `waza run --skill grilling --dry-run` parses the eval without errors.

### Step 2 — Create fixtures directory

Where: `skills/engineering/grilling/evals/grilling/fixtures/`

- Create the directory.
- Add at least one fixture file (e.g., a sample user prompt that should trigger the skill, plus the expected branch options and Decision Ledger excerpt).
- Reference the fixture from at least one of the 6 task files (or document that fixtures are optional inputs for evaluator configuration).

Verify: `ls skills/engineering/grilling/evals/grilling/fixtures/` shows at least one file.

### Step 3 — Verify suite runs end-to-end

Where: `skills/engineering/grilling/evals/grilling/`

- Run `waza run --skill grilling` and confirm the suite executes all 6 tasks.
- Capture the run output as evidence the suite is functional.

Verify: All 6 tasks appear in the run output and report a pass/fail status.

## Context pointers

**Files**:
- `skills/engineering/grilling/evals/grilling/tasks/` — six task files already present
- `skills/engineering/domain-grilling/evals/domain-grilling/eval.yaml` — template to crib from
- `skills/engineering/grilling/SKILL.md` — the skill being evaluated

**ADRs**: None.

**Domain terms**:
- Waza Eval Suite — the eval format AGENTS.md mandates: `eval.yaml` + `tasks/` + `fixtures/`

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D001` — the requirement to create `eval.yaml` and `fixtures/`

## Acceptance criteria

- [ ] `skills/engineering/grilling/evals/grilling/eval.yaml` exists with `name`, `description`, `skill`, `version`, `config`, and `tasks:` fields.
- [ ] The `tasks:` glob resolves to all 6 files in `evals/grilling/tasks/`.
- [ ] `skills/engineering/grilling/evals/grilling/fixtures/` directory exists with at least one fixture file.
- [ ] `waza run --skill grilling` executes the suite end-to-end.
- [ ] No other skill in the repo is left with an incomplete eval suite (grilling is the only one).

## Dependencies

**Blocked by**: None — can start immediately.
