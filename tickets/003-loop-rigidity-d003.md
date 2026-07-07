---
title: Add re-open check, soften example gate, and document interactive-only stance
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Tighten the loop in `skill-architect` so the final convergence step is a check (not a statement) and the intake gate accepts a description of the desired output's shape in addition to a concrete example — without broadening the gate to anti-examples and without introducing a 4th "Pivot" value to the 3-value review protocol.

## What to build

Implements `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D003` (issues 3, 4, 9, 12):

- **Issue 9** (Step 5 final statement): replace the verbatim declaration *"We have a deterministic skill design."* with a check question (e.g., *"Have we reached a deterministic design?"*) followed by an explicit re-open rule. If the user answers "no" or equivalent, the workflow re-opens the appropriate earlier step (typically Step 3 or Step 4) and continues.
- **Issue 4** (Step 1 example gate): soften the gate so it accepts "the user provides a concrete example **OR a description of the desired output's shape**". An anti-example is NOT a substitute — this is the user's explicit narrowing of the proposal (the original review suggested anti-examples also satisfy the gate; that is rejected).
- **Issue 3** (Step 3 3-value protocol): keep the verbatim Accept AS IS / Requires Modifications / Reject protocol as-is. A Pivot is handled via the existing Reject branch (which restarts the design), NOT as a 4th verbatim value. This is intentional design — no change required.
- **Issue 12** (autonomous mode): DEFERRED. The loop is interactive-only by default; a future use case may re-open it. No documentation change required for this ticket.

## Recommended Workflow

### Step 1 — Soften the Step 1 example gate

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 1 "Intent Intake", current lines 33–41)

- Locate element (d) and its completion criterion — currently "one concrete example of the desired behaviour" with "if the user cannot produce a concrete example, the workflow does not advance to Step 2."
- Change element (d) to accept EITHER a concrete example OR a description of the desired output's shape. Update the completion criterion to reflect both acceptable forms (e.g., "all four explicit elements are captured; the workflow advances only when the user has provided an example or a description of the desired output's shape").
- Add an explicit "anti-example is not a substitute" note (a single sentence) so future implementers don't broaden the gate further.

Verify: Reading Step 1, element (d) and its completion criterion both reference the two acceptable forms (example OR shape description), and the anti-example exclusion is stated.

### Step 2 — Replace the Step 5 final statement with a check and re-open rule

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 5 "Final Review & Convergence", current line 72)

- Locate the final sentence: *"Once verified against the validation criteria, declare: 'We have a deterministic skill design.'"*
- Replace the verbatim declaration with a check question: *"Have we reached a deterministic design?"*
- Add an explicit re-open rule immediately after the check: if the user answers "no" (or equivalent), the workflow re-opens the appropriate earlier step (typically Step 3 for a translation issue, Step 4 for a schema/compliance issue, or Step 2 for a domain-analysis issue). The re-open rule should be one paragraph at most — it does not need to enumerate every possible cause, just establish that "no" triggers a re-open and identify the canonical re-entry points.
- Remove the previous verbatim declaration language entirely. Do not leave both the declaration and the check in the file.

Verify: Step 5's final paragraph contains the check question and the re-open rule, and the old "We have a deterministic skill design" declaration is no longer present in the file.

### Step 3 — Verify no other loops were changed

Where: `skills/skills-meta/skill-architect/SKILL.md`

- Confirm Step 3's verbatim 3-value protocol (Accept AS IS / Requires Modifications / Reject) is unchanged at current line 50. The Reject branch's existing restart/exit choice at line 53 remains the canonical Pivot path.
- Confirm no new "Pivot" value or branch was added.

Verify: Grep for "Accept AS IS", "Requires Modifications", "Reject", and "Pivot" in the file — the first three appear once each in the protocol, "Pivot" does not appear as a 4th value.

## Context pointers

**Files**:
- `skills/skills-meta/skill-architect/SKILL.md` — the meta-skill being updated (Step 1 example gate, Step 5 final statement)

**ADRs**: None.

**Domain terms**:
- **Pass/Fail Gate** — the check introduced in Step 5 is a verification step that produces a binary pass/fail signal. The "Have we reached a deterministic design?" check is the user's confirmation; it is the macro-level gate for the workflow, distinct from the per-step micro-verifications in the Recommended Workflow sections of tickets.

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D003` — Issue 9 (re-open check), Issue 4 (example gate softening), Issue 3 (keep 3-value protocol), Issue 12 (deferred)

## Acceptance criteria

- [ ] Step 1's element (d) and completion criterion both accept "a concrete example OR a description of the desired output's shape"; an anti-example is explicitly excluded.
- [ ] Step 5's final statement is a check question ("Have we reached a deterministic design?" or equivalent) followed by an explicit re-open rule identifying the canonical re-entry points (typically Step 2, Step 3, or Step 4).
- [ ] The old declaration "We have a deterministic skill design" is removed (not present alongside the new check).
- [ ] Step 3's 3-value protocol (Accept AS IS / Requires Modifications / Reject) is unchanged; no 4th "Pivot" value was added.
- [ ] No documentation change is made for Issue 12 (autonomous mode remains deferred; the loop is interactive-only by default).

## Dependencies

**Blocked by**: None — can start immediately.
