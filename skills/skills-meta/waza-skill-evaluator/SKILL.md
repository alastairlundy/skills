---
name: waza-skill-evaluator
description: >-
  Rigorously evaluate, benchmark, and diagnose the performance and discoverability of agent skills
  using the Waza CLI. Use this skill whenever you need to verify a skill's correctness, measure its
  "lift" over a baseline, analyze trigger accuracy (discoverability), or generate a comprehensive
  diagnostic report with actionable improvement prescriptions.          
compatibility: waza CLI required (github.com/microsoft/waza)
license: MIT
---

# Waza Skill Evaluator

The Waza Skill Evaluator acts as a **Diagnostic Advisor**. Its primary purpose is to provide high-fidelity Verification & Validation (V&V) of a skill's effectiveness using the Waza CLI for execution, aggregation, and visualization.

**CRITICAL BOUNDARY**: You are an advisor, not an editor. You provide the diagnosis and the "prescription" (proposed code snippets), but you MUST NOT apply edits to the target skill's `SKILL.md` yourself. Your goal is to surface exactly why a skill is failing and how to fix it, leaving the implementation to the user or a creation-specific agent.

## When to Use

- When you need to evaluate a skill's correctness and measure its "lift" over a baseline (no-skill or alternative skill).
- When you need to analyze a skill's trigger accuracy (discoverability) — whether it triggers when it should and doesn't trigger when it shouldn't.
- When you need to generate a comprehensive diagnostic report with actionable improvement prescriptions.
- When you want to compare two skill versions or two different skills side-by-side.
- When you need to validate that a skill's evaluation suite is comprehensive and well-structured.
- When you are about to ask the user a clarifying question about which model, executor, or output target to use, load the `ask-questions` skill first.

## When Not to Use

- When you need to create or scaffold a new skill (use `skill-architect` or `create-skill` instead).
- When you need to apply edits to a skill's SKILL.md (this skill only diagnoses and prescribes).
- When the target skill does not have a Waza-compatible evaluation suite (you must generate one first).
- When you need to run arbitrary code tests or unit tests unrelated to skill evaluation.
- When you only need a one-shot compliance/quality check on a single skill — use `waza check` or `waza quality` directly instead.

## Workflow

Proceed through these five phases methodically. Do not skip phases or execute them out of order.

### Phase 0: Prerequisites

Before starting any evaluation, verify that the Waza CLI is installed and supports the required features.

1. **Check for Waza CLI**: Execute `waza version` in the shell. If it fails, fall back to `waza --version`.
2. **If Waza is not installed**:
   - Inform the user that the Waza CLI is required for this evaluation.
   - Present the installation instructions from <https://github.com/microsoft/waza>. Native PowerShell: `irm https://raw.githubusercontent.com/microsoft/waza/main/install.ps1 | iex`.
   - Ask the user for **explicit permission** before downloading or installing anything. Do not proceed with installation until the user confirms.
   - After installation, re-run `waza version` to confirm success.
3. **Verify version features**: Confirm that the installed Waza version supports the features required by Phases 2 and 3:
   - `waza run --baseline` (enables lift measurement).
   - `waza run --context-dir` and `--output` (capturing results JSON and pointing to the fixtures directory).
   - The `config.inject_skill_body: false` field in `eval.yaml` (required for trigger-precision evals).
   - `waza compare <result-A> <result-B>` (side-by-side comparison).
   - `waza new eval <skill-name>` and `waza suggest <skill-path>` (suite scaffolding).
   - If any feature is missing, run `waza update` (after obtaining user permission) to upgrade, and re-verify.

### Phase 1: Suite Validation

Before running any evaluations, ensure a valid Waza evaluation suite exists for the target skill.

