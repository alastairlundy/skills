---
name: spec-to-tickets
description: Create session-scoped implementation tickets with dependency graphs, HITL/AFK classification, and context pointers from a spec, PRD, or conversation context. Output to issue tracker or local markdown. Use when - spec/PRD exists and is complete, need tickets sized for one agent session, want to enable parallel agent work with explicit dependency tracking, need HITL/AFK classification per ticket. Don't use when - spec is incomplete or vague (use domain-grilling or to-prd first), need different granularity like epics or tasks, want to implement directly without decomposition, user explicitly wants to send tickets to issue tracker AND doesn't need dependency graphs or classification (use to-issues instead).
---

# Spec to Tickets

Break a spec, PRD, or conversation context into session-scoped tickets with dependency graphs, optimized for agent implementation.

## When to Use

- A spec, PRD, or design document exists and is complete enough to decompose
- The conversation context contains a resolved plan with problem statement, solution approach, scope boundaries, and acceptance criteria
- Tickets need to be sized for one agent session
- Output should target an issue tracker or local markdown files
- Parallel agent work is desired (dependency graph enables concurrent sessions on leaf tickets)

## When Not to Use

- The spec is incomplete, vague, or unresolved (use `domain-grilling` to resolve, or `to-prd` to capture)
- A different granularity is needed (epics, milestones, tasks)
- The goal is direct implementation rather than decomposition
- The source material is a single trivial change that does not benefit from decomposition

## Workflow

Use a conversational tone. Provide a brief opening statement that frames the workflow (e.g., "Following the spec to tickets workflow to break down this spec, as requested"), then use transitional phrases between major sections. Avoid step-by-step narration or broadcasting internal step numbers.

**Abbreviation rules** - In workflow output, avoid all abbreviations except AFK and terms previously defined in CONTEXT.md or the project glossary. When writing ticket content, prohibit abbreviations not previously agreed upon in CONTEXT.md/glossary unless they are explicitly used by the user or spec. In such cases, clarify unfamiliar abbreviations in brackets on first use (e.g., "HITL (Human In The Loop)").

### 1. Mode Detection

Determine whether the skill is running in HITL (Human In The Loop) or AFK (Away From Keyboard) mode.

1. Parse the user's natural language input for explicit mode signals. Phrases like "AFK", "just do it", "no need to ask me", or other affirmative authorizations for autonomous action indicate AFK mode. **If an explicit AFK signal is present, use AFK mode regardless of conversation history.**
2. **AFK negative signals** - phrases requesting to overwrite, replace, rewrite, or delete existing tickets are NOT AFK signals. These involve destructive operations on existing work and always require HITL mode. If the user uses these phrases alongside an AFK signal, treat the request as HITL.
3. If no explicit signal is present and the user has previously replied to the agent in the current conversation, default to HITL.
4. If no signal is present and no prior conversation exists, default to HITL.

Record the mode. All subsequent steps branch on this value. When presenting the detected mode to the user, use the full term (Human In The Loop or Away From Keyboard) rather than the abbreviation.

### 2. Input Gathering

Determine the source material to decompose. Accept one of three input types.

1. **Issue tracker reference** - If the user provides an issue number, URL, or path, fetch it using the project's git host CLI. Read the full body and comments.
2. **File path** - If the user provides a path to a local file (e.g., `docs/prds/feature-x.md`), read it.
3. **Conversation context** - If neither of the above is provided, assess whether the current conversation contains sufficient context. Proceed to Input Sufficiency Check.

### 3. Input Sufficiency Check

Verify the input contains enough detail to produce actionable tickets. This check applies to all input types - a 2-line PRD file is as insufficient as a vague conversation.

The input must contain all four of -
1. A problem statement (what is being solved)
2. A solution approach (how it will be solved - architecture, modules, key decisions)
3. Scope boundaries (what is in and out of scope)
4. Acceptance criteria or verifiable outcomes (how to know when done)

**In HITL mode** - present the heuristic results to the user. List which criteria are met and which are missing. Ask whether to proceed or provide a spec first.

