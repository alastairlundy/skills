---
title: Strengthen Steps 6 and 7 ticket decomposition and detection
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Tighten the ticket-decomposition step (Step 6) and the existing-ticket-detection step (Step 7) so that the closing-question format is enforced at write time, the ticket count rule is uniform, the destructive-operation safety in Step 7 is mode-aware, and the custom-patterns validation rule remains in both Step 6.1 and the Validation list.

## What to build

Four rule changes, applied to Step 6 and Step 7 in both sub-workflows:

- **Step 6 - closing-question format inline.** Move the closing-question format (preamble paragraph, blank line, the line `A few things to check:`, and three questions on separate lines) from the Validation list into Step 6's Collaborative-mode validation loop. The agent uses the format at write time, not as a post-hoc check. The Validation list retains a compliance check that references the Step 6 rule without restating the full format.
- **Step 6 - ticket count rule.** Remove the "one ticket is acceptable" exception. The rule becomes "at least 2 tickets" with no exception.
- **Step 7 - destructive-operation safety in Collaborative mode.** In the Collaborative sub-workflow, ask the user whether to overwrite existing tickets on a case-by-case basis rather than applying the semantic-match rule automatically. In the Self-Contained sub-workflow, retain the current behavior: the semantic-match rule is applied automatically, and the permission layer is the fallback safety boundary.
- **Custom-patterns validation (no change).** The "Custom patterns are validated against skill constraints before proceeding" rule remains in both Step 6.1 and the Validation list. The duplication is intentional: the Validation list serves as enforcement.

Apply the changes to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Inline the closing-question format in Step 6

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Move the closing-question format (preamble paragraph, blank line, the line `A few things to check:`, three questions on separate lines) from the Validation list into Step 6's Collaborative-mode validation loop in the Collaborative sub-workflow.
- The three questions are: (1) "Which tickets, if any, would you combine, split, or rescope?" (2) "Are there any spec requirements not yet covered by a ticket, or any ticket that doesn't trace back to a requirement?" (3) "Are there any tickets where the `Blocked by` chain or Independent/Collaborative classification feels off?"
- The Self-Contained sub-workflow does not get the inline format because it does not run the validation loop.

Verify: Step 6 in the Collaborative sub-workflow contains the full closing-question format at write time; Step 6 in the Self-Contained sub-workflow does not.

### Step 2 - Tighten the ticket count rule in Step 6

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Remove the "one ticket is acceptable" exception in both sub-workflows' Step 6 ticket-count rule.
- The rule becomes: ticket count is at least 2, with no exception.

Verify: Both sub-workflows' Step 6 ticket-count rule contains no exception clause; the rule reads as "at least 2 tickets".

### Step 3 - Mode-aware Step 7 destructive-operation safety

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 7 of the Collaborative sub-workflow, add a case-by-case user prompt for overwriting existing tickets. The agent asks the user before overwriting any ticket rather than applying the semantic-match rule automatically.
- In Step 7 of the Self-Contained sub-workflow, retain the current behavior: the semantic-match rule is applied automatically, and the permission layer is the fallback safety boundary.

Verify: Step 7 in the Collaborative sub-workflow contains the case-by-case user prompt; Step 7 in the Self-Contained sub-workflow retains the semantic-match rule with permission-layer fallback.

### Step 4 - Retain the custom-patterns validation duplication

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Confirm the "Custom patterns are validated against skill constraints before proceeding" rule appears in both Step 6.1 and the Validation list.
- No edit is required; this step is a verification.

Verify: The custom-patterns validation rule appears in both locations and is textually close between the two.

### Step 5 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Replace the restated closing-question format with a one-line compliance check that references the Step 6 rule.
- Replace the "one ticket is acceptable" exception with a strict "at least 2 tickets" rule in the validation bullet.
- Add a bullet that the custom-patterns validation rule appears in both Step 6.1 and the Validation list.
- Add a bullet that the Collaborative sub-workflow's Step 7 asks the user before overwriting existing tickets, and the Self-Contained sub-workflow's Step 7 retains the automatic semantic-match behavior.

Verify: All four updated Validation bullets are present; the closing-question format is no longer restated in the Validation list.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 6 and Step 7 in both sub-workflows, plus the Validation list).
**ADRs** - None.
**Domain terms** - `Collaborative`, `Self-Contained` (relevant for the mode-aware Step 7 behavior); `Collaborative` and `Independent` ticket classifications (relevant for the closing-question format's third question).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D004` (Step 7 mode-aware safety), `DECISIONS-skills-spec-to-tickets-review.md#D010` (closing-question format inline), `DECISIONS-skills-spec-to-tickets-review.md#D011` (ticket count rule), `DECISIONS-skills-spec-to-tickets-review.md#D021` (custom-patterns validation duplication retained).

## Acceptance criteria

- [ ] Step 6 in the Collaborative sub-workflow contains the closing-question format inline (preamble, blank line, `A few things to check:`, three questions on separate lines).
- [ ] Step 6 in the Self-Contained sub-workflow does not contain the closing-question format.
- [ ] Both sub-workflows' Step 6 ticket-count rule reads as "at least 2 tickets" with no exception clause.
- [ ] Step 7 in the Collaborative sub-workflow contains the case-by-case user prompt for overwriting existing tickets.
- [ ] Step 7 in the Self-Contained sub-workflow retains the automatic semantic-match rule with permission-layer fallback.
- [ ] The custom-patterns validation rule appears in both Step 6.1 and the Validation list.
- [ ] The Validation list's closing-question bullet references the Step 6 rule without restating the full format.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 6 and Step 7 edits apply to both sub-workflows created by ticket 001).
