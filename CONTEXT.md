# Glossary

## Skill Evaluator
A specialized tool that operates on an existing skill directory to verify its correctness and performance. It is decoupled from the initial skill creation process.

## Ticket
A handoff artifact scoping one session of work. Stands alone or hangs off a spec as one of its children. Contains goal, acceptance criteria, context pointers, and dependency relationships. Sized to be completable before the agent's context degrades.

## Session
The unit of work scope for a ticket. A ticket should be completable within one session. If sessions routinely degrade before completion, tickets are too large; if sessions spend most context on setup, tickets are too small.

## Spec
The input document (PRD, design doc, issue tracker reference, file path, or conversation context) that gets decomposed into tickets.

## Dependency Graph
The structure of blocked-by relationships between tickets. Determines execution order and enables parallelism. Independent tickets (leaves) can run concurrently.

## Decomposition Pattern
A strategy for organizing tickets from a spec. Three patterns are supported: Vertical Slices (each ticket delivers end-to-end functionality), Domain (tickets grouped by module or concept), and Features (tickets grouped by user-facing capability). The pattern choice depends on the spec's structure and influences ticket boundaries and dependencies.

## Vertical Slice (Tracer Bullet)
A decomposition strategy where each ticket cuts end-to-end through all layers (schema, API, UI, tests). A completed slice is demoable or verifiable on its own.

## Leaf Ticket
A ticket with no blockers in the dependency graph. Can be implemented immediately and enables parallelism when multiple agents work concurrently.

## Context Pointers
References included in a ticket to relevant files, ADRs, and key domain terms. Provide context without requiring the agent to re-derive what previous sessions knew.

## HITL (Human In The Loop)
Operating mode where the skill interacts with the user for confirmation, decisions, and validation. Default mode when no explicit signal is given.

## AFK (Away From Keyboard)
Operating mode where the skill operates autonomously without human interaction. Requires explicit authorization from the user.

## Output Target
Where tickets are published - either an issue tracker (GitHub Issues, GitLab Issues, etc.) or local markdown files. Configurable via natural language argument.