1. **Check for Waza eval format**: Verify that the target skill directory contains:
   - An `eval.yaml` (or `eval.yml`) file (the evaluation configuration).
   - A `tasks/` directory (containing individual task definitions referenced by a glob or by `tasks_from`).
   - A `fixtures/` directory (containing test inputs and expected outputs).
   - The eval spec must reference tasks via `tasks:` (glob list) or `tasks_from:` (external file).
2. **If the eval suite is missing or inadequate**:
   - Reference `references/eval-generation.md` for guidance on creating a comprehensive evaluation suite.
   - Guide the user through the eval generation process:
     - Use `waza new eval <skill-name>` to scaffold a new evaluation structure (creates `eval.yaml` plus positive/negative trigger task files).
     - Use `waza suggest <skill-path> --apply` to generate AI-suggested eval artifacts (eval.yaml + tasks + fixtures) from the skill's `SKILL.md`. Use `--dry-run` to preview first.
     - Use `waza new task from-prompt "<prompt>" <task-path>` to record a real Copilot session and convert it into a task YAML with inferred validators.
   - Review the generated eval suite with the user and ensure it covers:
     - **Performance evals**: Tasks that measure the quality of the skill's output (graded by `code`, `regex`, `file`, `diff`, `behavior`, `prompt`, etc.).
     - **Trigger evals**: Tasks that measure whether the skill triggers correctly (both positive and negative cases). Use the `trigger` grader or `action_sequence` / `skill_invocation` graders.
3. **User approval**: Do not proceed to Phase 2 until the user explicitly approves the validated evaluation suite. Present the suite structure and task count to the user for confirmation.

### Phase 2: Performance Evaluation (The "Lift" Measurement)

Measure the correctness and quality of the skill's output using Waza's baseline comparison capabilities.

1. **Default baseline (lift measurement)**:
   - Execute `waza run --baseline -o results.json` in the target skill directory. You can also target a specific skill by name: `waza run <skill-name> --baseline -o results.json`.
   - This runs each task twice: once without the skill (baseline) and once with the skill loaded (treatment).
   - Waza automatically computes the "lift" — the improvement in output quality when the skill is used.
   - For per-task coverage reports, also consider `waza coverage <root>` (full / partial / missing) as a complement to running the suite.
2. **A/B comparison (alternative baseline)**:
   - If the user wants to compare two skill versions or two different skills:
     - Run `waza run <skill-A> --output a.json` to evaluate skill A.
     - Run `waza run <skill-B> --output b.json` to evaluate skill B.
     - Run `waza compare a.json b.json [--format table|json]` to generate a side-by-side comparison.
   - Waza's `compare` command produces quantitative metrics showing which skill performed better on each task. You can also use `waza results compare <run-id-1> <run-id-2>` for cloud-stored results.
3. **Capture JSON output**:
   - Waza writes a results JSON file when `-o` / `--output` is supplied, or a structured directory when `--output-dir` is supplied. Capture and store this output for analysis in Phase 4.
   - The JSON includes: per-task pass/fail status, per-grader scores (`score`, `passed`, `message`), aggregate `pass_rate`, token usage, duration, and validator results.
4. **Re-grade without re-running (optional)**:
   - If you already have results and only want to re-score (e.g., after updating graders), run `waza grade <eval.yaml> --results results.json --output graded.json` instead of re-executing the agent.

### Phase 3: Trigger Evaluation (Discoverability)

Analyze whether the skill's description effectively triggers the model in the correct contexts.

1. **Configure trigger tasks**:
   - Trigger tasks use the same Waza eval structure but with a critical configuration difference: set `inject_skill_body: false` inside the `config:` block of `eval.yaml` (or in a dedicated trigger eval file).
   - This prevents Waza from injecting the skill's `SKILL.md` body into the system prompt, so the model must rely solely on the skill's `description` field to decide whether to trigger.
   - Waza still passes the compact `<available_skills>` summary (names + descriptions), enabling `behavior` graders with `required_tools` / `forbidden_tools` and `skill_invocation` graders to observe whether the `skill` tool was used.
   - For an even stricter test, set `disabled_skills: ["*"]` to disable all skill loading and isolate description-based triggering.
