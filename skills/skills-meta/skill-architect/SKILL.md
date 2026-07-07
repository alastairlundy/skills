---
name: skill-architect
description: >-
  Guides users through the design, refinement, and deterministic translation of a new agent skill, ensuring the design follows established agent-skill conventions without performing file system writes. Use when creating or designing a new skill. Do not use when making minor tweaks to existing skills.
license: MIT
---

# Skill Architect

The Skill Architect is an intellectual design phase for creating agent skills. It transforms "vague" user intents into deterministic execution patterns, ensuring the resulting skill is precise, compliant, and implementable by an LLM.

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

## Output Mode

**You MUST NOT use any file system modification tools** (e.g., `write`, `edit`, `bash` for file creation) unless the user explicitly requests that the skill be written directly to the file system. By default, this skill operates entirely within the conversation. You must draft the skill's design and present it as markdown text. If the user requests file creation, complete the architectural design first, then load `references/saving-the-skill.md` and follow the save procedure there.

## Workflow

### Step 1: Intent Intake
Collect the high-level goal, target audience, and any initial sketches or "vague" requirements. Before beginning, announce the active output mode in plain language — e.g. *"Drafting the SKILL content for [purpose XYZ]. File creation is out of scope."* — and, if file creation is out of scope, follow with a one-line prompt — e.g. *"Tell me if you want the skill saved to a SKILL file after the design is resolved."*

The agent must collect four explicit elements:
- (a) the **goal**,
- (b) the **target audience**,
- (c) the **trigger context** (when this skill should and should not fire),
- (d) **one concrete example of the desired behaviour OR a description of the desired output's shape**.

A fifth element, the **value proposition**, shall be inferred by the agent from the goal and audience. The value prop is a design input that shapes the description, the When to Use scenarios, and the When Not to Use scenarios of the designed skill. The agent shall ask the user about it only if the inference is unclear or ambiguous.

The completion criterion is: all four explicit elements are captured; the workflow advances only when the user has provided an example or a description of the desired output's shape. An anti-example (what the skill should NOT do) is not a substitute for either.

### Step 2: Domain Analysis
Break down the goal into logical "branches" or decision trees. Use a Mermaid diagram to visualize the branches and intended flow when the skill has three or more branches, two or more decision points, or any non-linear flow. For simpler skills, prose decomposition is sufficient. Map the prerequisites and the intended end state. Determine what "success" looks like for this skill.

### Step 3: Collaborative Deterministic Translation Loop
For each branch identified in Step 2, translate the intent into a deterministic execution pattern.

1. **Map Intent**: Propose a specific, actionable translation. Replace ambiguous phrases (e.g., "be smart about errors") with concrete logic (e.g., "implement a try-catch-verify loop with a 3-retry limit").
2. **Collaborative Review**: Ask the user, verbatim: *"Does this translation of your intent into deterministic actions accurately capture what you want the agent to do?"* The user must respond with one of three values, verbatim: *"Accept AS IS"*, *"Requires Modifications"*, or *"Reject"*.
   - On **Accept AS IS**: proceed to the next branch.
   - On **Requires Modifications**: ask the user what modifications they want made, apply them, and re-ask the verbatim question for the same branch.
   - On **Reject**: ask the user to choose: (i) start the design over with different skill-design constraints or notes recorded for the next attempt, or (ii) exit the workflow with no further action or artefact.
3. **Iterative Resolution**: Resolve one intent/branch per turn to maintain precision and avoid batching errors.

### Step 4: Compliance Mapping
Before performing compliance checks, load `references/skill-standards.md` to obtain the authoritative standards target.

Organize the resolved deterministic logic into the mandatory skill schema. Five sections are always present; two sections are conditional — include them only when the design needs them:

