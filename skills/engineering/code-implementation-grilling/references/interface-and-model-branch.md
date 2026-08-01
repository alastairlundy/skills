### Step 6: Interface & Model Branch (Optional)

## Code-impl context block (5 elements)

Every per-decision question in this file (architectural decisions in
Phase 1, source-of-truth conflicts in Phase 2, type introductions in
Phase 3) emits a 5-element code-impl context block before the
locked question line. The 5-element context block is defined in
`references/locked-question-format.md`; the first four elements
(Goal, Prior decisions, Stakes, Scope) are the parent grilling
skill's 4-element block unchanged, and the 5th element (Spec
section) is the code-impl addition per D011. See
`references/locked-question-format.md` for the full template, the
citation format, and the requirement that the 5th element is not
optional. The context block is not a free-form prose summary, a
"current state" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis.

### Worked example (Interface & Model Branch)

A Type Loop decision (Contact type) presented in the 5-element
code-impl format:

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

For each per-decision question, the agent emits the locked question
format across two turns:

- **Turn 1** — the 5-element code-impl context block (per
  `references/locked-question-format.md`), followed by the optional
  Socratic elicitation
  question using the D003 verbatim wording: *"What are you working
  toward in this decision? You may answer, or skip and see the
  options as-is."* The Socratic question is optional; the user may
  engage to steer or decline (signals: "skip", "no", "as-is", or a
  no-op response), and the agent proceeds to Turn 2 without
  re-asking. Stop and wait for the user's response.
- **Turn 2** — the locked question line using the D004 verbatim
  wording: *"**For [Txxx] – [branch name]: pick an option,
  hybridize, or provide your own answer.**"*, followed by the
  reference-set preamble ("Here are options to help you refine or
  confirm your answer. Pick one, reject all, or hybridize."), the
  options block (What it is / Benefit / Cost / Risk, each one
  sentence, 2–4 options), and the recommendation (Recommendation /
  Reasoning / Forward risk). All three response types (pick,
  hybridize, provide) are equally valid. Stop and wait for the
  user's response.

See `../grilling/references/locked-question-format.md` for the
full locked question format, the 2-turn sequence, the engage and
decline behaviors, and the worked example.

### Worked example — hybrid format

A Phase 1 architectural decision (layer boundaries) presented in
the hybrid format:

```md
- **Goal**: establish the architectural shape for the freelancing
  platform (D001).
- **Prior decisions**: D002 established the contact-vs-organization
  model; T001 established C# as the primary language.
- **Stakes**: the layer boundary determines whether the domain
  model can be tested without infrastructure dependencies.
- **Scope**: this decision covers where one layer ends and the
  next begins; it does not cover dependency direction or
  separation mechanism.
- **Spec section**: the layer boundary is required by
  `specs/freelancing-platform.md §2.1 (Architecture)` to keep the
  domain model free of infrastructure concerns.

What are you working toward in this decision? You may answer, or
skip and see the options as-is.

<user answers or says "skip">

**For T007 – layer boundaries: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick
one, reject all, or hybridize.

- **Option 1 — Domain in its own project, no infrastructure
  references.** What it is: the domain project has no references
  to infrastructure projects; infrastructure depends on domain.
  Benefit: the domain model is testable without infrastructure.
  Cost: infrastructure must adapt to domain interfaces, which can
  feel constraining. Risk: a future developer adds a one-way
  infrastructure reference to "simplify" a feature, breaking the
  boundary.
- **Option 2 — Shared kernel between domain and infrastructure.**
  What it is: a shared kernel project holds types both layers
  consume. Benefit: less ceremony for cross-cutting types. Cost:
  the shared kernel becomes a dumping ground and the boundary
  blurs. Risk: a future type in the shared kernel pulls in
  infrastructure concerns, polluting the domain.

`Recommendation: Option 1 — Domain in its own project, no
infrastructure references.`
`Reasoning: keeping the domain free of infrastructure aligns with
your goal of a testable domain model (D001).`
`Forward risk: a future developer adds an infrastructure reference
to the domain project to "simplify" a feature, breaking the
testability boundary.`
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

  Present each decision using the locked question format described
  in the "Format" section above: Turn 1 emits the 5-element code-impl
  context block plus the optional Socratic elicitation question;
  Turn 2 emits the locked question line plus the reference-set
  preamble plus the options block (2–4 options, each with What it is
  / Benefit / Cost / Risk, one sentence per field) plus the
  recommendation (Recommendation / Reasoning / Forward risk). Wait
  for the user's response before presenting the next decision.

  When all architectural decisions are resolved, ask: *"Ready to
  move to Source of Truth?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 2: Source of Truth

  Identify any conflicts where two plausible sources claim authority
  for the same functionality or data. If 0 conflicts exist, skip
  directly to the transition prompt. If 1-3 conflicts exist
  (typical: 0-2), resolve each one at a time, each with its own
  gate. For each conflict, use the locked question format described
  in the "Format" section above: Turn 1 emits the 5-element code-impl
  context block plus the optional Socratic elicitation question;
  Turn 2 emits the locked question line plus the reference-set
  preamble plus the options block (the two plausible sources framed
  as options, each with What it is / Benefit / Cost / Risk, one
  sentence per field) plus the recommendation. Wait for the user's
  response before presenting the next conflict.

  When all conflicts are resolved (or none were found), ask: *"Ready
  to move to the type loop?"* The user confirms or revises before
  the phase transitions. Do not advance without confirmation.

  #### Phase 3: Detailed Definition (Type Loop)

  Introduce exactly one named type per turn. For each type, use the
  locked question format described in the "Format" section above:
  Turn 1 emits the 5-element code-impl context block plus the
  optional Socratic elicitation question; Turn 2 emits the locked
  question line plus the reference-set preamble plus the options
  block (2–4 alternative type shapes, each with What it is /
  Benefit / Cost / Risk, one sentence per field) plus the
  recommendation (the type's full signature, fields or properties,
  and a 1–2 sentence rationale for why it exists).
   2. **Family carve-out**: If the type system supports closed sum
      types or sealed class hierarchies, apply the family carve-out;
      otherwise introduce types individually. Both the carve-out
      branch and the individual branch are per-decision questions
      subject to the locked question format described in the
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
