## Problem Statement

The existing `skill-evaluator` skill ships ~800 lines of Python scripts (`aggregate_benchmark.py`, `run_eval.py`, `aggregate_probes.py`, `generate_report.py`, `quick_validate.py`, `package_skill.py`, `generate_review.py`, `utils.py`) that must be remotely executed on the user's machine. This creates a hard Python 3 dependency, requires the consuming agent to manage a Python runtime, and increases the attack surface of the skill by shipping executable code that runs in the user's environment.

Additionally, the existing skill duplicates functionality that is now natively provided by the Waza CLI (benchmark aggregation, result comparison, trigger evaluation, result visualization), leading to maintenance burden and feature drift.

## Solution

Replace the Python-based `skill-evaluator` with a new Waza-based skill (temporarily named `waza-skill-evaluator`) that uses the Waza CLI for execution, aggregation, and visualization. The new skill is a pure SKILL.md with supporting agent instructions and reference documents — no executable code shipped. The consuming agent invokes `waza` CLI commands directly, and the skill instructions guide the agent through the evaluation workflow.

The new skill preserves the existing 4-phase evaluation workflow (Suite Validation → Performance → Trigger → Diagnostic) while delegating execution mechanics to Waza and retaining agent-generated qualitative analysis where Waza provides only quantitative results.

## User Stories

1. As a skill author, I want to evaluate my skill's correctness without needing Python installed, so that I can run evaluations in any environment.
2. As a skill author, I want the evaluator to check if Waza is installed before starting, so that I get clear installation guidance instead of cryptic errors.
3. As a skill author, I want the evaluator to guide me through installing Waza if it's missing, so that I can get set up quickly with explicit permission before any download.
4. As a skill author, I want to use Waza's YAML eval format (eval.yaml + tasks/ + fixtures/), so that my evals are compatible with the broader Waza ecosystem.
5. As a skill author with an existing evals.json, I want guidance on migrating to Waza's YAML format, so that I can reuse my existing test scenarios.
6. As a skill author, I want the evaluator to use `waza new eval` or `waza suggest` to generate eval suites when none exist, so that I can bootstrap evaluations quickly.
7. As a skill author, I want the evaluator to measure the "lift" of my skill using `waza run --baseline`, so that I can quantify the value my skill adds over no skill.
8. As a skill author, I want to compare two skill versions using `waza compare`, so that I can measure improvements between iterations.
9. As a skill author, I want trigger evaluation to use Waza's native trigger tasks with `inject_skill_body: false`, so that discoverability testing is integrated with the same tool.
10. As a skill author, I want trigger evaluations to run multiple trials via `--trials`, so that I can account for LLM variance in trigger behavior.
11. As a skill author, I want deterministic assertions to be graded by Waza's built-in validators (regex, code, behavior, action_sequence, diff), so that grading is fast and reproducible.
12. As a skill author, I want soft/qualitative assertions to be graded by the agent using LLM judgment, so that I can evaluate subjective qualities like tone and clarity.
13. As a skill author, I want the grader to extract implicit claims from outputs and verify them, so that I catch issues my predefined assertions miss.
14. As a skill author, I want the grader to critique the quality of my eval assertions, so that I can identify weak or trivial tests that create false confidence.
15. As a skill author, I want a diagnostic report that explains *why* failures occurred, not just *what* failed, so that I can make targeted fixes.
16. As a skill author, I want dual-option prescriptions (conservative vs structural) for each failure, so that I can choose between quick fixes and architectural improvements.
17. As a skill author, I want to view quantitative results in Waza's dashboard via `waza serve`, so that I can interactively explore pass/fail status and score distributions.
18. As a skill author, I want a separate agent-generated markdown diagnostic report, so that I can read the qualitative analysis alongside the quantitative dashboard.
19. As a skill author, I want the evaluator to never modify my skill's SKILL.md directly, so that I maintain control over my skill's content.
20. As a skill author, I want the evaluation workflow to follow 4 sequential phases, so that I can understand the progression from setup to diagnosis.
21. As a skill author, I want the evaluator to respect the "Diagnostic Advisor" boundary — providing prescriptions but not applying edits, so that I remain in control of changes.
22. As a skill maintainer, I want the new skill to have no Python scripts, so that there is no executable code to audit, maintain, or ship.
23. As a skill maintainer, I want the skill to declare `compatibility: waza CLI required (https://github.com/microsoft/waza)` in frontmatter, so that consuming agents know the dependency upfront.