2. **Use appropriate graders**:
   - **`trigger` grader**: Prompt trigger accuracy — detects whether a prompt should activate a skill.
   - **`action_sequence` grader**: Checks whether the model invoked the expected tools or actions in order, with F1 scoring.
   - **`skill_invocation` grader**: Validates the skill orchestration sequence (e.g., did it call the `skill` tool with the correct skill name?).
   - **`regex` / `text` graders**: Check whether the model's response contains specific patterns indicating it triggered (or didn't trigger) the skill.
   - **`tool_constraint` grader**: Validate tool usage constraints (e.g., required/forbidden tools, argument patterns).
3. **Run with multiple trials**:
   - Configure `trials_per_task: 3` to `trials_per_task: 5` in `eval.yaml` (or override on the CLI with `--trials N`) to account for LLM non-determinism.
   - Waza runs each trigger task multiple times and computes the trigger rate (percentage of trials where the skill triggered).
4. **Analyze trigger rates**:
   - **True positives**: Tasks that should trigger and did trigger (high trigger rate).
   - **False negatives**: Tasks that should trigger but didn't (low trigger rate) — indicates the skill description is too narrow.
   - **False positives**: Tasks that shouldn't trigger but did (high trigger rate) — indicates the skill description is too broad.
   - **True negatives**: Tasks that shouldn't trigger and didn't (low trigger rate).
5. **Filter for faster iteration (optional)**:
   - Use `waza run eval.yaml --task "trigger-*"` or `waza run eval.yaml --tags "trigger"` to run only trigger-precision tasks.

### Phase 4: Diagnostic Analysis (The Prescription)

Synthesize the findings from Performance and Trigger evaluations into a comprehensive diagnostic report.

