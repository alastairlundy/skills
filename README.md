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
The skills in this repo don't depend on or require [Matt Pocock's Skills](https://github.com/mattpocock/skills/) . That being said some of this repo's skills may benefit from those also being installed or used. ``domain-grilling`` supports using the CONTEXT.md glossary system from ``grill-with-docs`` and ``setup-matt-pockock-skills``, and enables interaction with ``to-issues`` and ``to-prd``.

## Skills

Skills are organized into two categories:

### Engineering Skills

Domain-specific tasks for software development workflows.

| Skill | Description | Notes | 
|-------|-------------|-------|
| [spec-to-tickets](skills/engineering/spec-to-tickets/) | Decompose specs, PRDs, or conversation context into focused implementation tickets (at most 3-4 hours each) with dependency graphs, Independent/Collaborative classification, and context pointers. Outputs to issue trackers or local markdown. | Inspired by Matt Pocock's ``to-issues`` skill. |
| [domain-grilling](skills/engineering/domain-grilling/) | Relentless DDD-aligned interviewing skill that resolves design decisions linearly, sharpens domain terminology against CONTEXT.md, and documents architectural decisions as ADRs. | Inspired by Matt Pocock's ``grill-with-docs`` skill. |
| [code-implementation-grilling](skills/engineering/code-implementation-grilling/) | Relentlessly resolves concrete technical implementation details (language, framework, structure) from a plan or spec before ticket creation to minimize ambiguity for the implementer. | |
| [write-changelog](skills/engineering/write-changelog/) | Generate user-facing markdown changelogs from git history by analyzing commits, transforming messages, and categorizing changes across sub-projects. | |

### Alignment Skills

Skills for ensuring LLMs stay aligned on expectations and behaviour whilst performing tasks.

| Skill | Description | Notes | 
|-------|-------------|-------|
| [anti-slop](skills/alignment/anti-slop/) | Sanitizes LLM output by removing "AI slop", redundant phrasing, and sycophancy to maximize information density and maintain a professional AI identity. | |

### "Meta" Skills

Tools for creating and evaluating other skills.

| Skill | Description |
|-------|-------------|
| [skill-architect](skills/skills-meta/skill-architect/) | Guide the design of new agent skills by translating fuzzy intents into deterministic execution patterns. Used for AI-assisted skill design. |

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
