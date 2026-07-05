---
title: Annotate the C1 false positive in skill-reviews/grilling.md
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Mark the "C1: Ledger format link" claim in `skill-reviews/grilling.md` as a closed false positive, citing D008. Future readers shall not re-open the branch.

## What to build

Add a `Status: Closed (false positive)` line under the C1 bullet in `skill-reviews/grilling.md`, citing `DECISIONS-skills-grilling-review.md#D008`. The bullet's content is unchanged.

The original claim: "The `Dxxx` / `Txxx` record format is referenced in code-implementation-grilling and domain-grilling but defined in `grilling/references/decision-ledger.md` — the parent skill owns the format, but only the children link to it." This is a false positive: the parent (`grilling/SKILL.md`) links to `references/decision-ledger.md` via the "load all 6 references" step (Step 1), so the format is reachable from the parent, not only from the children.

## Recommended Workflow

### Step 1 — Add the annotation

Where: `skill-reviews/grilling.md` — the C1 bullet

- Add a sub-bullet or status line: `Status: Closed (false positive) — see DECISIONS-skills-grilling-review.md#D008`.
- Do not modify the original bullet's text.

Verify: The C1 bullet has a status line citing D008.

## Context pointers

**Files**:
- `skill-reviews/grilling.md` — the review file to annotate

**ADRs**: None.

**Domain terms**: None.

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D008` — the false-positive annotation

## Acceptance criteria

- [ ] The C1 bullet in `skill-reviews/grilling.md` has a `Status: Closed (false positive)` line citing D008.
- [ ] The original bullet text is unchanged.

## Dependencies

**Blocked by**: None — can start immediately.
