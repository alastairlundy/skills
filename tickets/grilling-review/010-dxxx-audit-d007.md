---
title: Audit Dxxx and Txxx references across the repo (separate workstream)
classification: Collaborative
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Add a check (script, pre-commit hook, or CI step) that fails when any file references `Dxxx` or `Txxx` by raw number outside the ledger file itself. This is a separate workstream from the `grilling`-only changes — it affects other skills that use the Decision Ledger (`write-changelog`, `spec-to-tickets`, `code-implementation-grilling`, `domain-grilling`, `grilling`, and any future skill).

## What to build

A check that:

1. Scans all files in the repo for `Dxxx` or `Txxx` references by raw number (e.g., `D001`, `T005`).
2. For each match, verifies the file IS the ledger (`docs/decisions/DECISIONS-*.md`) or the match is wrapped in a `filename#Dxxx` citation format (e.g., `DECISIONS-skills-grilling-review.md#D001`).
3. Fails the check (non-zero exit, or pre-commit block) on any bare `Dxxx` / `Txxx` reference outside the ledger.

**Why Collaborative**: the implementation mechanism (script vs pre-commit hook vs CI step) is a follow-up decision. The implementer must consult with the maintainer on the right enforcement layer for this repo.

**Constraint**: this is a P4 item — separate workstream, not part of the `grilling`-only PR. A symbolic-ID alternative (`D-LAST`, `D-PREV`) is a possible substitute but is not the chosen approach; if the audit becomes too noisy in practice, the symbolic-ID path may be re-opened.

## Recommended Workflow

### Step 1 — Survey the affected skills

Where: `skills/engineering/grilling/`, `skills/engineering/domain-grilling/`, `skills/engineering/code-implementation-grilling/`, `skills/engineering/write-changelog/`, `skills/engineering/spec-to-tickets/`, and any other skill that uses the Decision Ledger

- Inventory every `Dxxx` / `Txxx` reference in each skill's `SKILL.md` and `references/`.
- Classify each reference as either "wrapped in `filename#Dxxx`" or "bare".

Verify: An inventory of all `Dxxx` / `Txxx` references across the affected skills exists.

### Step 2 — Decide the implementation mechanism (Collaborative)

Where: N/A — this is a follow-up decision.

- Present three options to the maintainer: a standalone script in `scripts/`, a pre-commit hook in `.pre-commit-config.yaml`, or a CI step in `.github/workflows/`.
- Recommend the option that integrates with the repo's existing CI (likely a GitHub Actions step, since `docs/agents/issue-tracker.md` confirms the repo uses GitHub).
- Wait for the maintainer's decision before proceeding.

Verify: The maintainer has chosen one of the three options.

### Step 3 — Implement the chosen mechanism

Where: per the maintainer's choice (e.g., `.github/workflows/audit-decision-references.yml`)

- Implement the scan-and-fail logic.
- Wire the check into the existing CI or hook layer.
- Add a `docs/agents/decision-ledger-audit.md` describing the rule and how to fix violations.

Verify: Running the check on the current repo reports zero violations (or only known acceptable ones).

### Step 4 — Document the rule

Where: `docs/agents/decision-ledger-audit.md` (new file) and a reference from `AGENTS.md`

- Document the audit rule: bare `Dxxx` / `Txxx` references outside the ledger are prohibited.
- Document the remediation: wrap in `filename#Dxxx` format.

Verify: The new doc page exists and is linked from `AGENTS.md`.

## Context pointers

**Files**:
- `skills/engineering/grilling/`, `skills/engineering/domain-grilling/`, `skills/engineering/code-implementation-grilling/`, `skills/engineering/write-changelog/`, `skills/engineering/spec-to-tickets/` — affected skills to survey
- `docs/agents/issue-tracker.md` — confirms the repo uses GitHub, which informs the CI choice
- `AGENTS.md` — add a reference to the new audit doc

**ADRs**: None.

**Domain terms**:
- `Dxxx` / `Txxx` — Decision Ledger record IDs (functional and technical, respectively)
- `filename#Dxxx` citation format — the canonical way to reference a Decision Ledger record from outside the ledger
- Symbolic ID — a non-numeric alternative to `Dxxx` (e.g., `D-LAST`, `D-PREV`); not the chosen approach

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D007` — the audit requirement

## Acceptance criteria

- [ ] An inventory of all `Dxxx` / `Txxx` references across affected skills exists.
- [ ] The maintainer has chosen an implementation mechanism (script, pre-commit, or CI).
- [ ] The chosen mechanism is implemented and wired into the repo's CI/hook layer.
- [ ] A `docs/agents/decision-ledger-audit.md` page documents the rule and remediation.
- [ ] Running the check on the current repo reports zero violations.

## Dependencies

**Blocked by**: None — can start immediately. (Note: this is a separate workstream from the other tickets; it should not be in the same PR as the `grilling`-only changes.)
