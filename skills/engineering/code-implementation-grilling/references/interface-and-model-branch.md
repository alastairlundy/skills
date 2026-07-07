### Step 5: Interface & Model Branch (Optional)

Ask the user: *"Would you like to be grilled on the specific
Interface, Contract, DTO, and Model definitions now?"*

- **If No**: Provide the following warning: *"Skipping detailed
  interface resolution means these details must be determined during
  implementation. This will likely result in more 'Collaborative'
  tickets that require human-in-the-loop intervention."* Then skip
  directly to Step 6 (Output Selection).
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
