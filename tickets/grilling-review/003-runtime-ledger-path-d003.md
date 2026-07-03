---
title: Detect Decision Ledger path at runtime with user confirmation
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Remove the hard-coded assumption that the working repo has a `docs/decisions/` directory. The skill should scan the repo at runtime, present any existing ledgers, and fall back to a default path with user confirmation before the first append.

## What to build

Rewrite Step 2 of `skills/engineering/grilling/SKILL.md` to:

1. Scan the working repo for `docs/decisions/` (via `Test-Path docs/decisions` or equivalent).
2. If the directory exists, scan it for every `DECISIONS-*.md` file — do not limit to feature-specific matches.
3. Branch on the detection result:
   - **One existing ledger**: use it. Read it end-to-end. Report to the user: the highest existing `Dxxx` number, any unresolved contradictions between existing records, and the branches already covered. Confirm the ledger path with the user before the first append.
   - **Multiple existing ledgers**: present every match to the user. Let the user pick one to continue, or specify a new path. Do not auto-choose. Once the user picks, read it end-to-end and report the same three points.
   - **No existing ledger**: derive the path `docs/decisions/DECISIONS-<repo>-<feature>.md` where `<repo>` is the directory name of the working repository and `<feature>` is a short kebab-case slug of the topic. Default the parent directory to `docs/decisions/`. Confirm the path with the user before the first append.

The user-confirmation step is mandatory before the first write, per the reference's lazy-creation rule.

## Recommended Workflow

### Step 1 — Rewrite Step 2 with runtime detection

Where: `skills/engineering/grilling/SKILL.md` Step 2

- Replace any hard-coded `docs/decisions/` path with the three-branch detection procedure above.
- Include the `Test-Path docs/decisions` check (or equivalent) before scanning.
- Make the user-confirmation step explicit: "Confirm the ledger path with the user before the first append."

Verify: Step 2 begins with a runtime existence check, not a hard-coded assumption.

### Step 2 — Specify the three branches

Where: `skills/engineering/grilling/SKILL.md` Step 2

- Spell out the one-existing-ledger, multiple-existing-ledgers, and no-existing-ledger branches.
- For multiple ledgers: "present every match to the user. Let the user pick one to continue, or specify a new path. Do not auto-choose."
- For no existing ledger: state the path derivation `docs/decisions/DECISIONS-<repo>-<feature>.md` and the default parent directory.

Verify: Each of the three branches is documented with its specific behaviour.

### Step 3 — Verify lazy-creation rule is preserved

Where: `skills/engineering/grilling/SKILL.md` Step 2 and `references/decision-ledger.md`

- Confirm the user-confirmation step appears before the first write in all three branches.
- Confirm no branch writes a file without user approval.

Verify: The lazy-creation rule is honoured in every branch.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — Step 2 to rewrite
- `skills/engineering/grilling/references/decision-ledger.md` — the lazy-creation rule and the path convention

**ADRs**: None.

**Domain terms**:
- Decision Ledger — the file the skill appends `Dxxx` records to
- Lazy creation — the ledger file is created on the first resolved decision, not on skill load
- Highest existing Dxxx — the next ID is `highest + 1` (e.g., if D007 is highest, next is D008)
- Unresolved contradiction — two existing records that conflict on the same branch

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D003` — the runtime path detection requirement
- `docs/decisions/DECISIONS-skills-grilling-review.md#D015` — the pre-flight `Test-Path` is folded into this ticket (D015 itself is "no change" since D003 covers it)

## Acceptance criteria

- [ ] Step 2 begins with a runtime existence check (`Test-Path docs/decisions` or equivalent).
- [ ] One existing ledger branch: use it, read end-to-end, report highest `Dxxx`, contradictions, and covered branches; confirm path with user.
- [ ] Multiple existing ledgers branch: present all matches, let user pick, do not auto-choose.
- [ ] No existing ledger branch: derive `docs/decisions/DECISIONS-<repo>-<feature>.md` and confirm with user.
- [ ] User confirmation is mandatory before the first write in all three branches.

## Dependencies

**Blocked by**: None — can start immediately.
