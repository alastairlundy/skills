---
title: Standardise terminology on branch across the six references and SKILL.md
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Replace all instances of "gate" with "branch" in the six reference files and `grilling/SKILL.md`. "Branch" is the canonical term; "gate" is removed. "One question at a time" is pacing language, not terminology, and is preserved as-is.

## What to build

Search-and-replace "gate" → "branch" across:

- `skills/engineering/grilling/SKILL.md`
- `skills/engineering/grilling/references/locked-question-format.md`
- `skills/engineering/grilling/references/convergence-test.md`
- `skills/engineering/grilling/references/tone-and-output.md`
- `skills/engineering/grilling/references/decision-ledger.md`
- `skills/engineering/grilling/references/options-format.md`
- `skills/engineering/grilling/references/recommendation-format.md`

Special cases to preserve verbatim:

- "one question at a time" — describes pacing, not the noun; leave unchanged.
- `Dxxx` record headings in examples (e.g., `### [D012] — where the gate lives`) — if the example is quoting a `Dxxx` heading from a real ledger, the heading is part of the example payload. Replace with "branch" only if the heading is a generic example, not a quoted record.

## Recommended Workflow

### Step 1 — Search the six references for "gate"

Where: `skills/engineering/grilling/references/*.md`

- Run a case-insensitive search for "gate" across all 6 reference files.
- List every match with line number and surrounding context (so quoted `Dxxx` headings are identifiable).

Verify: A list of all "gate" occurrences across the 6 files exists, with quoted-`Dxxx`-heading candidates flagged.

### Step 2 — Replace "gate" with "branch" in references

Where: `skills/engineering/grilling/references/*.md`

- For each match, replace "gate" with "branch" unless the match is inside a quoted `Dxxx` heading from a real ledger.
- Confirm "one question at a time" is unchanged wherever it appears.

Verify: A re-search for "gate" returns no matches (other than quoted `Dxxx` headings, if any).

### Step 3 — Replace "gate" with "branch" in SKILL.md

Where: `skills/engineering/grilling/SKILL.md`

- Replace any "gate" instances with "branch".
- Preserve the "one question at a time" pacing phrase.

Verify: A re-search for "gate" in SKILL.md returns no matches.

### Step 4 — Verify cross-skill consistency

Where: `skills/engineering/domain-grilling/`, `skills/engineering/code-implementation-grilling/`

- Spot-check whether these child skills use "gate" in a way that should be updated to "branch".
- Note any cross-skill drift in a follow-up; do not modify the child skills in this ticket (each has its own decision ledger).

Verify: A short note on cross-skill drift is added to the PR description (or commit message), with references to the child ledgers.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md`
- `skills/engineering/grilling/references/decision-ledger.md`
- `skills/engineering/grilling/references/options-format.md`
- `skills/engineering/grilling/references/recommendation-format.md`
- `skills/engineering/grilling/references/locked-question-format.md`
- `skills/engineering/grilling/references/tone-and-output.md`
- `skills/engineering/grilling/references/convergence-test.md`

**ADRs**: None.

**Domain terms**:
- Branch — a single decision point in the grilling tree (canonical term)
- Gate — the deprecated term; replaced by "branch"
- Locked question — the format used at every branch

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D012` — standardise on "branch"

## Acceptance criteria

- [ ] No instance of "gate" remains in `grilling/SKILL.md`.
- [ ] No instance of "gate" remains in any of the 6 reference files, except inside quoted `Dxxx` headings from a real ledger.
- [ ] "One question at a time" is preserved as-is wherever it appears.
- [ ] All replaced instances use "branch" as the canonical term.
- [ ] Cross-skill drift in child skills is noted as a follow-up, not silently fixed.

## Dependencies

**Blocked by**: None — can start immediately.
