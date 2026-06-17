# Skill Standards Reference

This document is the authoritative standards target for the Skill Architect workflow. It synthesises the repo's own `AGENTS.md` conventions with broader best practices for writing agent skills. Use it as a checklist when validating a skill draft during Step 4 (Compliance Mapping) of the Skill Architect workflow.

A draft skill passes compliance only if it satisfies every section below. Each section defines what to look for and concrete pass/fail criteria.

---

## 1. Required SKILL.md structure

A `SKILL.md` file must contain a specific set of structural elements. This is the mandatory schema; deviations cause skills to be rejected during review.

**Pass criteria (all must be true):**

- The file begins with a level-1 heading (`# <Skill Name>`) matching the `name` field in the frontmatter.
- The file has YAML frontmatter delimited by `---` lines containing exactly these keys:
  - `name` — short, slug-style identifier.
  - `description` — written using YAML block-fold syntax (`>-`); describes what the skill does and when to use it.
  - `license: MIT` — present verbatim.
- The body has these four sections in this order: **When to Use**, **When Not to Use**, **Workflow**, **Validation**.
- The "When to Use" section is a bulleted list (not prose).
- The "When Not to Use" section exists and lists explicit anti-scenarios.

**Fail criteria (any one fails the check):**

- Missing frontmatter, missing any of the four required sections, or sections in the wrong order.
- `description` written as a plain string or a folded-but-misquoted block (must use `>-`).
- "When to Use" written as a single paragraph or as numbered steps instead of bullets.
- "When Not to Use" missing, or written as a vague "use other skills instead" sentence.

---

## 2. Determinism rules

Workflow steps must be concrete, actionable instructions an LLM can execute without judgement. Vague language is a defect because it forces the LLM to invent behaviour, which is exactly what skill authoring is meant to prevent.

**Pass criteria (all must be true):**

- Every workflow step names a specific action, tool, input, or output.
- Steps are written in imperative voice ("Run X", "Compare Y to Z", "Return W") — not descriptive ("This step is about X").
- Steps have an unambiguous success condition (the LLM can tell when the step is complete).

**Fail criteria (any one fails the check):**

- Any occurrence of vague language: "be smart", "as appropriate", "optimally", "where possible", "appropriately", "smartly", "judiciously", "as needed", "try to", "consider doing".
- A step that describes a goal without a procedure (e.g., "Make sure the output is good").
- A step whose success condition requires subjective judgement ("looks reasonable", "is clean").

---

## 3. Trigger discipline

Skills activate conditionally. The "When to Use" list is the contract with the LLM about when this skill applies. Unconditional triggers (e.g., "applies by default") cause the skill to compete with task-specific skills for context on every step, diluting the LLM's effective context.

**Pass criteria (all must be true):**

- The "When to Use" bullets describe specific, recognisable scenarios the LLM can detect from user input.
- Each bullet uses a "When you need to..." or "When [condition]..." framing tied to an observable cue.
- If the workflow may need user clarification, at least one bullet explicitly invokes the `ask-questions` skill.
- No bullet uses unconditional language: "applies by default", "always use this", "use on every turn", "use for all tasks".

**Fail criteria (any one fails the check):**

- Any bullet phrased as an unconditional trigger.
- A bullet whose scenario is too generic to be a reliable activation signal (e.g., "When you want a good result").
- Missing `ask-questions` bullet when the workflow contains any decision point that depends on user preference.

---

## 4. Context budget discipline

Skill content is loaded into the LLM's context window. Every line in `SKILL.md` is paid for on every activation; content in `references/` is paid for only when loaded. Aim for moderate detail — enough to be useful, not enough to overwhelm.

**Pass criteria (all must be true):**

- `SKILL.md` is under 500 lines (target ~50–200 for most skills).
- The skill adds information the agent does not already have; it does not restate general LLM knowledge.
- Detailed content (templates ≥20 lines, long examples, exhaustive reference tables) lives in `references/`, not in `SKILL.md`.
- A load-trigger sentence in `SKILL.md` tells the LLM when to load each `references/` file.

**Fail criteria (any one fails the check):**

- `SKILL.md` exceeds 500 lines without justification.
- A long template (≥20 lines) is inlined in `SKILL.md` when it could be in `references/`.
- The skill restates general LLM behaviour ("Always be helpful", "Think step by step") rather than skill-specific guidance.
- A `references/` file is referenced from `SKILL.md` without a load-trigger sentence.

---

## 5. Calibrating control

The level of specificity in a skill should match the fragility of the task. A skill with high blast radius (irreversible actions, ambiguous interpretation) needs step-by-step procedures; a skill with low blast radius (read-only exploration) can give general direction.

**Pass criteria (all must be true):**

- Steps provide defaults, not menus: a single recommended action is given rather than a list of options the LLM must choose between.
- Steps favour procedures (numbered, with inputs and outputs) over declarations (statements of intent).
- The specificity of each step matches the cost of getting it wrong: irreversible or high-risk steps are detailed; low-risk steps can be terse.
- The skill does not delegate critical decisions to the LLM's discretion when a deterministic answer exists.

**Fail criteria (any one fails the check):**

- A step presents multiple equally-weighted options without guidance on which to pick.
- A step that performs an irreversible action is described at the same level of detail as a read-only check.
- A critical decision is left to LLM judgement when a specific rule or threshold would work.

---

## 6. Patterns for effective instructions

Several concrete patterns reliably improve skill quality. Use them where applicable.

**Pass criteria (applicable patterns present):**

- **Gotchas section**: If the skill has known pitfalls (common mistakes, edge cases that trip agents up), they are surfaced explicitly, not buried in prose.
- **Output templates**: If the skill produces structured output, a template (with placeholders) is provided in `references/` if long, inline if short.
- **Checklists for multi-step workflows**: Workflows with more than three steps include a checklist in the **Validation** section so a future agent can verify adherence.
- **Validation loops**: Steps that depend on a prior step's output include an explicit verification (re-read, compare, assert) before proceeding.
- **Plan-validate-execute**: For non-trivial tasks, the workflow includes an explicit plan or design step, a validation of that plan, and only then an execution step.

**Fail criteria (any one fails the check when applicable):**

- A skill that frequently causes agents to fail (known gotcha) has no explicit gotchas section.
- A skill that produces structured output has no template for it.
- A multi-step workflow's **Validation** section is missing or is a single vague sentence.
- A step whose output feeds into a later step has no verification before the dependency is consumed.

---

## 7. Load trigger convention

When a skill moves content from `SKILL.md` into `references/`, the LLM must be told when to load that file. Without a load-trigger sentence, the file becomes orphaned context that is never read.

**Pass criteria (all must be true):**

- Every `references/` file referenced from `SKILL.md` has a corresponding load-trigger sentence.
- Each load-trigger sentence has two parts: a clear condition (when to load) and the file path (what to load).
- The load trigger follows the pattern: "Before [action], load `references/X.md`." or "When [condition], load `references/X.md`."
- The condition is specific enough that the LLM only loads the file when its content is needed.

**Fail criteria (any one fails the check):**

- A `references/` file exists but is not mentioned in `SKILL.md`.
- A load-trigger sentence has no condition (e.g., "Load the references file" with no `before/when` clause).
- The condition is unconditional (e.g., "Always load `references/X.md`" — defeats the purpose of progressive disclosure).
- The file path in the trigger does not match an actual file in `references/`.

---

## Attribution

Sections 4–6 of this document synthesise best-practice guidance from the [agentskills.io](https://agentskills.io) best-practices resource. Sections 1–3 and 7 draw from this repo's `AGENTS.md` skill conventions.
