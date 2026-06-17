# Glossary

## Skill Evaluator
A specialized tool that operates on an existing skill directory to verify its correctness and performance. It is decoupled from the initial skill creation process.

## Ticket
A handoff artifact scoping one session of work. Stands alone or hangs off a spec as one of its children. Contains goal, recommended workflow, acceptance criteria, context pointers, and dependency relationships. Sized for at most 3-4 hours of focused work. Can be implemented by a human or agent.

## Recommended Workflow
A section within a ticket that breaks implementation into ordered steps. Always present (minimum 1 step). Each step has four elements: a verb-phrase title, Where (file paths), bulleted actions, and Verify (a micro-verification). Distinct from Acceptance criteria, which are macro-verifications for the ticket as a whole. Steps can be reordered by the implementer but must respect inter-step dependencies.

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

## Slop
AI-generated text that exhibits vague modifiers, non-committal framing, or vocabulary patterns that signal automated origin rather than substantive content. Distinguished from "bad writing" by its surface-level polish and structural emptiness — text that follows a professional template while lacking measurable claims, goal alignment, or decisive positioning. Vocabulary-clean slop (e.g., text that avoids all banned words but is still substantively empty) is the hardest variant to detect.

## Goal Constraint
A concrete, measurable objective that grounds a response. Used to evaluate whether content advances a stated goal rather than drifting into tangential or hedged territory. Distinguished from a "goal" (which may be vague, e.g., "improve the code") by requiring specificity (e.g., "reduce cyclomatic complexity to < 10"). Vague goals must be decomposed into specific constraints before the constraint can ground the response.

## Pass/Fail Gate
A verification step that produces a binary pass/fail signal based on mechanical criteria. Used to remove the need for self-assessment — the gate's result is the source of truth, not the agent's claim of compliance. Distinguished from a self-administered checklist by the absence of judgment: the agent cannot tick the box without the gate having fired.
## Code implementation plan

The output artifact of `code-implementation-grilling`: a resolved set of *technical* decisions (language, framework, dependencies, project structure, sub-projects, project type, optional interfaces) derived from an existing spec or PRD. Distinct from a **general plan** (any non-code strategy, ops plan, business plan), a **domain model** (the conceptual map produced by `domain-grilling`), and a **spec/PRD** (the input document).

## code/technical problem

A problem whose resolution requires a programming/code related or technical solution. Used by `domain-grilling` to decide whether the `code-implementation-grilling` exit applies at convergence.

## ask_question
A discrete-choice clarification tool. Refers to a tool that lets an LLM pose multi-option questions to the user, with optional free-text override. The name is used in two ways: (1) the abstract affordance name in the `ask-questions` SKILL, and (2) the literal tool name in some agents (e.g., Claude Code's `ask_question` tool). In opencode, the tool that implements this affordance is named `question`; both names refer to the same affordance class.

## question
The concrete name of the `ask_question` tool in opencode. See `ask_question` for the full definition.

## label
The short, scannable title of an option in an `ask_question` tool call. Subject to a length cap defined by the relevant SKILL's shaping rules.

## question description
The short, discriminative explanation shown beneath a `label` in the `ask_question` UI. Must answer "why pick this over the others?"; teaching content belongs in context prose, not in descriptions.

## context prose
The LLM's message text *before* an `ask_question` tool call. Carries the longer setup, framing, and reasoning that the tool's options alone cannot hold. Subject to prose discipline: focused, scannable, not bloated.

## question tool call
A single invocation of the `ask_question` tool. The natural unit of "asking" for shaping purposes; questions batched within one call share a single user-response round.

## fit test
The second gate. Determines whether a candidate question is a fit for the `ask_question` tool: must be a decision question, or an honestly bracketed continuum. Questions that fail the fit test are rephrased or routed to a prose fallback.

## gate
A hard verification step in a workflow procedure whose failure prevents the next step. Distinguished from a checklist item by its enforcement: the LLM cannot proceed to the next gate without satisfying the current one.

## prose fallback
A question the LLM asks in its message text *without* invoking `ask_question`. Used as a last resort when the option set genuinely exceeds 2-4 honest options and no tool-compatible adaptation (raise abstraction, sequence, subsume, consolidate) preserves the question's meaning. Subject to the same prose discipline as context prose.

## load trigger
A sentence or "When to Use" bullet in a SKILL.md that tells the LLM when to load a `references/` file. Mitigates the self-referential under-trigger risk that arises when a long template is moved out of the inline skill to reduce context cost: the LLM only loads the reference if it recognizes the situation the trigger describes. Mirrors the convention for skills that need user clarification to invoke the `ask-questions` skill.

## evaluative opener

A subjective-judgement word used to begin a sentence (e.g., `Good`, `Great`, `Nice`, `Excellent`, `Perfect`, `Solid`, `Cool`, `Fair enough`, `Lovely`, `Brilliant`). Forbidden by the `domain-grilling` SKILL because an LLM has no emotions or subjective opinions to express. Distinguished from an **acknowledgement opener** — a neutral confirmation that is permitted.

## acknowledgement opener

A neutral-confirmation word used to begin a sentence (e.g., `Right`, `OK`, `Got it`, `Understood`). Permitted by the `domain-grilling` SKILL. Distinguished from an **evaluative opener** — a subjective judgement that is forbidden.

## in-session signal

A behaviour in which a skill detects a property of the problem during a session and surfaces that detection at a convergence point to tailor recommendations. Used by `domain-grilling` to decide whether to ask the explicit confirmation question "Is this a code/technical problem?" at convergence, before listing exits.
