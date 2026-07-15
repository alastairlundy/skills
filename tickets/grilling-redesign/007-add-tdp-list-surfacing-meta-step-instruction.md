---
title: Add explicit TDP list surfacing meta-step instruction to code-impl
classification: Independent
blocked_by: ["002-diagnose-code-impl-context-block-deviation"]
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Add an explicit instruction to `skills/engineering/code-implementation-grilling/SKILL.md` Step 5.2 stating that the TDP list surfacing is a meta-step (not a branch) and that the context block is not emitted on this turn.

## What to build

In `skills/engineering/code-implementation-grilling/SKILL.md` Step 5.2:

- Add a sentence stating that the TDP list surfacing is a meta-step (not a branch).
- Add a sentence stating that the context block is not emitted on this turn.
- Add a note stating that the first TDP's full context block appears in the next turn when the agent begins resolving the first TDP.

What NOT to do:

- Do not change Step 5.2's behavior — only add the explicit instruction.
- Do not introduce a brief 1-2 sentence summary in place of the TDP list.
- Do not add a 5th element to the TDP list turn.

## Recommended Workflow

### Step 1 — Locate Step 5.2 in the code-impl SKILL.md

Where: `skills/engineering/code-implementation-grilling/SKILL.md`

- Read Step 5.2 end-to-end.
- Note the current text and the line range.

Verify: Step 5.2 location and current text are captured.

### Step 2 — Add the explicit meta-step instruction

Where: `skills/engineering/code-implementation-grilling/SKILL.md` Step 5.2

- Add a sentence: "The TDP list surfacing is a meta-step (not a branch); the context block is not emitted on this turn."
- Add a sentence: "The first TDP's full context block appears in the next turn when the agent begins resolving the first TDP."

Verify: Both sentences are present in Step 5.2.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — primary edit target (Step 5.2)

**ADRs**: None.

**Domain terms**:
- TDP list surfacing — a meta-step that presents the list of TDPs (Technical Decision Points) in dependency order, before the first TDP is resolved
- Meta-step — a step that is not a branch decision; the context block (which is for branches) does not apply

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D010` — the meta-step instruction requirement

## Acceptance criteria

- [ ] Step 5.2 includes the explicit instruction that the TDP list surfacing is a meta-step (not a branch).
- [ ] Step 5.2 includes the explicit instruction that the context block is not emitted on this turn.
- [ ] Step 5.2 notes that the first TDP's full context block appears in the next turn.
- [ ] The rest of Step 5.2 (and the rest of the SKILL.md) is unchanged.

## Dependencies

**Blocked by**: `002-diagnose-code-impl-context-block-deviation` — the diagnosis confirms the current text and line range.
