# SKILLs

My AI Agent Skills developed to solve problems when creating and maintaining software with AI.

This repository contains no executable code — only structured skill definitions that AI agents can load and follow. Each skill provides deterministic workflows for specific tasks.

## Quickstart
Run the skills.sh installer:

```bash
npx skills@latest add alastairlundy/skills
```

Pick the skills you want, and which coding agents you want to install them on. 

### Dependence on Matt Pocock's Skills 
The skills in this repo don't depend on or require [Matt Pocock's Skills](https://github.com/mattpocock/skills/) . That being said some of this repo's skills may benefit from those also being installed or used. ``domain-grilling`` supports using the CONTEXT.md glossary system from ``setup-matt-pockock-skills``, and enables interaction with ``to-issues`` and ``to-prd``.

## Skills

Skills are organized into two categories:

### Engineering Skills

Domain-specific tasks for software development workflows.

| Skill | Description | Notes | 
|-------|-------------|-------|
| [spec-to-tickets](skills/engineering/spec-to-tickets/) | Break specs, PRDs, or conversation context into focused tickets sized by coherence, with dependency ordering. Outputs to issue trackers or local markdown. | Inspired by Matt Pocock's ``to-issues`` skill. |
| [grilling](skills/engineering/grilling/) | Socratic interviewing for non-code, non-domain decisions — strategy, direction, design, process. Extracts clear decisions from vague ideas. | Generic parent of ``domain-grilling`` and ``code-implementation-grilling``. |
| [domain-grilling](skills/engineering/domain-grilling/) | Socratic interviewing for domain modeling — bounded contexts, glossary, terminology. Aligns ubiquitous language and writes decisions to ADRs. | Specializes ``grilling``; inspired by Matt Pocock's ``grill-with-docs`` skill. |
| [code-implementation-grilling](skills/engineering/code-implementation-grilling/) | Socratic interviewing on technical choices — language, framework, dependencies, structure. Resolves implementation ambiguity once a spec exists. | Specializes ``grilling``. |
| [write-changelog](skills/engineering/write-changelog/) | Generate user-facing changelogs from git history. Analyzes commits, groups changes by sub-project, supports tag ranges. | |
| [dependency-review](skills/engineering/dependency-review/) | Audit dependencies for staleness, bloat, coupling, and deprecation. Produces a structured report. Default scope is code only. | Pass `scope: code,non-code` to opt in to OS, runtimes, hosted services, databases, and CI tooling. |
| [implement-tickets](skills/engineering/implement-tickets/) | Coordinate parallel ticket implementation. Builds dependency order, dispatches tickets to sub-agents, validates against acceptance criteria, commits per ticket. | Use when a batch of tickets should be implemented with per-ticket commits and an end-of-run report. |

### Alignment Skills

Skills for ensuring LLMs stay aligned on expectations and behaviour whilst performing tasks.

| Skill | Description | Notes | 
|-------|-------------|-------|
| [ask-questions](skills/alignment/ask-questions/) | Guide agents on when and how to ask questions via discrete-choice tools or prose. Teaches a four-gate procedure to balance over-asking and under-asking. | |

### "Meta" Skills

Tools for creating and evaluating other skills.

| Skill | Description |
|-------|-------------|
| [skill-architect](skills/skills-meta/skill-architect/) | Guide the design and refinement of new agent skills. Ensures designs follow established conventions without writing files. |
| [setup-alastairlundy-skills](skills/skills-meta/setup-alastairlundy-skills/) | Configure a repository to use the skill family. Writes agent-consumable docs and updates AGENTS.md or CLAUDE.md with skill configuration. | Use when setting up a new repo for AI agents, switching the repo's issue tracker, or re-running after a config change. |

## Repository Structure

```
skills/<category>/<skill-name>/
├── SKILL.md          # Skill definition (required)
└── evals.json        # Evaluation specification (optional)

docs/
├── agents/           # Agent-consumable documentation
│   ├── domain.md           # How to consume CONTEXT.md and ADRs
│   ├── issue-tracker.md    # GitHub CLI conventions
│   └── triage-labels.md    # Standard label vocabulary
├── adr/              # Architecture Decision Records
└── prds/             # Product Requirements Documents

CONTEXT.md            # Domain glossary (required)
AGENTS.md             # Repository conventions for agents
tickets/              # Implementation tickets (when using local markdown output)
```

## Key Concepts

This repository uses specific terminology for skill workflows:

- **Spec** — Input document (PRD, design doc, issue, or conversation) that gets decomposed into tickets
- **Ticket** — Session-scoped work artifact with goal, acceptance criteria, context pointers, and dependencies
- **Session** — Focused work session; a ticket should be completable within at most 3-4 hours
- **Dependency Graph** — Structure of blocked-by relationships between tickets
- **Vertical Slice** — Decomposition strategy where each ticket cuts end-to-end through all layers
- **Interactive mode** — Workflow mode where the skill interacts with the user for confirmation, decisions, and validation
- **Autonomous mode** — Workflow mode where the skill operates without user interaction, requires explicit authorization
- **Independent (ticket classification)** — Ticket has sufficient context to proceed without further discussion, can be implemented by a human or agent
- **Collaborative (ticket classification)** — Ticket requires discussion, decision-making, or review before or during implementation
- **Context Pointers** — References to files, ADRs, and domain terms included in tickets

See [CONTEXT.md](CONTEXT.md) for the complete glossary.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Creating new skills
- Improving existing skills
- Evaluating skill performance with Waza CLI
- AI-assisted skill creation with skill-architect

For skill structure and conventions, see [CREATING-SKILLS.md](CREATING-SKILLS.md).

## License

Human written content in this repo is licensed under the MIT license. Some content in this repo is AI generated.
