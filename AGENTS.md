## Repo layout

This repo holds agent skills (prompt templates), not executable code. There is no build, test, or lint pipeline.

```
skills/<category>/<skill-name>/SKILL.md   ← one skill per directory
skills/<category>/<skill-name>/evals/     ← Waza Eval Suite (eval.yaml + tasks/ + fixtures/)
docs/agents/                              ← agent-consumable docs for THIS repo
```

Categories: `engineering/` (domain tasks), `alignment/` (LLM behaviour and expectations), `skills-meta/` (creating/evaluating skills).

## Skill file conventions

Every `SKILL.md` must have:
- H1 title: `# <Skill Name>` at the top of the file
- YAML frontmatter with:
  - `name` field
  - `description` field using YAML block-fold syntax (`>-`)
  - `license: MIT` field
- Sections: **When to Use**, **When Not to Use**, **Workflow**, **Validation** (always present); **Output Mode** and **Transitions** are included conditionally — Output Mode when the skill has a non-default output behaviour, Transitions when the skill depends on a downstream tool or skill
- "When to Use" section must use a bulleted list format
- Workflow steps must be deterministic — no vague language ("be smart", "as appropriate")
- Any skill whose workflow may need user clarification must include a "When to Use" bullet that invokes the `ask-questions` skill

### Evaluation format

Every skill must include a Waza Eval Suite in `evals/<skill-name>/`:
- `eval.yaml` — evaluation configuration
- `tasks/` — individual task definitions
- `fixtures/` — test inputs and expected outputs

Run evaluations with `waza run` and serve the eval UI with `waza serve`.

Eval creation is the job of the downstream evaluator tool (`waza-skill-evaluator` or its successor), not the designing skill itself. See [ADR-0003](docs/adr/0003-skill-architect-does-not-create-evals.md) for the full decision.

### Attribution

Derived content from upstream MIT sources must include attribution in the skill's documentation or comments.

## Skill conventions

### Templates

Short templates (<20 lines) live inline in `SKILL.md`. Longer templates (≥20 lines) live in `references/` and are referenced from `SKILL.md` with a load-trigger sentence ("Load `references/X.md` before Y"). Templates in `SKILL.md` consume context on every activation; templates in `references/` load only when needed. See `skills/engineering/spec-to-tickets/references/ticket-template.md` for an example.

### Trigger shape

Skills activate conditionally, not by default. The "When to Use" section must list specific scenarios the skill applies to. Unconditional triggers ("applies by default", "always use this") are not permitted — they cause skills to compete with task-specific skills for context on every step. See `skills/alignment/anti-slop/SKILL.md` for an example.

## Agent skills

### Issue tracker

Issues live in the repo's GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Standard triage label vocabulary. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout. See `docs/agents/domain.md`.
