### Step 6: Interface & Model Branch (Optional)

## Code-impl context block (5-row table)

Every per-decision question in this file (architectural decisions in
Phase 1, source-of-truth conflicts in Phase 2, type introductions in
Phase 3) emits a 5-row code-impl context block using the 1-turn wrapper.
The 5-row context block is defined in
`references/locked-question-format.md`; the first 3 data rows
(Goal, Prior decisions, Scope) match the parent grilling
skill's context block, and the 4th data row (Spec
section) is the code-impl addition. See
`references/locked-question-format.md` for the full template, the
citation format, and the requirement that the Spec section row is not
optional. The context block is not a free-form prose summary, a
"current state" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis.

### Worked example (Interface & Model Branch)

A Type Loop decision (Contact type) presented in the 5-row
code-impl format:

```md
### Round 1

4 branches remain, 2 unblocked this round.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | Define the type for the freelancing platform's contact record (D001).       |
| **Prior decisions** | D002 established that the contact acts for a client organization; D003 established the payment flow. |
| **Scope**        | This decision covers the `Contact` type's fields and invariants; not `ClientOrganization` or `Invoice`. |
| **Spec section** | `specs/freelancing-platform.md §3.2 (Contact record)` — Contact must carry identity, display name, and reference to a single `ClientOrganization`. |

**For T003 – Contact type: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Record type** | Contact is a C# record with value equality. | Immutable; serializable for messages. | Cannot use reference equality for identity checks. | Future developer assumes reference equality. |
| B — Class with Identity | Contact is a class implementing `IHasIdentity`. | Reference equality; familiar pattern. | Mutable; requires `IEquatable` implementation. | Developer forgets to override `Equals`. |

**Recommendation: A.**
**Reasoning:** A record type aligns with your goal of a serializable contact that carries identity — value equality is the natural fit for message passing.
```

## Format: meta-questions vs. per-decision questions

This file uses two question formats, distinguished by their purpose.
The agent must apply the correct format to each question type.

### Phase-transition meta-questions (lightweight)

Phase-transition meta-questions pace the workflow. They are
**not** subject to the locked question format and keep their
lightweight one-line form. Examples in this file:

- *"How many architectural decisions do you want to resolve? (0-3)"*
  (Phase 1 count question)
- *"Ready to move to Source of Truth?"* (Phase 1 transition)
- *"Ready to move to the type loop?"* (Phase 2 transition)
- *"Would you like to expand any of these variants? If so, which
  ones?"* (Phase 3 family carve-out follow-up)
- *"Any more, or ready to move on?"* (Phase 3 termination)

### Per-decision questions (locked question format)

Per-decision questions are about a specific decision and **are**
subject to the parent grilling skill's locked question format. The
per-decision questions in this file are:

- **Phase 1** — architectural decisions (layer boundaries,
  dependency direction, separation mechanism)
- **Phase 2** — source-of-truth conflicts
- **Phase 3** — type introductions (including the family carve-out
  branch and the individual branch)

For each per-decision question, the agent emits the 1-turn wrapper
in a single agent turn:

- The full wrapper: round header, frontier statement, 5-row context
  block (Goal, Prior decisions, Scope, Spec section), conflict callout
  (if any), options table (5-column), recommendation (2-line). No
  Socratic elicitation question is emitted. Stop and wait for the
  user's response.

See `../grilling/references/locked-question-format.md` for the
full wrapper format and the worked example.

### Worked example — hybrid format

A Phase 1 architectural decision (layer boundaries) presented in
the 1-turn wrapper:

```md
### Round 1

4 branches remain, 2 unblocked this round.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | Establish the architectural shape for the freelancing platform (D001).      |
| **Prior decisions** | D002 established the contact-vs-organization model; T001 established C# as primary language. |
| **Scope**        | This decision covers where one layer ends and the next begins; not dependency direction or separation mechanism. |
| **Spec section** | `specs/freelancing-platform.md §2.1 (Architecture)` — domain model must be free of infrastructure concerns. |

**For T002 – layer boundaries: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Clean Architecture** | Domain layer has zero framework dependencies. | Domain tests run without infrastructure. | More boilerplate for DI wiring. | Future developer adds a framework reference to "save time." |
| B — Hexagonal ports | Domain exposes ports; adapters implement them. | Clear boundary; easy to swap adapters. | Port definitions add abstraction overhead. | Over-engineering for simple CRUD flows. |

**Recommendation: A.**
**Reasoning:** Clean Architecture aligns with your goal of testable domain logic — the zero-dependency rule is the enforcement mechanism.
```

<user answers or says "skip">

**For T007 – layer boundaries: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick
one, reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Domain in its own project** | Domain project has no references to infrastructure; infrastructure depends on domain. | Domain model testable without infrastructure. | Infrastructure must adapt to domain interfaces. | Future developer adds infrastructure reference to "simplify" a feature. |
| B — Shared kernel | Shared kernel project holds types both layers consume. | Less ceremony for cross-cutting types. | Shared kernel becomes a dumping ground. | Future type in shared kernel pulls in infrastructure concerns. |

**Recommendation: A.**
**Reasoning:** Keeping the domain free of infrastructure aligns with your goal of a testable domain model (D001).
```

The meta-question that follows ("Ready to move to Source of Truth?")
is a phase-transition meta-question and stays lightweight — no
context block, no Socratic, no locked question line.

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

  Present each decision using the 1-turn wrapper described
  in the "Format" section above: emit the full wrapper (round header,
  frontier statement, 5-row context block, options table, recommendation)
  in a single turn. Wait
  for the user's response before presenting the next decision.

  When all architectural decisions are resolved, ask: *"Ready to
  move to Source of Truth?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 2: Source of Truth

  Identify any conflicts where two plausible sources claim authority
  for the same functionality or data. If 0 conflicts exist, skip
  directly to the transition prompt. If 1-3 conflicts exist
  (typical: 0-2), resolve each one at a time, each with its own
  gate. For each conflict, use the 1-turn wrapper described
  in the "Format" section above: emit the full wrapper (round header,
  frontier statement, 5-row context block, options table, recommendation)
  in a single turn. Wait for the user's response before presenting the
  next conflict.

  When all conflicts are resolved (or none were found), ask: *"Ready
  to move to the type loop?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 3: Detailed Definition (Type Loop)

  Introduce exactly one named type per turn. For each type, use the
  1-turn wrapper described in the "Format" section above:
  emit the full wrapper (round header, frontier statement, 5-row context
  block, options table, recommendation) in a single turn. Present the
  type's full signature, fields or properties, and a 1–2 sentence
  rationale for why it exists in the recommendation's Reasoning field.
   2. **Family carve-out**: If the type system supports closed sum
      types or sealed class hierarchies, apply the family carve-out;
      otherwise introduce types individually. Both the carve-out
      branch and the individual branch are per-decision questions
       subject to the 1-turn wrapper described in the
       "Format" section above.
      - **Carve-out branch**: introduce the abstract type plus its
        variants as a family in the abstract type's turn. Present the
        variant names as a bulleted list in alphabetical order as the
        options block, then ask the phase-transition meta-question:
        *"Would you like to expand any of these variants? If so,
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
