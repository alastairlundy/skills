---
title: Replace to-prd and to-issues references in CIG with plain-language guidance
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md
---

## Goal

Replace every reference to the non-existent `to-prd` and `to-issues` skills in `skills/engineering/code-implementation-grilling/SKILL.md` with plain-language guidance that names the target capability (spec formalization and issue tracking/management, respectively), so the workflow no longer invokes skills that do not exist.

## What to build

In `skills/engineering/code-implementation-grilling/SKILL.md`, find every instance of `to-prd` and `to-issues` and replace it with plain-language guidance per the rules below.

Replacement rules:

- For `to-prd` (spec formalization): replace with language that names the capability without naming any specific skill — for example, "If the user needs a spec or PRD captured first, hand off to a skill that formalizes a specification from user input (e.g., grilling) before returning to this one." Do not name `to-prd` (it does not exist) and do not name a specific replacement skill (D004 constraint). The plain-language guidance describes the target capability, not a specific skill.
- For `to-issues` (issue tracker hand-off): replace with language that names the capability — for example, "Hand off to a workflow that files the spec and blueprint as issues in the issue tracker." Do not name `to-issues` (it does not exist) and do not name a specific replacement skill. Reference the issue tracker itself (e.g., "the project's issue tracker") without naming a specific skill that operates on it.

Locations to inspect (verified against the current source — re-audit before editing):

- `skills/engineering/code-implementation-grilling/SKILL.md` "When Not to Use" section (line 40) — one `to-prd` instance.
- `skills/engineering/code-implementation-grilling/SKILL.md` Terminal Output section, Option A (line 372) — one `to-issues` instance.
- `skills/engineering/code-implementation-grilling/SKILL.md` Terminal Output section, Option B (line 397) — one `to-issues` instance.

The Terminal Output section also has a "Template: ticket consumer (`spec-to-tickets`)" entry that names an existing skill. That entry is out of scope for this ticket (it references a real skill) — do not touch it.

Do not consolidate the six Terminal Output templates — that is D009 and explicitly out of scope per D004's constraints.

## Recommended Workflow

### Step 1 — Audit the skill for `to-prd` and `to-issues` instances

Where: `skills/engineering/code-implementation-grilling/SKILL.md`

- Run a case-insensitive search for `to-prd` and `to-issues`.
- Record the file, line, surrounding context, and the template or section the instance sits in.
- Confirm there are three total instances: one `to-prd` (line 40) and two `to-issues` (lines 372 and 397).
- Flag any other instances found that are not in the expected list.

Verify: A complete list of instances with file, line, and surrounding context.

### Step 2 — Replace the `to-prd` instance with plain-language spec-formalization guidance

Where: `skills/engineering/code-implementation-grilling/SKILL.md` "When Not to Use" section (line 40)

- Replace `to-prd` with plain-language guidance that describes the target capability (formalizing a specification from user input).
- Do not name a specific skill.
- Preserve the surrounding bullet structure and the "When Not to Use" form (e.g., the bullet is "For creating a spec or PRD itself — defer to `to-prd` or `domain-grilling`."; rewrite to something like "For creating a spec or PRD itself — hand off to a skill that formalizes a specification from user input, or to `domain-grilling`.").
- Coordinate with the D002 ticket: the active trigger form ("Do not use when <trigger>") may be required by D002 instead of "For <trigger> — hand off to..." — apply whichever form is current after the D002 ticket's edits, since the D002 ticket will also rewrite this line.

Verify: A search for `to-prd` in CIG returns zero hits; the surrounding bullet preserves the "When Not to Use" semantics.

### Step 3 — Replace the `to-issues` instances with plain-language issue-tracker guidance

Where: `skills/engineering/code-implementation-grilling/SKILL.md` Terminal Output section (lines 372 and 397)

- For each instance, replace the template label "Template: issue tracker (`to-issues`)" with a label that names the capability — for example, "Template: issue tracker (file the spec and blueprint as issues in the project's issue tracker)".
- The template body (the paragraph that begins "Run the `to-issues` skill...") must also be rewritten to remove the `to-issues` reference. Replace with a generic description of the action: "File the spec and blueprint as issues in the project's issue tracker, citing the Decision Ledger per the same constraints as the ticket-consumer template."
- Do not name a specific skill (e.g., do not introduce `gh-fix-ci` or any other named workflow).
- Do not consolidate the six templates (D009 is out of scope).

Verify: A search for `to-issues` in CIG returns zero hits; the two templates retain their Option A / Option B distinction and their ticket-consumer siblings are unchanged.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — the file to edit (three locations: lines 40, 372, 397)
- `skills/engineering/grilling/SKILL.md` — the parent skill; "defer to" / "When Not to Use" conventions originate here (read-only reference)

**ADRs**: None.

**Domain terms**:
- Generic-exit convention — the parent's pattern of describing the next workflow step by capability ("hand off to a skill that...") rather than by skill name
- Terminal Output template — one of the six pre-written handoff templates in CIG's Terminal Output section, keyed on Output format (Option A/B) and Downstream consumer (ticket consumer / issue tracker / manual handoff)

**Ledger records**:
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D004` — the `to-prd` / `to-issues` replacement requirement, including the constraint that the follow-up targets CIG only and uses the generic-exit convention
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D009` — the Terminal Output consolidation decision; out of scope for this ticket

## Acceptance criteria

- [ ] A case-insensitive search for `to-prd` in `skills/engineering/code-implementation-grilling/SKILL.md` returns zero hits.
- [ ] A case-insensitive search for `to-issues` in `skills/engineering/code-implementation-grilling/SKILL.md` returns zero hits.
- [ ] The `to-prd` replacement describes the target capability (spec formalization) without naming a specific skill.
- [ ] Both `to-issues` replacements describe the target capability (issue tracking/management) without naming a specific skill.
- [ ] The `spec-to-tickets` template entry (Terminal Output) is unchanged — that entry references a real skill and is out of scope.
- [ ] The six Terminal Output templates are not consolidated (D009 out of scope).
- [ ] The D002 ticket's active trigger form is preserved at the `to-prd` location (D002 rewrites "defer to" → active form; D004 replaces `to-prd` with plain language; the two edits compose without conflict).

## Dependencies

**Blocked by**: None — can start immediately. Note: the D002 ticket also rewrites the line at SKILL.md:40 (the "defer to `to-prd`" instance). If both tickets are implemented concurrently, coordinate so the active trigger form (D002) and the plain-language spec-formalization replacement (D004) are applied together. Neither ticket blocks the other; the coordination concern is implementation-time, not ticket-time.
