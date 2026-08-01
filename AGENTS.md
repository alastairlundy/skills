# Skills Repository

You are working in a repository of agent skill definitions (prompt templates). This repo contains no executable application code. The primary artifacts are `SKILL.md` files that define deterministic workflows for AI agents.

## Key facts

- **Primary deliverable**: `SKILL.md` files (prompt templates with deterministic workflows)
- **No build, test, or lint pipeline**: There is no compilation, bundling, packaging, or deploy step
- **No runtime dependencies**: Skills are declarative — they contain instructions, not executable code
- **Eval tooling**: `waza run` (add `--baseline` for comparison, `--trials N` for trigger accuracy); `waza serve` for the eval UI
- **Domain glossary**: `CONTEXT.md` at the repo root — use its vocabulary consistently; do not invent synonyms for defined terms

## Common mistakes

- Do not suggest adding build pipelines, test frameworks, or application dependencies
- Do not treat `SKILL.md` files as documentation for application code — they *are* the product
- Do not add `package.json`, `Cargo.toml`, `pyproject.toml`, or similar project manifests
- Do not suggest adding CI/CD for building or deploying — this repo has no deployable artifact
- Do not assume the agent is working on a downstream project that *uses* these skills — the agent is working *on the skills themselves*
- **NEVER edit skills under `.agents/skills/`** — these are installed upstream skills (tracked via `skills-lock.json`) and are external to this repo. Edits made there will be overwritten on the next install and will not be committed. If a change is needed, propose it upstream or mirror the skill into `skills/<category>/<skill-name>/`

## Repo layout

```
skills/<category>/<skill-name>/SKILL.md   ← one skill per directory
skills/<category>/<skill-name>/evals/     ← Waza Eval Suite (eval.yaml + tasks/ + fixtures/)
skills/<category>/<skill-name>/references/ ← templates ≥20 lines, loaded on demand
docs/agents/                              ← agent-consumable docs for THIS repo
docs/adr/                                 ← Architecture Decision Records
docs/decisions/                           ← Decision Ledgers (DECISIONS-*.md)
tickets/                                  ← local markdown tickets (from spec-to-tickets)
transcripts/                              ← eval run transcripts (gitignored)
.agents/skills/                           ← installed upstream skills (external, tracked in skills-lock.json)
```

Categories: `engineering/` (domain tasks), `alignment/` (LLM behaviour), `skills-meta/` (creating/evaluating skills).

## Skill file conventions

Every `SKILL.md` must have:
- H1 title: `# <Skill Name>` at the top
- YAML frontmatter: `name`, `description` (YAML block-fold `>-`), `license: MIT`
- Required sections: **When to Use**, **When Not to Use**, **Workflow**, **Validation**
- Conditional sections: **Output Mode** (non-default output behaviour), **Transitions** (depends on downstream tool/skill)
- "When to Use" must be a bulleted list of specific trigger scenarios
- Workflow steps must be deterministic — no vague language ("be smart", "as appropriate")
- Skills needing user clarification must include a "When to Use" bullet invoking the `ask-questions` skill
- **Triggers are conditional** — unconditional triggers ("applies by default") are not permitted

Full structure details: `CREATING-SKILLS.md`.

### Templates

Short templates (<20 lines) live inline in `SKILL.md`. Longer templates (≥20 lines) live in `references/` and are referenced with a load-trigger sentence ("Load `references/X.md` before Y"). See `skills/engineering/spec-to-tickets/references/ticket-template.md`.

### Decision Ledger references

When citing a Decision Ledger record from outside `docs/decisions/DECISIONS-*.md`, use the format `filename#Dxxx` (e.g. `DECISIONS-repo-feature.md#D001`). Bare `Dxxx`/`Txxx` references outside ledger files are prohibited. See `docs/agents/decision-ledger-audit.md`.

### Attribution

Derived content from upstream MIT sources must include attribution in the skill's documentation or comments.

## Agent skills

- **Issue tracker**: GitHub Issues via `gh` CLI — see `docs/agents/issue-tracker.md`
- **Triage labels**: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` — see `docs/agents/triage-labels.md`
- **Domain docs**: single-context layout, consume `CONTEXT.md` + `docs/adr/` — see `docs/agents/domain.md`
