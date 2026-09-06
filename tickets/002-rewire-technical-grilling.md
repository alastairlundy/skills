---
title: Rewire technical-grilling into a self-contained single skill
classification: Independent
blocked_by: [001-port-grilling-references]
parent: Conversation context (2026-09-06) - Decomposing the grilling consolidation Decision Ledger (docs/decisions/DECISIONS-skills-grilling-consolidation.md) - make technical-grilling self-contained and delete the generic grilling skill. Resolved approach - port the parent reference set and eval script into technical-grilling, sweep live docs of grilling references, and record the consolidation in a standalone ADR.
---

# 002 - Rewire technical-grilling into a self-contained single skill

## Goal

Make the skill claim its own territory. `SKILL.md` and the local references point only at local files, all parent/child lineage language is gone, and the YAML description and When-Not-to-Use state the technical boundary positively with no negation clauses.

## What to build

Edit 7 files in `skills/engineering/technical-grilling/`:

**`SKILL.md`**

- YAML description - positive-only claim of the technical territory; drop the "Defer to `grilling` for non-technical decisions" clause and every other negation clause about non-technical decisions (D009). Name no replacement skill (D002).
- H1 - retitle to the standalone skill name (currently `# Technical \`grilling\``, which frames a parent).
- Body - remove "specializes `grilling`", the "carried over from the former `domain-grilling` / `code-implementation-grilling`" narrative (that history moves to the consolidation ADR - see 006-write-consolidation-adr), the "core `grilling` machinery owned by the `grilling` skill" passage, and both "Parent `grilling` references" sections.
- Rewire every parent-step citation ("`grilling` Step 1.0", "`grilling` Step 4.0a", "per `grilling` Step 3") to this skill's own steps.
- When-Not-to-Use - remove the "use `grilling` instead" bullet without adding a replacement pointer; reword the "(no grilling needed)" phrasings so no bullet names the deleted skill (D002, D010).

**Local references still pointing at the parent** - rewire `../grilling/references/` paths to local paths and reword "parent grilling skill's" to "this skill's":

- `references/interface-and-model-branch.md` (lines ~92, 164)
- `references/validation.md` (lines ~6, 23, 73 - including the "All six `grilling` reference files" wording)
- `references/ddd-initialization.md` (lines ~26, 77)
- `references/recording-decisions.md` (lines ~26, 35, 39, 53)
- `references/term-resolution.md` (line ~46)
- `references/output-selection.md` (lines ~29, 104)

The over-trigger boundary stays enforced empirically by the existing no-trigger eval tasks (business-pricing, vague-plan, non-code-idea) - do not touch `evals/` in this ticket (D009).

## Size

- **Files** - 7 (all edited)

## Recommended Workflow

### Step 1 - Rewrite the YAML description and When-Not-to-Use

Where: `skills/engineering/technical-grilling/SKILL.md`

- Replace the description with a positive-only claim of technical and code-related decision elicitation; remove every negation clause about non-technical decisions.
- Remove the "use `grilling` instead" bullet; reword the remaining "(no grilling needed)" bullets.

Verify: YAML description and When-Not-to-Use contain no grilling skill pointer and no "Do not use for non-technical" clause.

### Step 2 - Rewire the SKILL.md body

Where: `skills/engineering/technical-grilling/SKILL.md`

- Point every reference at local `references/` files; convert parent-step citations to this skill's steps; delete the parent-reference sections and the lineage narrative; retitle the H1.

Verify: no `../grilling/` path, "parent", "specializes", or "carried over" phrasing remains in `SKILL.md`.

### Step 3 - Rewire the local references

Where: the 6 reference files listed in What to build

- Replace `../grilling/references/` paths with local paths; reword "parent grilling skill's" to "this skill's"; update `validation.md`'s reference-set wording to the local set.

Verify: a search for `../grilling` under `skills/engineering/technical-grilling/` returns no matches.

### Step 4 - Lineage scrub

Where: `skills/engineering/technical-grilling/`

- Search for lineage phrasing (child of, specializes, parent, merges with, carried over from).

Verify: zero matches; the skill reads as a standalone single skill.

## Context pointers

##### Files

- `skills/engineering/technical-grilling/SKILL.md` - primary rewrite target
- The 6 local reference files listed in What to build
- `skills/engineering/grilling/references/` - content source already ported by 001-port-grilling-references

##### ADRs

- `docs/adr/0002-trigger-discipline-for-grilling-skills.md` - YAML-craft lessons (positive claims beat negations) that shape the description rewrite.

##### Domain terms

- **evaluative opener**, **acknowledgement opener** - rules the SKILL states; keep them intact while rewiring.
- **load trigger** - keep reference load-trigger sentences intact.
- **in-session signal** - convergence behaviour described by the skill; preserve its wording intent.

##### Ledger records

- `DECISIONS-skills-grilling-consolidation.md#D001` - self-containment goal.
- `DECISIONS-skills-grilling-consolidation.md#D002` - technical-only boundary; no replacement pointer.
- `DECISIONS-skills-grilling-consolidation.md#D003` - no `../grilling/references/` path remains.
- `DECISIONS-skills-grilling-consolidation.md#D009` - positive-only wording.
- `DECISIONS-skills-grilling-consolidation.md#D010` - lineage erased from live docs.

## Acceptance criteria

- [ ] YAML description states coverage positively with no negation clause about non-technical decisions and names no replacement skill (D009, D002).
- [ ] When-Not-to-Use contains no grilling pointer (D002).
- [ ] `SKILL.md` references only local `references/` files; no `../grilling/references/` path remains anywhere under `skills/engineering/technical-grilling/` (D003).
- [ ] No live sentence in the skill describes technical-grilling as specializing in, parenting from, or merging with grilling (D010).
- [ ] The `evals/` directory is untouched by this ticket; the no-trigger tasks remain the empirical boundary (D009).

## Dependencies

**Blocked by** - 001-port-grilling-references (the local reference files must exist before paths point at them)
