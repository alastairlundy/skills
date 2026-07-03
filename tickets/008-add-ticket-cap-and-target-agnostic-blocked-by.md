---
title: Add ticket cap and target-agnostic blocked-by
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Add a total-scope soft cap of 50 hours alongside the existing 15-ticket soft cap, and change the `Blocked by` field to be target-agnostic with render-time substitution at Step 9.

## What to build

Two cross-cutting rule changes:

- **Total-scope soft cap of 50 hours.** In Step 6's ticket-size rule (in both sub-workflows), retain the 15-ticket soft cap and add a total-scope soft cap of 50 hours. If either cap is exceeded, the skill signals scope creep. The 3-4 hour per-ticket hard cap remains unchanged.
- **Target-agnostic `Blocked by` field.** The `Blocked by` field in Step 8's ticket generation is stored as target-agnostic ticket IDs (for example, `T001`, `T002`). At render time (Step 9's publish step), the field is substituted with the appropriate format: issue numbers for issue-tracker targets, basenames for local markdown targets. A user who changes target mid-workflow does not need to re-render the field manually.

Apply both changes to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Add the 50-hour total-scope soft cap

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 6 of both sub-workflows, expand the ticket-size rule to include a total-scope soft cap of 50 hours.
- The rule reads: the 15-ticket soft cap and the 50-hour total-scope soft cap both apply; if either is exceeded, the skill signals scope creep. The 3-4 hour per-ticket hard cap is unchanged.

Verify: Both Step 6 copies contain the 50-hour total-scope soft cap; the 15-ticket soft cap and the 3-4 hour per-ticket hard cap are preserved.

### Step 2 - Make the Blocked by field target-agnostic

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 8 of both sub-workflows, state explicitly that the `Blocked by` field is stored as target-agnostic ticket IDs (for example, `T001`, `T002`).
- Update the parent-field example in the ticket template (`references/ticket-template.md`) to use target-agnostic ticket IDs.
- In `references/publishing-rules.md` (the file created by ticket 007), add a render-time substitution rule: at publish time, substitute the target-agnostic IDs with the appropriate format - issue numbers for issue-tracker targets, basenames for local markdown targets. The substitution runs once at publish, not during ticket generation.

Verify: Both Step 8 copies state the target-agnostic format; the ticket template's parent-field example uses target-agnostic IDs; the publishing rules reference includes the render-time substitution step.

### Step 3 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Add a bullet that the total-scope soft cap of 50 hours applies alongside the 15-ticket soft cap (per step 1).
- Add a bullet that the `Blocked by` field is target-agnostic in storage and substituted at publish time (per step 2).

Verify: Both new Validation bullets are present.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 6 and Step 8 in both sub-workflows, plus the Validation list), `skills/engineering/spec-to-tickets/references/ticket-template.md` (parent-field example updated to target-agnostic IDs), `skills/engineering/spec-to-tickets/references/publishing-rules.md` (render-time substitution rule added - this file is created by ticket 007; if 008 lands first, create the file stub or note the dependency).
**ADRs** - None.
**Domain terms** - `Leaf Ticket` (relevant for the total-scope cap computation, which counts leaf tickets as the units of parallel work).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D005` (50-hour cap), `DECISIONS-skills-spec-to-tickets-review.md#D022` (target-agnostic blocked-by).

## Acceptance criteria

- [ ] Both Step 6 copies state the 15-ticket soft cap, the 50-hour total-scope soft cap, and the 3-4 hour per-ticket hard cap.
- [ ] Both Step 8 copies state that the `Blocked by` field is stored as target-agnostic ticket IDs.
- [ ] `references/ticket-template.md`'s parent-field example uses target-agnostic ticket IDs.
- [ ] `references/publishing-rules.md` (or its eventual location after ticket 007 lands) contains the render-time substitution rule.
- [ ] The Validation list gains two new bullets corresponding to the two rule changes.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 6 and Step 8 edits apply to both sub-workflows created by ticket 001). The `references/publishing-rules.md` change has a soft dependency on ticket 007 (which creates the file); if 008 lands first, the agent creates a stub or notes the dependency in the implementation notes.
