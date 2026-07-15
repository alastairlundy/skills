---
title: Add parent 4-element context block check to code-impl validation
classification: Independent
blocked_by: ["002-diagnose-code-impl-context-block-deviation"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Append a verbatim copy of the parent grilling skill's 4-element context block check to the code-impl skill's validation reference, so the agent catches non-parity context blocks at validation time.

## What to build

In `skills/engineering/code-implementation-grilling/references/validation.md` (or the resolved placement from the `TK002` diagnosis if the file does not exist):

- Add the parent grilling skill's 4-element context block check verbatim. The check is: "Every context block was emitted as the four-element bullet list (Goal, Prior decisions, Stakes, Scope) in that order, each element exactly one sentence, with ledger citations. The context block was not replaced with a free-form prose summary, a 'current state' investigation, a code reading, a domain-glossary recap, or any other kind of analysis."
- Place the check alongside the other validation checks (the placement is at the implementer's discretion; recommend grouping with the related context-block checks added by `TK003`).
- If `validation.md` does not exist, create it with the verbatim check as the first entry; the rest of the file can be a minimal scaffold (a heading and the check).

What NOT to do:

- Do not write a code-impl-specific check that references the parent — use the verbatim parent check.
- Do not split the check into four separate checks (one per element) — keep it as one bullet.

## Recommended Workflow

### Step 1 — Read the parent validation check

Where: `skills/engineering/grilling/SKILL.md` Validation list (search for "context block" and "four-element")

- Locate the parent's 4-element context block check.
- Capture the verbatim text.

Verify: A copy of the parent's verbatim check is in hand.

### Step 2 — Verify the TK002 diagnosis does not require different placement

Where: the diagnosis file from `TK002`

- Confirm that `references/validation.md` exists in the code-impl skill (the diagnosis may note its absence if it does not exist).
- If the file does not exist, create it with the verbatim check as the first entry; if the file exists, append the verbatim check.

Verify: The placement is determined (append vs. create).

### Step 3 — Add the verbatim check to code-impl validation

Where: `skills/engineering/code-implementation-grilling/references/validation.md` (or the resolved placement from Step 2)

- Add the verbatim check.

Verify: A search for "four-element bullet list (Goal, Prior decisions, Stakes, Scope)" in code-impl matches the parent text exactly.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — source of the verbatim check (read-only)
- `skills/engineering/code-implementation-grilling/references/validation.md` — primary edit target (create if absent per `TK002` diagnosis)

**ADRs**: None.

**Domain terms**:
- Verbatim check — an exact copy of a check from another skill, with no rewording or abbreviation

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D007` — the verbatim check requirement

## Acceptance criteria

- [ ] The parent grilling skill's 4-element context block check is present in `skills/engineering/code-implementation-grilling/references/validation.md` (or the resolved file from `TK002`) verbatim.
- [ ] The check uses the verbatim text: "Every context block was emitted as the four-element bullet list (Goal, Prior decisions, Stakes, Scope) in that order, each element exactly one sentence, with ledger citations. The context block was not replaced with a free-form prose summary, a 'current state' investigation, a code reading, a domain-glossary recap, or any other kind of analysis."
- [ ] The check is a single bullet, not split into four separate checks (one per element).
- [ ] The rest of the code-impl validation checklist is unchanged.

## Dependencies

**Blocked by**: `002-diagnose-code-impl-context-block-deviation` — the diagnosis may note whether `validation.md` exists.
