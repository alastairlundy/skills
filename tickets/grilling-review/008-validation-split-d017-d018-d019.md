---
title: Split Validation into Pre-conditions and Output Checks with verbatim and no-batch gates
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-review.md
---

## Goal

Align the Validation list with the strictness of the workflow's format rule, split run-level checks from content-level checks, and make the "no batching" rule a hard gate verified in the transcript.

## What to build

Three changes to the Validation section of `skills/engineering/grilling/SKILL.md`:

1. **D019 — Split Validation into Pre-conditions and Output Checks**:
   - **Pre-conditions** (run-level checks): references loaded, abort-on-missing, ledger path confirmed.
   - **Output checks** (content-level checks): everything else.
   - Move the locked-question format string `For [Dxxx] – [branch name]: pick an option, or provide your answer.` from the Validation list into the body of Step 3, so the check verifies the SKILL.md contains the format string, not the resolved output.

2. **D017 — Add a verbatim check**: new output check: "Every record's field headers matched the reference template verbatim (`Resolved Answer` / `Normalized Requirement` / `Constraints`)." Aligns the strict rule (line 68: "Apply the formats ... verbatim throughout the session. Do not paraphrase, abbreviate, or modify the formats.") with the check, which previously verified only field presence.

3. **D018 — Make no-batch a hard gate**: mark the existing "One Decision Ledger record was appended immediately after every resolved branch (no batching at session end)" item as a must-pass check, with an instruction to verify in the transcript.

The banned-words list remains in Validation only (D011, no change); the reference `tone-and-output.md` is the source of truth, loaded in Step 1.

## Recommended Workflow

### Step 1 — Move the locked-question format string into Step 3

Where: `skills/engineering/grilling/SKILL.md` Step 3

- Inline the format string `For [Dxxx] – [branch name]: pick an option, or provide your answer.` directly into Step 3's body, alongside the reference to `references/locked-question-format.md`.
- Remove the format string from the Validation list.

Verify: The format string appears in Step 3 body, not in the Validation list.

### Step 2 — Split Validation into Pre-conditions and Output Checks

Where: `skills/engineering/grilling/SKILL.md` Validation section

- Add H3 "Pre-conditions" subsection containing the run-level checks (refs loaded, abort-on-missing, ledger path confirmed).
- Add H3 "Output checks" subsection containing the content-level checks (everything else).
- The pre-conditions run at session start; the output checks run after the workflow completes. Both must pass for the session to be valid.

Verify: The Validation section has two H3 subsections.

### Step 3 — Add the verbatim field-header check

Where: `skills/engineering/grilling/SKILL.md` Validation > Output checks

- Add a new item: "Every record's field headers matched the reference template verbatim (`Resolved Answer` / `Normalized Requirement` / `Constraints`)."

Verify: The new check appears under Output checks.

### Step 4 — Mark the no-batch item as a must-pass gate

Where: `skills/engineering/grilling/SKILL.md` Validation > Output checks

- Edit the existing "One Decision Ledger record was appended immediately after every resolved branch (no batching at session end)" item to be marked "Must pass — verify in transcript".
- Add a verify-in-transcript note: "Inspect the transcript for write-time evidence: a successful append must be visible between the user's resolution of one branch and the agent's first question of the next."

Verify: The no-batch item is marked as a hard gate with the verify-in-transcript instruction.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — Step 3 and Validation section
- `skills/engineering/grilling/references/decision-ledger.md` — the field-header template
- `skills/engineering/grilling/references/tone-and-output.md` — the source of truth for the banned-words list

**ADRs**: None.

**Domain terms**:
- Pre-condition — a run-level check that must pass before the workflow proceeds
- Output check — a content-level check that verifies the resolved output
- Hard gate — a check that produces a binary pass/fail signal based on mechanical criteria
- Banned-words list — the list of forbidden filler words in `references/tone-and-output.md`

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-review.md#D017` — verbatim field-header check
- `docs/decisions/DECISIONS-skills-grilling-review.md#D018` — no-batch hard gate
- `docs/decisions/DECISIONS-skills-grilling-review.md#D019` — split into Pre-conditions and Output Checks
- `docs/decisions/DECISIONS-skills-grilling-review.md#D011` — banned-words list stays in Validation only (no change; cited for context)

## Acceptance criteria

- [ ] Validation section is split into H3 "Pre-conditions" and H3 "Output checks" subsections.
- [ ] The locked-question format string is moved into Step 3's body, removed from the Validation list.
- [ ] A new output check verifies verbatim field headers (`Resolved Answer` / `Normalized Requirement` / `Constraints`).
- [ ] The no-batch item is marked "Must pass — verify in transcript" with a write-time-evidence instruction.
- [ ] The banned-words list remains in Validation only; `references/tone-and-output.md` is the source of truth.

## Dependencies

**Blocked by**: None — can start immediately.