## Implementation Decisions

### Module Structure

The new skill consists of three components:

1. **SKILL.md** — Main skill instructions defining the 5-phase workflow (Phase 0 through Phase 4). Contains no executable code; instructs the consuming agent to invoke `waza` CLI commands and apply its own reasoning for qualitative analysis.

2. **agents/grader.md** — Modified grader agent instructions for the hybrid grading approach. Instructs the agent to prioritize Waza validator results for deterministic checks, then apply LLM judgment for soft assertions. Retains claim extraction, eval critique, and the structured JSON output format.

3. **references/eval-generation.md** — Rewritten reference document that preserves the conceptual guidance on tracer bullet scenarios and assertion design, while describing Waza's YAML task/validator model and referencing `waza new eval` / `waza suggest` for generation.

### Dropped Components

The following components from the existing skill are **not** carried forward:

- **scripts/** — All 8 Python scripts (`aggregate_benchmark.py`, `run_eval.py`, `aggregate_probes.py`, `generate_report.py`, `quick_validate.py`, `package_skill.py`, `utils.py`, `__init__.py`). Their functions are replaced by Waza CLI commands.
- **agents/comparator.md** — Blind A/B comparison. Replaced by `waza compare` for quantitative comparison and the diagnostic phase for qualitative analysis.
- **agents/analyzer.md** — Post-hoc analysis. Its function is absorbed into the Phase 4 diagnostic instructions in SKILL.md.
- **eval-viewer/** — Custom Python HTTP server and HTML viewer (`generate_review.py`, `viewer.html`). Replaced by `waza serve` for quantitative dashboard and agent-generated `diagnostic-report.md` for qualitative analysis.
- **assets/** — Static HTML assets. No longer needed.

### Workflow Phases

The skill follows 5 phases (Phase 0 added for prerequisites):

- **Phase 0: Prerequisites** — Agent runs `waza version` to check for Waza CLI. If missing, agent guides the user through installation with explicit permission before any download. Verifies the installed version supports required features.

- **Phase 1: Suite Validation** — Agent checks for Waza YAML eval format (`eval.yaml` + `tasks/` + `fixtures/`). If missing or inadequate, agent references the rewritten `eval-generation.md` and guides the user through generation using `waza new eval` or `waza suggest`. Does not proceed until a validated suite is approved.

- **Phase 2: Performance Evaluation** — Agent runs `waza run --baseline` for default lift measurement (with-skill vs without-skill). For arbitrary A/B comparisons, agent runs two separate evaluations and uses `waza compare` for side-by-side results. Agent captures Waza's JSON output for analysis.

- **Phase 3: Trigger Evaluation** — Agent uses Waza native trigger tasks with `inject_skill_body: false` in the config. Tasks use `action_sequence` or `regex` validators to check whether the skill triggered. Agent uses `--trials 3-5` for variance detection.

- **Phase 4: Diagnostic Analysis** — Agent analyzes Waza's JSON results and generates a `diagnostic-report.md` containing: per-failure context/insight explaining *why* the failure occurred, Prescription A (conservative/minimal fix), and Prescription B (structural/architectural change). Agent also runs the hybrid grading workflow for soft assertions, claim extraction, and eval critique.

### Grading Model

Hybrid approach combining Waza validators with agent-based grading:

- **Deterministic checks** — Waza's built-in validators (regex, text, code, behavior, action_sequence, diff) handle pattern matching, compilation checks, tool-call verification, and snapshot comparison.
- **LLM-based judgment** — The agent applies reasoning for soft assertions (e.g., "tone is professional", "insightful analysis") only when deterministic checks are inapplicable.
- **Claim extraction** — Agent extracts implicit claims from outputs (factual, process, quality) and verifies them against transcripts and output files.
- **Eval critique** — Agent evaluates the quality of the eval assertions themselves, flagging weak/trivial assertions that create false confidence.

### Result Presentation

Two complementary outputs:

- **Waza serve dashboard** — Quantitative results: pass/fail per task, score distributions, model comparisons, aggregated metrics. Launched via `waza serve` after evaluation completes.
- **diagnostic-report.md** — Agent-generated qualitative analysis: failure explanations, dual-option prescriptions, claim verification results, eval critique, improvement suggestions. Written to the workspace directory.

### Eval Format Migration

The new skill adopts Waza's YAML format natively. The `evals.json` format is deprecated. Existing `evals.json` files (only `skill-architect/evals.json` in this repo) require a one-time migration to Waza's YAML structure. The rewritten `references/eval-generation.md` documents the mapping between old assertion types and Waza validators.

### Temporary Naming

The new skill is created at `skills/skills-meta/waza-skill-evaluator/` as a separate skill from the existing `skill-evaluator`. Once validated, it will be renamed to `skill-evaluator` and the old Python-based skill will be removed.

### Diagnostic Advisor Boundary

The skill operates as a Diagnostic Advisor, not an editor. It provides diagnoses and prescriptions (proposed code snippets) but **never** applies edits to the target skill's SKILL.md. This boundary is enforced in the SKILL.md instructions.

## Testing Decisions

### What Makes a Good Test

This skill is a SKILL.md with agent instructions, not executable code. Testing means:

- **Trigger accuracy** — Does the skill trigger on the correct prompts? Evaluated via Waza trigger tasks with `inject_skill_body: false`.
- **Workflow completeness** — Does the agent follow all 5 phases in sequence? Verified by examining the agent's transcript for evidence of each phase.
- **Output quality** — Does the diagnostic report contain actionable prescriptions? Verified by agent grading of the diagnostic-report.md content.
- **Constraint adherence** — Does the agent avoid modifying the target SKILL.md? Verified by checking that no file-writing tools were invoked on the target skill.

### Modules to Test

- The skill's trigger accuracy (positive and negative triggers)
- The Phase 0 prerequisites workflow (waza detection, installation guidance)
- The Phase 1 suite validation workflow (eval format detection, generation guidance)
- The Phase 4 diagnostic report generation (prescription quality, dual-option format)

### Prior Art

- `skill-architect/evals.json` — Existing eval format (being deprecated, but demonstrates the trigger/performance split)
- Waza's own eval examples (`examples/` directory in the Waza repo) — Demonstrate the YAML task/validator format

## Out of Scope

- **Skill packaging** — The existing `package_skill.py` (creates .skill zip files) is not carried forward. Packaging is a separate concern that can be addressed by a dedicated skill or Waza's own packaging features if/when they exist.
- **Skill validation** — The existing `quick_validate.py` (validates SKILL.md frontmatter) is not carried forward. Waza's `waza check` and `waza dev` commands provide equivalent or superior validation.
- **Custom HTML report generation** — The existing eval viewer's rich output file rendering (PDFs, XLSX, images) is not carried forward. Users who need this level of detail can use the existing eval viewer separately.
- **Blind A/B comparison with rubric scoring** — The existing comparator.md's structured rubric-based judging is not carried forward. Waza's `compare` provides quantitative comparison; the diagnostic phase provides qualitative analysis.
- **Post-hoc transcript analysis** — The existing analyzer.md's detailed transcript comparison is not carried forward as a separate agent. Its function is absorbed into the Phase 4 diagnostic instructions.
- **Multi-language support** — The skill is designed for evaluating agent skills (SKILL.md files), not arbitrary code. Language-specific testing concerns are out of scope.
- **CI/CD integration** — While Waza supports CI/CD via exit codes and GitHub comment formatting, the skill itself does not include CI/CD pipeline configuration. Users can integrate Waza directly into their pipelines.

## Further Notes

### ADR Reference

This PRD is governed by ADR-0001: "Migrate Skill Evaluator from Python to Waza CLI" (`docs/adr/0001-waza-skill-evaluator-migration.md`).

### Migration Path

The migration is a hard replacement, not a gradual transition. The new skill is developed separately as `waza-skill-evaluator`, validated against the existing `skill-architect` eval suite (after migration to Waza format), and then renamed to `skill-evaluator` while the old Python-based skill is removed.

### Waza Version Dependency

The skill relies on Waza features that may have been added recently (e.g., `--baseline` flag, `inject_skill_body: false`, `waza compare`). The Phase 0 prerequisites check should verify the installed Waza version supports these features. If Waza's API changes, the skill instructions may need updates.

### Agent Compatibility

The skill is designed to be consumed by any agent that supports the `Task` tool for spawning subagents and can invoke shell commands. It has been designed with Claude Code and Copilot in mind but should work with any compatible agent runtime.

### Risk: Waza Feature Stability

Waza is still evolving (currently v0.28.0). Features we depend on (`--baseline`, `inject_skill_body: false`, trigger task behavior) may change in future versions. The skill should be tested against the latest Waza release before each use, and the compatibility string may need version pinning if breaking changes occur.
