---
name: skill-architect
description: Guides users through the design, refinement, and deterministic translation of a new agent skill, ensuring compatibility with project standards without performing file system writes.
---

# Skill Architect

The Skill Architect is an intellectual design phase for creating agent skills. It transforms "fuzzy" user intents into deterministic execution patterns, ensuring the resulting skill is precise, compliant, and implementable by an LLM.

## When to Use
- When you have a high-level goal for a new skill but no concrete workflow.
- When you need to refine ambiguous agent behaviors into deterministic steps.
- When you want to ensure a new skill adheres to the project's mandatory structure and standards.
- When converting vague goals into a technical design before shifting to implementation.

## When Not to Use
- For trivial changes to existing skills.
- When you already have a complete, finalized PRD or specification.
- When the primary goal is actual file system scaffolding (use `create-skill` instead).
- When the task is a simple code fix or refactor.

## Workflow

**Tooling Constraint**: This skill is an architectural phase. You MUST NOT use any file system modification tools (e.g., `write`, `edit`, `bash` for file creation) during this process. All outputs must be presented as text/markdown in the conversation.

### Step 1: Intent Intake
Collect the high-level goal, target audience, and any initial sketches or "fuzzy" requirements. Identify the core value proposition of the skill.

### Step 2: Domain Analysis
Break down the goal into logical "branches" or decision trees. Use Mermaid diagrams to visualize these branches and the intended flow. Map the prerequisites and the intended end state. Determine what "success" looks like for this skill.

### Step 3: Deterministic Translation Loop
For each branch identified in Step 2, translate the intent into a deterministic execution pattern.
1. **Map Intent**: Propose a specific, actionable step (e.g., replace "be smart about errors" with "implement a try-catch-verify loop with a 3-retry limit").
2. **Approval Gate**: If the translation involves an interpretation of ambiguous intent:
    - Propose the translation clearly.
    - **Ask for explicit approval**.
    - If approved, commit the step to the design.
    - If rejected, seek further guidance to refine the translation.
3. **Iterative Resolution**: Resolve one intent/branch per turn to maintain precision and avoid batching errors.

### Step 4: Compliance Mapping
Organize the resolved deterministic logic into the mandatory skill schema:
- **Frontmatter**: Generate a concise `name` and `description`.
- **When to Use**: Define the precise triggers for the skill.
- **When Not to Use**: Define clear boundaries to prevent misuse.
- **Workflow**: Document the sequence of deterministic steps.
- **Validation**: Create a checklist to verify the skill's output.

### Step 5: Final Review & Convergence
Present the final markdown content for the `SKILL.md` file as a single, clean Markdown code block. Verify that the design is:
- **Deterministic**: No "be smart" or "appropriately" language; every step is a concrete action.
- **Compliant**: All mandatory sections are present and formatted correctly.
- **Aligned**: The final design accurately reflects the validated user intent.

## Validation
- [ ] Does the skill have mandatory frontmatter (name, description)?
- [ ] Are the "When to Use" and "When Not to Use" sections distinct and clear?
- [ ] Is the workflow composed of deterministic, non-ambiguous steps?
- [ ] Does the skill avoid performing direct file system writes (remaining an architect tool)?
- [ ] Was the translation of fuzzy goals explicitly approved by the user?
