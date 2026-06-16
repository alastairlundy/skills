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
- Sections: **When to Use**, **When Not to Use**, **Workflow**, **Validation**
- "When to Use" section must use a bulleted list format
- Workflow steps must be deterministic — no vague language ("be smart", "as appropriate")
- Any skill whose workflow may need user clarification must include a "When to Use" bullet that invokes the `ask-questions` skill

### Evaluation format

Every skill must include a Waza Eval Suite in `evals/<skill-name>/`:
- `eval.yaml` — evaluation configuration
- `tasks/` — individual task definitions
- `fixtures/` — test inputs and expected outputs

Run evaluations with `waza run` and serve the eval UI with `waza serve`.

### Attribution

Derived content from upstream MIT sources must include attribution in the skill's documentation or comments.

## Agent skills

### Issue tracker

Issues live in the repo's GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Standard triage label vocabulary. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout. See `docs/agents/domain.md`.
