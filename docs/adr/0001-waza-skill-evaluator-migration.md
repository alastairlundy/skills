# Migrate Skill Evaluator from Python to Waza CLI

The existing `skill-evaluator` skill ships Python scripts (`aggregate_benchmark.py`, `run_eval.py`, `generate_review.py`, etc.) that must be remotely executed on the user's machine. We decided to replace it with a Waza-based skill (`waza-skill-evaluator`, later renamed to `skill-evaluator`) that uses the Waza CLI for execution, aggregation, and visualization.

**Why:** Eliminate the Python dependency, leverage Waza's native capabilities (baseline comparison, trigger tasks, result dashboard), and simplify maintenance by removing ~800 lines of custom Python.

**Trade-offs:** We're dropping the custom eval viewer (replaced by `waza serve` + agent markdown report), the surgical probing workflow (replaced by Waza native trigger tasks), and the blind comparator/post-hoc analyzer (absorbed into Waza's `compare` and the diagnostic phase). We're keeping the diagnostic prescription phase as agent-generated narrative, since Waza provides quantitative results but not qualitative "why this failed" analysis. The grading model is hybrid: Waza validators for deterministic checks, agent grading for soft assertions and claim extraction.

**Compatibility:** The skill declares `compatibility: waza CLI required (https://github.com/microsoft/waza)` in frontmatter. Phase 0 of the workflow checks for the `waza` CLI and guides installation if missing.
