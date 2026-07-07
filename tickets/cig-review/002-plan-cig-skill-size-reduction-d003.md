---
title: Plan CIG skill size reduction with target line count and candidate blocks
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md
---

## Goal

Produce a follow-up plan that proposes a target line count for `skills/engineering/code-implementation-grilling/SKILL.md` and lists the candidate blocks to promote to `references/`, justified by the AGENTS.md "≥20-line template goes in references/" convention. The triage session shall not modify the skill's size in place; this ticket produces the plan.

## What to build

A plan (deliverable: either a new markdown file at `docs/plans/cig-skill-size-reduction.md` or, if simpler, an inline checklist appended to the Decision Ledger) that contains:

1. **Measured current size** of `skills/engineering/code-implementation-grilling/SKILL.md`: confirm the 467-line count from D003 and break it down by section.

2. **Target line count** with justification: the 100-line figure from D003 is a reviewer proposal, not a commitment. The plan must either:
   - Adopt 100 lines and justify it against the AGENTS.md convention, OR
   - Propose a different target and justify it (for example, by measuring activation cost: tokens consumed per SKILL.md load, with and without the candidate blocks inlined vs. referenced).

3. **Candidate blocks to promote** to `references/`, with measured line counts. Per D003:
   - Step 5: Interface & Model Branch — 78 lines (currently lines 164-242 of SKILL.md)
   - Step 6: Output Selection — 79 lines (currently lines 243-322 of SKILL.md)
   - Terminal Output — 67 lines (currently lines 346-412 of SKILL.md)
   - Validation — 53 lines (currently lines 414-466 of SKILL.md)
   - Recording Technical Decisions to the Ledger — 22 lines (currently lines 100-122 of SKILL.md; borderline; plan must include or exclude with justification)

4. **AGENTS.md convention check**: confirm the AGENTS.md "≥20-line template goes in references/" rule applies to these blocks (templates vs. prose is the relevant distinction; Step 5 and Step 6 are largely procedural prose, not templates, so the rule may not strictly apply to them — note this in the plan).

5. **Activation cost estimate**: rough order-of-magnitude estimate of how much the SKILL.md load would shrink if the candidate blocks were promoted (sum of candidate block line counts as a fraction of 467).

6. **Implementation outline** (for the future follow-up that will execute the plan): the order in which blocks should be promoted (recommend largest non-borderline first), the `references/` filenames to use, and any cross-references that must be added to the new files (e.g., "Load `references/interface-and-model-branch.md` before Step 5").

Do not modify the SKILL.md file. Do not create the `references/` files. This ticket produces a plan only.

## Recommended Workflow

### Step 1 — Measure and confirm the current section line counts

Where: `skills/engineering/code-implementation-grilling/SKILL.md`

- Count total lines (expect 467; confirm).
- For each H2/H3 section in the file, measure the line range and length.
- Compare against the candidate block list in D003 (Step 5: 78, Step 6: 79, Terminal Output: 67, Validation: 53, Recording block: 22).
- Note any drift between the D003 figures and the actual measured counts (Step 5 was 78 in D003; actual is 79; Step 6 was 79 in D003; actual is 80; close enough; flag in the plan if material).

Verify: A table of sections with line ranges and lengths, matching or explaining the drift from D003's figures.

### Step 2 — Decide target line count and write the justification

Where: the plan file

- State the proposed target (recommend 100 unless the measured activation cost argues for a different number).
- Cite the AGENTS.md "≥20-line template goes in references/" convention.
- Note that Step 5 and Step 6 are procedural prose, not templates — the AGENTS.md rule strictly applies to templates, so the plan must justify promoting procedural prose on a different basis (reduced per-activation context cost; clearer authorship boundary).
- If choosing a target other than 100, state the alternative and the reasoning.

Verify: The plan has a single explicit target line count with a one-paragraph justification.

### Step 3 — List the candidate blocks with proposed `references/` filenames

Where: the plan file

- For each candidate block from D003 (plus the borderline Recording block), state: the SKILL.md line range, measured length, proposed `references/` filename (e.g., `references/interface-and-model-branch.md`), and a one-line rationale for including or excluding the borderline Recording block.
- Order the list by descending size (largest first) for the future implementation.

Verify: The plan has a table of candidate blocks with all four columns (current location, length, proposed references/ filename, rationale).

### Step 4 — Add an implementation outline and activation-cost estimate

Where: the plan file

- Estimate activation cost: sum of candidate block lengths as a percentage of 467.
- Outline the future implementation: order of promotion, load-trigger sentences to add to SKILL.md, and any cross-references between references/ files.

Verify: The plan has both an activation-cost estimate and an implementation outline.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — the file whose size the plan addresses (read-only for this ticket)
- `AGENTS.md` — the "≥20-line template goes in references/" convention cited in D003
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md` — the source ledger for D003
- `skills/engineering/spec-to-tickets/references/ticket-template.md` — precedent for the `references/` load-trigger pattern

**ADRs**: None.

**Domain terms**:
- Activation cost — tokens consumed by a SKILL.md load before any workflow step runs
- Load-trigger sentence — a sentence at the top of a SKILL.md section that tells the implementer to load a `references/` file before that section (precedent: "Load `references/X.md` before Y")

**Ledger records**:
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D003` — the size-reduction plan requirement, including the four primary candidate blocks and the borderline Recording block

## Acceptance criteria

- [ ] A plan file exists at `docs/plans/cig-skill-size-reduction.md` (or an inline Decision Ledger appendix), containing all six sections from the "What to build" list.
- [ ] The current 467-line size is confirmed or corrected (with the correction noted).
- [ ] A target line count is proposed with a justification that cites the AGENTS.md "≥20-line template goes in references/" convention.
- [ ] All four primary candidate blocks (Step 5, Step 6, Terminal Output, Validation) and the borderline Recording block are listed with measured lengths and proposed `references/` filenames.
- [ ] The borderline Recording block's include/exclude decision is justified.
- [ ] An activation-cost estimate is provided (sum of candidate lengths as a percentage of 467).
- [ ] The plan does not modify `skills/engineering/code-implementation-grilling/SKILL.md` or create any `references/` files.

## Dependencies

**Blocked by**: None — can start immediately.
