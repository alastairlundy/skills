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

By default, this skill operates entirely within the conversation. You must draft the skill's design and present it as markdown text — do not save to disk. The user can opt in to saving by indicating any clear intent to save (e.g., "save it now", "yes write it", or equivalent). If the user opts in, complete the architectural design first, then load `references/saving-the-skill.md` and follow the save procedure there.

## Workflow

### Step 0: Load the design-ledger reference

Before the first user question, load `references/decision-ledger.md` in
full. This file is the own copy of the Decision Ledger standard for
`skill-architect`; it documents the `Dxxx` and `Ixxx` record formats,
the sentinel-bump mechanics, the TBD placeholder pattern, and the
`<target-skill-dir>/.design-ledger.md` lifecycle. The file ships with
uninitialized sentinels (`next-d: D001`, `next-i: I001`) so each new
skill design is self-bootstrapping. Apply the formats from this file
verbatim throughout the session.

If `references/decision-ledger.md` is missing or unreadable, abort the
session and report the missing file to the user.

### Step 1: Intent Intake
Collect the high-level goal, target audience, and any initial sketches or "vague" requirements. Before beginning, announce the output mode as a two-part opener:

(a) **Opener (recommended, can be rephrased or omitted)**: a sentence announcing the SKILL is being drafted, e.g. *"Drafting the SKILL content for [purpose XYZ]."*

(b) **Scope declaration (mandatory, verbatim)**: the exact sentence *"File creation is in scope."* or *"File creation is out of scope."*

If file creation is out of scope, follow with a one-line prompt — e.g. *"Tell me if you want the skill saved to a SKILL file after the design is resolved."*

The scope declaration itself is a clarifying interaction. Before
emitting the verbatim scope declaration, append a fresh `Ixxx` record
to the design ledger using the Ixxx record template from
`references/decision-ledger.md`. The `Prompt` field captures the
verbatim scope declaration text. The other three fields
(`User Response`, `Resolution`, `Notes`) are set to the literal string
`TBD`. Bump the `<!-- next-i: Ixxx -->` sentinel atomically with the
append.

If file creation is out of scope, the Ixxx is still recorded — the
follow-up prompt ("Tell me if you want the skill saved...") is
captured as a separate clarifying interaction. If the user does not
ask for a save at this point, the Ixxx is completed in place with
`User Response = "no save requested"` and `Resolution = "skipped file
creation; design remains in conversation"`.

If the target skill directory is known at this point (e.g., the user
has already named a target path), initialize the design ledger at
`<target-skill-dir>/.design-ledger.md` with the file-format header
(Dxxx record template, Ixxx record template, lifecycle/storage notes,
and the two trailing sentinels `next-d: D001` and `next-i: I001`).
The directory may not yet exist — defer the file creation until the
directory exists, on the first real append at the latest. The hidden
filename (`.design-ledger.md`) keeps the file out of casual listings
during the design phase; it is deleted on materialization per the
lifecycle in `references/decision-ledger.md` and per
`saving-the-skill.md` Step 8.

The agent must collect four explicit elements:
- (a) the **goal**,
- (b) the **target audience**,
- (c) the **trigger context** (when this skill should and should not fire),
- (d) **one concrete example of the desired behaviour OR a description of the desired output's shape**.

Before collecting the four explicit elements, append a fresh `Dxxx`
record to the design ledger using the goal record template from
`references/decision-ledger.md` (Driver / Resolved Answer / Normalized
Requirement / Constraints). Bump the `<!-- next-d: Dxxx -->` sentinel
atomically with the append. The `Dxxx` is the foundational goal
record for the design session. Subsequent structural decisions in
Steps 2–4 reference this record.

Each clarifying question the agent asks while collecting the four
elements (the goal-clarification question, the trigger-context
question, the example-or-output-shape question) is itself a
clarifying interaction. Before emitting each question, append a fresh
`Ixxx` record with `Prompt` set to the verbatim question text and the
other three fields set to `TBD`. After the user answers, complete the
`Ixxx` in place by filling the three `TBD` fields with the user's
verbatim response, the resolution, and any cross-references or
non-load-bearing context. Read-back to confirm the `Ixxx` is in its
expected position in the file and the three fields are now filled.
Do not amend the `Prompt` field. Do not create a second `Ixxx` for the
same interaction. Do not move the `Ixxx` in the file.

A fifth element, the **value proposition**, shall be inferred by the agent from the goal and audience. The value prop is a design input that shapes the description, the When to Use scenarios, and the When Not to Use scenarios of the designed skill. The agent shall ask the user about it only if the inference is unclear or ambiguous. If the agent does ask, the question is a clarifying interaction and is recorded as an `Ixxx` per the same append/complete pattern.

The completion criterion is: all four explicit elements are captured; the workflow advances only when the user has provided an example or a description of the desired output's shape. An anti-example (what the skill should NOT do) is not a substitute for either.

### Step 2: Domain Analysis
Break down the goal into logical "branches" or decision trees. Use a Mermaid diagram to visualize the branches and intended flow when the skill has three or more branches, two or more decision points, or any non-linear flow. For simpler skills, prose decomposition is sufficient. Map the prerequisites and the intended end state. Determine what "success" looks like for this skill.

