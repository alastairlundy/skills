---
name: waza-skill-evaluator
description: Rigorously evaluate, benchmark, and diagnose the performance and discoverability of agent skills using the Waza CLI. Use this skill whenever you need to verify a skill's correctness, measure its "lift" over a baseline, analyze trigger accuracy (discoverability), or generate a comprehensive diagnostic report with actionable improvement prescriptions.
compatibility: waza CLI required (github.com/microsoft/waza)
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

## When Not to Use

- When you need to create or scaffold a new skill (use `skill-architect` or `create-skill` instead).
- When you need to apply edits to a skill's SKILL.md (this skill only diagnoses and prescribes).
- When the target skill does not have a Waza-compatible evaluation suite (you must generate one first).
- When you need to run arbitrary code tests or unit tests unrelated to skill evaluation.

## Workflow

Proceed through these five phases methodically. Do not skip phases or execute them out of order.

### Phase 0: Prerequisites

Before starting any evaluation, verify that the Waza CLI is installed and supports the required features.

1. **Check for Waza CLI**: Execute the command `waza version` in the shell.
2. **If Waza is not installed**:
   - Inform the user that the Waza CLI is required for this evaluation.
   - Present the installation instructions from https://github.com/microsoft/waza.
   - Ask the user for **explicit permission** before downloading or installing anything. Do not proceed with installation until the user confirms.
   - After installation, re-run `waza version` to confirm success.
3. **Verify version features**: Confirm that the installed Waza version supports:
   - The `--baseline` flag for `waza run` (enables lift measurement).
   - The `inject_skill_body: false` configuration option for trigger tasks.
   - The `waza compare` command for side-by-side result comparison.
   - If any feature is missing, inform the user that they need to upgrade Waza to the latest version and provide the upgrade command.

### Phase 1: Suite Validation

Before running any evaluations, ensure a valid Waza evaluation suite exists for the target skill.

1. **Check for Waza eval format**: Verify that the target skill directory contains:
   - An `eval.yaml` file (the evaluation configuration).
   - A `tasks/` directory (containing individual task definitions).
   - A `fixtures/` directory (containing test inputs and expected outputs).
2. **If the eval suite is missing or inadequate**:
   - Reference `references/eval-generation.md` for guidance on creating a comprehensive evaluation suite.
   - Guide the user through the eval generation process:
     - Use `waza new eval` to scaffold a new evaluation structure, or
     - Use `waza suggest` to generate eval suggestions based on the skill's SKILL.md.
   - Review the generated eval suite with the user and ensure it covers:
     - **Performance evals**: Tasks that measure the quality of the skill's output.
     - **Trigger evals**: Tasks that measure whether the skill triggers correctly (both positive and negative cases).
3. **User approval**: Do not proceed to Phase 2 until the user explicitly approves the validated evaluation suite. Present the suite structure and task count to the user for confirmation.

### Phase 2: Performance Evaluation (The "Lift" Measurement)

Measure the correctness and quality of the skill's output using Waza's baseline comparison capabilities.

1. **Default baseline (lift measurement)**:
   - Execute `waza run --baseline` in the target skill directory.
   - This runs each task twice: once with the skill loaded (with-skill) and once without any skill (no-skill baseline).
   - Waza automatically computes the "lift" — the improvement in output quality when the skill is used.
2. **A/B comparison (alternative baseline)**:
   - If the user wants to compare two skill versions or two different skills:
     - Run `waza run --skill-path <path-to-skill-A>` to evaluate skill A.
     - Run `waza run --skill-path <path-to-skill-B>` to evaluate skill B.
     - Run `waza compare <result-A> <result-B>` to generate a side-by-side comparison.
   - Waza's `compare` command produces quantitative metrics showing which skill performed better on each task.
3. **Capture JSON output**:
   - Waza outputs results in JSON format. Capture and store this output for analysis in Phase 4.
   - The JSON includes: pass/fail status per task, scores, token usage, duration, and validator results.

### Phase 3: Trigger Evaluation (Discoverability)

Analyze whether the skill's description effectively triggers the model in the correct contexts.

1. **Configure trigger tasks**:
   - Trigger tasks use the same Waza eval structure but with a critical configuration difference: set `inject_skill_body: false` in the task config.
   - This prevents Waza from injecting the skill's SKILL.md body into the prompt, so the model must rely solely on the skill's `description` field to decide whether to trigger.
2. **Use appropriate validators**:
   - **`action_sequence` validator**: Checks whether the model invoked the expected tools or actions (e.g., did it call the `skill` tool with the correct skill name?).
   - **`regex` validator**: Checks whether the model's response contains specific patterns indicating it triggered (or didn't trigger) the skill.
3. **Run with multiple trials**:
   - Execute trigger evaluations with `--trials 3` to `--trials 5` to account for LLM non-determinism.
   - Waza runs each trigger task multiple times and computes the trigger rate (percentage of trials where the skill triggered).
4. **Analyze trigger rates**:
   - **True positives**: Tasks that should trigger and did trigger (high trigger rate).
   - **False negatives**: Tasks that should trigger but didn't (low trigger rate) — indicates the skill description is too narrow.
   - **False positives**: Tasks that shouldn't trigger but did (high trigger rate) — indicates the skill description is too broad.
   - **True negatives**: Tasks that shouldn't trigger and didn't (low trigger rate).

