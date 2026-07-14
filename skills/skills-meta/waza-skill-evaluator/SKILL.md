---
name: waza-skill-evaluator
description: >-
  Rigorously evaluate, benchmark, and diagnose the performance and discoverability of agent skills
  using the Waza CLI. Use for verifying a skill's correctness, measuring its
  "lift" over a baseline, analyze trigger accuracy (discoverability), or generate a
  diagnostic report with actionable recommended fixes. Runs a waza benchmark
  against the skill and reports pass rate.
compatibility:
  tools: waza CLI
license: MIT
---

# Waza Skill Evaluator

> **First-run probe.** If interactive: ask the user "Do you want a diagnostic evaluation of a specific skill (full run with report), or a one-shot `waza check`? If the latter, defer to `waza check` and stop." If non-interactive: default to diagnostic evaluation and proceed. If the user has not named the skill to be evaluated, ask for it (interactive) or refuse with a help message pointing to this skill's description and "Use For" list (non-interactive).

The Waza Skill Evaluator acts as a **Diagnostic Advisor**. Its primary purpose is to provide high-fidelity Verification & Validation (V&V) of a skill's effectiveness using the Waza CLI for execution, aggregation, and visualization.

## Hard Constraints

The following rules are load-bearing and apply to every phase. Violating either rule is a workflow failure, not a stylistic choice.

1. **No Edits (advisor-not-editor).** You are a diagnostic advisor. You provide the diagnosis and the recommended fixes (proposed code snippets or rule changes), but you MUST NOT apply edits to the target skill's `SKILL.md` yourself. The user or a creation-specific agent applies the fixes.
2. **Sequential Phases.** Execute the nine workflow phases in strict order (0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8). Do not skip phases or execute them out of order. Each phase depends on the output of the previous phase.

## Guidance

- When the workflow requires user input (a choice, an opt-in, a clarification), and the `ask-questions` skill is available, load it and use it to ask the user.
- If the `ask-questions` skill is not available, ask the user directly in prose using the following rules:
  - Phrase the question as a single, concrete choice whenever possible (e.g., "Run an isolation test on `waza-skill-evaluator`? [yes / no / defer]").
  - For multi-option questions, offer two or three options and mark the recommended default with "(Recommended)".
  - For binary decisions, ask a yes/no question.
  - Do not bundle multiple unrelated questions into one turn; ask the most blocking question first and follow up after the user answers.
  - Wait for the user's response before proceeding; do not assume a default in interactive mode unless the user has stated a preference earlier in the session.

## Glossary

- **lift** = the change in pass rate, score, or quality between baseline and treatment runs.
- **Hybrid grading** = the combination of Waza's deterministic validator, Waza's optional LLM judge, and the skill's separate LLM grading with rubric, applied in sequence.
- **recommended fixes** = proposed code snippets or rule changes the user can apply.

## Use For

- When you need to evaluate a skill's correctness and measure its lift over a baseline (no-skill or alternative skill).
- When you need to analyze a skill's trigger accuracy (discoverability) — whether it triggers when it should and doesn't trigger when it shouldn't.
- When you need to generate a diagnostic report with actionable recommended fixes.
- When you want to compare two skill versions or two different skills side-by-side.
- When you need to validate that a skill's evaluation suite is well-structured.
- When you need to run an isolation test to determine whether a skill triggers correctly without competition from other skills.

## Do Not Use For

- When you need to create or scaffold a new skill (use `skill-architect` or `create-skill` instead).
- When you need to apply edits to a skill's SKILL.md (this skill only diagnoses and recommends fixes).
- When the target skill does not have a Waza-compatible evaluation suite (you must generate one first).
- When you need to run arbitrary code tests or unit tests unrelated to skill evaluation.
- When you only need a one-shot compliance/quality check on a single skill — use `waza check` or `waza quality` directly instead.

## Workflow

Proceed through these nine phases methodically. Do not skip phases or execute them out of order.

### Phase 0: Prerequisites (Waza CLI detection)

Before invoking any `waza` command, load [references/waza-cli.md](references/waza-cli.md) to obtain the current Waza CLI command catalogue, installation instructions, and the list of version features the workflow requires. This gate prevents the agent from using stale or invented CLI flags.

1. Run `waza --version` and report the installed waza version (e.g., "Installed waza version: <output>"). If not, present the install command from the `waza-cli.md` Installation section and obtain **explicit user permission** before downloading or installing anything; re-run `waza --version` after install.
2. Confirm the installed Waza version supports the features required by later phases (see `waza-cli.md` "Required version features"). If any feature is missing, run `waza update` (after obtaining user permission) and re-verify.