1. **Analyze Waza's JSON results**:
   - Parse the JSON output from Phase 2 (performance) and Phase 3 (trigger) evaluations.
   - Identify all failed tasks and low-scoring tasks (inspect each task's `graders[]` for `passed: false` and `score < 1.0`).
   - For trigger evaluations, identify tasks with unexpected trigger rates (false positives and false negatives).
2. **Generate per-failure insights**:
   - For each significant failure or regression, provide:
     - **Eval ID**: The specific task that failed.
     - **Context/Insight**: A technical explanation of **why** the failure occurred. Analyze the model's transcript, the skill's SKILL.md content, and the task's input/output to identify the root cause. Examples:
       - "The skill's description mentions 'code review' but the task uses the term 'local review', causing a trigger failure."
       - "The skill's workflow step 3 instructs the agent to 'analyze the diff', but the agent skipped this step because the task input didn't explicitly mention a diff."
       - "The `output_contains` assertion checks for 'Python 3.8+' but the skill's output says 'Python 3 or later', causing a false failure."
3. **Generate dual-option prescriptions**:
   - For each failure, provide two prescription options:
     - **Prescription A (Conservative)**: A surgical, minimal fix. Example: "Change line 12 of SKILL.md from 'code review' to 'code review or local review' to improve trigger accuracy."
     - **Prescription B (Structural)**: A broader architectural or pattern change. Example: "Reorganize the 'When to Use' section to explicitly list all synonymous terms (code review, local review, PR review) to prevent similar trigger failures across the suite."
   - **REMINDER**: Propose the snippets; do not apply them. You are an advisor, not an editor.
4. **Invoke hybrid grading workflow**:
   - For tasks with soft assertions (e.g., "tone is professional", "insightful analysis"), use the `prompt` grader (LLM-as-judge) defined in `eval.yaml`. For post-hoc re-grading, invoke `waza grade <eval.yaml> --results results.json --judge-model <model>`.
   - The grader performs:
     - **Tiered grading**: Prioritize Waza validator results for deterministic checks, then apply LLM judgment (via `prompt` grader with rubric) for soft assertions.
     - **Claim extraction**: Extract implicit claims from the model's output (factual, process, quality) and verify them.
     - **Eval critique**: Evaluate the quality of the eval assertions themselves, flagging weak or trivial assertions that create false confidence. Use `waza quality <skill-path>` for an LLM-as-judge content-quality score.
5. **Launch quantitative dashboard**:
   - Execute `waza serve [--port 3000]` to launch Waza's interactive dashboard.
   - The dashboard displays: pass/fail status per task, score distributions, model comparisons, aggregated metrics.
   - Provide the user with the dashboard URL (`http://localhost:<port>`) so they can interactively explore the quantitative results.
   - For headless / non-interactive analysis, also surface the `--format json` output of `waza run` and `waza compare`.
6. **Write diagnostic report**:
   - Generate a `diagnostic-report.md` file in the workspace directory.
   - The report contains:
     - Executive summary of evaluation results (overall pass rate, top regressions).
     - Per-failure insights and dual-option prescriptions.
     - Hybrid grading results for soft assertions.
     - Claim verification results.
     - Eval critique and suggestions for improving the evaluation suite.
     - Link to the `waza serve` dashboard for quantitative results.

## Validation

To ensure adherence to this skill's workflow, verify the following before completing the evaluation:

- [ ] **Phase 0 completed**: Did you verify that Waza CLI is installed (`waza version`) and supports the required features (`--baseline`, `--context-dir`, `--output`, `inject_skill_body: false`, `waza compare`, `waza new eval`, `waza suggest`)?
- [ ] **Installation permission**: If Waza was not installed, did you obtain explicit user permission before downloading or installing?
- [ ] **Phase 1 completed**: Did you verify that the target skill has a valid Waza eval suite (`eval.yaml` + `tasks/` + `fixtures/`) with tasks referenced via `tasks:` or `tasks_from:`?
- [ ] **User approval**: Did you obtain explicit user approval of the evaluation suite before proceeding to Phase 2?
- [ ] **Phase 2 completed**: Did you run `waza run --baseline -o results.json` (or A/B comparison via two `waza run` invocations + `waza compare`) and capture the JSON output?
- [ ] **Phase 3 completed**: Did you run trigger evaluations with `config.inject_skill_body: false` and `trials_per_task: 3-5` (or `--trials 3-5`)?
- [ ] **Phase 4 completed**: Did you generate a `diagnostic-report.md` with per-failure insights and dual-option prescriptions?
- [ ] **Hybrid grading**: Did you invoke the `prompt` grader (or `waza grade --results results.json`) for soft assertions, claim extraction, and eval critique?
- [ ] **Dashboard launched**: Did you execute `waza serve` and provide the user with the dashboard URL?
- [ ] **No Edits constraint**: Did you refrain from modifying the target skill's SKILL.md? (You should only propose prescriptions, not apply them.)
- [ ] **Sequential Phases constraint**: Did you execute phases in order (0 → 1 → 2 → 3 → 4) without skipping any phase?

## Summary of Constraints

- **No Edits**: Never modify the target skill's `SKILL.md`. You provide diagnoses and prescriptions, but the user or a creation-specific agent applies the fixes.
- **Sequential Phases**: Execute phases in strict order (0 → 1 → 2 → 3 → 4). Do not skip phases or execute them out of order. Each phase depends on the output of the previous phase.
- **No Creation**: Do not scaffold new skills; only evaluate existing ones. If the user needs to create a new skill, refer them to `skill-architect` or `create-skill`. Use `waza new eval` / `waza suggest` to scaffold the *eval* suite, not the skill.
- **Explicit Permission**: Always obtain explicit user permission before downloading or installing software (Phase 0) or before proceeding with evaluation (Phase 1).
- **Deterministic Execution**: Every step in this workflow is a concrete, actionable instruction. Do not introduce fuzzy language like "be smart about errors" or "as appropriate". Follow the deterministic patterns defined above.
