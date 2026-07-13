# Waza CLI Command Catalogue

This document is the authoritative catalogue of Waza CLI commands used by the `waza-skill-evaluator` skill. It is loaded in Phase 0 (after the first-run probe, before any `waza` invocation) and consulted throughout the workflow whenever a Waza command is needed. Refer to this file rather than guessing flags or invocations.

## Installation

The Waza CLI is installed from <https://github.com/microsoft/waza>. Native PowerShell:

```powershell
irm https://raw.githubusercontent.com/microsoft/waza/main/install.ps1 | iex
```

Always obtain explicit user permission before downloading or installing.

## Version detection

- `waza --version` — print the installed Waza CLI version. The single command for confirming Waza is installed. There is no `waza version` subcommand; do not try one.

## Installation

If `waza --version` reports the CLI is not installed, present the user with the installation options from <https://github.com/microsoft/waza>. The native PowerShell installer is the canonical command for Windows hosts:

```
irm https://raw.githubusercontent.com/microsoft/waza/main/install.ps1 | iex
```

Linux and macOS hosts use the repository's shell installer; consult the README at the same URL for the current command. Always obtain **explicit user permission** before downloading or installing; never run an installer without confirmation. Re-run `waza --version` after install to confirm success.

## Required version features

The workflow assumes the installed Waza version supports each of the following. If any is missing, run `waza update` (after obtaining user permission) and re-verify:

- `waza run --baseline` — enables lift measurement by running each task twice (no-skill baseline, then skill-loaded treatment).
- `waza run --output` / `-o` and `--output-dir` — captures results to a file or directory for downstream analysis.
- `waza run --context-dir` — points the run at a fixtures directory.
- `config.inject_skill_body: false` in `eval.yaml` — required for trigger-precision evals so the model sees only the skill's description, not the body.
- `waza compare <result-A> <result-B>` and `waza results compare <run-id-1> <run-id-2>` — side-by-side comparison of two result files or two cloud-stored runs.
- `waza new eval <skill-name>` and `waza new task from-prompt "<prompt>" <task-path>` — suite and task scaffolding.

## Suite scaffolding

- `waza new eval <skill-name>` — scaffold a new evaluation structure for a skill. Creates `eval.yaml` plus positive and negative trigger task files.
- `waza new task from-prompt "<prompt>" <task-path>` — record a real Copilot session against a prompt and convert it into a task YAML with inferred validators.

## Running evaluations

- `waza run --baseline -o results.json` — run the eval suite in the current directory with a baseline comparison; writes the result to `results.json`. Runs each task twice: once without the skill (baseline) and once with the skill loaded (treatment). The diff is the lift.
- `waza run <skill-name> --baseline -o results.json` — same as above, targeting a specific skill by name.
- `waza run <skill-A> --output waza-output/base.json` — run a single eval (no baseline) and write results to the baseline file under `waza-output/`. Used for A/B comparison.
- `waza run <skill-B> --output waza-output/description-edits.json` — same as above for the treatment arm of an A/B comparison; the treatment file name is a hyphenated phrase describing what is being changed.
- `waza compare waza-output/base.json waza-output/description-edits.json [--format table|json]` — produce a side-by-side comparison of the two result files. The `table` format is human-readable; `json` is machine-readable.
- `waza results compare <run-id-1> <run-id-2>` — compare two cloud-stored runs by their run IDs.
- `waza coverage <root>` — produce a per-task coverage report (full / partial / missing) over `<root>`. Useful as a complement to running the suite.
- `waza grade <eval.yaml> --results results.json --output graded.json` — re-score an existing `results.json` against the graders in `<eval.yaml>` without re-executing the agent. Use this when graders have been updated and only the scoring needs to be re-run.

## Quality and one-shot checks

- `waza quality <skill-path>` — produce an LLM-as-judge content-quality score for the `SKILL.md` at `<skill-path>`. Used in Phase 6 to obtain a content-quality input for the eval critique.
- `waza check` — one-shot compliance/quality check on a single skill. Use this directly (outside the full workflow) when the user wants a quick check with no diagnostic report.

## Dashboard

- `waza serve [--port 3000]` — launch the Waza interactive dashboard. Default port is 3000. The dashboard displays pass/fail status per task, score distributions, model comparisons, and aggregated metrics. The URL follows the pattern `http://localhost:<port>`.

## Version management

- `waza update` — upgrade the Waza CLI to the latest version. Requires explicit user permission before invocation.

## Notes

- This catalogue covers only the commands the `waza-skill-evaluator` skill relies on. It is not a complete catalogue of every Waza command.
- Commands not listed here are outside the skill's surface. If a future Waza release adds a command the skill should use, it is added to this catalogue and to the relevant workflow phase in `SKILL.md`.
