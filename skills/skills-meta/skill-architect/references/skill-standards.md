# Skill Standards Reference

This document is the authoritative standards target for the Skill Architect workflow. It synthesises the repo's own `AGENTS.md` conventions with best practices from [agentskills.io](https://agentskills.io/skill-creation/best-practices). Use it as a checklist when validating a skill draft during Step 4 (Compliance Mapping) of the Skill Architect workflow.

A draft skill passes compliance only if it satisfies every section below. Each section defines what to look for and concrete pass/fail criteria. Each section also cites its source so the criteria can be re-verified against upstream material.

---

## 1. Required SKILL.md structure

A `SKILL.md` file must contain a specific set of structural elements. This is the mandatory schema; deviations cause skills to be rejected during review.

**Source:** `AGENTS.md` (Skill file conventions)

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

**Source:** `AGENTS.md` (Skill file conventions: "Workflow steps must be deterministic — no vague language")

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

**Source:** `AGENTS.md` (Skill conventions: Trigger shape)

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

Skill content is loaded into the LLM's context window. Every token in `SKILL.md` is paid for on every activation; content in `references/` and `assets/` is paid for only when loaded. Aim for moderate detail — enough to be useful, not enough to overwhelm.

**Source:** [agentskills.io — Spending context wisely](https://agentskills.io/skill-creation/best-practices#spending-context-wisely)

**Pass criteria (all must be true):**

- `SKILL.md` is under 500 lines (target ~50–200 for most skills).
- The skill adds information the agent would get wrong without it; it does not restate general LLM knowledge (e.g., explanations of what a PDF is, how HTTP works, or generic "Always be helpful" / "Think step by step" framing).
- Detailed content — templates ≥20 lines, long examples, exhaustive reference tables — lives in `references/` or `assets/`, not inlined in `SKILL.md`.
- A load-trigger sentence in `SKILL.md` tells the LLM when to load each `references/` file (e.g., "Read `references/api-errors.md` if the API returns a non-200 status code"), not a generic "see references/ for details."
- The skill is scoped to a coherent unit of work: narrowly enough to activate precisely, broadly enough that one task does not require loading several sibling skills.

**Fail criteria (any one fails the check):**

- `SKILL.md` exceeds 500 lines without justification.
- A long template (≥20 lines) is inlined in `SKILL.md` when it could be in `references/` or `assets/`.
- The skill restates general LLM behaviour rather than skill-specific guidance.
- A `references/` file is referenced from `SKILL.md` without a load-trigger sentence, or with a generic "see references/" pointer that gives the LLM no condition to recognise.
- The skill is scoped too narrowly (forces multiple skills to load for a single task) or too broadly (covers unrelated domains — e.g., querying a database AND administering it).

---

## 5. Calibrating control

The level of specificity in a skill should match the fragility of the task. Match the prescriptiveness of each part to the cost of getting it wrong.

**Source:** [agentskills.io — Calibrating control](https://agentskills.io/skill-creation/best-practices#calibrating-control)

**Pass criteria (all must be true):**

- For flexible instructions (multiple valid approaches, task tolerates variation), the skill explains *why* rather than prescribing exact steps — an agent that understands the purpose makes better context-dependent decisions.
- For fragile or destructive operations, the skill gives exact commands and forbids deviation (e.g., "Run exactly this sequence: `python scripts/migrate.py --verify --backup`. Do not modify the command or add additional flags.").
- Steps provide a single default with alternatives mentioned briefly, not a menu of equally-weighted options.
- The skill teaches the agent *how to approach* a class of problems (reusable method) rather than *what to produce* for one specific instance.
- The specificity of each step matches the cost of getting it wrong: irreversible or high-risk steps are detailed; low-risk steps can be terse.

**Fail criteria (any one fails the check):**

- A step presents multiple equally-weighted options without guidance on which to pick (e.g., "You can use pypdf, pdfplumber, PyMuPDF, or pdf2image...").
- A step that performs an irreversible action is described at the same level of detail as a read-only check.
- The skill provides a specific answer to one task without giving a reusable method (e.g., names exact column joins for a single query but no procedure for general analytical queries).
- A critical decision is left to LLM judgement when a specific rule or threshold would work.

---

## 6. Patterns for effective instructions

Several concrete patterns reliably improve skill quality. Use the ones that fit the task — not every skill needs all of them.

**Source:** [agentskills.io — Patterns for effective instructions](https://agentskills.io/skill-creation/best-practices#patterns-for-effective-instructions)

**Pass criteria (applicable patterns present):**

- **Gotchas section**: Environment-specific facts that defy reasonable assumptions are surfaced explicitly (e.g., "The `users` table uses soft deletes. Queries must include `WHERE deleted_at IS NULL` or results will include deactivated accounts."). Gotchas live in `SKILL.md` where the agent reads them before encountering the situation; a separate reference file works only if a load trigger tells the agent when to read it.
- **Templates for output format**: When the skill produces structured output, a template with placeholders is provided. Short templates inline in `SKILL.md`; long templates in `assets/` or `references/` with a load trigger.
- **Checklists for multi-step workflows**: Workflows with more than three steps include an explicit checklist (`- [ ] Step N: ...`) so the agent can track progress and avoid skipping steps, especially when steps have dependencies or validation gates.
- **Validation loops**: Steps that depend on a prior step's output include an explicit verification (re-read, compare, assert, or run a validator script) before proceeding, and iterate until validation passes.
- **Plan-validate-execute**: For batch or destructive operations, the workflow creates an intermediate plan in a structured format, validates it against a source of truth (a validator script, a schema, a reference document), and only then executes.

**Fail criteria (any one fails the check when applicable):**

- A known gotcha (something the agent will get wrong without being told) is buried in prose, missing, or hidden behind a load trigger the agent cannot recognise.
- A skill that produces structured output has no template for it.
- A multi-step workflow's **Validation** section is missing, is a single vague sentence, or lacks a checklist.
- A step whose output feeds into a later step has no verification before the dependency is consumed.
- A batch or destructive operation runs without a validated intermediate plan.

---

## 7. Load trigger convention

When a skill moves content from `SKILL.md` into `references/`, the LLM must be told when to load that file. Without a load-trigger sentence, the file becomes orphaned context that is never read.

**Source:** `AGENTS.md` (Skill conventions: Templates); agentskills.io — Spending context wisely (progressive disclosure)

**Pass criteria (all must be true):**

- Every `references/` file referenced from `SKILL.md` has a corresponding load-trigger sentence.
- Each load-trigger sentence has two parts: a clear condition (when to load) and the file path (what to load).
- The load trigger follows the pattern: "Before [action], load `references/X.md`." or "When [condition], load `references/X.md`."
- The condition is specific enough that the LLM only loads the file when its content is needed (e.g., "Read `references/api-errors.md` if the API returns a non-200 status code" — not "see references/ for details").

**Fail criteria (any one fails the check):**

- A `references/` file exists but is not mentioned in `SKILL.md`.
- A load-trigger sentence has no condition (e.g., "Load the references file" with no `before/when` clause).
- The condition is unconditional (e.g., "Always load `references/X.md`" — defeats the purpose of progressive disclosure).
- The file path in the trigger does not match an actual file in `references/`.

---

## Attribution

Sections 4–6 of this document are grounded in the [agentskills.io best-practices resource](https://agentskills.io/skill-creation/best-practices) (Spending context wisely, Calibrating control, Patterns for effective instructions). Sections 1–3 and 7 draw from this repo's `AGENTS.md` skill conventions; section 7 also references the agentskills.io guidance on progressive disclosure.

Derived content from agentskills.io is used under the upstream MIT licence.
