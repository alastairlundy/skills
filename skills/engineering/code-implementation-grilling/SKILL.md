---
name: code-implementation-grilling
description: Produces a code implementation plan by grilling the user on technical choices (language, framework, dependencies, project structure, sub-projects, project type) before tickets are created. Use only when a spec or PRD is already present — referenced as a file path, attached as a document, or substantively laid out in the conversation — for a code/programming project. Defer to `domain-grilling` for vague ideas, domain modeling, or terminology alignment. Do not use for general planning, non-code/non-programming projects, or creating a spec/PRD itself.
license: MIT
---

# Skill: code-implementation-grilling

## When to Use
- When a spec or PRD is referenced as a file path, attached as a document, or substantively laid out in the conversation, and the goal is to produce a code implementation plan for a code/programming project.

## When Not to Use
- For general planning or non-code/non-programming projects (e.g., a business plan, an ops runbook, a research project).
- For vague ideas, domain modeling, or terminology alignment (defer to `domain-grilling`).
- For creating a spec or PRD itself (defer to `to-prd` or `domain-grilling`).

## Workflow

**Core Constraint**: To avoid overwhelming the user, you must ask exactly one question at a time. Wait for the user's response and resolve the current point before proceeding to the next question.

### Workflow Conventions
- Do not name skills in Steps 1-5. All skill references live in the Terminal Output section. Mid-workflow prose refers to consumers generically ('ticket consumer', 'issue tracker').

### Step 1: Foundation Establishment (Mandatory Checklist)
Iteratively resolve the following technical foundation points one-by-one. For each, present 2-4 natural options with trade-offs and a recommendation.
1. **Programming Language**: Which language will be used?
2. **Framework/Runtime**: Which primary framework or runtime is required?
3. **Key Dependencies**: What are the critical libraries or external APIs that must be used?
4. **Project Structure**: What is the overall organizational layout of the code (e.g., Layered, Vertical Slices, Monolith, Microservices)?
5. **Sub-projects**: If multiple sub-projects are called for in the spec, define the scope and purpose of each.
6. **Project Type**: If not specified in the spec, determine the type of project being created (e.g., CLI Console app, Desktop GUI program, Programming Library, etc.).
7. **Foundational Preferences (Optional)**: Ask the user if they wish to clarify any other important foundational information (e.g., preference for async/await programming model, specific CSS frameworks like Bootstrap vs TailwindCSS, etc.).

### Step 2: Spec-Driven Technical Extraction
Analyze the spec for remaining "how" gaps.
1. **Identify Technical Decision Points (TDPs)**: Extract every functional requirement that implies a technical choice (e.g., "Real-time updates" $\to$ WebSocket vs Long Polling).
2. **Filter Deferred Features**: Identify and skip any features explicitly marked as "deferred" or "out of scope" in the spec to avoid decision fatigue.
3. **Resolve Technical Decision Points**: Grill the user on each identified point using the "Options $\to$ Recommendation $\to$ Risk" pattern. **Crucial**: Never use the abbreviation "TDP" when communicating with the user; always use the full term "Technical Decision Point".

