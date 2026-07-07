---
title: Create ADR documenting the skill-architect-does-not-create-evals stance
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md
---

## Goal

Document the decision that `skill-architect` does not create evaluation suites — eval creation is the job of `waza-skill-evaluator` (a separate tool/skill) — as an Architectural Decision Record so future contributors do not re-litigate the boundary and so the `AGENTS.md` eval requirement has a clear enforcement owner.

## What to build

Implements the open follow-up explicitly flagged in `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008` Constraints:

> **Follow-up (open):** create an ADR documenting the D008 Issue 13 stance — `skill-architect` does not create evals; it is the job of other tools/skills (e.g., `waza-skill-evaluator`) to create and run skill evals.

The ADR must capture:

- **Context**: `AGENTS.md` mandates a Waza Eval Suite (eval.yaml + tasks/ + fixtures/) for every skill. There is a question of where in the tool chain this suite is created — is the designing skill (e.g., `skill-architect`) responsible, or is it a separate evaluator tool's job?
- **Decision**: `skill-architect` does NOT create eval suites. Eval creation is the job of `waza-skill-evaluator` (or a successor tool with the same scope). The `skill-architect` workflow ends with a designed SKILL.md; the user is responsible for invoking `waza-skill-evaluator` (or its successor) to generate the suite. The transitions to `waza-skill-evaluator` in `skill-architect`'s Transitions section (Phase 1: generate the suite; Phase 2: run baseline — per ticket 001 / D007) are the canonical hand-off path.
- **Consequences**: `AGENTS.md`'s eval requirement is enforced at the project/review level, not by `skill-architect` itself. A skill that ships without an eval suite is a `AGENTS.md` violation caught by the review process — `skill-architect` will not catch it at design time. The separation keeps `skill-architect` scoped to design and lets the evaluator tool evolve independently (e.g., add new task types, switch eval frameworks).
- **Alternatives considered**: the original review suggested that `skill-architect` should enforce eval creation itself. That alternative is explicitly rejected — it would conflate design and evaluation, bloat the workflow, and create a coupling that complicates future tool evolution. The decision is recorded so future reviews do not re-suggest the rejected alternative.

## Recommended Workflow

### Step 1 — Draft the ADR

Where: `docs/adr/0003-skill-architect-does-not-create-evals.md`

- Use a consistent structure with the existing ADRs in `docs/adr/` (`0001-default-on-activation.md`, `0002-trigger-discipline-for-grilling-skills.md`). Match their tone and section headings so the new ADR fits the existing series.
- Sections, in order:
  - **Title and Status** — a single line that states the decision in active voice (e.g., "skill-architect does not create evaluation suites").
  - **Context** — the situation that prompted the decision (the AGENTS.md eval requirement, the open question of who creates the suite, the original review's suggestion that skill-architect should do it).
  - **Decision** — the resolved stance, in declarative language. State that eval creation is the job of `waza-skill-evaluator` or a successor tool. State that `skill-architect`'s workflow ends with a designed SKILL.md. Reference the Transitions section in `skill-architect` (Phase 1 / Phase 2) as the canonical hand-off path.
  - **Consequences** — what this decision enables and what it forecloses. Note the project/review-level enforcement of the AGENTS.md eval requirement. Note the decoupling benefit (evaluator tool can evolve independently).
  - **Alternatives Considered** — the rejected alternative (skill-architect creates the suite) with a one-paragraph reason for rejection.
- Cite the Decision Ledger record using `filename#Dxxx` format: `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008`.

Verify: The new ADR file has all 5 sections (Title and Status, Context, Decision, Consequences, Alternatives Considered) and cites the D008 Decision Ledger record using the `filename#Dxxx` format.

### Step 2 — Reference the ADR from `AGENTS.md`

Where: `AGENTS.md`

- In the "Evaluation format" section (which describes the Waza Eval Suite requirement), add a one-line reference to the new ADR that clarifies the enforcement owner.
- The reference should be a relative path link, e.g., `[ADR-0003](docs/adr/0003-skill-architect-does-not-create-evals.md)`, with a one-sentence note that the ADR documents the decision that eval creation lives outside the designing skill.
- Do not duplicate the ADR's content in AGENTS.md — link to it.

Verify: `AGENTS.md`'s "Evaluation format" section contains a relative link to the new ADR, with a one-sentence note that the ADR documents the eval-creation ownership.

## Context pointers

**Files**:
- `docs/adr/0003-skill-architect-does-not-create-evals.md` — the new ADR to be created
- `AGENTS.md` — gets a one-line reference to the new ADR in the "Evaluation format" section

**ADRs**:
- `docs/adr/0001-default-on-activation.md` — existing ADR; use as a structural reference for the new ADR's tone and section headings
- `docs/adr/0002-trigger-discipline-for-grilling-skills.md` — existing ADR; use as a structural reference for the new ADR's tone and section headings

**Domain terms**:
- **Waza Eval Suite** — the eval format AGENTS.md mandates: `eval.yaml` + `tasks/` + `fixtures/`. The ADR documents who creates it (the evaluator tool, not the designing skill).

**Ledger records**:
- `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008` — Issue 13 stance: `skill-architect` does not create evals; the open follow-up flagged in the Constraints block is the action this ticket implements

## Acceptance criteria

- [ ] `docs/adr/0003-skill-architect-does-not-create-evals.md` exists with the 5 expected sections (Title and Status, Context, Decision, Consequences, Alternatives Considered).
- [ ] The new ADR cites `docs/decisions/DECISIONS-calm-falcon-skill-architect-triage.md#D008` using the `filename#Dxxx` format.
- [ ] `AGENTS.md`'s "Evaluation format" section contains a relative link to the new ADR with a one-sentence note about eval-creation ownership.
- [ ] The new ADR's tone and section headings match the existing ADRs (`0001`, `0002`) in `docs/adr/`.
- [ ] The rejected alternative (skill-architect creates the suite) is documented with a one-paragraph reason for rejection.

## Dependencies

**Blocked by**: None — can start immediately. The ticket is a documentation-only addition (one new ADR file plus a one-line reference in `AGENTS.md`).
