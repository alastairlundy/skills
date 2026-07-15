---
title: Redesign parent grilling per-branch format (3-turn to 2-turn collapse)
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Collapse the 3-turn per-branch sequence to 2 turns in `skills/engineering/grilling/SKILL.md` Step 4 and `skills/engineering/grilling/references/locked-question-format.md`. Turn 1 emits the context block plus the optional Socratic question; Turn 2 emits the locked question line, the reference-set preamble, the options block, and the recommendation together. Wire the engage-case (soft steering signal) and decline-case (default behavior) sub-rules per the Decision Ledger.

## What to build

Two coordinated edits — one in the parent SKILL.md, one in the parent reference file — that restructure the per-branch sequence from 3 turns to 2 turns while preserving every other aspect of the skill.

In `skills/engineering/grilling/SKILL.md` Step 4 (Open Branch A) around lines 170 to 242:

- Replace the existing 3-turn description with a 2-turn description.
  - **Turn 1 (new)** — the context block (the 4 elements Goal, Prior decisions, Stakes, Scope, preserved verbatim and in order) plus the optional Socratic elicitation question. Use the D003 verbatim wording: "What are you working toward in this decision? You may answer, or skip and see the options as-is." Add an explicit instruction that the Socratic question is optional — the user may engage to steer the options or decline (signals: "skip", "no", "as-is", or a no-op response) and the agent shall proceed to Turn 2 without re-asking.
  - **Turn 2 (new)** — the locked question line, the reference-set preamble, the options block, and the recommendation, all in a single turn. Use the D004 verbatim wording for the locked question line: "**For [Dxxx] – [branch name]: pick an option, hybridize, or provide your own answer.**" Add an explicit instruction that all three response types (pick an option, hybridize, provide your own answer) are equally valid; the agent must not default to a closed-ended "pick one" framing.
- Update the "three turns are mandatory" framing to "two turns are mandatory" (or equivalent).
- Update the re-ask rule: a re-ask restarts at the new Turn 1 (context plus optional Socratic), then proceeds to Turn 2. The agent must not skip the context block or the optional Socratic question on a re-ask, and must not collapse the two parts into a single turn.
- Update the worked example in the SKILL.md body, if present, to reflect the 2-turn sequence.

In `skills/engineering/grilling/references/locked-question-format.md` (full file):

- Update Part 2 (Socratic elicitation question) to use the D003 verbatim wording.
- Add an explicit instruction under Part 2 that the Socratic question is optional; the agent recognizes decline signals ("skip", "no", "as-is", or no-op) and proceeds to Part 4 without re-asking or extracting direction.
- Update Part 3 (Locked question line) to use the D004 verbatim wording.
- Add an explicit instruction under Part 3 that all three response types are equally valid.
- Add a "Behavior when the user engages" subsection per D005 — when the user provides a direction rather than declining, the agent uses the direction as a steering signal to inform the option names, the "What it is" descriptions, and the recommendation's `Reasoning` field. State explicitly that the reframing is a soft signal across all options, not a filter, and that defensible options are not dropped.
- Add a "Behavior when the user declines" subsection per D013 — when the user declines, the options are framed on the branch context (Goal, Prior decisions, Stakes, Scope) without steering; the recommendation's `Reasoning` field is based on the branch context, not on a direction. The agent shall not try to extract direction from a "skip" response.
- Update the worked example (around lines 138 to 175) to reflect the 2-turn sequence; collapse the three `<user answers>` placeholders to two.
- Update the "Rules" section to reflect the 2-turn structure (the "Place the context block, Socratic question, and locked question line on their own lines" rule and the "One question per turn" rule need re-statement for 2 turns).

What to preserve (explicit non-goals):