**In AFK mode** - if all four criteria are met, proceed. If any are missing, abort and report which criteria are unsatisfied. Suggest using `domain-grilling` or `to-prd` to fill the gaps.

### 4. Codebase Exploration

If not already explored in the current conversation -

1. Read `CONTEXT.md` at the repo root. If `CONTEXT-MAP.md` exists instead, read it and then read each `CONTEXT.md` it references.
2. Scan `docs/adr/` for architectural decisions relevant to the spec's area. In multi-context repos, also check `src/<context>/docs/adr/`.
3. Identify key files and modules that the tickets will likely reference.

Use the domain glossary vocabulary throughout all ticket content. Respect ADRs in the area being decomposed.

### 5. Output Target Resolution

Determine where to publish the tickets. This must be resolved before decomposition because the output target affects ticket content (e.g., `blocked_by` uses issue numbers vs file basenames).

1. Parse the user's natural language input for output target signals. Phrases like "send to github issues", "target is gitlab", "save as markdown files", "local tickets" indicate the target.
2. If no signal is present -
   - **In HITL mode** - ask the user to choose - issue tracker or local markdown files.
   - **In AFK mode** - default to local markdown files.

### 6. Ticket Decomposition Proposal

Break the source material into session-scoped tickets, identify which tickets block others, and classify each as HITL or AFK. These three activities are inseparable - dependencies emerge from decomposition, and classification depends on both.

**Decomposition strategies** - choose one based on the spec's structure -
- **Vertical slices** - each ticket cuts end-to-end through all layers (schema, API, UI, tests). For non-code projects, "layers" means the distinct deliverable components - e.g., for a documentation skill - instructions, reference documents, agent definitions, test suite. Each slice delivers a narrow but complete path and is demoable or verifiable on its own. Best for feature work with clear functional boundaries.
- **Domain** - group tickets by domain concept or module. Best for large refactors or work organized around distinct subsystems.
- **Features** - group tickets by user-facing capability or user story. Best for product-oriented specs with clear feature boundaries.

When the spec explicitly enumerates components or modules, use them as the basis for decomposition rather than deriving slices independently. Each component becomes a ticket, with a scaffolding/integration ticket if needed.

**Classification rules** - mark each ticket as HITL or AFK -
- **HITL** - the ticket requires a human decision that cannot be resolved from the spec alone (e.g., architectural choice between valid alternatives, design review, stakeholder approval).
- **AFK** - the ticket can be implemented and merged without human interaction, given the context pointers and acceptance criteria.

Prefer AFK over HITL. A ticket should only be HITL if there is a genuine decision that the spec does not resolve.

**Sizing heuristic** - applies to all modes. Aim for 2-8 tickets for a single-PRD decomposition. Fewer than 2 suggests tickets are too coarse (each should fit one session), unless the scope of the work is already narrowly scoped. More than 8 suggests tickets are too fine (merge related work). Prefer many thin slices over few thick ones.

**In HITL mode** -
1. Recommend a decomposition strategy based on the spec's structure and explain why. Also mention the other strategies considered (Vertical Slices, Domain, Features) and briefly explain why they were not selected for this spec.
2. Propose the full decomposition as a table or structured list. For each ticket, show - title, goal, classification (HITL/AFK), which User Stories or spec sections it covers, and which other tickets it depends on (with reasons). Do not abbreviate "User Stories" to "US" or any other form - always use the full term. Do not abbreviate column headers - use full, clear terms.
3. Ask the user - Does the strategy and granularity feel right? Should any tickets be merged or split?
4. Apply the user's feedback. Repeat until the user approves the decomposition, dependencies, and classifications.

**In AFK mode** -
1. Select the decomposition strategy most appropriate for the spec without user confirmation.
2. Decompose into tickets. Each ticket must be demoable or verifiable on its own.
3. Infer dependencies from domain logic and layer ordering. When uncertain whether two tickets are dependent, assume they are (prefer over-constraining over creating a broken graph).
4. Apply classification rules to each ticket.
5. Proceed without user confirmation.

