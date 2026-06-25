# Diagnostic Report Template

This document is the authoritative template for the diagnostic report produced by the `waza-skill-evaluator` skill in Phase 7. It is loaded before the report is written, so the agent does not invent a structure or omit required sections. Refer to this file rather than guessing the shape.

The report has six sections in the order below. Each section is required; do not skip or reorder them.

## Length guidance

Target 400–1200 lines for a typical evaluation (10–30 tasks, 3–5 failures). Shorter evaluations can produce shorter reports; longer evaluations may need the upper end. The Executive Summary is short (≤30 lines). The Per-failure insights, Hybrid grading, and Eval critique sections scale with the number of failures. The Claim verification and Dashboard link sections are short and fixed.

## Section 1: Executive summary

- One-paragraph overall pass rate and lift (baseline vs treatment) for performance evals.
- One-paragraph trigger accuracy summary (true / false positive / false negative / true negative counts) for trigger evals.
- Top three regressions or surprises, named by Eval ID.
- Trial count used (per Phase 3 sub-step 3 of `SKILL.md`).
- A one-line statement of whether the dashboard was launched, with the URL if so, or a note that it was not.

## Section 2: Per-failure insights

- For each significant failure or regression, a block containing:
  - **Eval ID** — the specific task that failed.
  - **Context/Insight** — a technical explanation of *why* the failure occurred, drawing on the model's transcript, the skill's `SKILL.md` content, and the task's input/output.
  - **Recommended Fix A (Conservative)** — a surgical, minimal change.
  - **Recommended Fix B (Structural)** — a broader architectural or pattern change.
- Failures are ordered by severity (highest impact first).

## Section 3: Hybrid grading results

- A one-line user-facing definition: "Hybrid grading combines Waza's deterministic validator and LLM judge with the skill's own LLM grading, so the report covers more than the Waza evaluations alone."
- The output of Phase 6 of `SKILL.md` (Eval critique sub-steps 1–3): per-eval-suite weak-assertion flags, the `waza quality` content-quality score, and the cross-eval consistency check.

## Section 4: Claim verification results

- A table or list of claims extracted in Phase 4, with verification outcomes from Phase 5 (verified / contradicted / unverifiable) and the evidence source for each.

## Section 5: Eval critique

- The output of Phase 6 sub-step 1 of `SKILL.md` (eval-suite critique): weak or trivial assertions flagged.
- Suggestions for improving the evaluation suite itself, separate from the target skill.
- Note: the target skill's own `SKILL.md` improvements appear in Section 2 (Per-failure insights) as recommended fixes; this section critiques the *eval*, not the *skill*.

## Section 6: Dashboard link

- A markdown link to the Waza dashboard URL (`http://localhost:<port>`), launched in Phase 7 sub-step 5 of `SKILL.md`.
- A one-line note if the dashboard was not launched, pointing to `waza serve --help`.

## Path

The report is written to `<repo-root>/diagnostic-report.md` by default. If the user supplied a different path (at Phase 0, Phase 1, or via a `--output` flag), the supplied path takes precedence. See `SKILL.md` Phase 7 sub-step 3 for the path rule.
