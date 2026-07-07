---
title: Move Foundation item 7 to its own step and address catch-all language
classification: Collaborative
blocked_by: []
parent: docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md
---

## Goal

Move Foundation Establishment item 7 ("Foundational Preferences (Optional)") out of the Mandatory Checklist and into its own step or sub-step, so the "Mandatory" label is honest and the optional item has a visible home. While moving the item, drop the catch-all "ask the user if they wish to clarify any other important foundational information" wording (D022) and either enumerate the specific preferences or drop the catch-all item entirely.

## What to build

In `skills/engineering/code-implementation-grilling/SKILL.md`:

1. **Move item 7 out of the Mandatory Checklist.** The current Step 3 (line 124) is titled "Foundation Establishment (Mandatory Checklist)" and lists seven items, of which item 7 is labeled "(Optional)". After this change:
   - Step 3's "Mandatory" label is honest: it covers items 1-6 only.
   - Item 7 becomes a separate step (recommended: "Step 3.5: Foundational Preferences (Optional)" or a new "Step 4: Foundational Preferences" with the existing steps renumbered) — the implementer picks the structure.
   - The moved item retains its "Optional" labeling so the implementer knows it is conditional.

2. **Resolve the catch-all language (D022).** Item 7's current text reads, in part: "Ask the user if they wish to clarify any other important foundational information (e.g., preference for async/await programming model, specific CSS frameworks like Bootstrap vs TailwindCSS, etc.)." This catch-all is the D022 issue. The implementer must choose one of:
   - **Option A (enumerate)**: replace the catch-all with an explicit list of the specific preferences named in D005 — async/await programming model, CSS framework, ORM, test framework, logging. Each preference is presented as a separate bullet within the new step. The user can decline any or all (the step is still optional).
   - **Option B (drop)**: remove the catch-all item entirely, retaining only the specific preferences as discrete questions the user can opt into. If no preferences are extracted from the spec, the step may be omitted.

   This is a design choice the D005/D022 constraints leave open. The implementer must pick one and record the choice in the commit message or the Decision Ledger.

3. **Update the Validation list.** The current Validation list (line 414 onward) includes a "Foundation Complete" check that enumerates six items: Language, Framework, Dependencies, Structure, Sub-projects, Project Type. The list is already consistent with the "Mandatory = items 1-6" structure (D005 constraint: "The Validation list's 'Foundation Complete' check enumerates the six mandatory items, not seven — that list remains consistent with the new 'Mandatory = items 1–6' structure."). No edit to the Validation list is required. Confirm this in the diff.

4. **Renumber subsequent steps if needed.** If the new "Foundational Preferences" step is inserted as a new Step 4 (renumbering the existing Steps 4-7 to 5-8), update the "Step 1: Load the references" cross-references in the Terminal Output templates that reference "Step 6 (Output Selection)" (line 243) and any other step numbers that may be affected. Audit the file for hard-coded step numbers before deciding on the numbering scheme.

## Recommended Workflow

### Step 1 — Decide between "new sub-step" and "new top-level step"

Where: `skills/engineering/code-implementation-grilling/SKILL.md` outline (lines 49, 124, 164, 243, 323, 346)

- Option A: insert item 7 as a sub-step within the existing Step 3 (e.g., a new "Step 3.1: Foundational Preferences (Optional)"). Simpler renumbering; keeps the Foundation establishment visually grouped.
- Option B: extract item 7 as a new top-level step (e.g., "Step 4: Foundational Preferences (Optional)") and renumber the existing Steps 4-7 to 5-8. More invasive; matches the D005 spec's "new step or sub-step" allowance.
- Record the choice in the commit message or Decision Ledger.

Verify: A one-line note in the commit or ledger stating which numbering scheme was chosen and why.

### Step 2 — Resolve the D022 catch-all language

Where: `skills/engineering/code-implementation-grilling/SKILL.md` moved item 7 (text)

- Choose Option A (enumerate: async/await, CSS framework, ORM, test framework, logging) or Option B (drop the catch-all entirely).
- For Option A: replace the catch-all sentence with a bulleted list of the five specific preferences, each presented as a conditional prompt (e.g., "If the spec implies web UI work, ask: 'Which CSS framework, if any?' (Bootstrap, TailwindCSS, custom, none)").
- For Option B: drop the catch-all sentence; the moved step becomes an empty "Optional" placeholder or is removed entirely.