### Phase 1: Suite validation

Verify that a valid Waza evaluation suite exists for the target skill before running any evaluations.

1. **Check for Waza eval format**: Verify that the target skill directory contains:
   - An `eval.yaml` (or `eval.yml`) file (the evaluation configuration).
   - A `tasks/` directory (containing individual task definitions referenced by a glob or by `tasks_from`).
   - A `fixtures/` directory (containing test inputs and expected outputs).
   - The eval spec must reference tasks via `tasks:` (glob list) or `tasks_from:` (external file).
2. **If the eval suite is missing or inadequate**:
   - Reference [references/eval-generation.md](references/eval-generation.md) for guidance on creating a comprehensive evaluation suite.
   - Guide the user through the eval generation process using `waza new eval <skill-name>` to scaffold a new evaluation structure (creates `eval.yaml` plus positive/negative trigger task files).
   - Use `waza new task from-prompt "<prompt>" <task-path>` to record a real Copilot session and convert it into a task YAML with inferred validators.
   - Review the generated eval suite with the user and ensure it covers:
     - **Performance evals**: Tasks that measure the quality of the skill's output (graded by `code`, `regex`, `file`, `diff`, `behavior`, `prompt`, etc.).
     - **Trigger evals**: Tasks that measure whether the skill triggers correctly (both positive and negative cases). Use the `trigger` grader or `action_sequence` / `skill_invocation` graders.
3. **User approval**: Do not proceed to Phase 2 until the user explicitly approves the validated evaluation suite. Present the suite structure and task count to the user for confirmation.

### Phase 2: Performance evaluation (lift / A/B comparison)

Measure the correctness and quality of the skill's output using Waza's baseline comparison capabilities.

1. **Default baseline (lift measurement)**:
   - Execute `waza run --baseline -o results.json` in the target skill directory. You can also target a specific skill by name: `waza run <skill-name> --baseline -o results.json`.
   - This runs each task twice: once without the skill (baseline) and once with the skill loaded (treatment).
   - Waza automatically computes the lift — the improvement in output quality when the skill is used.
   - For per-task coverage reports, also consider `waza coverage <root>` (full / partial / missing) as a complement to running the suite.
2. **A/B comparison (alternative baseline)**:
   - If the user wants to compare two skill versions or two different skills:
     - Run `waza run <skill-A> --output waza-output/base.json` to evaluate skill A.
     - Run `waza run <skill-B> --output waza-output/description-edits.json` to evaluate skill B (substitute `<treatment-description>` for the actual treatment).
     - Run `waza compare waza-output/base.json waza-output/description-edits.json [--format table|json]` to generate a side-by-side comparison.
   - Waza's `compare` command produces quantitative metrics showing which skill performed better on each task. You can also use `waza results compare <run-id-1> <run-id-2>` for cloud-stored results.
3. **A/B output paths**: When running an A/B comparison, save the two result files in a visible subdirectory at `<repo-root>/waza-output/` (create the directory if it does not exist). The baseline file is always named `base.json`; the treatment file is named `<treatment-description>.json` where `<treatment-description>` is a hyphenated phrase reflecting what is being changed in the treatment run (e.g., `description-edits.json` for a description-edit treatment). Generic placeholders like `a.json` / `b.json` are not allowed.
4. **Capture JSON output**:
   - Waza writes a results JSON file when `-o` / `--output` is supplied, or a structured directory when `--output-dir` is supplied. Capture and store this output for analysis in Phases 4–6.
   - The JSON includes: per-task pass/fail status, per-grader scores (`score`, `passed`, `message`), aggregate `pass_rate`, token usage, duration, and validator results.
5. **Re-grade without re-running (optional)**:
   - If you already have results and only want to re-score (e.g., after updating graders), run `waza grade <eval.yaml> --results results.json --output graded.json` instead of re-executing the agent.

### Phase 3: Standard eval (trigger evaluation)

Analyze whether the skill's description effectively triggers the model in the correct contexts.

