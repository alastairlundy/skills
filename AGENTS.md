## Repo layout

This repo holds agent skills (prompt templates), not executable code. There is no build, test, or lint pipeline.

```
skills/<category>/<skill-name>/SKILL.md   ← one skill per directory
skills/<category>/<skill-name>/evals.json ← optional evaluation spec
docs/agents/                              ← agent-consumable docs for THIS repo
```

Categories: `engineering/` (domain tasks), `skills-meta/` (creating/evaluating skills).

## Skill file conventions

Every `SKILL.md` must have:
- YAML frontmatter with `name` and `description`
- Sections: **When to Use**, **When Not to Use**, **Workflow**, **Validation**
- Workflow steps must be deterministic — no vague language ("be smart", "as appropriate")

`evals.json` (optional) has two top-level keys: `performance` (id, description, input, assertion) and `trigger` (id, description, input, expected: "trigger"|"no-trigger").

## Agent skills

### Issue tracker

Issues live in the repo's GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Standard triage label vocabulary. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout. See `docs/agents/domain.md`.
