---
title: Rewrite Phase 3 family carve-out to a closed-sum-type conditional
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md
---

## Goal

Rewrite the Phase 3 "Family carve-out" bullet in `skills/engineering/code-implementation-grilling/SKILL.md` to a conditional that applies the discriminated-union carve-out only when the target language's type system supports closed sum types or sealed class hierarchies, and explicitly names Go, Haskell, and OCaml as languages where the carve-out does not apply. The "1-decision-per-turn regardless of language (works for C#, TypeScript, Rust, Go, and similar)" line is also updated to stop claiming Go supports the carve-out. This also resolves the bundled D021 (the "1-decision-per-turn regardless of language" claim being overstated).

## What to build

In `skills/engineering/code-implementation-grilling/SKILL.md` Step 5, Phase 3 (currently lines 215-241), make two coordinated edits:

1. **Rewrite bullet 2 ("Family carve-out")** to be conditional on the type system. Use the user-supplied literal text from D006:

   > "If the type system supports closed sum types or sealed class hierarchies, apply the family carve-out; otherwise introduce types individually."

   In the carve-out branch, retain the existing mechanics: introduce the abstract type plus its variants as a family, present the variant names in alphabetical order, ask the user which variants (if any) to expand, and do not pre-emptively enumerate every variant's fields and properties. In the individual branch, introduce one type per turn with no carve-out.

   Add an explicit note naming Go, Haskell, and OCaml as examples where the carve-out does not apply (their type systems do not have closed sum types or sealed class hierarchies in the relevant sense; the simple type-by-type loop is correct for them).

2. **Update the closing paragraph** that currently reads "The type loop is 1-decision-per-turn regardless of language (works for C#, TypeScript, Rust, Go, and similar)." This is the D021 overstatement. Replace it with text that:
   - Keeps the "1-decision-per-turn" discipline as the general rule.
   - Drops Go from the explicit "carve-out works for" list (since Go does not have closed sum types / sealed hierarchies).
   - Lists C#, TypeScript, and Rust as languages where the carve-out applies (or uses a non-exhaustive framing like "languages with closed sum types or sealed class hierarchies").
   - Does not name Haskell or OCaml in the "works for" list (they fall under the individual-introduction branch).

   Suggested replacement: "The type loop is 1-decision-per-turn as the general rule. The family carve-out is an exception that applies only when the target language's type system supports closed sum types or sealed class hierarchies (for example, C#, TypeScript, Rust). Languages without that support (for example, Go, Haskell, OCaml) use the simple type-by-type loop. A 'decision' in this loop is either (a) the introduction of a new named type, or (b) the expansion of one previously named variant in a discriminated-union family. Do not batch multiple types into a single turn."

The C#, TypeScript, Rust and Go, Haskell, OCaml lists are illustrative, not exhaustive — frame them with "for example" so the conditional's wording is the source of truth, not the examples.

Do not modify bullets 1, 3, or 4 of Phase 3 (signature/rationale, visible running checklist, termination). Do not modify any other step.

## Recommended Workflow

### Step 1 — Confirm the current text of Phase 3

Where: `skills/engineering/code-implementation-grilling/SKILL.md` lines 215-241

- Read the existing Phase 3 block end-to-end.
- Confirm the two text targets: bullet 2 ("Family carve-out") and the closing paragraph ("1-decision-per-turn regardless of language...").
- Note line numbers for the diff.

Verify: Both target paragraphs are located and their exact current text is captured.

### Step 2 — Rewrite bullet 2 to the conditional

Where: `skills/engineering/code-implementation-grilling/SKILL.md` bullet 2 of Phase 3

- Replace the current Family carve-out text with: "If the type system supports closed sum types or sealed class hierarchies, apply the family carve-out; otherwise introduce types individually."
- Retain the existing carve-out mechanics (alphabetical variant order, the "expand any of these variants?" prompt, the no-pre-emption rule) in the carve-out branch.
- Add a sentence naming Go, Haskell, and OCaml as examples where the carve-out does not apply.
- Keep bullet 2 as a numbered list item under Phase 3; expand into sub-bullets if needed to express the conditional cleanly.

