---
title: Replace vague verifiability with measurable proxies and add character limits
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Make the verifiability rules in `skill-architect` measurable and project-local. Replace vague terms ("verifiable outcome", "concise") with named completion signals and concrete character limits, and tighten the boundary between per-step verifiability (Determinism Audit) and per-validation-item verifiability (Validation Utility) so the two checks do not overlap.

## What to build

Implements `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D004` (issues 5, 8, 16):

- **Issue 5** (Determinism Audit): replace "verifiable outcome" with a measurable proxy. The step must name a specific completion signal — a returned value, a check, a state change, a file produced, or an equivalent. The Determinism Audit bullet now requires each step's completion criterion to reference one of these proxies by name.
- **Issue 8** (Step 4 character limits): replace "concise" with measurable character limits per the skill specification — name ≤ 50 characters (hard), description ≤ 500 characters (hard), description < 350 characters (soft target, not a hard requirement). These limits are project-local (tighter than the Waza eval convention of description ≤ 1024 characters).
- **Issue 16** (Validation Utility): separate per-step verifiability (Determinism Audit) from per-validation-item verifiability (Validation Utility); tighten wording so the two checks do not overlap on verifiability scope. The Determinism Audit checks that each workflow step names a completion signal; the Validation Utility checks that each item in the generated Validation section is itself a yes/no pass/fail condition.

The proxy design for issue 5 lives in `references/skill-standards.md`; the saving procedure (where the character limits are also enforced at write time) lives in `references/saving-the-skill.md`. This ticket updates the SKILL.md wording and adds concrete examples of completion-signal proxies in the reference doc.

## Recommended Workflow

### Step 1 — Replace "verifiable outcome" in the Determinism Audit

Where: `skills/skills-meta/skill-architect/SKILL.md` (Validation → Determinism Audit, current line 87)

- Change the bullet from "Every workflow step must (a) start with a verb, (b) name a concrete action, and (c) end with a verifiable outcome" to one that names a measurable proxy.
- New wording: "Every workflow step must (a) start with a verb, (b) name a concrete action, and (c) end with a specific completion signal — for example, a returned value, a check result, a state change, a file produced, or an equivalent named artefact. If a step fails any of (a)–(c), rewrite it."
- The set of named proxies ("returned value, check, state change, file produced, or equivalent") is the measurable definition of "verifiable outcome" and replaces the vague term in the Validation bullet.

Verify: The Determinism Audit bullet names at least 3 example completion-signal proxies and uses one of them (or "equivalent") in place of "verifiable outcome".

### Step 2 — Replace "concise" with character limits in Step 4

Where: `skills/skills-meta/skill-architect/SKILL.md` (Step 4 "Compliance Mapping", current line 60)

- Change "Generate a concise `name` and `description`" to one that states the measurable character limits.
- New wording: "Generate a `name` (≤ 50 characters, hard limit) and a `description` (≤ 500 characters hard limit; < 350 characters is a soft target). Use `>-` block-fold syntax for the description."
- The character limits are project-local — they are tighter than the Waza eval convention (description ≤ 1024 characters). Note this in the bullet so future implementers know the source of the limit.

Verify: The Step 4 Frontmatter bullet names the 50 / 500 / 350 character limits in numbers, marks 50 and 500 as hard and 350 as a soft target, and notes the project-local source.

### Step 3 — Tighten the Validation Utility boundary

Where: `skills/skills-meta/skill-architect/SKILL.md` (Validation → Validation Utility, current line 90)

- The current bullet is "Does every item in the generated Validation section name a specific pass/fail condition (yes/no) that an agent can determine from the design alone?"
- Issue 16 says the boundary between the Determinism Audit (per-step verifiability) and the Validation Utility (per-validation-item verifiability) must be tightened so the two checks do not overlap on verifiability scope.
- Tighten the bullet so it explicitly scopes itself to per-validation-item verifiability and references the Determinism Audit as the per-step scope owner. New wording: "Does every item in the generated Validation section name a specific pass/fail condition (yes/no) that an agent can determine from the design alone? This check covers per-validation-item verifiability only; per-step verifiability is the scope of the Determinism Audit above."
- Do not change the Determinism Audit's scope (per-step) — only the Validation Utility's wording to make the boundary explicit.

Verify: The Validation Utility bullet explicitly names its scope as "per-validation-item verifiability" and references the Determinism Audit as the per-step scope owner, so the two checks have non-overlapping scopes.

### Step 4 — Add completion-signal proxy examples to the reference doc

Where: `skills/skills-meta/skill-architect/references/skill-standards.md`

- Add a short subsection (or augment an existing one) listing the named completion-signal proxies the Determinism Audit now requires — at minimum: returned value, check result, state change, file produced, plus a one-line example of each.
- The examples are reference material that future skill authors and reviewers can consult when writing a workflow step; they are not a closed list ("or equivalent" is allowed).
- Reference this subsection from the Determinism Audit bullet (or from the load-trigger sentence in `SKILL.md` Step 4) so the implementer loads the reference when needed.

Verify: `references/skill-standards.md` has a subsection that names at least 3 completion-signal proxies with one-line examples, and the Determinism Audit bullet (or the Step 4 load-trigger sentence) references the new subsection.

## Context pointers

**Files**:
- `skills/skills-meta/skill-architect/SKILL.md` — the meta-skill being updated (Step 4 Frontmatter bullet, Validation → Determinism Audit, Validation → Validation Utility)
- `skills/skills-meta/skill-architect/references/skill-standards.md` — the reference doc that gets the completion-signal proxy examples

**ADRs**: None.

**Domain terms**:
- **Pass/Fail Gate** — the Determinism Audit and the Validation Utility are both verification steps that produce binary pass/fail signals. Issue 16 separates them by scope: Determinism Audit is per-step; Validation Utility is per-validation-item. A step that passes the Determinism Audit may still fail a per-validation-item check (and vice versa), so the two gates are independent.

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D004` — Issue 5 (measurable completion-signal proxy), Issue 8 (name ≤ 50 / description ≤ 500 hard, < 350 soft), Issue 16 (separate per-step vs per-validation-item verifiability)

## Acceptance criteria

- [ ] The Validation → Determinism Audit bullet names at least 3 example completion-signal proxies (returned value, check, state change, file produced, or equivalent) in place of "verifiable outcome".
- [ ] Step 4's Frontmatter bullet states the 50 / 500 / 350 character limits in numbers, marks 50 and 500 as hard and 350 as a soft target.
- [ ] The Validation → Validation Utility bullet explicitly scopes itself to "per-validation-item verifiability" and references the Determinism Audit as the per-step scope owner.
- [ ] `references/skill-standards.md` has a subsection listing completion-signal proxies with examples; the SKILL.md references it from a load-trigger sentence.
- [ ] No occurrence of "verifiable outcome" or "concise" remains in the relevant SKILL.md bullets.

## Dependencies

**Blocked by**: None — can start immediately.
