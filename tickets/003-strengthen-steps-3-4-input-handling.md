---
title: Strengthen Steps 3 and 4 input handling
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Tighten the Input Sufficiency Check (Step 3) and the Codebase Exploration (Step 4) so that the skill handles missing Decision Ledgers, missing repo conventions, and wholly-insufficient input in a deterministic way.

## What to build

Three rule additions and one inline definition, applied to Step 3 and Step 4 in both sub-workflows:

- **Step 3 - wholly-insufficient input branch.** When all four input-sufficiency criteria (problem statement, solution approach, scope boundaries, acceptance criteria) are missing, recommend running `grilling` or `domain-grilling` (per the DDD-alignment rule below) rather than aborting. The current text aborts; the replacement recommends grilling instead. The current abort behavior is retained for partially-insufficient input (one or more criteria missing).
- **Step 3 - DDD-alignment rule for the no-ledger branch.** When the spec ships without a Decision Ledger, recommend `domain-grilling` if DDD alignment is critical or important for the spec, or `grilling` otherwise. The recommendation is made before the ticket decomposition proceeds. Add the term `ledger record` to the glossary entry produced by Step 3, defined inline on first use as a `Dxxx` or `Txxx` entry in a Decision Ledger.
- **Step 4 - fall-through behavior made explicit.** When `CONTEXT.md`, `docs/adr/`, or `docs/decisions/` are not found, the skill proceeds without them and does not create them. The agent shall explicitly inform the user which of these files or conventions are missing, rather than silently falling through.
- **Step 3 inline glossary term.** Define `ledger record` inline the first time the term appears in the skill, so a top-to-bottom reader can understand the term without searching.

Apply the same changes to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Add the wholly-insufficient input branch to Step 3

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 3 of both sub-workflows, add a branch for the all-four-missing case: the skill recommends `grilling` or `domain-grilling` (per the DDD-alignment rule in step 2) rather than aborting.
- Confirm the existing abort behavior is preserved for partially-insufficient input.

Verify: Both Step 3 copies contain a distinct all-four-missing branch with the grilling/domain-grilling recommendation; partially-insufficient input still aborts.

### Step 2 - Add the no-ledger recommendation to Step 3

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 3 of both sub-workflows, add a paragraph (or bullet) under the Decision Ledger pairing rule: when no Decision Ledger is found, recommend `domain-grilling` if DDD alignment is critical or important, or `grilling` otherwise.
- Place the recommendation before any ticket decomposition proceeds.

Verify: Both Step 3 copies contain the no-ledger recommendation with the DDD-alignment tie-breaker.

### Step 3 - Define the term ledger record inline

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- At the first place the term `ledger record` appears in the skill (in the Decision Ledger pairing paragraph added in step 2), add an inline definition: "A `ledger record` is a `Dxxx` or `Txxx` entry in a Decision Ledger."

Verify: The first occurrence of `ledger record` in the skill carries the inline definition.

### Step 4 - Make Step 4 fall-through behavior explicit

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 4 of both sub-workflows, add an explicit statement that the absence of `CONTEXT.md`, `docs/adr/`, or `docs/decisions/` is informational: the skill proceeds without them and does not create them.
- Add a requirement that the agent explicitly informs the user which of these files or conventions are missing, rather than silently falling through.

Verify: Both Step 4 copies contain the explicit fall-through statement and the user-inform requirement; no silent fall-through remains.

### Step 5 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Add a bullet that the all-four-missing branch routes to grilling or domain-grilling (per step 1).
- Add a bullet that the no-ledger branch routes per the DDD-alignment rule (per step 2).
- Add a bullet that the first use of `ledger record` carries its inline definition (per step 3).
- Add a bullet that Step 4 explicitly informs the user about missing conventions (per step 4).

Verify: All four new Validation bullets are present.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 3 and Step 4 in both sub-workflows, plus the Validation list).
**ADRs** - None.
**Domain terms** - `Decision Ledger` (referenced in the existing Step 3 text), `ledger record` (new inline definition added by this ticket), `grilling`, `domain-grilling` (skill names invoked by the new branches).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D007` (no-ledger recommendation), `DECISIONS-skills-spec-to-tickets-review.md#D009` (Step 4 fall-through), `DECISIONS-skills-spec-to-tickets-review.md#D018` (all-four-missing branch), `DECISIONS-skills-spec-to-tickets-review.md#D020` (inline `ledger record` definition).

## Acceptance criteria

- [ ] Step 3 in both sub-workflows contains a distinct all-four-missing branch that recommends grilling or domain-grilling.
- [ ] Step 3 in both sub-workflows recommends `domain-grilling` for DDD-critical specs and `grilling` otherwise, when no Decision Ledger is found.
- [ ] The first occurrence of `ledger record` in the skill carries an inline definition.
- [ ] Step 4 in both sub-workflows states explicitly that the skill proceeds without `CONTEXT.md`, `docs/adr/`, or `docs/decisions/` and does not create them.
- [ ] Step 4 in both sub-workflows requires the agent to explicitly inform the user which conventions are missing.
- [ ] The Validation list gains four new bullets corresponding to the four rule additions.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 3 and Step 4 edits apply to both sub-workflows created by ticket 001).
