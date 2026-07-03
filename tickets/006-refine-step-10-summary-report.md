---
title: Refine Step 10 summary report
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Tighten Step 10's summary report: surface a ticket-bloat warning for any `XS` ticket, remove the `XXL` effort label from the closed vocabulary, and compute the per-ticket `Review complexity` label deterministically from the ticket's own `blocked-by` chain.

## What to build

Three rule changes in Step 10 of both sub-workflows:

- **`XS` ticket-bloat warning.** Surface a ticket-bloat warning in the summary report for any ticket labeled `XS`, signaling that the ticket may need to be combined with another ticket. The `XS` label is retained (under 1 hour is allowed).
- **Remove the `XXL` label.** The effort label vocabulary is reduced to 5 labels: `XS` (under 1 hour), `S` (1 hour), `M` (2-3 hours), `L` (3-4 hours), `XL` (1 working day). The `XXL` label is removed. The "Step 6 must split" rule for tickets that would have been `XXL` remains.
- **Per-ticket `Review complexity`.** Compute `Review complexity` per ticket: a ticket is `High` if its own `blocked-by` chain crosses a domain boundary, else `Low`. A one-line override is permitted (`override: <reason>`).

Apply the changes to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Add the XS ticket-bloat warning

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 10 of both sub-workflows, add a sentence to the Estimated effort paragraph: any ticket labeled `XS` surfaces a ticket-bloat warning in the summary, signaling that the ticket may need to be combined with another ticket.
- Confirm the existing guidance ("under 1 hour is allowed but indicates the ticket is too thin") is preserved.

Verify: Both Step 10 copies contain the XS bloat-warning sentence; the `XS` label remains in the vocabulary.

### Step 2 - Remove the XXL label

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 10 of both sub-workflows, remove the `XXL` entry from the effort label vocabulary.
- Confirm the "Step 6 must split" rule for tickets that would have been `XXL` is preserved (the rule text rephrases as "tickets shall not be published if their effort is beyond `XL`; Step 6 must split the work first").

Verify: Both Step 10 copies list exactly five effort labels (`XS`, `S`, `M`, `L`, `XL`); no `XXL` entry remains; the Step 6 must-split rule is preserved.

### Step 3 - Compute Review complexity per-ticket

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 10 of both sub-workflows, replace the Review complexity rule with a per-ticket computation: a ticket is `High` if its own `blocked-by` chain crosses a domain boundary, else `Low`.
- Add a one-line override note: `override: <reason>` is permitted.

Verify: Both Step 10 copies contain the per-ticket rule and the override note; no aggregate or "team-wide" complexity rule remains.

### Step 4 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Add a bullet that the effort label vocabulary is exactly `XS`, `S`, `M`, `L`, `XL` (per step 2).
- Add a bullet that any `XS` ticket surfaces a bloat warning in the summary (per step 1).
- Add a bullet that `Review complexity` is computed per-ticket from the ticket's own `blocked-by` chain (per step 3).

Verify: All three new Validation bullets are present.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 10 in both sub-workflows, plus the Validation list).
**ADRs** - None.
**Domain terms** - `Leaf Ticket` (relevant for the per-ticket `blocked-by` chain computation; a leaf has no blockers and therefore trivially `Low` complexity).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D012` (XS bloat warning), `DECISIONS-skills-spec-to-tickets-review.md#D013` (XXL removed), `DECISIONS-skills-spec-to-tickets-review.md#D014` (per-ticket review complexity).

## Acceptance criteria

- [ ] Both Step 10 copies surface a ticket-bloat warning for any `XS` ticket.
- [ ] Both Step 10 copies list exactly five effort labels (`XS`, `S`, `M`, `L`, `XL`); no `XXL` entry.
- [ ] Both Step 10 copies contain the per-ticket `Review complexity` rule with the override note.
- [ ] The Step 6 must-split rule for tickets that exceed `XL` is preserved in both sub-workflows.
- [ ] The Validation list gains three new bullets corresponding to the three rule changes.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 10 edits apply to both sub-workflows created by ticket 001).