Verify: Bullet 2 now contains the D006 verbatim conditional and an explicit Go / Haskell / OCaml note; the carve-out mechanics are preserved.

### Step 3 — Update the closing paragraph to fix the D021 overstatement

Where: `skills/engineering/code-implementation-grilling/SKILL.md` closing paragraph of Phase 3

- Replace the current "1-decision-per-turn regardless of language (works for C#, TypeScript, Rust, Go, and similar)" text.
- The replacement must keep the 1-decision-per-turn discipline, drop Go from the carve-out "works for" list, keep C# / TypeScript / Rust (or replace with a non-exhaustive framing), and explicitly exclude Go, Haskell, OCaml from the carve-out.
- Preserve the "A 'decision' in this loop is either ... Do not batch multiple types into a single turn." closer (it is correct and not in scope).

Verify: The closing paragraph no longer claims the carve-out works for Go; C# / TypeScript / Rust appear (with the appropriate "for example" framing) as carve-out languages; Go, Haskell, OCaml are absent from the carve-out list.

### Step 4 — Confirm the rest of the file is unchanged

Where: `skills/engineering/code-implementation-grilling/SKILL.md` (full file)

- Confirm the rest of Phase 3 (bullets 1, 3, 4) and all other steps (Step 1, Step 2, Step 3, Step 4, Step 6, Step 7) are unchanged.
- Confirm no other "Go" reference in the file is gratuitously touched.

Verify: A diff against the prior version of the file shows changes only in Phase 3 bullet 2 and the Phase 3 closing paragraph.

## Context pointers

**Files**:
- `skills/engineering/code-implementation-grilling/SKILL.md` — Step 5, Phase 3 (lines 215-241) is the edit target

**ADRs**: None.

**Domain terms**:
- Closed sum type — a type whose set of valid values is a fixed, finite enumeration known at compile time (Haskell's `data` with no `..`, OCaml's polymorphic variants, Rust enums, TypeScript discriminated unions, C# abstract records with sealed cases)
- Sealed class hierarchy — an inheritance hierarchy where the compiler knows the full set of subtypes (C# `sealed` on every leaf, sealed interfaces in Java/Kotlin, Rust's exhaustive `match` on enums)
- Family carve-out — the Phase 3 rule that lets a discriminated union be introduced in one turn as a family (abstract type plus variant names), with variants expanded on demand
- Discriminated union — a sum type whose variants are tagged so the compiler can dispatch on the tag

**Ledger records**:
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D006` — the Phase 3 family carve-out rewrite requirement, including the verbatim replacement wording and the Go / Haskell / OCaml exclusion
- `docs/decisions/DECISIONS-shiny-cactus-cig-skill-review.md#D021` — the "1-decision-per-turn regardless of language" overstatement, bundled into the D006 fix

## Acceptance criteria

- [ ] Phase 3 bullet 2 ("Family carve-out") now contains the D006 verbatim conditional: "If the type system supports closed sum types or sealed class hierarchies, apply the family carve-out; otherwise introduce types individually."
- [ ] Phase 3 bullet 2 names Go, Haskell, and OCaml as examples where the carve-out does not apply.
- [ ] The Phase 3 closing paragraph no longer claims the carve-out "works for C#, TypeScript, Rust, Go, and similar."
- [ ] The Phase 3 closing paragraph retains the "1-decision-per-turn" discipline and the "A 'decision' in this loop is either ... Do not batch multiple types into a single turn" closer.
- [ ] C#, TypeScript, and Rust appear (with "for example" or non-exhaustive framing) as languages where the carve-out applies; Go, Haskell, and OCaml do not appear in the carve-out "applies to" list.
- [ ] The carve-out mechanics (alphabetical variant order, the "expand any of these variants?" prompt, the no-pre-emption rule) are preserved in the carve-out branch.
- [ ] Bullets 1, 3, and 4 of Phase 3 are unchanged.
- [ ] All other steps in CIG (Steps 1, 2, 3, 4, 6, 7) are unchanged.

## Dependencies

**Blocked by**: None — can start immediately.
