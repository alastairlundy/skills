# SKILLs

My AI Agent Skills developed to solve problems when creating and maintaining software with AI.

This repository contains no executable code — only structured skill definitions that AI agents can load and follow. Each skill provides deterministic workflows for specific tasks.

## Skills

Skills are organized into two categories:

### Engineering Skills

Domain-specific tasks for software development workflows.

| Skill | Description | Notes | 
|-------|-------------|-------|
| [spec-to-tickets](skills/engineering/spec-to-tickets/) | Decompose specs, PRDs, or conversation context into session-scoped implementation tickets with dependency graphs, Human In the Loop (HITL)/AFK classification, and context pointers. Outputs to issue trackers or local markdown. | Inspired by Matt Pocock's ``to-issues`` skill. |
| [domain-grilling](skills/engineering/domain-grilling/) | Relentless DDD-aligned interviewing skill that resolves design decisions linearly, sharpens domain terminology against CONTEXT.md, and documents architectural decisions as ADRs. | Inspired by Matt Pocock's ``grill-with-docs`` skill. |
| [write-changelog](skills/engineering/write-changelog/) | Generate user-facing markdown changelogs from git history by analyzing commits, transforming messages, and categorizing changes across sub-projects. | |

### "Meta" Skills

Tools for creating and evaluating other skills.

| Skill | Description |
|-------|-------------|
| [skill-architect](skills/skills-meta/skill-architect/) | Guide the design of new agent skills by translating fuzzy intents into deterministic execution patterns. Used for AI-assisted skill design. |
| [waza-skill-evaluator](skills/skills-meta/waza-skill-evaluator/) | Evaluate skill correctness, measure "lift" over baselines, analyze trigger accuracy, and generate diagnostic reports with improvement prescriptions using the [Waza CLI](https://github.com/microsoft/waza). |

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
- **Session** — Unit of work scope; a ticket should be completable within one session
- **Dependency Graph** — Structure of blocked-by relationships between tickets
- **Vertical Slice** — Decomposition strategy where each ticket cuts end-to-end through all layers
- **HITL (Human In The Loop)** — Operating mode requiring user interaction for decisions
- **AFK (Away From Keyboard)** — Autonomous operating mode requiring explicit authorization
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
