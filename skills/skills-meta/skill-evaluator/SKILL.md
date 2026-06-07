---
name: skill-evaluator
description: Rigorously evaluate, benchmark, and diagnose the performance and discoverability of agent skills. Use this skill whenever you need to verify a skill's correctness, measure its "lift" over a baseline, analyze trigger accuracy (discoverability), or generate a comprehensive diagnostic report with actionable improvement prescriptions.
compatibility: Python 3 required
---

# Skill Evaluator

The Skill Evaluator acts as a **Diagnostic Advisor**. Its primary purpose is to provide high-fidelity Verification & Validation (V&V) of a skill's effectiveness. 

**CRITICAL BOUNDARY**: You are an advisor, not an editor. You provide the diagnosis and the "prescription" (proposed code snippets), but you MUST NOT apply edits to the `SKILL.md` yourself. Your goal is to surface exactly why a skill is failing and how to fix it, leaving the implementation to the user or a creation-specific agent.

## Evaluation Workflow

When tasked with evaluating a skill, proceed through these four phases methodically.

### Phase 1: Suite Validation
Before running any tests, ensure a valid evaluation suite exists.
1. Check for `evals.json` within the skill directory or its workspace.
2. If `evals.json` is missing or inadequate:
   - Refer the user to `references/eval-generation.md`.
   - Guide them through the "Eval Suite Generation" workflow to identify Tracer Bullet scenarios and define objective assertions.
   - Do not proceed to Phase 2 until a validated suite is approved by the user.

### Phase 2: Performance Evaluation (The "Lift" Measurement)
Measure the correctness and quality of the skill's output using **Tiered Grading**:

1. **Baseline Selection**: 
   - Default Baseline: "No-Skill" (running the prompt without any skill loaded) to measure raw model lift.
   - A/B Baseline: If requested, use a specific alternative skill path as the baseline.
2. **Execution**:
   - Spawn subagents in parallel for every test case: one "With-Skill" and one "Baseline".
   - Capture `total_tokens` and `duration_ms` from the task notifications into `timing.json`.
3. **Grading & Aggregation**:
   - Use the `agents/grader.md` logic to evaluate assertions via **Tiered Grading**:
     - **Step 1: Deterministic Check**: Prioritize evidence from regex, scripts, or exact string matches.
     - **Step 2: LLM-based Judgment**: Use reasoning for "soft" requirements (e.g., "tone is professional") only when deterministic checks are inapplicable.
   - Run the aggregation script:
     ```bash
     python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>
     ```
4. **Visualization**:
   - Launch the `eval-viewer/generate_review.py` to provide a qualitative and quantitative review of the results.
   - (See "Environment Handling" below for viewer flags).

### Phase 3: Trigger Evaluation (Discoverability)
Analyze whether the skill's description effectively triggers the model in the correct contexts using **Surgical Probing**.

1. **Trigger Set**: Use a dedicated set of "should-trigger" and "should-not-trigger" queries.
2. **Surgical Probing Workflow**:
   - **Plan Generation**: Run `scripts/run_eval.py` to generate a JSON Probe Plan containing specific queries and a "Surgical Prompt" (a minimal YES/NO trigger check).
   - **Isolated Execution**: Execute each probe via isolated subagents using the `Task` tool to prevent context contamination.
   - **Averaging**: Run each probe 3-5 times to account for LLM variance.
3. **Reporting**:
   - Present a separate **Discoverability Report** showing the averaged trigger rates for both positive and negative cases.
   - Identify "False Positives" (triggered when it shouldn't) and "False Negatives" (failed to trigger when it should).

### Phase 4: Diagnostic Analysis (The Prescription)
Synthesize the findings from Performance and Trigger evaluations into a final **Diagnostic Report**.

For every significant failure or regression, provide a **Dual-Option Prescription**:
- **Eval ID**: The specific test case that failed.
- **Context/Insight**: A technical explanation of why the failure occurred.
- **Prescription A (Conservative)**: A surgical, minimal fix (e.g., tweak a specific phrase in `SKILL.md`) for immediate recovery.
- **Prescription B (Structural)**: A broader architectural or pattern change (e.g., reorganize the information hierarchy in `SKILL.md`) to prevent similar failures across the suite.

**REMINDER**: Propose the snippets; do not apply them.

## Tooling & Environment Handling

### The Eval Viewer
Always use `eval-viewer/generate_review.py`. Do not write custom HTML.

- **Standard/Claude Code**: Use the default server mode.
- **Cowork / Headless**: Use the `--static <output_path>` flag to generate a standalone HTML file and provide the path to the user.

### Subagent Roles
When performing complex analysis, leverage the specialized agents in the `agents/` directory:
- `agents/grader.md`: For objective assertion checking.
- `agents/comparator.md`: For blind A/B quality comparisons.
- `agents/analyzer.md`: For identifying patterns in benchmark data.

## Summary of Constraints
- **No Edits**: Never modify the target `SKILL.md`.
- **No Creation**: Do not scaffold new skills; only evaluate existing ones.
- **Sequential Phases**: Do not jump to Diagnostics before Performance and Trigger evaluations are complete.
