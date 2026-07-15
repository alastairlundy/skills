### Step 6: Interface & Model Branch (Optional)

## Code-impl context block (5 elements)

Every per-decision question in this file (architectural decisions in
Phase 1, source-of-truth conflicts in Phase 2, type introductions in
Phase 3) emits a 5-element code-impl context block before the
locked question line. The first four elements match the parent
grilling skill's 4-element block (Goal, Prior decisions, Stakes,
Scope) in name, order, and shape — each element exactly one sentence,
with ledger citations in the **Goal**, **Prior decisions**, and
**Stakes** items. The 5th element — **Spec section** — is purely
additive: it captures the spec file path and the specific section or
functional requirement the branch addresses.

The 5th element is **required for every code-impl per-decision
question**; it is not optional. The citation format for the 5th
element is fixed: the spec file path plus the section or
requirement, in the form `specs/feature-x.md §3.2` (file path plus
section or requirement). The 5th element is one sentence and must
include the inline citation.

The parent 4-element block (Goal, Prior decisions, Stakes, Scope) is
emitted verbatim, in order, each element exactly one sentence, with
ledger citations. See
`../grilling/references/locked-question-format.md` Part 1 for the
parent definition and constraints. The context block is not a
free-form prose summary, a "current state" reading, a code
investigation, a domain-glossary recap, or any other kind of
analysis.

### 5-element code-impl context block template

```md
- **Goal**: <one sentence — the goal of the overall decision, citing D001>
- **Prior decisions**: <one sentence — the prior decisions that affect
  this branch, with ledger citations (e.g., D002, D003)>
- **Stakes**: <one sentence — why this decision matters>
- **Scope**: <one sentence — what is in and out of this decision>
- **Spec section**: <one sentence — the spec file path and the
  specific section or functional requirement the branch addresses,
  cited inline (e.g., `specs/feature-x.md §3.2`)>
```

The 5th element is required, not optional. The citation format is
fixed. The parent's 4 elements stay aligned with the parent grilling
skill; the 5th element is the only code-impl addition.

### Worked example

```md
- **Goal**: define the type for the freelancing platform's contact
  record (D001).
- **Prior decisions**: D002 established that the contact acts for a
  client organization; D003 established the payment flow.
- **Stakes**: the type shape determines whether contacts can be
  serialized for messages and whether the payment flow type-checks.
- **Scope**: this decision covers the `Contact` type's fields and
  invariants; it does not cover `ClientOrganization` or `Invoice`.
- **Spec section**: the `Contact` type is required by
  `specs/freelancing-platform.md §3.2 (Contact record)` to carry an
  identity, a display name, and a reference to a single
  `ClientOrganization`.
```

---

Ask the user: *"Would you like to be grilled on the specific
Interface, Contract, DTO, and Model definitions now?"*

- **If No**: Provide the following warning: *"Skipping detailed
  interface resolution means these details must be determined during
  implementation. This will likely result in more 'Collaborative'
  tickets that require human-in-the-loop intervention."* Then skip
  directly to Step 7 (Output Selection).
- **If Yes**: Walk through three sequenced phases. The phases are
  sequential, not nested — once a phase transitions, do not
  interleave its decisions back into a later phase. Each phase uses
  1-decision-per-turn discipline.

  #### Phase 1: Architectural Separation

  First, ask the user: *"How many architectural decisions do you
  want to resolve? (0-3)"*. Use the chosen count N; walk the first
  N items from the typical list below, in order. If N=0, skip
  directly to the Phase 1 transition prompt. Resolve 1-3
  architectural decisions one at a time, each with its own gate.
  Typical decisions:
  - **Layer boundaries**: Where does one layer end and the next
    begin?
  - **Dependency direction**: Which layer depends on which?
  - **Separation mechanism**: How are layers physically separated
    (e.g., separate project, class library, microservice)?

  Present each decision with 2-4 options, trade-offs, and a
  recommendation. Wait for the user's response before presenting the
  next decision.

  When all architectural decisions are resolved, ask: *"Ready to
  move to Source of Truth?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 2: Source of Truth

  Identify any conflicts where two plausible sources claim authority
  for the same functionality or data. If 0 conflicts exist, skip
  directly to the transition prompt. If 1-3 conflicts exist
  (typical: 0-2), resolve each one at a time, each with its own
  gate. For each conflict, present the two plausible sources and
  ask the user which is canonical. Wait for the user's response
  before presenting the next conflict.

  When all conflicts are resolved (or none were found), ask: *"Ready
  to move to the type loop?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 3: Detailed Definition (Type Loop)

  Introduce exactly one named type per turn. For each type:
  1. Present the type's full signature, fields or properties, and a
     1-2 sentence rationale for why it exists.
   2. **Family carve-out**: If the type system supports closed sum
      types or sealed class hierarchies, apply the family carve-out;
      otherwise introduce types individually.
      - **Carve-out branch**: introduce the abstract type plus its
        variants as a family in the abstract type's turn. Present the
        variant names as a bulleted list in alphabetical order, then
        ask: *"Would you like to expand any of these variants? If so,
        which ones?"*. Do not pre-emptively enumerate every variant's
        fields and properties.
      - **Individual branch**: introduce one type per turn with no
        carve-out.
      - The carve-out does not apply to languages whose type systems
        lack closed sum types or sealed class hierarchies (for
        example, Go, Haskell, OCaml).
   3. **Visible running checklist**: after introducing the type,
      show a single-line running checklist of types already
      introduced and types still to come (for example: *"Introduced:
      A, B, C — remaining: D, E, F"*). The checklist is mandatory,
      not optional.
   4. **Termination**: ask *"Any more, or ready to move on?"* The
      user decides whether to introduce the next type, expand a
      previously introduced family, or close the loop. The agent
      does not decide when the type list is complete.

  The type loop is 1-decision-per-turn as the general rule. The
  family carve-out is an exception that applies only when the target
  language's type system supports closed sum types or sealed class
  hierarchies (for example, C#, TypeScript, Rust). Languages without
  that support (for example, Go, Haskell, OCaml) use the simple
  type-by-type loop. A "decision" in this loop is either (a) the
  introduction of a new named type, or (b) the expansion of one
  previously named variant in a discriminated-union family. Do not
  batch multiple types into a single turn.