### 7. Existing Ticket Detection

Before publishing, detect whether tickets already exist for this source material.

1. **Local markdown** - check if a `tickets/` directory exists at the repo root and contains files with a matching `parent` frontmatter value. Matching rules by input type -
   - Issue tracker reference - exact issue number or URL match in `parent` field.
   - File path - exact relative path match in `parent` field.
   - Conversation context - match on the date prefix (e.g., `Conversation context (2026-06-07)`) rather than the full summary text.
2. **Issue tracker** - search for open issues whose body contains a matching parent reference, using the same matching rules above.

**If existing tickets are found and the user explicitly asked to overwrite/replace them** (this is always HITL mode per Mode Detection):
- **If the spec/PRD is available** - proceed with the normal workflow as if the tickets don't exist. The new tickets will overwrite the existing ones.
- **If the spec/PRD is NOT available** - read the existing tickets and update them to conform to the skill's template and guidance (goal, what to build, acceptance criteria, context pointers, etc.). Preserve the existing ticket content and structure where it meets the guidance.
  - **If the existing tickets lack sufficient information to enable meaningful improvements** - gracefully fail. Explain to the user why the update is not possible (insufficient context in existing tickets) and suggest creating or providing the spec/PRD to enable proper decomposition.

**If existing tickets are found but the user did not explicitly ask to overwrite/replace them:**
- **In HITL mode** - present the finding. Offer three options - overwrite (delete existing, create new), update (modify existing in place to match skill guidance), or cancel (abort). Wait for user choice. If the user chooses overwrite or update, apply the logic above.
- **In AFK mode** - abort. Report that existing tickets were found and recommend running in HITL mode to resolve.

### 8. Ticket Generation

Apply the ticket template below to each approved ticket.

**Abbreviation rule** - Do not use abbreviations in ticket content unless they are defined in CONTEXT.md, the project glossary, or explicitly used by the user/spec. When using an abbreviation that may be unfamiliar, clarify it in brackets on first use (e.g., "HITL (Human In The Loop)"). Never abbreviate "User Stories" to "US".

<ticket-template>

```yaml
---
title: <short descriptive name>
classification: <HITL|AFK>
blocked_by: [<ticket references or empty>]
parent: <spec reference>
---
```

**blocked_by reference format by output target:**
- Issue tracker: issue numbers (e.g., `#42`)
- Local markdown: zero-padded file basenames without extension (e.g., `001-authentication`)

## Goal

Brief statement of what this ticket accomplishes and why it matters. One to three sentences - enough to orient an implementing agent without requiring them to read the full ticket.

## What to build

Description of the end-to-end behavior with sufficient context for an implementing agent to understand what to do and why. Describe what the system should do and the outcomes it must achieve. Avoid specific file paths or code snippets - they go stale. Exceptions - if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note that it came from a prototype. For greenfield or structural work where the file/directory layout is itself a deliverable, specify paths.

## Implementation details (conditional)

Include this section only when the spec or PRD prescribes specific technical choices, approaches, or constraints that must be followed. These are not suggestions - they are requirements from the spec that constrain how the implementation is done. Examples - specific tools to use (e.g., "use Waza CLI"), file formats (e.g., "write in YAML"), architectural patterns (e.g., "use event sourcing"), or specific file/directory structures when they are deliverables.

If the spec does not prescribe implementation details, omit this section entirely.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Context pointers

**Files** - <key files to examine or modify, with brief notes on why they're relevant>
**ADRs** - <relevant architectural decisions by reference>
**Domain terms** - <terms from CONTEXT.md that help understand this ticket's scope and boundaries - include enough to prevent confusion, but do not reproduce the glossary>

## Dependencies

**Blocked by** - <ticket references that must complete first, or "None - can start immediately">

</ticket-template>

**Parent field values by input type** -
- Issue tracker reference - the issue number or URL (e.g., `#123`)
- File path - the relative file path (e.g., `docs/prds/feature-x.md`)
- Conversation context - the date and a 1-3 sentence summary sufficient for a reader who was not part of the original conversation (e.g., `Conversation context (2026-06-07) - Implementing user authentication with OAuth2 and session management. Agreed on PKCE flow with refresh token rotation. Out of scope - social login providers.`)