Each structural branch decision in Step 2 (e.g., "this skill has
three branches", "the prerequisite is X", "success is the agent
emitting a structured markdown file") is recorded as a `Dxxx` record
in the design ledger using the Dxxx record template from
`references/decision-ledger.md`. Bump the
`<!-- next-d: Dxxx -->` sentinel atomically with each append. If the
agent asks the user a clarifying question to disambiguate a branch
shape (e.g., "is this skill one-shot or looped?"), record the question
as an `Ixxx` per the same append/complete pattern as Step 1.

### Step 3: Collaborative Deterministic Translation Loop
For each branch identified in Step 2, translate the intent into a deterministic execution pattern.

1. **Map Intent**: Propose a specific, actionable translation. Replace ambiguous phrases (e.g., "be smart about errors") with concrete logic (e.g., "implement a try-catch-verify loop with a 3-retry limit").
2. **Collaborative Review**: Ask the user, verbatim: *"Does this translation of your intent into deterministic actions accurately capture what you want the agent to do?"* The verbatim review question is a clarifying interaction. Before emitting it, append a fresh `Ixxx` record to the design ledger with `Prompt` set to the verbatim question text and the other three fields set to `TBD`. The user must respond with one of three values, verbatim: *"Accept AS IS"*, *"Requires Modifications"*, or *"Reject"*.
   - On **Accept AS IS**: complete the `Ixxx` in place with `User Response = "Accept AS IS"`, the resolution (which branch the acceptance confirmed), and any non-load-bearing context. Append a fresh `Dxxx` record to the design ledger using the Dxxx record template (`Driver` = the underlying principle that motivated the translation, `Resolved Answer` = the verbatim "Accept AS IS" response, `Normalized Requirement` = the deterministic translation that was accepted, `Constraints` = any scope boundaries the user named). Bump the `<!-- next-d: Dxxx -->` sentinel atomically. Proceed to the next branch.
   - On **Requires Modifications**: complete the `Ixxx` in place with `User Response = "Requires Modifications"`, the verbatim modification request, and the resolution (the agent will re-ask the verbatim question after applying the modifications). After applying the modifications, append a fresh `Ixxx` record for the re-ask with `Prompt` set to the verbatim re-ask question and the other three fields set to `TBD`. The accepted final response produces a `Dxxx` record on Accept AS IS, not before.
   - On **Reject**: complete the `Ixxx` in place with `User Response = "Reject"`, the user's rejection reasoning, and the resolution (the next-step choice the agent will surface). Append a `Dxxx` record only if the rejection resolved to a concrete decision (e.g., "exit the workflow with no further action"); otherwise the Ixxx itself is the durable record.
3. **Iterative Resolution**: Resolve one intent/branch per turn to maintain precision and avoid batching errors.

### Step 4: Compliance Mapping
Before performing compliance checks, load `references/skill-standards.md` to obtain the authoritative standards target.

Each compliance-mapping decision (which always-present sections to include, which conditional sections to include, what character limits to enforce, what value-proposition wording to weave in) is recorded as a `Dxxx` record in the design ledger using the Dxxx record template from `references/decision-ledger.md`. Bump the `<!-- next-d: Dxxx -->` sentinel atomically with each append. If the agent asks the user a clarifying question during compliance mapping (e.g., "do you want an Output Mode section?"), record the question as an `Ixxx` per the same append/complete pattern as Step 1.

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

Once the checks pass, ask the user: *"Have we reached a deterministic design?"* The verbatim convergence question is a clarifying interaction. Before emitting it, append a fresh `Ixxx` record to the design ledger with `Prompt` set to the verbatim question text and the other three fields set to `TBD`. After the user answers, complete the `Ixxx` in place with `User Response` (the verbatim yes/no equivalent), `Resolution` (the step the agent will re-open, or "convergence declared"), and any non-load-bearing context. If the user answers "no" or equivalent, re-open the appropriate earlier step — Step 2 for a domain-analysis issue, Step 3 for a translation issue, or Step 4 for a schema or compliance issue — and continue from there. The convergence `Ixxx` is not closed until the user answers "yes" or equivalent.

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
- [ ] **Constraint Adherence**: Did the agent refrain from saving the design to file by default? If the user indicated intent to save, did the agent follow the save procedure? Did the agent announce the output mode at the start of Step 1?
- [ ] **Validation Utility**: Does every item in the generated Validation section name a specific pass/fail condition (yes/no) that an agent can determine from the design alone? This check covers per-validation-item verifiability only; per-step verifiability is the scope of the Determinism Audit above.
- [ ] **Design ledger initialized**: Was `references/decision-ledger.md` loaded in full before the first user question, and was `<target-skill-dir>/.design-ledger.md` initialized with the file-format header and the two trailing sentinels `next-d: D001` and `next-i: I001` (or lazily on the first real append if the target skill directory did not yet exist)?
- [ ] **Dxxx records appended at structural decisions**: Was every structural design decision (Step 1 goal record, Step 2 branch shapes, Step 3 accepted translations, Step 4 schema-presence choices, any re-opens with `Supersedes: Dxxx` lines) recorded as a fresh `Dxxx` record in the design ledger, with a verbatim `Resolved Answer`, a `Driver` field capturing the user's underlying principle, a testable `Normalized Requirement`, and any `Constraints` the user named? Each append bumped the `<!-- next-d: Dxxx -->` sentinel atomically.
- [ ] **Ixxx records appended at clarifying interactions**: Was every clarifying interaction (the scope declaration, each of the four explicit elements in Step 1, the value-proposition clarification when asked, the verbatim review question in Step 3, the re-ask when Requires Modifications, the Step 5 convergence question, any clarifying questions in Steps 2 and 4) recorded as a fresh `Ixxx` record before the prompt was presented, with `Prompt` filled and the other three fields (`User Response`, `Resolution`, `Notes`) set to `TBD`? Each append bumped the `<!-- next-i: Ixxx -->` sentinel atomically. After the user responded, the `Ixxx` was completed in place by filling the three `TBD` fields. No `Ixxx` was amended in `Prompt`, moved in the file, or duplicated for the same interaction.