### Step 3: Interface & Model Branch (Optional)
Ask the user: *"Would you like to be grilled on the specific Interface, Contract, DTO, and Model definitions now?"*
- **If No**: Provide the following warning: *"Skipping detailed interface resolution means these details must be determined during implementation. This will likely result in more 'Collaborative' tickets that require human-in-the-loop intervention."*
- **If Yes**: Walk through three sequenced phases. The phases are sequential, not nested — once a phase transitions, do not interleave its decisions back into a later phase. Each phase uses 1-decision-per-turn discipline.

  #### Phase 1: Architectural Separation
  Resolve 1-3 architectural decisions one at a time, each with its own gate. Typical decisions:
  - **Layer boundaries**: Where does one layer end and the next begin?
  - **Dependency direction**: Which layer depends on which?
  - **Separation mechanism**: How are layers physically separated (e.g., separate project, class library, microservice)?

  Present each decision with 2-4 options, trade-offs, and a recommendation. Wait for the user's response before presenting the next decision.

  When all architectural decisions are resolved, ask: *"Ready to move to Source of Truth?"* The user confirms or revises before the phase transitions. Do not advance without confirmation.

  #### Phase 2: Source of Truth
  Identify any conflicts where two plausible sources claim authority for the same functionality or data. If 0 conflicts exist, skip directly to the transition prompt. If 1-3 conflicts exist (typical: 0-2), resolve each one at a time, each with its own gate. For each conflict, present the two plausible sources and ask the user which is canonical. Wait for the user's response before presenting the next conflict.

  When all conflicts are resolved (or none were found), ask: *"Ready to move to the type loop?"* The user confirms or revises before the phase transitions. Do not advance without confirmation.

  #### Phase 3: Detailed Definition (Type Loop)
  Introduce exactly one named type per turn. For each type:
  1. Present the type's full signature, fields or properties, and a 1-2 sentence rationale for why it exists.
  2. **Family carve-out**: a discriminated union (one abstract type plus its concrete variants) is introduced as a family in the abstract type's turn. List the variant names and offer to expand any or all variants on user request. Do not pre-emptively enumerate every variant's fields and properties.
  3. **Visible running checklist**: after introducing the type, show a single-line running checklist of types already introduced and types still to come (for example: *"Introduced: A, B, C — remaining: D, E, F"*). The checklist is mandatory, not optional.
  4. **Termination**: ask *"Any more, or ready to move on?"* The user decides whether to introduce the next type, expand a previously introduced family, or close the loop. The agent does not decide when the type list is complete.

  The type loop is 1-decision-per-turn regardless of language (works for C#, TypeScript, Rust, Go, and similar). Do not batch multiple types into a single turn.

### Step 4: Output Selection
Present the user with the following two-part choice, one part at a time:

**Part A: Output format**

**Option A: Implementation Blueprint (Recommended)**
- **What**: A standalone blueprint file at the repo root, with a `Scope Binding` section that links the blueprint to the source spec.
- **Filename derivation**: Derive the blueprint filename from the spec's identifying token by input type — file path → basename without extension (e.g., `docs/prds/feature-x.md` → `IMPLEMENTATION-feature-x.md`); issue tracker reference → issue number (e.g., `#123` → `IMPLEMENTATION-123.md`); conversation context → date prefix in `YYYY-MM-DD` form (e.g., `Conversation context (2026-06-15)` → `IMPLEMENTATION-2026-06-15.md`). If the spec is referenced by both a file path and an issue tracker reference, prefer the file path (more descriptive). The default location is the repo root.
- **Trade-offs**: High clarity; serves as a clean "Context Pointer" for tickets; keeps the PRD focused on "What".
- **Risks**: Temporary file overhead.
- **Scope Binding contents**: The blueprint must include `Linked Spec: <path_to_spec>` and a notice that the blueprint is a context pointer valid ONLY for the linked spec and must not be applied to other specifications without explicit authorization.
- **Filename confirmation**: Before writing the file, surface the resolved filename in a confirmation prompt (e.g., *"I'm going to write the blueprint to `IMPLEMENTATION-feature-x.md` at the repo root — OK?"*). If the user wants a different name, adjust the filename before writing.

**Option B: PRD Augmentation**
- **What**: Appending a "Technical Implementation" section to the existing spec/PRD.
- **Trade-offs**: Single source of truth; no fragmented files.
- **Risks**: Can clutter high-level requirements with low-level technical noise.

**Part B: Downstream consumer**

- **Ticket consumer**: hand off to a workflow that auto-decomposes the spec and blueprint into a dependency graph of implementation tickets.
- **Issue tracker**: hand off to a workflow that files the spec and blueprint as issues in the issue tracker.
- **Manual handoff**: no automated decomposition; the user takes the artifacts from here.

Capture both choices. The downstream-consumer choice drives the template emitted in the Terminal Output section.

### Step 5: Final Alignment Check & Convergence
Before declaring convergence:
1. **Cross-Reference**: Compare the resolved technical blueprint/section against the original PRD/Spec.
2. **Conflict Detection**: Identify any technical choices that contradict the functional requirements.
3. **Resolution**: Resolve any contradictions with the user.
4. **Declaration**: Once aligned, explicitly declare: *"We have reached a shared implementation understanding."*

## Terminal Output (Required)

This block is mandatory. A workflow run that ends without emitting it is incomplete.

At the end of the workflow, the agent emits exactly one of the following pre-written handoff templates, selected by the user's downstream-consumer choice in Step 4. The agent substitutes `<spec-path>` and `<blueprint-path>` only. Do not add any other prose around the template.

**Template: ticket consumer (`spec-to-tickets`)**

> Run the `spec-to-tickets` skill with the spec at `<spec-path>` and the blueprint at `<blueprint-path>` as context.

**Template: issue tracker (`to-issues`)**

> Run the `to-issues` skill with the spec at `<spec-path>` and the blueprint at `<blueprint-path>` as context.

**Template: manual handoff**

> Manual handoff. The spec is at `<spec-path>` and the technical blueprint is at `<blueprint-path>`. Use these to drive ticket creation or implementation planning in your own workflow.

## Validation
- [ ] **Atomic Questioning**: Did the agent ask exactly one question at a time, waiting for a response before proceeding?
- [ ] **Foundation Complete**: Were Language, Framework, Dependencies, Structure, Sub-projects, and Project Type all resolved?
- [ ] **TDP Extraction**: Were all non-deferred technical gaps in the spec identified and resolved?
- [ ] **No Abbreviations**: Did the agent avoid using the abbreviation "TDP" in all user-facing communication?
- [ ] **Optionality Handled**: Was the user asked about Interfaces, and given the "Collaborative ticket" warning if they declined?
- [ ] **Interface Logic**: If Interfaces were resolved, were separation of concerns and the source of truth determined before signatures?
- [ ] **Output Choice**: Did the user choose between a Blueprint and PRD augmentation after seeing trade-offs?
- [ ] **Alignment Check**: Was a final pass performed to ensure the technical "how" supports the functional "what"?
- [ ] **Scope Binding**: Does the blueprint explicitly link to the specific PRD and warn against cross-spec application?
- [ ] **Pass/Fail Gate**: Has the Terminal Output block been emitted? If no, the workflow is incomplete.
