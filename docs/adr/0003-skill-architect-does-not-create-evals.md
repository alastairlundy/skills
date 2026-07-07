# ADR 0003: skill-architect does not create evaluation suites

- Status: Accepted
- Date: 2026-07-07

## Context

`AGENTS.md` mandates a Waza Eval Suite (`eval.yaml` + `tasks/` + `fixtures/`) for every skill. The question is which tool in the chain is responsible for creating it: the designing skill (`skill-architect`) or a separate evaluator tool?

The original review of `skill-architect` (ticket 001, reviewed at `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008`) surfaced a suggestion that `skill-architect` should enforce or generate eval suites as part of its workflow. The triage resolved against that suggestion — but left the decision undocumented as an open follow-up.

## Decision

`skill-architect` does NOT create eval suites. Eval creation is the job of `waza-skill-evaluator` (or a successor tool with the same scope). The `skill-architect` workflow ends with a designed `SKILL.md`; the user is responsible for invoking `waza-skill-evaluator` (or its successor) to generate the suite. The transitions to `waza-skill-evaluator` in `skill-architect`'s Transitions section (Phase 1: generate the suite; Phase 2: run baseline — per D007) are the canonical hand-off path.

## Consequences

**Positive**

- `skill-architect` stays scoped to design. Adding eval generation would bloat its workflow and create a coupling that complicates future tool evolution (e.g., adding new task types, switching eval frameworks).
- The evaluator tool can evolve independently — add new task types, switch eval frameworks, update runner syntax — without touching `skill-architect`.
- Separation of concerns aligns with the existing Transitions pattern: each tool in the chain has a single clear responsibility.

**Negative**

- `AGENTS.md`'s eval requirement is enforced at the project/review level, not by `skill-architect` itself. A skill that ships without an eval suite is an `AGENTS.md` violation caught by the review process — `skill-architect` will not catch it at design time.
- New users may need reminding to invoke `waza-skill-evaluator` after designing a skill, since `skill-architect` gives no eval-related output.

**Mitigations**

- The Transitions section in `skill-architect`'s `SKILL.md` lists the downstream evaluator as the next step, providing an explicit prompt for the user.
- The separation is documented in this ADR so future contributors do not re-litigate the boundary.

## Alternatives considered

- **`skill-architect` creates the eval suite** — rejected. Conflating design and evaluation in a single tool bloats the workflow, couples the evaluator format to the designing skill, and creates a maintenance burden: any change to the evaluation framework would require changes to `skill-architect`. Keeping the evaluator independent allows each tool to iterate on its own cadence.
