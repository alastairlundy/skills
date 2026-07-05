---
title: Split When to Use into Triggers and Examples subsections
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Make the distinction between triggers (when the skill fires) and examples (what the trigger fires on) explicit. Currently the "When to Use" bullet list mixes both, blurring the line between activation conditions and concrete scenarios.

## What to build

Replace the single "When to Use" section of `skills/engineering/grilling/SKILL.md` with two H3 subsections:

- **Triggers**: the conditions under which the skill activates. Move the first two bullets here:
  - "When the user has a vague idea, ambiguous goal, or undecided direction and wants the agent to help think it through."
  - "The decision is not primarily about code/tech implementation and not primarily about domain modeling or terminology."
  - "When user input would clarify the request, invoke ask-questions" (moves to the end of the Triggers section).

- **Examples**: the user-facing scenarios that the trigger fires on. Move the third bullet here:
  - "Business strategy pivots, product direction, design choices, process changes, organizational structure, hiring, pricing, marketing positioning, partnership decisions."

The "vague decision" / "ambiguous decision" trigger remains undefined — the boundary with `domain-grilling` and `code-implementation-grilling` is the children's responsibility to enforce, not this skill's. This is D005 (no change), included here as a context pointer.

## Recommended Workflow

### Step 1 — Restructure the "When to Use" section

Where: `skills/engineering/grilling/SKILL.md` "When to Use" section

- Add an H3 "Triggers" subsection containing the first two bullets plus the ask-questions bullet at the end.
- Add an H3 "Examples" subsection containing the third bullet.
- Confirm the section still uses a bulleted list format (AGENTS.md requirement).

Verify: The "When to Use" section has two H3 subsections, with the ask-questions bullet at the end of Triggers.

### Step 2 — Confirm "vague decision" stays undefined

Where: `skills/engineering/grilling/SKILL.md` "When to Use" section

- Confirm no worked-example definition of "vague decision" is added.
- Confirm no worked-example definition of "ambiguous decision" is added.
- The boundary with `domain-grilling` and `code-implementation-grilling` is enforced by the children, not this skill.

Verify: The Triggers section contains no definition of "vague decision" or "ambiguous decision".

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — "When to Use" section to split

**ADRs**: None.

**Domain terms**:
- Trigger — a condition under which the skill activates
- Example — a user-facing scenario the trigger fires on (not a trigger itself)

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D006` — the Triggers/Examples split requirement
- `docs/decisions/DECISIONS-skills-grilling-review.md#D005` — "vague decision" remains undefined (no change; this ticket does not redefine it)

## Acceptance criteria

- [ ] "When to Use" section is split into H3 "Triggers" and H3 "Examples" subsections.
- [ ] The first two bullets (vague-idea trigger and the not-code-not-domain exclusion) move to "Triggers".
- [ ] The ask-questions bullet is the last item in "Triggers".
- [ ] The third bullet (business strategy, product direction, etc.) moves to "Examples".
- [ ] "Vague decision" remains undefined in this skill (no worked-example definition added).

## Dependencies

**Blocked by**: None — can start immediately.
