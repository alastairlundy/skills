---
name: code-implementation-grilling
description: >-
  Relentless Socratic interviewing on technical implementation choices —
  language, framework, dependencies, project structure — once a spec/PRD
  exists. Use when implementation is the question. When non-code/tech
  decisions, use `grilling`. When terminology, use `domain-grilling`.
license: MIT
---

# Code Implementation Grilling

A relentless Socratic interviewing skill, focused on resolving
technical implementation choices once a functional spec/PRD exists.
This skill specializes `grilling` for the case where the user has a
spec and is now answering "how do we build it?"

The core grilling machinery (Decision Ledger, options/recommendation
formats, locked question format, tone discipline, convergence test)
is owned by the `grilling` skill. This skill adds spec/PRD reading,
the Foundation checklist, Technical Decision Point extraction, the
optional Interface/Model branch, and the code-specific Terminal
Output handoff templates.

## When to Use

- When a spec or PRD is referenced as a file path, attached as a
  document, or substantively laid out in the conversation, and the
  goal is to produce a code implementation plan for a code/programming
  project.
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- Do not use when general planning or non-code/non-programming projects
  (e.g., a business plan, an ops runbook, a research project).
- Do not use when vague ideas, domain modeling, or terminology alignment.
- Do not use when creating a spec or PRD itself.

## Workflow

**Core Constraint**: To avoid overwhelming the user, ask exactly one
question at a time. Wait for the user's response and resolve the
current point before proceeding to the next question.

### Step 1: Load the references

Before the first user question, load and read in full:

- `../grilling/references/decision-ledger.md` (Decision Ledger
  mechanics, including the `Dxxx` and `Txxx` record formats)
- `../grilling/references/options-format.md`
- `../grilling/references/recommendation-format.md`
- `../grilling/references/locked-question-format.md`
- `../grilling/references/tone-and-output.md`
- `../grilling/references/convergence-test.md`

Apply the formats from those files verbatim throughout the session.
If any file is missing or unreadable, abort the session and report
the missing file to the user.

### Step 2: Spec and Decision Ledger resolution

The Decision Ledger is the shared artifact between `grilling`,
`domain-grilling`, and this skill. Functional decisions land as
`Dxxx` records (typically by `domain-grilling`); technical decisions
land as `Txxx` records (by this skill). Both share one file at
`docs/decisions/DECISIONS-<repo>-<feature>.md`.

1. **Locate the spec.** Identify the spec/PRD that grounds the
   session. Derive the spec's identifying token using the
   precedence **file path > issue tracker reference > conversation
   context**.
2. **Locate the Decision Ledger.** Scan `docs/decisions/` for the
   matching ledger. If exactly one match exists, use it. If
   multiple matches exist for the same feature slug, ask the user
   which one to extend. If none exist, ask the user whether to
   start a new ledger or abort.
3. **Read existing records.** Read the file end-to-end and note:
   - The highest existing `Dxxx` and `Txxx` numbers — the next
     `Txxx` is `max(Txxx) + 1`, or `T001` if no `Txxx` records
     exist.
   - Every `Dxxx` record's `Resolved Answer` and `Constraints` —
     these are the functional requirements the technical decisions
     must satisfy.
