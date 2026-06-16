---
name: skill-architect
description: >-
  Guides users through the design, refinement, and deterministic translation of a new agent skill, ensuring compatibility with project standards without performing file system writes.
license: MIT
---

# Skill Architect

The Skill Architect is an intellectual design phase for creating agent skills. It transforms "fuzzy" user intents into deterministic execution patterns, ensuring the resulting skill is precise, compliant, and implementable by an LLM.

## When to Use
- When you have a high-level goal for a new skill but no concrete workflow.
- When you need to refine ambiguous agent behaviors into deterministic steps.
- When you want to ensure a new skill adheres to the project's mandatory structure and standards.
- When converting vague goals into a technical design before shifting to implementation.
- When user input would clarify the request, invoke ask-questions

## When Not to Use
- For trivial changes to existing skills.
- When you already have a complete, finalized PRD or specification.
- When the task is a simple code fix or refactor.

## Workflow

**Default Output Mode**: By default, this skill operates entirely within the conversation. You must draft the skill's design and present it as markdown text. You MUST NOT use any file system modification tools (e.g., `write`, `edit`, `bash` for file creation) unless the user explicitly requests that the skill be written directly to the file system. If this request is made, complete the architectural design first, then transition to the implementation phase using the `create-skill` skill or appropriate scaffolding tools.

### Step 1: Intent Intake
Collect the high-level goal, target audience, and any initial sketches or "fuzzy" requirements. Identify the core value proposition of the skill.

### Step 2: Domain Analysis
Break down the goal into logical "branches" or decision trees. Use Mermaid diagrams to visualize these branches and the intended flow. Map the prerequisites and the intended end state. Determine what "success" looks like for this skill.

### Step 3: Collaborative Deterministic Translation Loop
For each branch identified in Step 2, translate the intent into a deterministic execution pattern.

1. **Map Intent**: Propose a specific, actionable translation. Replace ambiguous phrases (e.g., "be smart about errors") with concrete logic (e.g., "implement a try-catch-verify loop with a 3-retry limit").
2. **Collaborative Review**: Present the translation to the user and ask: *"Does this translation of your intent into deterministic actions accurately capture what you want the agent to do?"*
3. **Resolution Path**:
    - **If Acceptable**: Incorporate the change into the technical design and proceed to the next branch.
    - **If Unacceptable**: Ask the user to provide a more concrete idea or specific example of the desired behavior. Do not guess; iterate until the user provides a deterministic requirement.
4. **Iterative Resolution**: Resolve one intent/branch per turn to maintain precision and avoid batching errors.

### Step 4: Compliance Mapping
Organize the resolved deterministic logic into the mandatory skill schema:
- **Frontmatter**: Generate a concise `name` and `description`.
- **When to Use**: Define the precise triggers for the skill.
- **When Not to Use**: Define clear boundaries to prevent misuse.
- **Workflow**: Document the sequence of deterministic steps.
- **Validation**: Create a comprehensive validation section (as seen in this file) that allows future agents to verify their own adherence to the skill's instructions.

### Step 5: Final Review & Convergence
Present the final markdown content for the `SKILL.md` file as a single, clean Markdown code block. Verify that the design is:
- **Deterministic**: No "be smart" or "appropriately" language; every step is a concrete action.
- **Compliant**: All mandatory sections are present and formatted correctly.
- **Aligned**: The final design accurately reflects the validated user intent.

## Validation
To ensure the quality and determinism of the resulting skill, the agent must verify the following before presenting the final design:

- [ ] **Structural Integrity**: Does the skill contain all mandatory sections (Frontmatter, When to Use, When Not to Use, Workflow, Validation)?
- [ ] **Determinism Audit**: Scan the "Workflow" section for "fuzzy" language (e.g., "appropriately", "optimally", "where possible", "smartly"). Every step must be an actionable, deterministic instruction.
- [ ] **Collaborative Alignment**: Was every translation of "fuzzy" intent explicitly presented to the user and flagged as "Acceptable" before being committed to the design?
- [ ] **Constraint Adherence**: Did the agent refrain from using any file-writing tools unless specifically requested by the user to write to the file system?
- [ ] **Validation Utility**: Does the generated "Validation" section provide a concrete way for future agents to prove they have followed the skill's workflow correctly?