- 4-element context block (Goal, Prior decisions, Stakes, Scope) format and order.
- Reference-set preamble (the fixed phrase: "Here are options to help you refine or confirm your answer. Pick one, reject all, or hybridize.").
- Options 4-field format (What it is, Benefit, Cost, Risk).
- Recommendation 3-field format (Recommendation, Reasoning, Forward risk).
- Decision Ledger pattern, including the Dxxx template with Driver field.
- Tone discipline (no evaluative openers, neutral mirroring).
- Convergence test (4 checks).
- Post-pick step (one-sentence confirmation, reminder, tool call to append, read-back verification, transition).
- Goal discovery (Step 3) and its separation from the first branch.
- The "you" convention in templates (refers to the user, not the LLM).

## Recommended Workflow

### Step 1 — Audit the current 3-turn sequence in the parent skill

Where: `skills/engineering/grilling/SKILL.md` lines 170-242, `skills/engineering/grilling/references/locked-question-format.md` (full file)

- Read both files end-to-end.
- Identify all explicit 3-turn references (for example, "Turn 1", "Turn 2", "Turn 3", "three turns", "three separate agent turns").
- Note the locations of: the Socratic elicitation question, the locked question line, the reference-set preamble, the worked example, the Rules section.
- Note any cross-references in other reference files (`options-format.md`, `recommendation-format.md`, `decision-ledger.md`, `tone-and-output.md`, `convergence-test.md`) that mention the 3-turn sequence.

Verify: A list of 3-turn references in both files, with line numbers and cross-references in other reference files.

### Step 2 — Update parent SKILL.md Step 4 to the 2-turn sequence

Where: `skills/engineering/grilling/SKILL.md` lines 170-242

- Replace the existing "Turn 1" with the new Turn 1: the 4-element context block plus the D003 Socratic wording plus the explicit "this question is optional; the user may engage or decline" instruction.
- Replace the existing "Turn 2" and "Turn 3" with the new Turn 2: the D004 locked question line, the reference-set preamble, the options block, and the recommendation — all in one turn.
- Update the "three turns are mandatory" framing to "two turns are mandatory" (or equivalent wording that retains the "stop and wait" semantics).
- Update the re-ask rule: a re-ask restarts at the new Turn 1, not at the locked question line.
- Update the worked example in the SKILL.md body, if present, to reflect the 2-turn sequence.

Verify: A search for "Turn 1" and "Turn 2" and "Turn 3" in the file shows two turns; the locked question line uses the D004 wording; the Socratic question uses the D003 wording; the optional-Socratic and equally-valid-response-types instructions are present.

### Step 3 — Update references/locked-question-format.md for the 2-turn sequence

Where: `skills/engineering/grilling/references/locked-question-format.md` (full file)

- Update Part 2 (Socratic elicitation question) to the D003 verbatim wording.
- Add an instruction that the Socratic question is optional and that the agent recognizes decline signals.
- Update Part 3 (Locked question line) to the D004 verbatim wording.
- Add an instruction that all three response types are equally valid.
- Add a "Behavior when the user engages" subsection per D005.
- Add a "Behavior when the user declines" subsection per D013.
- Update the worked example to reflect the 2-turn sequence.
- Update the "Rules" section to reflect the 2-turn structure.

Verify: The reference file's parts use the D003 and D004 verbatim wordings; the engage and decline subsections are present; the worked example uses 2 turns; the Rules section is consistent with 2 turns.

### Step 4 — Update the parent's validation checklist for the 2-turn sequence

Where: `skills/engineering/grilling/SKILL.md` Validation list (around lines 366 to 473)

- Update the branch-question check (currently around lines 407 to 417) to verify 2 turns: context block plus Socratic elicitation turn, then locked question plus options plus recommendation turn.
- Update the locked question line check to verify the D004 wording.
- Update the Socratic elicitation question check to verify the D003 wording.
- Add a check for the optional Socratic question: the agent recognized the decline signal and proceeded to Turn 2 without re-asking.
- Add a check for the locked question line: all three response types were presented as equally valid.

Verify: The validation list contains the 2-turn check; both wordings are verified; the optional-Socratic and equally-valid-response-types checks are present.

### Step 5 — Confirm no other parent skill files need updates

Where: `skills/engineering/grilling/references/` (full directory)

