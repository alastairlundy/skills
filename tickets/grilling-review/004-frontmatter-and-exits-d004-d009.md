---
title: Standardise trigger phrasing and rename exit paths
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Make `grilling`'s trigger phrasing match the repo's "Do not use for / when" convention, and rename Step 6's exit paths from tool-specific names (`to-prd`, `to-issues`) to generic verbs that map to whatever the calling environment provides.

## What to build

Two changes to `skills/engineering/grilling/SKILL.md`:

1. **Frontmatter `description` (D004)**: replace the "defer to `code-implementation-grilling`" and "defer to `domain-grilling`" phrasing with "Do not use for X — use `skill-y` instead". The wording shall match the style of `ask-questions`, `write-changelog`, and `skill-architect`.

2. **Step 6 exit paths (D009)**: rename the exits to generic verbs:
   - **Document the decision** (was the implicit "Hand off to `to-prd`")
   - **Specialize to DDD** (was "Hand off to `domain-grilling`")
   - **Specialize to code** (was "Hand off to `code-implementation-grilling`")
   - **Decompose** (was "Break into tickets or issues")
   - **Hand off to another agent** (was "Hand off")
   - **Custom save** (unchanged)
   
   Add a one-line comment or table mapping each generic name to the tool the calling environment provides. `to-prd` and `to-issues` are not present in this repo; the renamed exits are tool-agnostic. The mapping table is best-effort: if the named tool is not available, the agent falls back to the generic behaviour described in the body.

## Recommended Workflow

### Step 1 — Rewrite the frontmatter description

Where: `skills/engineering/grilling/SKILL.md` frontmatter (lines 6-9)

- Replace the "defer to `code-implementation-grilling`" phrasing with "Do not use for code/technical implementation choices — use `code-implementation-grilling` instead".
- Replace the "defer to `domain-grilling`" phrasing with "Do not use for domain modeling or terminology alignment — use `domain-grilling` instead".
- Confirm the wording matches the style of `skills/alignment/ask-questions/SKILL.md`, `skills/engineering/write-changelog/SKILL.md`, and `skills/skills-meta/skill-architect/SKILL.md`.

Verify: The frontmatter `description:` uses "Do not use for X — use `skill-y` instead" phrasing for both cross-references.

### Step 2 — Rename Step 6 exit paths

Where: `skills/engineering/grilling/SKILL.md` Step 6

- Rename the exits to the six generic verbs listed above.
- Add a "Tool mapping" subsection (table or comment block) under the exit list. Map each generic verb to the named tool if present (`Document the decision` → `to-prd`, `Decompose` → `spec-to-tickets` or `to-issues`), with a fallback behaviour for each.
- Make explicit that if the named tool is not available, the agent falls back to the generic behaviour described in the exit body.

Verify: Step 6 lists six generic-verb exits plus a tool mapping table with explicit fallbacks.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — frontmatter and Step 6
- `skills/alignment/ask-questions/SKILL.md` — style reference for "Do not use for" phrasing
- `skills/engineering/write-changelog/SKILL.md` — style reference
- `skills/skills-meta/skill-architect/SKILL.md` — style reference

**ADRs**: None.

**Domain terms**:
- Tool mapping — the indirection from a generic verb to a specific tool in the calling environment
- Generic verb — a tool-agnostic exit name that resolves to whichever tool the caller provides

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D004` — frontmatter trigger phrasing
- `docs/decisions/DECISIONS-skills-grilling-review.md#D009` — generic exit names

## Acceptance criteria

- [ ] Frontmatter `description:` uses "Do not use for X — use `skill-y` instead" for both cross-references to `code-implementation-grilling` and `domain-grilling`.
- [ ] Step 6 lists six exits: "Document the decision", "Specialize to DDD", "Specialize to code", "Decompose", "Hand off to another agent", "Custom save".
- [ ] A tool-mapping table or comment block maps each generic verb to the tool the calling environment provides, with explicit fallbacks.
- [ ] The wording matches the style of `ask-questions`, `write-changelog`, and `skill-architect` for the frontmatter change.

## Dependencies

**Blocked by**: None — can start immediately.
