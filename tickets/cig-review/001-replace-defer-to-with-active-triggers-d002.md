---
title: Replace Defer-to phrasing with active trigger forms across the grilling family
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md
---

## Goal

Replace passive "Defer to <skill>" phrasing with active trigger forms ("When <trigger>, use <skill>" and "Do not use when <trigger>") across the three grilling-family skills, so the trigger shape is honest about activation conditions rather than presenting a hand-off as a static reference.

## What to build

Across `skills/engineering/grilling/SKILL.md`, `skills/alignment/domain-grilling/SKILL.md`, and `skills/engineering/code-implementation-grilling/SKILL.md`, find every "Defer to <skill>" / "defer to <skill>" instance and rewrite it as an active trigger.

Replacement rules:

- "Defer to `<skill>` for <X>." in a "When Not to Use" section becomes "Do not use when <X>" (negated trigger).
- "Defer to `<skill>` for <X>." in a "When to Use" / frontmatter `description` field becomes "When <X>, use `<skill>`" (positive trigger).
- Preserve the existing bullet structure (AGENTS.md requires "When to Use" to remain a bulleted list).

Locations to inspect (verified against the current CIG source — apply the same audit to the other two skills):

- `skills/engineering/code-implementation-grilling/SKILL.md` frontmatter `description` (line 6) — one "Defer to" instance.
- `skills/engineering/code-implementation-grilling/SKILL.md` "When Not to Use" section (lines 36, 38, 40) — three "defer to" instances, two targeting `grilling` and `domain-grilling` and one targeting the non-existent `to-prd` skill (also covered by D004 — the `to-prd` instance here must use the D004 plain-language replacement, not a generic active form).
- `skills/alignment/domain-grilling/SKILL.md` and `skills/engineering/grilling/SKILL.md` — find all "Defer to" / "defer to" instances and apply the same replacement.

Do not invent new triggers; preserve the original trigger condition text verbatim, only changing the verb phrase from "defer to" to the active form. Do not change skill names or capability descriptions.

## Recommended Workflow

### Step 1 — Audit the three skills for "Defer to" / "defer to" instances

Where: `skills/engineering/grilling/SKILL.md`, `skills/alignment/domain-grilling/SKILL.md`, `skills/engineering/code-implementation-grilling/SKILL.md`

- Run a case-insensitive search for `defer to` across the three files.
- Record the file, line, surrounding bullet, and the target skill (e.g., `grilling`, `domain-grilling`, `to-prd`).
- Tag each instance as "When to Use" / "When Not to Use" / frontmatter `description` to drive the replacement form.

Verify: A complete list of instances with file, line, and target skill, classified by section.

### Step 2 — Rewrite each instance per the replacement rules

Where: same three files, at the lines recorded in Step 1

- For "When to Use" / `description` instances: replace with "When <trigger>, use `<skill>`" (preserving the original trigger text verbatim).
- For "When Not to Use" instances: replace with "Do not use when <trigger>" (preserving the original trigger text verbatim).
- The single `to-prd` instance in CIG's "When Not to Use" must use the D004 plain-language replacement (a skill that deals with formalizing or creating a specification from user input), not a generic active form — coordinate with the D004 ticket.

Verify: A second search for `defer to` returns zero hits across the three files; the "When to Use" sections still use a bulleted list.

### Step 3 — Confirm frontmatter `description` field still parses as valid YAML

Where: same three files, frontmatter block

- Confirm the `description` field's block-fold scalar (`>-`) still parses after edits.
- Confirm no trailing spaces or accidental indentation breaks were introduced.

Verify: `Get-Content <file> -Head 10` (or equivalent) shows the frontmatter block is well-formed YAML.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — frontmatter `description` and "When Not to Use" section (primary edit target)
- `skills/alignment/domain-grilling/SKILL.md` — "When to Use" / "When Not to Use" sections (likely edit target; audit in Step 1)
- `skills/engineering/grilling/SKILL.md` — "When to Use" / "When Not to Use" sections (likely edit target; audit in Step 1)
- `docs/agents/triage-labels.md` — note: D002's resolved answer is to defer ("Fix Later"), but this ticket does the work directly per the user's "Break this into tickets" instruction rather than filing a follow-up issue

**ADRs**: None.

**Domain terms**:
- Trigger — a condition under which a skill activates
- Use When / Do not use when — the active trigger forms required by D002

**Ledger records**:
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D002` — the family-wide "Defer to" → active trigger replacement requirement

## Acceptance criteria

- [ ] A case-insensitive search for `defer to` across the three grilling-family skills returns zero hits.
- [ ] Every former "Defer to" instance is replaced with either "When <trigger>, use `<skill>`" (in "When to Use" or frontmatter `description`) or "Do not use when <trigger>" (in "When Not to Use").
- [ ] The original trigger text is preserved verbatim — only the verb phrase changed.
- [ ] The single `to-prd` instance in CIG's "When Not to Use" uses the D004 plain-language replacement (no skill name), not a generic active form.
- [ ] The "When to Use" sections in all three skills remain a bulleted list (AGENTS.md requirement).
- [ ] Frontmatter `description` fields remain valid YAML block-fold scalars.

## Dependencies

**Blocked by**: None — can start immediately.
