---
title: Restructure workflow into sub-workflows
classification: Independent
blocked_by: []
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Replace the single Workflow section of `SKILL.md` with two clearly-separated sub-workflows (Collaborative and Self-Contained), duplicate the shared steps in both, retire the `> Mode banner` callout style, and retain the conversational-opening instruction.

## What to build

Restructure the Workflow section as follows:

- Introduce two top-level sub-headings under Workflow: `### Collaborative Workflow` and `### Self-Contained Workflow`.
- Duplicate the steps that run identically in both modes into both sub-workflows, using identical text - Step 1 (Mode Detection), Step 2 (Input Gathering), Step 3 (Input Sufficiency Check), Step 4 (Codebase Exploration), Step 8 (Ticket Generation), and Step 10 (Summary Report).
- Keep the steps whose content diverges by mode in their respective sub-workflows, with the mode-specific content inline (no `> Mode banner` callouts). The divergent steps are Step 5 (Output Target Resolution), Step 6.2 (post-table validation loop), Step 7 (Existing Ticket Detection's overwrite question), and Step 9 (Ticket Publishing's install prompt).
- Remove every existing `> Mode banner: ...` callout from the skill.
- Retain the Workflow opening paragraph that instructs the LLM to use a conversational tone. The conversational tone governs the LLM's user-facing output, not the internal step structure.
- Update the Validation list to remove mode-banner style references (the structural change makes the callout style obsolete).

## Recommended Workflow

### Step 1 - Add sub-workflow headings and opening

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Insert `### Collaborative Workflow` and `### Self-Contained Workflow` headings under the existing `## Workflow` heading.
- Keep the existing conversational-tone opening paragraph above the new sub-workflow headings.

Verify: Both sub-headings exist under `## Workflow`; opening paragraph is unchanged; no `> Mode banner` callouts remain.

### Step 2 - Duplicate shared steps into both sub-workflows

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Copy Steps 1, 2, 3, 4, 8, and 10 verbatim into the Collaborative sub-workflow.
- Copy the same six steps verbatim into the Self-Contained sub-workflow.

Verify: Both sub-workflows contain the six shared steps with byte-identical text; Step 1's mode-detection rule still routes "self-contained" requests to the Self-Contained sub-workflow.

### Step 3 - Place divergent steps under their owning sub-workflow

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Place Step 5 in both sub-workflows with the Collaborative branch asking via `ask_question` and the Self-Contained branch defaulting to local markdown.
- Place Step 6.2 in both sub-workflows with the Collaborative branch running the closing-question validation loop and the Self-Contained branch proceeding without confirmation.
- Place Step 7 in both sub-workflows with the Collaborative branch asking case-by-case about overwriting existing tickets and the Self-Contained branch retaining the automatic semantic-match behavior.
- Place Step 9 in both sub-workflows with the install-prompt branch in the Collaborative sub-workflow and the no-prompt branch in the Self-Contained sub-workflow.

Verify: Each divergent step appears in both sub-workflows with the correct mode-specific content; no step relies on a `> Mode banner` callout to convey its mode-specific content.

### Step 4 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Remove any Validation bullets that reference mode-banner callouts.
- Add a bullet that the sub-workflow structure is self-consistent (shared steps duplicated, divergent steps placed under the correct sub-workflow).

Verify: Validation list contains no references to `> Mode banner`; the new consistency bullet is present.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (the only file modified by this ticket; restructures the Workflow section and the Validation list).
**ADRs** - None.
**Domain terms** - `Collaborative`, `Self-Contained` (defined in the glossary as workflow modes; relevant because the sub-workflow structure makes the mode the unit of organization rather than a callout).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D003` (the structural split), `DECISIONS-skills-spec-to-tickets-review.md#D017` (mode-banner callout style retired), `DECISIONS-skills-spec-to-tickets-review.md#D023` (conversational opening retained).

## Acceptance criteria

- [ ] The Workflow section contains two sub-headings: `### Collaborative Workflow` and `### Self-Contained Workflow`.
- [ ] Steps 1, 2, 3, 4, 8, and 10 appear in both sub-workflows with identical text.
- [ ] Steps 5, 6.2, 7, and 9 appear in both sub-workflows with the correct mode-specific content.
- [ ] No `> Mode banner` callout remains anywhere in the skill.
- [ ] The conversational-tone opening paragraph is preserved above the sub-workflow headings.
- [ ] The Validation list contains no mode-banner references and includes a new consistency bullet for the sub-workflow structure.
- [ ] `When to Use`, `When Not to Use`, the YAML frontmatter, and the references/ directory are unchanged.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - None - can start immediately.