1. **Configure trigger tasks**:
   - Trigger tasks use the same Waza eval structure but with a critical configuration difference: set `inject_skill_body: false` inside the `config:` block of `eval.yaml` (or in a dedicated trigger eval file).
   - This prevents Waza from injecting the skill's `SKILL.md` body into the system prompt, so the model must rely solely on the skill's `description` field to decide whether to trigger.
   - Waza still passes the compact `<available_skills>` summary (names + descriptions), enabling `behavior` graders with `required_tools` / `forbidden_tools` and `skill_invocation` graders to observe whether the `skill` tool was used.
   - For an isolation test — a description-only discoverability test ("can a user with no other skills find and invoke this skill based on description alone?") or a trigger-accuracy test ("does the skill's trigger fire correctly with no other skills competing for the same trigger phrases?") where the skill is tested without competition from other skills — set `disabled_skills: ["*"]` to disable all skill loading.
2. **Use appropriate graders**:
   - **`trigger` grader**: Prompt trigger accuracy — detects whether a prompt should activate a skill.
   - **`action_sequence` grader**: Checks whether the model invoked the expected tools or actions in order, with F1 scoring.
   - **`skill_invocation` grader**: Validates the skill orchestration sequence (e.g., did it call the `skill` tool with the correct skill name?).
   - **`regex` / `text` graders**: Check whether the model's response contains specific patterns indicating it triggered (or didn't trigger) the skill.
   - **`tool_constraint` grader**: Validate tool usage constraints (e.g., required/forbidden tools, argument patterns).
3. **`trials_per_task` rule (mode-conditional)**:
   - **Interactive mode** (user is in the loop): present three options and ask the user to pick — 1 trial per task (cost-prioritised, less accurate), 3 trials per task (balanced, best for performance metrics), 5 trials per task (accuracy-prioritised, more expensive, best for trigger metrics).
   - **Non-interactive mode** (user is unavailable): default to 3 trials per task, except — if the user's request explicitly mentions "trigger accuracy" or a trigger-related issue, use 5 trials per task; if the user's request includes cost-sensitive words (e.g., "affordable", "cheap", "low cost"), use 1 trial per task.
   - Waza runs each trigger task multiple times and computes the trigger rate (percentage of trials where the skill triggered).
4. **When to run isolation tests**:
   - **Default**: user request only — run an isolation test only if the user explicitly asks.
   - **Proactive ask**: if the user mentions under-triggering or non-triggering at any point in the workflow, ask the user whether to run an isolation test on the relevant skill(s).
   - **Reactive suggestion**: if the Waza evals indicate low trigger performance or under-triggering (as measured by the eval results), suggest that isolation tests be performed on the relevant skill(s), without automatically running them.
5. **Analyze trigger rates**:
   - **True positives**: Tasks that should trigger and did trigger (high trigger rate).
   - **False negatives**: Tasks that should trigger but didn't (low trigger rate) — indicates the skill description is too narrow.
   - **False positives**: Tasks that shouldn't trigger but did (high trigger rate) — indicates the skill description is too broad.
   - **True negatives**: Tasks that shouldn't trigger and didn't (low trigger rate).
6. **Filter for faster iteration (optional)**:
   - Use `waza run eval.yaml --task "trigger-*"` or `waza run eval.yaml --tags "trigger"` to run only trigger-precision tasks.

### Phase 4: Claim extraction

Extract implicit claims from the model's output for downstream verification.

1. **Read the JSON results** from Phase 2 (performance) and Phase 3 (trigger) evaluations.
2. **Identify failed and low-scoring tasks**: inspect each task's `graders[]` for `passed: false` and `score < 1.0`. For trigger evaluations, identify tasks with unexpected trigger rates (false positives and false negatives).
3. **Extract claims per failing task**: for each significant failure, extract the implicit claims in the model's transcript — factual claims (the model stated X), process claims (the model did Y), and quality claims (the output meets criterion Z). Record the claim text and the location (task ID, grader ID, transcript offset) so Phase 5 can verify them.

### Phase 5: Claim verification

Verify the claims extracted in Phase 4 against the Waza outputs and the source skill's `SKILL.md`.

1. **Verify each claim**: for each claim recorded in Phase 4, check it against the relevant Waza output (per-grader score, pass/fail flag, transcript excerpt) and against the target skill's `SKILL.md` content (workflow step that should have fired, glossary definition, etc.).
2. **Classify verification outcomes**: each claim is either **verified** (the evidence supports the claim), **contradicted** (the evidence refutes the claim), or **unverifiable** (the evidence is insufficient).
3. **Record verification evidence**: for each claim, note the evidence source and a one-sentence justification. The evidence feeds the diagnostic report's per-failure insights and the eval critique in Phase 6.

### Phase 6: Eval critique

Evaluate the quality of the evaluation suite and the grading regime, applying the Hybrid grading term (per the glossary).