4. **Confirm both paths with the user** before the first append.
5. **Conflict pre-check.** If any `Dxxx` record contradicts another
   (e.g., "single tab per session" vs. "all open tabs survive
   restart"), surface the contradiction now and resolve it before
   proceeding. Do not silently record a Technical Decision that
   violates a `Dxxx` constraint.

If the user cannot produce or locate a ledger, do not invent one.
The recommended path is to run `domain-grilling` first; this skill
assumes a durable functional record exists.

### Recording Technical Decisions to the Ledger

After every resolved decision in Steps 3, 4, and 5, append a `Txxx`
record to the ledger using this template:

```md
### [Txxx] — <Decision label>

- **Resolved Answer**: <verbatim user choice>
- **Normalized Requirement**: <concise, testable statement>
- **Constraints**: <negative requirements, edge cases, or defaults>
- **Cites**: <Dxxx ids from the same ledger whose constraints this answer respects>
```

- `Txxx` is a zero-padded sequence incremented from the highest
  existing `Txxx`.
- `Cites` lists every `Dxxx` (or earlier `Txxx`) record whose
  `Constraints` the technical answer must respect. A Technical
  Decision that ignores a cited constraint is a silent loss; do not
  cite a record unless the answer actually honours it.
- The Core Constraint still applies: append the record in the same
  turn the user resolves the decision, before asking the next
  question.

### Step 3: Foundation Establishment (Mandatory Checklist)

Iteratively resolve the following technical foundation points
one-by-one. For each, present 2-4 natural options with trade-offs
and a recommendation.

1. **Programming Language**: Which language will be used?
2. **Framework/Runtime**: Which primary framework or runtime is
   required?
3. **Key Dependencies**: What are the critical libraries or external
   APIs that must be used?
4. **Project Structure**: What is the overall organizational layout
   of the code (e.g., Layered, Vertical Slices, Monolith,
   Microservices)?
5. **Sub-projects**: If multiple sub-projects are called for in the
   spec, define the scope and purpose of each.
6. **Project Type**: If not specified in the spec, determine the
   type of project being created (e.g., CLI Console app, Desktop
   GUI program, Programming Library, etc.).
7. **Foundational Preferences (Optional)**: Ask the user if they
   wish to clarify any other important foundational information
   (e.g., preference for async/await programming model, specific CSS
   frameworks like Bootstrap vs TailwindCSS, etc.).

### Step 4: Spec-Driven Technical Extraction

Analyze the spec for remaining "how" gaps.

1. **Identify Technical Decision Points (TDPs)**: Extract every
   functional requirement that implies a technical choice
   (e.g., "Real-time updates" → WebSocket vs Long Polling).
2. **Filter Deferred Features**: Identify and skip any features
   explicitly marked as "deferred" or "out of scope" in the spec
   to avoid decision fatigue.
3. **Resolve Technical Decision Points**: Grill the user on each
   identified point using the "Options → Recommendation → Risk"
   pattern from `../grilling/references/*`. **Crucial**: Never use
   the abbreviation "TDP" when communicating with the user; always
   use the full term "Technical Decision Point".

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
  2. **Family carve-out**: a discriminated union (one abstract type
     plus its concrete variants) is introduced as a family in the
     abstract type's turn. Present the variant names as a bulleted
     list in alphabetical order, then ask: *"Would you like to
     expand any of these variants? If so, which ones?"*. Do not
     pre-emptively enumerate every variant's fields and properties.
  3. **Visible running checklist**: after introducing the type,
     show a single-line running checklist of types already
     introduced and types still to come (for example: *"Introduced:
     A, B, C — remaining: D, E, F"*). The checklist is mandatory,
     not optional.
  4. **Termination**: ask *"Any more, or ready to move on?"* The
     user decides whether to introduce the next type, expand a
     previously introduced family, or close the loop. The agent
     does not decide when the type list is complete.

  The type loop is 1-decision-per-turn regardless of language
  (works for C#, TypeScript, Rust, Go, and similar). A "decision"
  in this loop is either (a) the introduction of a new named type,
  or (b) the expansion of one previously named variant in a
  discriminated-union family. Do not batch multiple types into a
  single turn.

### Step 6: Output Selection

Present the user with the following two-part choice, one part at a
time.

**Part A: Output format**

**Option A: Implementation Blueprint (Recommended)**

- **What**: A standalone blueprint file at the repo root, with a
  `Scope Binding` section that links the blueprint to the source
  spec and the Decision Ledger.
- **Filename derivation**: Derive the blueprint filename from the
  spec's identifying token by input type — file path → basename
  without extension (e.g., `docs/prds/feature-x.md` →
  `IMPLEMENTATION-feature-x.md`); issue tracker reference → issue
  number (e.g., `#123` → `IMPLEMENTATION-123.md`); conversation
  context → date prefix in `YYYY-MM-DD` form (e.g., `Conversation
  context (2026-06-15)` → `IMPLEMENTATION-2026-06-15.md`). When
  the spec is referenced by more than one input type, resolve the
  filename using the strict total ordering **file path > issue
  tracker reference > conversation context** — pick the
  highest-precedence source present. The default location is the
  repo root.
- **Trade-offs**: High clarity; serves as a clean "Context Pointer"
  for tickets; keeps the PRD focused on "What".
- **Risks**: Temporary file overhead.
- **Scope Binding contents**: The blueprint must include
  `Linked Spec: <path_to_spec>`,
  `Decision Ledger: <ledger-path>`, and a notice that the
  blueprint is a context pointer valid ONLY for the linked spec
  and must not be applied to other specifications without explicit
  authorization.
- **Ledger Binding**: Every technical statement in the blueprint
  body that satisfies a functional requirement must reference the
  `Dxxx` (or earlier `Txxx`) record it satisfies using the
  `filename#<Dxxx|Txxx>` format in square brackets, inline
  (e.g., *"The store [`DECISIONS-repo-feature.md#D012`] will use
  Redis with per-tab key namespaces, so a failed write to one tab
  does not corrupt siblings [`DECISIONS-repo-feature.md#D014`]."*).
  The blueprint must also include a `## Ledger Reference` section
  listing every `Dxxx` and `Txxx` record the blueprint cites, so a
  reader can audit the binding in one pass.

**Option B: PRD Augmentation**

- **What**: Appending a "Technical Implementation" section to the
  existing spec/PRD.
- **Trade-offs**: Single source of truth; no fragmented files.
- **Risks**: Can clutter high-level requirements with low-level
  technical noise.
- **Ledger Binding (Option B)**: The appended Technical
  Implementation section must inline-cite the `Dxxx`/`Txxx`
  records using `filename#<Dxxx|Txxx>` format, and must open with a
  `Decision Ledger: <ledger-path>` pointer so readers can audit
  the binding.

**Part B: Downstream consumer**

- **Ticket consumer**: hand off to a workflow that auto-decomposes
  the spec and blueprint into a dependency graph of implementation
  tickets.
- **Issue tracker**: hand off to a workflow that files the spec and
  blueprint as issues in the issue tracker.
- **Manual handoff**: no automated decomposition; the user takes
  the artifacts from here.

**Step 6.1: Filename confirmation (Option A only)**

If the user chose Option A (Implementation Blueprint), surface the
resolved filename in a confirmation prompt (e.g., *"I'm going to
write the blueprint to `IMPLEMENTATION-feature-x.md` at the repo
root — OK?"*). If the user wants a different name, adjust the
filename before writing. Skip this step entirely if the user chose
Option B (PRD Augmentation).

Captured: Output format = Option A | Option B; Downstream consumer
= ticket consumer | issue tracker | manual handoff. The captured
choices drive template selection in the Terminal Output section.

### Step 7: Final Alignment Check & Convergence

Before declaring convergence:

1. **Cross-Reference**: Compare the resolved technical
   blueprint/section against the original PRD/Spec.
2. **Conflict Detection**: Identify any technical choices that
   contradict the functional requirements.
3. **Resolution**: Resolve any contradictions with the user.
4. **Decision Ledger Coverage**: Re-read the Decision Ledger and
   verify (a) every Technical Decision Point resolved in Steps 3-5
   has a corresponding `Txxx` record, (b) every blueprint body
   statement that satisfies a functional requirement cites the
   `Dxxx`/`Txxx` record it satisfies using `filename#<Dxxx|Txxx>`
   format, and (c) the blueprint's `## Ledger Reference` section
   (or the augmented PRD's `Decision Ledger:` pointer) lists every
   cited record. A blueprint that omits citations, or a session
   that ends with unreferenced decisions, is not convergent —
   re-open the affected decision or the blueprint and complete the
   binding before declaring.
5. **Declaration**: Once aligned and bound, explicitly declare:
   *"We have reached a shared implementation understanding."*

## Terminal Output (Required)

This block is mandatory. A workflow run that ends without emitting
it is incomplete.

At the end of the workflow, the agent emits exactly one of the
following pre-written handoff templates. Template selection is
keyed on the captured choices from Step 6: first select the
template set by Output format (Option A = Implementation Blueprint,
Option B = PRD Augmentation), then select the specific template by
Downstream consumer. The agent substitutes `<spec-path>`,
`<blueprint-path>` (Option A only), and `<ledger-path>` only. Do
not add any other prose around the template.

### Option A: Implementation Blueprint

**Template: ticket consumer (`spec-to-tickets`)**

> Run the `spec-to-tickets` skill with the spec at `<spec-path>`,
> the blueprint at `<blueprint-path>`, and the Decision Ledger at
> `<ledger-path>` as context. Every ticket's acceptance criteria
> and constraints must cite a `Dxxx` or `Txxx` record using
> `filename#<Dxxx|Txxx>` format.

**Template: issue tracker (file the spec and blueprint as issues in the project's issue tracker)**

> File the spec and blueprint as issues in the project's issue tracker,
> citing the Decision Ledger per the same constraints as the
> ticket-consumer template. Every issue's acceptance criteria
> and constraints must cite a `Dxxx` or `Txxx` record using
> `filename#<Dxxx|Txxx>` format.

**Template: manual handoff**

> Manual handoff. The spec is at `<spec-path>`, the technical
> blueprint is at `<blueprint-path>`, and the Decision Ledger is
> at `<ledger-path>`. Use these to drive ticket creation or
> implementation planning in your own workflow. Every ticket's
> acceptance criteria and constraints must cite a `Dxxx` or `Txxx`
> record using `filename#<Dxxx|Txxx>` format.

### Option B: PRD Augmentation

**Template: ticket consumer (`spec-to-tickets`)**

> Run the `spec-to-tickets` skill with the spec at `<spec-path>`
> (which now includes the Technical Implementation section) and
> the Decision Ledger at `<ledger-path>` as context. Every
> ticket's acceptance criteria and constraints must cite a
> `Dxxx` or `Txxx` record using `filename#<Dxxx|Txxx>` format.

**Template: issue tracker (file the spec and blueprint as issues in the project's issue tracker)**

> File the spec (which now includes the Technical Implementation
> section) and the Decision Ledger as issues in the project's
> issue tracker, citing the Decision Ledger per the same
> constraints as the ticket-consumer template. Every issue's
> acceptance criteria and constraints must cite a `Dxxx` or
> `Txxx` record using `filename#<Dxxx|Txxx>` format.

**Template: manual handoff**

> Manual handoff. The spec is at `<spec-path>` (which now
> includes the Technical Implementation section) and the
> Decision Ledger at `<ledger-path>`. Use these to drive ticket
> creation or implementation planning in your own workflow.
> Every ticket's acceptance criteria and constraints must cite a
> `Dxxx` or `Txxx` record using `filename#<Dxxx|Txxx>` format.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] **References Loaded**: All six `grilling` reference files were
      loaded and read in full before the first user question. If
      any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] **Atomic Questioning**: Did the agent ask exactly one
      question at a time, waiting for a response before
      proceeding?
- [ ] **Decision Ledger Located**: Was the existing Decision
      Ledger located, read end-to-end, and its path confirmed with
      the user before the first question?
- [ ] **Foundation Complete**: Were Language, Framework,
      Dependencies, Structure, Sub-projects, and Project Type all
      resolved?
- [ ] **TDP Extraction**: Were all non-deferred technical gaps in
      the spec identified and resolved?
- [ ] **No Abbreviations**: Did the agent avoid using the
      abbreviation "TDP" in all user-facing communication?
- [ ] **Ledger Recording**: Was a `Txxx` record appended to the
      Decision Ledger after every resolved decision in Steps 3, 4,
      and 5, each with a fresh `Txxx` ID and a `Cites:` line
      naming the `Dxxx`/`Txxx` records the answer respects?
- [ ] **Optionality Handled**: Was the user asked about
      Interfaces, and given the "Collaborative ticket" warning if
      they declined?
- [ ] **Interface Logic**: If Interfaces were resolved, were
      separation of concerns and the source of truth determined
      before signatures?
- [ ] **Visible Checklist**: If Interfaces were resolved, was a
      single-line running checklist emitted after each type
      introduction in Phase 3?
- [ ] **Output Choice**: Did the user choose between a Blueprint
      and PRD augmentation after seeing trade-offs?
- [ ] **Alignment Check**: Was a final pass performed to ensure
      the technical "how" supports the functional "what"?
- [ ] **Ledger Coverage**: Does every blueprint body statement
      that satisfies a functional requirement inline-cite a
      `Dxxx`/`Txxx` record using `filename#<Dxxx|Txxx>` format,
      and does the blueprint (or augmented PRD) list every cited
      record in a `## Ledger Reference` / `Decision Ledger:` section?
- [ ] **Scope Binding**: If the user chose Option A
      (Implementation Blueprint), does the blueprint explicitly
      link to the specific PRD, the Decision Ledger, and warn
      against cross-spec application? If the user chose Option B
      (PRD Augmentation), does the augmented spec include the
      Scope Binding notice and the `Decision Ledger:` pointer in
      the appended Technical Implementation section?
- [ ] **Pass/Fail Gate**: Has the Terminal Output block been
      emitted with the Decision Ledger path substituted into
      `<ledger-path>`? If no, the workflow is incomplete.
