---
title: Refine Step 8 ticket generation rules
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Tighten Step 8's ticket-generation rules: make the parent-field summary requirement explicit, move the YAML-breaking-characters check to write time, retain the abbreviation rule and the context-pointers reactive rules as no-change decisions, and retain Step 8's workflow-generation rules as inline.

## What to build

Three rule changes and two verified no-change decisions, all in Step 8 of both sub-workflows:

- **Parent field summary explicit.** The 1-3 sentence summary is required only for the conversation-context input type. For issue-tracker-reference and file-path input types, the issue number or relative file path is sufficient. State this explicitly so the rule does not surprise.
- **YAML-breaking-characters check moved to write time.** Move the "no YAML-breaking characters" rule from the Validation list into Step 8 as a write-time rule, with explicit guidance on how to avoid or escape YAML-breaking characters. The Validation list retains a compliance check that references the Step 8 rule without restating the full rule.
- **Abbreviation rule (no change, verified).** The anti-abbreviation rule for "User Stories" remains universal and unconditional; `US` is never used as an abbreviation. No scoping or opt-in mechanism is added.
- **Context pointers reactive (no change, verified).** The current reactive context pointer rules (do not reproduce the glossary, do not reproduce the ledger) remain unchanged. No pointer-necessity or pointer-variety check is added.
- **Workflow-generation rules remain inline (no change, verified).** Step 8's workflow-generation rules remain inline; the repo convention "short templates live inline" is not applied to Step 8.

Apply the rule changes to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Make the parent field summary rule explicit

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 8 of both sub-workflows, expand the parent-field-values paragraph to state explicitly that the 1-3 sentence summary is required only for the conversation-context input type.
- For issue-tracker-reference and file-path input types, the issue number or relative file path is sufficient.

Verify: Both Step 8 copies contain the explicit input-type distinction; the conversation-context summary requirement is clearly bounded.

### Step 2 - Move the YAML-breaking-characters check to write time

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 8 of both sub-workflows, add a write-time rule: the `description` and other prose-bearing frontmatter fields shall contain no YAML-breaking characters (colons, unquoted special characters).
- Add explicit guidance on how to avoid or escape YAML-breaking characters (e.g., use a hyphen or rewrite the phrase).
- Remove the restated rule from the Validation list; replace it with a one-line compliance check that references the Step 8 rule.

Verify: Both Step 8 copies contain the write-time rule with explicit escape guidance; the Validation list contains the one-line reference but not the restated rule.

### Step 3 - Verify the abbreviation rule is unchanged

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Confirm the existing anti-abbreviation rule for "User Stories" remains universal and unconditional in both sub-workflows' Step 8.
- No edit is required; this step is a verification.

Verify: The abbreviation rule remains in both Step 8 copies; no scoping or opt-in mechanism is added.

### Step 4 - Verify the context pointers rules are unchanged

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Confirm the existing reactive context pointer rules (do not reproduce the glossary, do not reproduce the ledger) remain in both sub-workflows' Step 8 context-pointer paragraph.
- No edit is required; this step is a verification.

Verify: The context pointer rules remain in both Step 8 copies; no pointer-necessity or pointer-variety check is added.

### Step 5 - Verify Step 8 workflow-generation rules remain inline

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Confirm the workflow-generation rules (verb-phrase title, Where, bulleted actions, Verify, derivation priority) remain inline in both sub-workflows' Step 8.
- No edit is required; this step is a verification.

Verify: The workflow-generation rules remain inline in both Step 8 copies; no reference is created for the workflow-generation template.

### Step 6 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Add a bullet that the parent-field summary rule is explicit (per step 1).
- Add a bullet that the YAML-breaking-characters check is at write time (per step 2).
- Add a bullet that the abbreviation rule is universal and unconditional (per step 3, verification only).
- Add a bullet that the context pointer rules are reactive (per step 4, verification only).
- Add a bullet that Step 8 workflow-generation rules are inline (per step 5, verification only).

Verify: All five Validation bullets are present; the YAML-breaking-characters rule is referenced, not restated.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 8 in both sub-workflows, plus the Validation list).
**ADRs** - None.
**Domain terms** - `Decision Ledger` (referenced by the YAML-breaking-characters rule, which protects citation IDs like `filename#<Dxxx|Txxx>`).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D006` (abbreviation rule, verified no change), `DECISIONS-skills-spec-to-tickets-review.md#D008` (context pointers reactive, verified no change), `DECISIONS-skills-spec-to-tickets-review.md#D015` (parent field explicit), `DECISIONS-skills-spec-to-tickets-review.md#D016` (YAML-breaking-chars to write time), `DECISIONS-skills-spec-to-tickets-review.md#D019` (workflow-generation inline, verified no change), `DECISIONS-skills-spec-to-tickets-review.md#D020` (inline `ledger record` definition - cross-referenced with ticket 003).

## Acceptance criteria

- [ ] Both Step 8 copies state explicitly that the 1-3 sentence parent-field summary is required only for the conversation-context input type.
- [ ] Both Step 8 copies contain the YAML-breaking-characters write-time rule with explicit escape guidance.
- [ ] The anti-abbreviation rule for "User Stories" remains universal and unconditional in both Step 8 copies.
- [ ] The context pointer rules remain reactive in both Step 8 copies.
- [ ] The workflow-generation rules remain inline in both Step 8 copies.
- [ ] The Validation list references the Step 8 YAML-breaking-characters rule without restating it.
- [ ] The Validation list gains five new bullets corresponding to the five rule changes and verifications.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 8 edits apply to both sub-workflows created by ticket 001).