**Always-present sections:**
- **Frontmatter**: Generate a `name` (≤ 50 characters, hard limit) and a `description` (≤ 500 characters hard limit; < 350 characters is a soft target; using `>-` block-fold syntax). These limits are project-local (tighter than the Waza eval convention of description ≤ 1024 characters). The `license` field is included only if the user has confirmed a license; otherwise the field is omitted.
- **When to Use**: Define the precise triggers for the skill as a bulleted list of trigger branches.
- **When Not to Use**: Define clear boundaries to prevent misuse as a bulleted list of out-of-scope branches.
- **Workflow**: Document the sequence of deterministic steps, each with a completion criterion.
- **Validation**: Create a comprehensive validation section with checkable items, each a yes/no pass/fail condition.

**Value Proposition Distribution**: Take the value prop collected in Step 1 and weave it across the three output fields — (a) the `description` frontmatter field (a concise "what & why" statement), (b) the When to Use section (scenarios where the skill is valuable), and (c) the When Not to Use section (scenarios where the skill is not). The description may approach the 500-character hard limit (per the Frontmatter character limits above) when the value prop is woven in — this is expected, not a regression.

**Conditional sections (include only when the trigger condition applies):**
- **Output Mode**: Include when the design has a non-default output behaviour (i.e., the design intentionally deviates from the default of "draft in conversation, optionally save").
- **Transitions**: Include when the design depends on a downstream tool or skill (e.g., `waza-skill-evaluator`, `saving-the-skill.md`, or any other named dependency).

### Step 5: Final Review & Convergence
Present the final markdown content for the `SKILL.md` file as a single, clean Markdown code block. Verify that the design is:
- **Deterministic**: No vague language; every step is a concrete action.
- **Compliant**: All mandatory sections are present and formatted correctly.
- **Aligned**: The final design accurately reflects the validated user intent.

Once the checks pass, ask the user: *"Have we reached a deterministic design?"* If the user answers "no" or equivalent, re-open the appropriate earlier step — Step 2 for a domain-analysis issue, Step 3 for a translation issue, or Step 4 for a schema or compliance issue — and continue from there.

## Transitions

After convergence, the downstream chain is:
1. **`references/saving-the-skill.md`** — the procedure for writing the designed skill to disk (directory confirmation, name validation, license confirmation, write, optional eval stub, post-write validation).
2. **waza-skill-evaluator** — generates the Waza Eval Suite (eval.yaml + tasks/ + fixtures/).
3. **waza-skill-evaluator** — runs a baseline evaluation to verify the skill works end-to-end (Phase 1: generate the suite; Phase 2: run baseline).

This is the default chain. The user may override per environment.

## Validation
To ensure the quality and determinism of the resulting skill, the agent must verify the following before presenting the final design:

- [ ] **Structural Integrity**: Does the skill contain the 5 always-present sections (Frontmatter, When to Use, When Not to Use, Workflow, Validation)? The 2 conditional sections (Output Mode, Transitions) are required only when their trigger condition applies — Output Mode is required if the design has a non-default output behaviour; Transitions is required if the design depends on a downstream tool or skill.
- [ ] **Determinism Audit**: Every workflow step must (a) start with a verb, (b) name a concrete action, and (c) end with a specific completion signal — for example, a returned value, a check result, a state change, a file produced, or an equivalent named artefact. If a step fails any of (a)–(c), rewrite it.
- [ ] **Collaborative Alignment**: Was every translation of vague intent explicitly presented to the user, confirmed via the verbatim review question with Accept AS IS / Requires Modifications / Reject, and resolved through the appropriate follow-up flow?
- [ ] **Constraint Adherence**: Did the agent refrain from using any file-writing tools unless specifically requested by the user to write to the file system? Did the agent announce the output mode at the start of Step 1?
- [ ] **Validation Utility**: Does every item in the generated Validation section name a specific pass/fail condition (yes/no) that an agent can determine from the design alone? This check covers per-validation-item verifiability only; per-step verifiability is the scope of the Determinism Audit above.