### Phase 4: Diagnostic Analysis (The Prescription)

Synthesize the findings from Performance and Trigger evaluations into a comprehensive diagnostic report.

1. **Analyze Waza's JSON results**:
   - Parse the JSON output from Phase 2 (performance) and Phase 3 (trigger) evaluations.
   - Identify all failed tasks and low-scoring tasks.
   - For trigger evaluations, identify tasks with unexpected trigger rates (false positives and false negatives).
2. **Generate per-failure insights**:
   - For each significant failure or regression, provide:
     - **Eval ID**: The specific task that failed.
     - **Context/Insight**: A technical explanation of **why** the failure occurred. Analyze the model's transcript, the skill's SKILL.md content, and the task's input/output to identify the root cause. Examples:
       - "The skill's description mentions 'code review' but the task uses the term 'local review', causing a trigger failure."
       - "The skill's workflow step 3 instructs the agent to 'analyze the diff', but the agent skipped this step because the task input didn't explicitly mention a diff."
       - "The assertion checks for 'Python 3.8+' but the skill's output says 'Python 3 or later', causing a false failure."
3. **Generate dual-option prescriptions**:
   - For each failure, provide two prescription options:
     - **Prescription A (Conservative)**: A surgical, minimal fix. Example: "Change line 12 of SKILL.md from 'code review' to 'code review or local review' to improve trigger accuracy."
     - **Prescription B (Structural)**: A broader architectural or pattern change. Example: "Reorganize the 'When to Use' section to explicitly list all synonymous terms (code review, local review, PR review) to prevent similar trigger failures across the suite."
   - **REMINDER**: Propose the snippets; do not apply them. You are an advisor, not an editor.
4. **Invoke hybrid grading workflow**:
   - For tasks with soft assertions (e.g., "tone is professional", "insightful analysis"), invoke the grading workflow defined in `agents/grader.md`.
   - The grader performs:
     - **Tiered grading**: Prioritize Waza validator results for deterministic checks, then apply LLM judgment for soft assertions.
     - **Claim extraction**: Extract implicit claims from the model's output (factual, process, quality) and verify them.
     - **Eval critique**: Evaluate the quality of the eval assertions themselves, flagging weak or trivial assertions that create false confidence.
5. **Launch quantitative dashboard**:
   - Execute `waza serve` to launch Waza's interactive dashboard.
   - The dashboard displays: pass/fail status per task, score distributions, model comparisons, aggregated metrics.
   - Provide the user with the dashboard URL so they can interactively explore the quantitative results.
6. **Write diagnostic report**:
   - Generate a `diagnostic-report.md` file in the workspace directory.
   - The report contains:
     - Executive summary of evaluation results.
     - Per-failure insights and dual-option prescriptions.
     - Hybrid grading results for soft assertions.
     - Claim verification results.
     - Eval critique and suggestions for improving the evaluation suite.
     - Link to the `waza serve` dashboard for quantitative results.

## Validation

To ensure adherence to this skill's workflow, verify the following before completing the evaluation:

- [ ] **Phase 0 completed**: Did you verify that Waza CLI is installed and supports the required features (`--baseline`, `inject_skill_body: false`, `waza compare`)?
- [ ] **Installation permission**: If Waza was not installed, did you obtain explicit user permission before downloading or installing?
- [ ] **Phase 1 completed**: Did you verify that the target skill has a valid Waza eval suite (`eval.yaml` + `tasks/` + `fixtures/`)?
- [ ] **User approval**: Did you obtain explicit user approval of the evaluation suite before proceeding to Phase 2?
- [ ] **Phase 2 completed**: Did you run `waza run --baseline` (or A/B comparison) and capture the JSON output?
- [ ] **Phase 3 completed**: Did you run trigger evaluations with `inject_skill_body: false` and `--trials 3-5`?
- [ ] **Phase 4 completed**: Did you generate a `diagnostic-report.md` with per-failure insights and dual-option prescriptions?
- [ ] **Hybrid grading**: Did you invoke `agents/grader.md` for soft assertions, claim extraction, and eval critique?
- [ ] **Dashboard launched**: Did you execute `waza serve` and provide the user with the dashboard URL?
- [ ] **No Edits constraint**: Did you refrain from modifying the target skill's SKILL.md? (You should only propose prescriptions, not apply them.)
- [ ] **Sequential Phases constraint**: Did you execute phases in order (0 → 1 → 2 → 3 → 4) without skipping any phase?

## Summary of Constraints

- **No Edits**: Never modify the target skill's `SKILL.md`. You provide diagnoses and prescriptions, but the user or a creation-specific agent applies the fixes.
- **Sequential Phases**: Execute phases in strict order (0 → 1 → 2 → 3 → 4). Do not skip phases or execute them out of order. Each phase depends on the output of the previous phase.
- **No Creation**: Do not scaffold new skills; only evaluate existing ones. If the user needs to create a new skill, refer them to `skill-architect` or `create-skill`.
- **Explicit Permission**: Always obtain explicit user permission before downloading or installing software (Phase 0) or before proceeding with evaluation (Phase 1).
- **Deterministic Execution**: Every step in this workflow is a concrete, actionable instruction. Do not introduce fuzzy language like "be smart about errors" or "as appropriate". Follow the deterministic patterns defined above.