Verify: The moved item's text contains either an explicit list of the five D005 preferences (Option A) or no catch-all sentence (Option B).

### Step 3 — Move item 7 out of the Mandatory Checklist and update the heading

Where: `skills/engineering/code-implementation-grilling/SKILL.md` Step 3 (line 124 onward)

- Remove item 7 from the bulleted list under "Step 3: Foundation Establishment (Mandatory Checklist)".
- Update the heading to drop the parenthetical "Mandatory Checklist" or rephrase to "Foundation Establishment (items 1-6, mandatory)" if the implementer wants to keep the contrast visible.
- Insert the moved item (with the D022 catch-all resolved) in its new location per the Step 1 decision.
- Confirm the Mandatory label now matches the items under it (items 1-6, all non-optional).

Verify: The Step 3 heading and item list are consistent: "Mandatory" applies only to items the user must resolve, and item 7 no longer appears in this list.

### Step 4 — Audit and update hard-coded step-number cross-references

Where: `skills/engineering/code-implementation-grilling/SKILL.md` (search for "Step 4", "Step 5", "Step 6", "Step 7" throughout the file)

- If the implementer chose Option B in Step 1 (renumbering), update every cross-reference that points to the renumbered steps. The Terminal Output section (line 346 onward) and the existing Step 4 onward contain explicit "Step 4", "Step 5", "Step 6" references that may need updating.
- If the implementer chose Option A in Step 1 (sub-step), no cross-reference updates are needed.

Verify: A search for "Step 4" / "Step 5" / "Step 6" / "Step 7" in the file returns references that all point to the correct step numbers after the move.

### Step 5 — Confirm the Validation list is unchanged

Where: `skills/engineering/code-implementation-grilling/SKILL.md` Validation list (line 414 onward)

- Confirm the "Foundation Complete" check still enumerates six items: Language, Framework, Dependencies, Structure, Sub-projects, Project Type.
- No edit to the Validation list is required (D005 constraint).

Verify: The Validation list's "Foundation Complete" check still has six items, and none of them is "Foundational Preferences".

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — primary edit target (Step 3, item 7, and possibly step renumbering)
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md` — the source ledger for D005 and D022

**ADRs**: None.

**Domain terms**:
- Mandatory Checklist — a Foundation list in which every item is required before the workflow can proceed
- Optional item — a Foundation item the user may decline to resolve (item 7)
- Catch-all language — phrasing that opens an unbounded prompt ("any other important foundational information")

**Ledger records**:
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D005` — the move-item-7 requirement, the "Fix Later" pattern, and the bundling of D022
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D022` — the catch-all language on item 7; not in the visible excerpt of the ledger but referenced by D005's constraints. The D005 ticket must address D022; D022 itself does not have a separate ticket because the D005 resolved answer bundles the two.

## Acceptance criteria

- [ ] Item 7 ("Foundational Preferences (Optional)") is no longer in the Step 3 Mandatory Checklist bulleted list.
- [ ] Item 7 appears as its own step or sub-step, with the "Optional" label preserved.
- [ ] The catch-all sentence ("ask the user if they wish to clarify any other important foundational information") is gone, replaced by either an explicit list of the five D005 preferences (Option A) or nothing (Option B).
- [ ] The implementer's Option A / Option B choice for D022 is recorded in the commit message or the Decision Ledger.
- [ ] The Step 3 "Mandatory" label is now consistent with the items under it (items 1-6, all non-optional).
- [ ] The Validation list's "Foundation Complete" check is unchanged and still enumerates six items, none of which is "Foundational Preferences".
- [ ] If step renumbering was applied, all hard-coded cross-references in the file (Terminal Output, later steps) point to the correct step numbers.
- [ ] If sub-step nesting was applied, no cross-references needed updating.

## Dependencies

**Blocked by**: None — can start immediately.

**Design decision required before completion**: the Option A / Option B choice for D022 catch-all language (enumeration vs. drop). The ticket is classified Collaborative because this choice is not resolved in D005/D022 and must be made during implementation.