**Context pointers rules** -
- Include only files directly relevant to this ticket's scope.
- Include only ADRs that constrain this ticket's implementation.
- Include only domain terms that define boundaries or clarify ambiguity for this ticket. Do not reproduce the glossary.

### 9. Ticket Publishing

Publish the generated tickets to the chosen target.

#### Issue tracker target

1. Detect the project's git host -
   a. Parse `git remote -v` to extract the hostname.
   b. If the hostname is ambiguous (e.g., self-hosted with custom domain), check for host-specific config files (`.github/`, `.gitlab-ci.yml`, `.gitea/`).
   c. If detection fails, ask the user which host the project uses.
2. Look up the expected CLI for the detected host -
   - `github.com` → `gh`
   - `gitlab.com` or self-hosted GitLab → `glab`
   - `gitea.com` or Forgejo → `tea`
   - Other hosts → search PATH for known CLIs, or ask the user.
3. Verify the CLI is installed by checking if it is available in PATH. If not found, inform the user and provide installation guidance.
4. Publish tickets in dependency order - blockers first, then dependents. This ensures blocking ticket issue numbers exist before they are referenced in "Blocked by" fields.
5. For each ticket, create an issue using the host CLI. Fill in the "Blocked by" field with real issue numbers of previously published blocking tickets.
6. Do NOT close or modify any parent issue.

#### Local markdown target

1. Create a `tickets/` directory at the repo root if it does not exist.
2. Determine directory structure based on ticket count -
   - **Fewer than 8 tickets** - flat structure. All files in `tickets/`.
   - **8 or more tickets** - structured subdirectories -
     - **In HITL mode** - ask the user to choose a grouping strategy - dependency graph position (topological layers), domain concept, or feature area.
     - **In AFK mode** - group by domain concept.
3. Name files with zero-padded sequential numbers - `001-authentication.md`, `002-user-profiles.md`.
4. If using structured directories, place files in the group subdirectory - `tickets/authentication/001-login-endpoint.md`.
5. Write each ticket as a markdown file with YAML frontmatter matching the ticket template.

### 10. Summary Report

After publishing, present a summary to the user containing -

1. **Stats** - total ticket count, HITL count, AFK count, leaf ticket count (tickets with no blockers).
2. **Dependency graph** - which tickets can start immediately, which are blocked and by what.
3. **Next steps** - suggested execution order and parallelism opportunities.
4. **Output location** - issue numbers or file paths where tickets were saved.

The summary should be scannable - use clear structure (headings, tables, lists) so key information is quickly findable. Include enough detail to be useful without requiring the user to read the tickets, but avoid reproducing ticket content verbatim.

## Validation

- [ ] Every ticket has a goal, acceptance criteria, context pointers, blocked-by field, parent reference, and classification.
- [ ] No ticket requires context beyond its own body and its context pointers to begin work.
- [ ] The dependency graph has no cycles.
- [ ] Context pointers reference only files, ADRs, and domain terms directly relevant to the ticket.
- [ ] The glossary is not reproduced in any ticket's context pointers.
- [ ] Parent field contains a 1-3 sentence summary when the source is conversation context.
- [ ] Tickets were published in dependency order (blockers first) when targeting an issue tracker.
- [ ] The summary report includes stats, dependency graph, and next steps.
- [ ] The "Blocks" field is not used anywhere - dependencies are tracked via "Blocked by" only.
- [ ] The description contains no YAML-breaking characters (colons, unquoted special chars).
- [ ] Ticket count is at least 2, unless the spec scope is already narrowly scoped.
- [ ] No abbreviations are used in ticket content or workflow output unless defined in CONTEXT.md/glossary, explicitly used by the user/spec, or AFK. Unfamiliar abbreviations are clarified in brackets on first use. "User Stories" is never abbreviated to "US".
