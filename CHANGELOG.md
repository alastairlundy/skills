# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-16

Initial stable release. 10 skills across 3 categories.

### Alignment
- **ask-questions** — Discrete-choice clarification tool for agents

### Engineering
- **code-implementation-grilling** — Socratic interviewing on technical implementation choices
- **dependency-review** — Audit third-party dependencies for staleness, bloat, and deprecation
- **domain-grilling** — Socratic interviewing on DDD alignment and bounded contexts
- **grilling** — Socratic interviewing for non-code, non-domain decisions
- **implement-tickets** — Coordinate parallel ticket implementation with sub-agent dispatch and judge loop
- **spec-to-tickets** — Decompose specs into implementation tickets with dependency graphs
- **write-changelog** — Generate user-facing changelogs from git history

### Skills-meta
- **setup-alastairlundy-skills** — Scaffold per-repo agent configuration docs
- **skill-architect** — Guide design and refinement of new agent skills

### Infrastructure
- `CONTEXT.md` glossary with canonical vocabulary
- `docs/adr/` for Architecture Decision Records
- `docs/decisions/` for Decision Ledgers
- `docs/agents/` for agent-consumable docs (issue tracker, triage labels, domain, decision-ledger-audit)
- `AGENTS.md` with repo conventions and skill file requirements
- `CONTRIBUTING.md` with contribution guidelines
- `CREATING-SKILLS.md` with skill authoring reference

### Notes
- Evals exist for most skills but require validation against the current Waza release. Validated evals are planned for a follow-up release.
