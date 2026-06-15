---
name: code-implementation-grilling
description: Relentlessly grills the user to resolve concrete technical implementation details from a plan, spec, or PRD before tickets are created. Use for establishing the technical foundation (language, framework, structure) of a code/programming project and resolving "how" decisions to minimize ambiguity for the implementer. Do not use for establishing domain specific terminology, creating a PRD/specification, non-programming/code implementations, or creating a plan without a specification to base it from.
license: MIT
---

# Skill: code-implementation-grilling

## When to Use
- When a PRD or Spec exists but the specific technical choices (language, framework, libraries) are not yet defined.
- When you need to ensure a shared technical understanding before decomposing a spec into tickets.
- When you want to minimize the number of "Collaborative" tickets by resolving implementation details upfront.

## When Not to Use
- For trivial tasks where the technical path is obvious or already documented.
- When the user explicitly wants the implementer to make all technical architectural decisions.
- During the implementation phase itself.

## Workflow

**Core Constraint**: To avoid overwhelming the user, you must ask exactly one question at a time. Wait for the user's response and resolve the current point before proceeding to the next question.

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
- **If Yes**:
    1. **Architectural Separation**: Resolve the separation of concerns and how the code is structured (e.g., will UI-agnostic code be housed in a UI-agnostic business logic layer; what does that layer look like, such as a class library or API).
    2. **Source of Truth**: If there appear to be conflicting sources of truth for certain functionality or logic, resolve what the ultimate/definitive source of truth is.
    3. **Detailed Definition**: Resolve the signatures, data types, and relationships for the primary entities.
- **If No**: Provide the following warning: *"Skipping detailed interface resolution means these details must be determined during implementation. This will likely result in more 'Collaborative' tickets that require human-in-the-loop intervention."*

### Step 4: Output Selection
Present the user with the following choice for capturing the resolutions:

**Option A: Implementation Blueprint (Recommended)**
- **What**: A standalone `IMPLEMENTATION.md` file.
- **Trade-offs**: High clarity; serves as a clean "Context Pointer" for tickets; keeps the PRD focused on "What".
- **Risks**: Temporary file overhead.

**Option B: PRD Augmentation**
- **What**: Appending a "Technical Implementation" section to the existing spec/PRD.
- **Trade-offs**: Single source of truth; no fragmented files.
- **Risks**: Can clutter high-level requirements with low-level technical noise.

### Step 5: Final Alignment Check & Convergence
Before declaring convergence:
1. **Cross-Reference**: Compare the resolved technical blueprint/section against the original PRD/Spec.
2. **Conflict Detection**: Identify any technical choices that contradict the functional requirements.
3. **Resolution**: Resolve any contradictions with the user.
4. **Declaration**: Once aligned, explicitly declare: *"We have reached a shared implementation understanding."*

### Step 6: Handoff & Scope Binding
Depending on the output choice:
- **If Blueprint**: 
    1. Create the file with a **Scope Binding** section: `Linked Spec: <path_to_spec>`.
    2. Explicitly state in the file: *"This blueprint is a context pointer valid ONLY for the linked spec. Do not apply these technical decisions to other specifications without explicit authorization."*
- **Final Prompt**: Provide the user with the exact prompt to use for ticket creation:
    - *"To generate implementation tickets, I recommend running `spec-to-tickets` with the following instruction: 'Using the requirements in [Spec Path] and the technical decisions in [Blueprint Path/Section], decompose this into tickets.'"*

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
- [ ] **Handoff Prompt**: Was the user provided with a specific prompt for `spec-to-tickets` referencing both the spec and the technical resolutions?