1. **Eval-suite critique**: for each task in the eval suite, flag weak or trivial assertions that create false confidence (e.g., assertions that pass on empty output, regex assertions that match trivially, `behavior` graders with no real `required_tools` constraint).
2. **Content-quality score**: run `waza quality <skill-path>` to obtain an LLM-as-judge content-quality score for the target skill's `SKILL.md`. Treat the score as one input to the diagnostic report's eval critique section.
3. **Cross-eval consistency**: check whether the per-task failures and the content-quality score tell a coherent story. Inconsistencies (e.g., high quality score but high failure rate) are themselves a finding to surface in the diagnostic report.
4. **Hybrid grading note**: the verification outcomes from Phase 5, the eval-suite critique from sub-step 1, and the `waza quality` score from sub-step 2 together constitute the Hybrid grading regime — a combination of Waza's deterministic validator, Waza's optional LLM judge, and the skill's separate LLM grading with rubric, applied in sequence.

### Phase 7: Diagnostic report

Before writing the report, load [references/diagnostic-report-template.md](references/diagnostic-report-template.md) to obtain the six-section template shape. This gate prevents the agent from inventing a report structure or omitting required sections.

1. **Synthesise per-failure insights**: for each significant failure or regression surfaced in Phases 4–6, compose:
   - **Eval ID**: the specific task that failed.
   - **Context/Insight**: a technical explanation of *why* the failure occurred, drawing on the model's transcript, the skill's `SKILL.md` content, and the task's input/output. Examples: "The skill's description mentions 'code review' but the task uses the term 'local review', causing a trigger failure." / "The skill's workflow step 3 instructs the agent to 'analyze the diff', but the agent skipped this step because the task input didn't explicitly mention a diff." / "The `output_contains` assertion checks for 'Python 3.8+' but the skill's output says 'Python 3 or later', causing a false failure."
2. **Compose recommended fixes**: for each per-failure insight, propose two options:
   - **Recommended Fix A (Conservative)**: a surgical, minimal change. Example: "Change line 12 of SKILL.md from 'code review' to 'code review or local review' to improve trigger accuracy."
   - **Recommended Fix B (Structural)**: a broader architectural or pattern change. Example: "Reorganise the 'Use For' section to explicitly list all synonymous terms (code review, local review, PR review) to prevent similar trigger failures across the suite."
