---
title: Replace to-prd reference in skill metadata
classification: Independent
blocked_by: []
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Remove the `to-prd` reference from the skill's YAML description, body's `When Not to Use` section, and Step 3 abort text. Replace it with a generic instruction to check for an available spec/PRD-creation skill and recommend it; otherwise, no specific skill is named.

## What to build

The skill currently names `to-prd` as the recommended follow-up when the spec is incomplete. The replacement text does the following:

- Instructs the LLM to check whether the user has access to a skill that creates specifications or requirements documents.
- If such a skill is available, recommends it.
- If no such skill is available, names no specific skill and stops at the recommendation instruction.

The replacement applies in three locations:

1. The YAML `description` field's "Don't use when" clause - the current text reads "spec is incomplete, vague, or unresolved (use grilling first, or domain-grilling if the resolution needs DDD alignment, or to-prd to capture)".
2. The body's `When Not to Use` section - the matching bullet.
3. The Step 3 abort text in both sub-workflows (added by ticket 001) - the current text recommends `to-prd` alongside `grilling` and `domain-grilling`.

## Recommended Workflow

### Step 1 - Update YAML description

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Replace the `to-prd` reference in the YAML `description` field's "Don't use when" clause with the generic instruction text.

Verify: The YAML `description` field contains no `to-prd` reference; the new text matches the generic-instruction template.

### Step 2 - Update body's When Not to Use

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Replace the matching bullet in the `When Not to Use` section with the same generic instruction text.

Verify: The `When Not to Use` section contains no `to-prd` reference.

### Step 3 - Update Step 3 abort text in both sub-workflows

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Replace the `to-prd` reference in the Step 3 abort text with the same generic instruction text.
- Apply the change in both the Collaborative and Self-Contained sub-workflows.

Verify: Both sub-workflow copies of Step 3 contain no `to-prd` reference; the new text is identical between the two sub-workflows.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (three locations: YAML frontmatter, `When Not to Use` body section, Step 3 abort text in both sub-workflows).
**ADRs** - None.
**Domain terms** - None.
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D002`.

## Acceptance criteria

- [ ] The YAML `description` field contains no `to-prd` reference.
- [ ] The `When Not to Use` section contains no `to-prd` reference.
- [ ] The Step 3 abort text in the Collaborative sub-workflow contains no `to-prd` reference.
- [ ] The Step 3 abort text in the Self-Contained sub-workflow contains no `to-prd` reference.
- [ ] All four locations instruct the LLM to check for an available spec/PRD-creation skill and recommend it.
- [ ] No specific skill is named in the replacement text.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - None - can start immediately.
