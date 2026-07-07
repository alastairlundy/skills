---
title: Implement file-creation scope declaration and soft save default
classification: Independent
blocked_by: [001-conditional-sections-d002-d007]
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Replace the strong "MUST NOT use file system modification tools" rule in `skill-architect`'s Output Mode section with a soft default, and rewrite the Step 1 announcement as a two-part opener (a recommended framing sentence plus a mandatory file-creation scope declaration) so the user can opt in to saving the designed skill to disk with any clear indication of intent.

## What to build

Implements `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D005` (issues 6, 11):

- **Issue 6** (Step 1 announcement): the announcement has two parts — (a) an opening sentence announcing the SKILL is being drafted (recommended, can be rephrased or omitted), and (b) a mandatory sentence declaring file-creation scope using the verbatim language "File creation is in scope" or "File creation is out of scope". The opening sentence, if present, must clearly indicate a SKILL is being drafted. The file-creation-scope sentence is mandatory and uses verbatim language.
- **Issue 11** (Output Mode rule): replace "MUST NOT use file system modification tools unless explicitly requested" with a soft default — by default the agent does not save to file, and the user can opt in by indicating they want the file saved (e.g., "save it now", "yes write it", or any clear indication of intent to save). The trigger pattern is broader than "explicit request" — any clear indication of intent to save counts.

The current Step 1 announcement (line 31) already combines both parts into one sentence; the change enforces the (b) verbatim language for the scope declaration. The current Output Mode text (line 26) uses the strong "MUST NOT" wording and the narrower "explicitly requests" trigger; both change to the soft default and the broader opt-in.

## Recommended Workflow

### Step 1 — Rewrite the Step 1 announcement as a two-part opener

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 1 "Intent Intake", current line 31)

- Restructure the announcement clause so it has two clearly separated parts:
  - **Part (a) — opener (recommended, can be rephrased or omitted)**: a sentence announcing the SKILL is being drafted for the stated purpose (e.g., "Drafting the SKILL content for [purpose XYZ].").
  - **Part (b) — scope declaration (mandatory, verbatim)**: a sentence using the exact language "File creation is in scope." or "File creation is out of scope." — no paraphrasing.
- The example phrasing in the current line can be retained as a worked example, but the mandatory verbatim language for part (b) must be called out (e.g., as a quoted string or a "verbatim" note in parentheses).
- The follow-up prompt for opt-in ("Tell me if you want the skill saved to a SKILL file after the design is resolved.") stays; it is the mechanism for capturing the user's clear indication of intent to save.

Verify: The Step 1 announcement is structured as two parts, part (b) uses the exact verbatim language "File creation is in scope" or "File creation is out of scope", and the opt-in prompt is preserved.

### Step 2 — Soften the Output Mode rule to a default-with-opt-in

Where: `skills/skills-meta/skill-architect/SKILL.md` (Output Mode section, current line 26)

- Replace the strong MUST-NOT language ("You MUST NOT use any file system modification tools... unless the user explicitly requests that the skill be written directly to the file system") with a soft default:
  - Default behaviour: the agent does not save the designed skill to disk; the design is presented as markdown text in the conversation.
  - Opt-in trigger: the user can opt in to saving by indicating intent to save with any clear signal — "save it now", "yes write it", or any equivalent. Do not restrict to a narrow "explicit request" pattern.
- Keep the existing "draft the design first, then load `references/saving-the-skill.md`" guidance for when the user opts in — the save procedure reference is unchanged.
- If the Output Mode section has been made conditional by ticket 001, this content is what populates the section when the trigger condition applies. Verify the section heading and trigger condition (added by ticket 001) wrap this content correctly.

Verify: The Output Mode section states a soft default, names the broader opt-in trigger (any clear indication of intent to save), and references `references/saving-the-skill.md` for the save procedure.

### Step 3 — Update the Validation bullet to match the new rule

Where: `skills/skills-meta/skill-architect/SKILL.md` (Validation → Constraint Adherence, current line 89)

- The current bullet checks "Did the agent refrain from using any file-writing tools unless specifically requested by the user to write to the file system? Did the agent announce the output mode at the start of Step 1?"
- Update the first half of the bullet to match the soft default — "Did the agent refrain from saving the design to file by default? If the user indicated intent to save, did the agent follow the save procedure?" — so the check matches the new rule.
- The second half (announce the output mode at the start of Step 1) stays as-is.

Verify: The Constraint Adherence bullet's file-creation check matches the soft default from Step 2, and the output-mode-announcement check is preserved.

## Context pointers

**Files**:
- `skills/skills-meta/skill-architect/SKILL.md` — the meta-skill being updated (Output Mode section, Step 1 announcement, Validation → Constraint Adherence bullet)
- `skills/skills-meta/skill-architect/references/saving-the-skill.md` — the save procedure referenced from the Output Mode section; unchanged by this ticket

**ADRs**: None.

**Domain terms**:
- **Pass/Fail Gate** — the Constraint Adherence bullet is a verification step that produces a binary pass/fail signal. The file-creation check is one half of the bullet; the output-mode announcement check is the other half. Both must pass for the bullet to pass.

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D005` — Issue 6 (two-part Step 1 announcement with mandatory verbatim scope declaration), Issue 11 (soft default with broader opt-in trigger for saving)

## Acceptance criteria

- [ ] Step 1's announcement is structured as two parts: a recommended opener and a mandatory scope declaration.
- [ ] The scope declaration uses the exact verbatim language "File creation is in scope" or "File creation is out of scope".
- [ ] The Output Mode section states a soft default (agent does not save by default) and names a broader opt-in trigger (any clear indication of intent to save, not just a narrow "explicit request").
- [ ] The Output Mode section still references `references/saving-the-skill.md` for the save procedure when the user opts in.
- [ ] The Validation → Constraint Adherence bullet's file-creation check matches the new soft default; the output-mode-announcement check is preserved.
- [ ] No "MUST NOT" language remains in the Output Mode section unless it is part of a clearly bounded sub-rule.

## Dependencies

**Blocked by**: `001-conditional-sections-d002-d007` — ticket 001 establishes the conditional schema; this ticket populates the Output Mode section that 001 makes conditional.