3. **Report path**: write the report to `<repo-root>/diagnostic-report.md` by default. If the user supplied a different path (at Phase 0, Phase 1, or via a `--output` flag), use the supplied path instead.
4. **Report sections** (six, in the order defined by `references/diagnostic-report-template.md`):
   1. Executive summary
   2. Per-failure insights (the output of sub-step 1 above)
   3. Hybrid grading results (the output of Phase 6, including a one-line user-facing definition: "Hybrid grading combines Waza's deterministic validator and LLM judge with the skill's own LLM grading, so the report covers more than the Waza evaluations alone.")
   4. Claim verification results (the output of Phase 5)
   5. Eval critique (the output of Phase 6's eval-suite critique and content-quality score)
   6. Dashboard link (a markdown link to the Waza dashboard URL from sub-step 5 below)
5. **Launch quantitative dashboard**: execute `waza serve [--port 3000]` to launch Waza's interactive dashboard. The dashboard displays pass/fail status per task, score distributions, model comparisons, and aggregated metrics. Record the dashboard URL (`http://localhost:<port>`) for sub-step 4.6. For headless / non-interactive analysis, also surface the `--format json` output of `waza run` and `waza compare`.
6. **Trial count reporting**: include the trial count used (per Phase 3 sub-step 3) in the report's Executive Summary or as a metadata header, so the user can verify the choice.

### Phase 8: Validation

The "No Edits" and "Sequential Phases" rules are stated in the Hard Constraints block above and recap'd in the Summary of Constraints below. The checks here verify the rules are followed and that the terminal steps executed correctly.

1. **`waza serve` rules**:
   - **Mode-conditional default**: if interactive, ask "do you want the dashboard launched?"; if non-interactive, default to off and do not launch `waza serve`.
   - **Explicit instruction override**: if the user's message includes an explicit instruction to launch the dashboard (e.g., "Use Waza Serve", "Open the Waza dashboard", "launch the dashboard", or any clear instruction to launch), follow the instruction and launch `waza serve` regardless of mode.
2. **`waza serve` validation** (only when `waza serve` was launched): all three checks must pass:
   - **Launch**: the agent executed `waza serve` and the process is alive or has exited cleanly.
   - **URL pattern**: the reported URL matches the Waza-served URL format (e.g., `http://localhost:<port>`).
   - **Reachability**: the dashboard URL responds to an HTTP probe (e.g., `curl -I <url>` returns 200).
3. **Exit phrase**: stop after the exit phrase below. Do not offer additional help unless the user asks. Use the launched variant if the dashboard was launched; otherwise use the not-launched variant:
   - **Launched**: "Evaluation complete. Report at `<path>`. Dashboard at `<url>`. Review the report for the diagnostic findings and recommended fixes."
   - **Not launched**: "Evaluation complete. Report at `<path>`. Dashboard not launched. See `waza serve --help` for launching the dashboard. Review the report for the diagnostic findings and recommended fixes."

## Validation

To ensure adherence to this skill's workflow, verify the following before completing the evaluation:

- [ ] **First-run probe** (D020): did the probe fire before Phase 0, and (if the skill was not named) did the no-skill-provided fallback fire (ask if interactive, refuse if non-interactive)?
- [ ] **Hard Constraints** (D002): is the in-body "No Edits" and "Sequential Phases" repetition count exactly 0 outside the Hard Constraints block and the Summary of Constraints?
- [ ] **Phase 0 — load trigger** (D001): was `references/waza-cli.md` loaded before the first `waza` invocation?
- [ ] **Phase 0 — version check** (D009): did Phase 0 invoke only `waza --version` and avoid the non-existent `waza version` subcommand?
- [ ] **Phase 0 — installation permission**: if Waza was not installed, was explicit user permission obtained before downloading or installing?
- [ ] **Phase 1 — suite approval**: was explicit user approval of the evaluation suite obtained before proceeding to Phase 2?
- [ ] **Phase 1 — no `waza suggest`** (D010): did Phase 1 use only `waza new eval` and avoid `waza suggest --apply`?
- [ ] **Phase 2 — output paths** (D011): do the A/B comparison files match the pattern `base.json` and `<treatment-description>.json` inside `<repo-root>/waza-output/` (no generic `a.json` / `b.json`)?
- [ ] **Phase 3 — trial count reported** (D014): is the trial count (1, 3, or 5) recorded in the diagnostic report's Executive Summary or metadata header?
- [ ] **Phase 7 — load trigger** (D001): was `references/diagnostic-report-template.md` loaded before writing the report?
- [ ] **Phase 7 — report path** (D005): was the report written to either `<repo-root>/diagnostic-report.md` (default) or the user-supplied override?
- [ ] **Phase 7 — six sections in order** (D003): does the report contain all six sections in the order defined by the template (Executive summary → Per-failure insights → Hybrid grading → Claim verification → Eval critique → Dashboard link)?
- [ ] **Phase 7 — recommended fixes** (D021): does the report use the term "recommended fixes" (not "prescriptions") and define it per the glossary?
- [ ] **Phase 7 — Hard Constraints** (D002): does the report *propose* recommended fixes but *not* apply any edits to the target skill's `SKILL.md`?
- [ ] **Phase 8 — waza serve rules** (D016): were the mode-conditional default and explicit-instruction override applied correctly?
- [ ] **Phase 8 — waza serve validation** (D015): if `waza serve` was launched, do all three checks (launch + URL pattern + reachability) pass?
- [ ] **Phase 8 — exit phrase** (D019): did the agent stop after the exit phrase and not offer additional help?
- [ ] **Sequential Phases constraint**: were phases executed in order (0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8) without skipping any?

## Summary of Constraints

- **No Edits (advisor-not-editor).** You are a diagnostic advisor. You provide the diagnosis and the recommended fixes (proposed code snippets or rule changes), but you MUST NOT apply edits to the target skill's `SKILL.md` yourself. The user or a creation-specific agent applies the fixes.
- **Sequential Phases.** Execute the nine workflow phases in strict order (0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8). Do not skip phases or execute them out of order. Each phase depends on the output of the previous phase.
- **No Creation.** Do not scaffold new skills; only evaluate existing ones. If the user needs to create a new skill, refer them to `skill-architect` or `create-skill`. Use `waza new eval` to scaffold the *eval* suite, not the skill.
- **Explicit Permission.** Always obtain explicit user permission before downloading or installing software (Phase 0) or before proceeding with evaluation (Phase 1).
- **Deterministic Execution.** Every step in this workflow is a concrete, actionable instruction. Do not introduce fuzzy language like "be smart about errors" or "as appropriate". Follow the deterministic patterns defined above.
