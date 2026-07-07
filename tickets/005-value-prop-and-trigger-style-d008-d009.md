---
title: Distribute value proposition and apply Use when / Do not use when style
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Teach `skill-architect` to treat the value proposition as a design input and distribute it across three output fields of the designed skill — description (what & why), When to Use, When Not to Use — and apply the "Use when / Do not use when" trigger style to `skill-architect`'s own frontmatter description.

## What to build

Implements two decisions from the ledger:

- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008` Issue 14 — keep the value proposition in Step 1's intake; distribute it across three output fields of the designed skill — (a) the description (a concise "what & why" statement), (b) the When to Use section (scenarios where the skill is valuable), (c) the When Not to Use section (scenarios where it is not). The value prop is a *design input* that shapes the description and the trigger-shape sections.
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D009` — replace `skill-architect`'s own frontmatter description phrase "Use for creating or designing a new skill. Do not use for making minor tweaks to existing skills." with "Use when creating or designing a new skill. Do not use when making minor tweaks to existing skills." (or "Don't use when").

The description may approach the 500-character hard limit (per ticket 004 / D004) when the value prop is woven in. The implementer should be aware that longer "what & why" descriptions will be a normal outcome of the new pattern, not a regression.

This ticket does NOT require `skill-architect` to retroactively redesign itself using the new pattern. The change is to `skill-architect`'s *instructions* — what it collects in Step 1 and how it organizes output in Step 4. Whether `skill-architect` itself eventually gets a richer value-prop-styled description is a separate follow-up.

## Recommended Workflow

### Step 1 — Update `skill-architect`'s own frontmatter description

Where: `skills/skills-meta/skill-architect/SKILL.md` (frontmatter description, current line 4)

- Change the trigger-style phrase from "Use for creating or designing a new skill. Do not use for making minor tweaks to existing skills." to "Use when creating or designing a new skill. Do not use when making minor tweaks to existing skills." (or "Don't use when" — pick one and apply consistently).
- This is a one-line change to the description field; no other frontmatter field changes.

Verify: The frontmatter description contains the new "Use when" / "Do not use when" phrasing; the old "Use for" phrasing is no longer present.

### Step 2 — Clarify the value prop's role in Step 1

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 1 "Intent Intake", current lines 33–41)

- The current line 39 already mentions the value proposition: "A fifth element, the **value proposition**, shall be inferred by the agent from the goal and audience; the agent shall ask the user about it only if the inference is unclear or ambiguous."
- Strengthen the wording so the value prop is explicitly framed as a design input, not just an inferred element. New wording: "A fifth element, the **value proposition**, shall be inferred by the agent from the goal and audience. The value prop is a design input that shapes the description, the When to Use scenarios, and the When Not to Use scenarios of the designed skill. The agent shall ask the user about it only if the inference is unclear or ambiguous."
- Do not change the other four elements (goal, target audience, trigger context, example OR shape description) — those are covered by other tickets (003 covers the example/shape-description change for element d).

Verify: Step 1's value-prop element is explicitly framed as a design input that shapes three downstream fields; the rest of Step 1 is unchanged.

### Step 3 — Add value-prop distribution to Step 4

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 4 "Compliance Mapping", current lines 59–64)

- Add a new bullet to Step 4 that explicitly distributes the value prop across three output fields of the designed skill: "**Value Proposition Distribution**: Take the value prop collected in Step 1 and weave it across the three output fields — (a) the `description` frontmatter field (a concise 'what & why' statement), (b) the When to Use section (scenarios where the skill is valuable), and (c) the When Not to Use section (scenarios where the skill is not)."
- Place this bullet alongside the existing schema bullets (Frontmatter, When to Use, When Not to Use, Workflow, Validation) so the implementer reading Step 4 sees the distribution rule in the same context as the schema it operates on.
- Note that the description may approach the 500-character hard limit (per ticket 004 / D004) when the value prop is woven in — this is expected, not a regression. A one-line parenthetical suffices.

Verify: Step 4 contains a "Value Proposition Distribution" bullet that names the three output fields (description, When to Use, When Not to Use) and references the 500-character description limit as a known consequence.

## Context pointers

**Files**:
- `skills/skills-meta/skill-architect/SKILL.md` — the meta-skill being updated (frontmatter description, Step 1 value-prop element, Step 4 schema distribution)

**ADRs**: None.

**Domain terms**:
- **Vertical Slice (Tracer Bullet)** — the value-prop distribution is a cross-cutting rule that touches three of the five mandatory sections (description-equivalent, When to Use, When Not to Use). It is not a section of its own; it is a distribution rule applied at Step 4.

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008` Issue 14 — value prop is a design input distributed across the description, When to Use, and When Not to Use sections
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D009` — replace "Use for" with "Use when" in the description

## Acceptance criteria

- [ ] `skill-architect`'s frontmatter description uses the "Use when" / "Do not use when" trigger style; the old "Use for" phrasing is removed.
- [ ] Step 1's value-prop element is explicitly framed as a design input that shapes the description, When to Use, and When Not to Use sections of the designed skill.
- [ ] Step 4 contains a "Value Proposition Distribution" bullet that names the three output fields and notes the 500-character description-limit consequence.
- [ ] `skill-architect`'s own When to Use and When Not to Use sections are unchanged — the distribution rule applies to skills `skill-architect` designs, not to `skill-architect` itself.

## Dependencies

**Blocked by**: None — can start immediately.