- Audit `decision-ledger.md`, `options-format.md`, `recommendation-format.md`, `tone-and-output.md`, `convergence-test.md` for any references to "three turns" or "Turn 1 / Turn 2 / Turn 3" that are now stale.
- If any of these files reference the old 3-turn sequence, update the cross-references in their prose to use the 2-turn sequence. The reference files themselves do not change shape; only cross-references in their prose need updating.

Verify: A search for "Turn 1" and "Turn 2" and "Turn 3" across `skills/engineering/grilling/` returns no stale references.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — Step 4 (lines 170-242) and Validation list (lines 366-473) are the primary edit targets
- `skills/engineering/grilling/references/locked-question-format.md` — full file update for the 2-turn sequence, the D003 and D004 wordings, the engage and decline subsections, and the worked example
- `skills/engineering/grilling/references/options-format.md` — read-only; verify the reference-set preamble cross-reference is preserved
- `skills/engineering/grilling/references/recommendation-format.md` — read-only; verify the recommendation format cross-reference is preserved
- `skills/engineering/grilling/references/decision-ledger.md` — read-only; the Dxxx template and post-pick step are unchanged
- `skills/engineering/grilling/references/tone-and-output.md` — read-only; the tone discipline is unchanged
- `skills/engineering/grilling/references/convergence-test.md` — read-only; the convergence test is unchanged

**ADRs**: None.

**Domain terms**:
- Locked question format — the sequence the agent uses to ask a branch question; renamed to 2-turn under D002 (context plus optional Socratic in Turn 1; locked question plus options plus recommendation in Turn 2).
- Socratic elicitation question — the per-branch open-ended question designed to surface the user's values; made optional under D002; new wording under D003.
- Reference-set preamble — the fixed phrase "Here are options to help you refine or confirm your answer. Pick one, reject all, or hybridize." (preserved unchanged).
- 2-turn sequence — the new per-branch structure (per D002).
- Engage case — the user provides a direction; the agent uses it as a soft steering signal across all options (per D005).
- Decline case — the user says "skip" or "no" or "as-is" or no-op; the agent proceeds with the default framing based on the branch context (per D013).

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D002` — the 2-turn collapse structural change
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D003` — the D003 Socratic wording
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D004` — the D004 locked question line wording
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D005` — the engage case (soft steering signal)
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D013` — the decline case (default behavior)

## Acceptance criteria

- [ ] `skills/engineering/grilling/SKILL.md` Step 4 describes a 2-turn sequence (context plus optional Socratic in Turn 1; locked question plus options plus recommendation in Turn 2).
- [ ] The Socratic elicitation question in Step 4 uses the D003 verbatim wording: "What are you working toward in this decision? You may answer, or skip and see the options as-is."
- [ ] The locked question line in Step 4 uses the D004 verbatim wording: "**For [Dxxx] – [branch name]: pick an option, hybridize, or provide your own answer.**"
- [ ] Step 4 includes an explicit instruction that the Socratic question is optional.
- [ ] Step 4 includes an explicit instruction that all three response types (pick, hybridize, provide) are equally valid.
- [ ] The re-ask rule in Step 4 restarts at the new Turn 1 (context plus optional Socratic) and proceeds to Turn 2.
- [ ] `skills/engineering/grilling/references/locked-question-format.md` is updated to reflect the 2-turn sequence, the D003 and D004 wordings, the engage case (D005), the decline case (D013), and the worked example.
- [ ] The parent's validation checklist (in `SKILL.md`) verifies the 2-turn sequence, the D003 and D004 wordings, the optional-Socratic instruction, and the equally-valid-response-types instruction.
- [ ] The 4-element context block, the reference-set preamble, the options format, the recommendation format, the Decision Ledger pattern, the tone discipline, and the convergence test are unchanged.
- [ ] No cross-reference in `skills/engineering/grilling/references/` is left referring to the old 3-turn sequence.

## Dependencies

**Blocked by**: None — can start immediately.
