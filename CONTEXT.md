# Glossary

## Skill Evaluator
A specialized tool that operates on an existing skill directory to verify its correctness and performance. It is decoupled from the initial skill creation process.

## Ticket
A handoff artifact scoping one session of work. Stands alone or hangs off a spec as one of its children. Contains goal, acceptance criteria, context pointers, and dependency relationships. Sized for at most 3-4 hours of focused work. Can be implemented by a human or agent.

## Session
A focused work session. A ticket should be completable within at most 3-4 hours. If sessions routinely degrade before completion, tickets are too large; if sessions spend most context on setup, tickets are too small.

## Spec
The input document (PRD, design doc, issue tracker reference, file path, or conversation context) that gets decomposed into tickets.

## Dependency Graph
The structure of blocked-by relationships between tickets. Determines execution order and enables parallelism. Independent tickets (leaves) can run concurrently.

## Decomposition Pattern
A strategy for organizing tickets from a spec. Three patterns are supported: Vertical Slices (each ticket delivers end-to-end functionality), Domain (tickets grouped by module or concept), and Features (tickets grouped by user-facing capability). The pattern choice depends on the spec's structure and influences ticket boundaries and dependencies.

## Vertical Slice (Tracer Bullet)
A decomposition strategy where each ticket cuts end-to-end through all layers (schema, API, UI, tests). A completed slice is demoable or verifiable on its own.

## Leaf Ticket
A ticket with no blockers in the dependency graph. Can be implemented immediately and enables parallelism when multiple team members or agents work concurrently.

## Context Pointers
References included in a ticket to relevant files, ADRs, and key domain terms. Provide context without requiring the implementer to re-derive what previous sessions knew.

## Interactive mode
Workflow mode where the skill interacts with the user for confirmation, decisions, and validation. Default mode when no explicit signal is given.

## Autonomous mode
Workflow mode where the skill operates without user interaction. Requires explicit authorization from the user.

## Independent (ticket classification)
A ticket that has sufficient context, acceptance criteria, and clear boundaries to be picked up and completed without further discussion. Can be implemented by a human or agent.

## Collaborative (ticket classification)
A ticket that requires discussion, decision-making, or review that cannot be resolved from the spec alone. Needs human involvement before or during implementation.

## Output Target
Where tickets are published - GitHub Issues, GitLab Issues, Gitea Issues, Codeberg Issues, a hosted Forgejo Instance's Issues, or local markdown files. Configurable via natural language argument.
