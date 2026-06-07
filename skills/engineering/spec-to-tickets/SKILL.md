---
name: spec-to-tickets
description: Create session-scoped implementation tickets with dependency graphs, HITL/AFK classification, and context pointers from a spec, PRD, or conversation context. Output to issue tracker or local markdown. Use when - spec/PRD exists and is complete, need tickets sized for one agent session, want to enable parallel agent work with explicit dependency tracking, need HITL/AFK classification per ticket. Don't use when - spec is incomplete or vague (use domain-grilling or to-prd first), need different granularity like epics or tasks, want to implement directly without decomposition, want simple flat issue list without dependency graphs (use to-issues instead).
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

### Step 1 - Detect mode

Determine whether the skill is running in HITL (Human In The Loop) or AFK (Away From Keyboard) mode.

1. Parse the user's natural language input for explicit mode signals. Phrases like "AFK", "just do it", "no need to ask me", or other affirmative authorizations for autonomous action indicate AFK mode. **If an explicit AFK signal is present, use AFK mode regardless of conversation history.**
2. If no explicit signal is present and the user has previously replied to the agent in the current conversation, default to HITL.
3. If no signal is present and no prior conversation exists, default to HITL.

Record the mode. All subsequent steps branch on this value.

### Step 2 - Gather input

Determine the source material to decompose. Accept one of three input types.

1. **Issue tracker reference** - If the user provides an issue number, URL, or path, fetch it using the project's git host CLI. Read the full body and comments.
2. **File path** - If the user provides a path to a local file (e.g., `docs/prds/feature-x.md`), read it.
3. **Conversation context** - If neither of the above is provided, assess whether the current conversation contains sufficient context. Proceed to Step 3.

### Step 3 - Assess conversation sufficiency

If the input source is conversation context, verify it contains enough detail to produce actionable tickets.

The conversation must contain all four of -
1. A problem statement (what is being solved)
2. A solution approach (how it will be solved - architecture, modules, key decisions)
3. Scope boundaries (what is in and out of scope)
4. Acceptance criteria or verifiable outcomes (how to know when done)

**In HITL mode** - present the heuristic results to the user. List which criteria are met and which are missing. Ask whether to proceed or provide a spec first.

**In AFK mode** - if all four criteria are met, proceed. If any are missing, abort and report which criteria are unsatisfied. Suggest using `domain-grilling` or `to-prd` to fill the gaps.

### Step 4 - Explore codebase

If not already explored in the current conversation -

1. Read `CONTEXT.md` at the repo root. If `CONTEXT-MAP.md` exists instead, read it and then read each `CONTEXT.md` it references.
2. Scan `docs/adr/` for architectural decisions relevant to the spec's area. In multi-context repos, also check `src/<context>/docs/adr/`.
3. Identify key files and modules that the tickets will likely reference.

Use the domain glossary vocabulary throughout all ticket content. Respect ADRs in the area being decomposed.

### Step 5 - Decompose into tickets

Break the source material into session-scoped tickets using vertical slices (tracer bullets).

**In HITL mode** -
1. Propose an initial decomposition as a numbered list. For each ticket, show - title, goal, classification (HITL/AFK), and which user stories or spec sections it covers.
2. Ask the user two questions - Does the granularity feel right? Should any tickets be merged or split?
3. Apply the user's feedback. Repeat until the user approves the decomposition.

**In AFK mode** -
1. Decompose using vertical slices. Each ticket cuts end-to-end through all layers (schema, API, UI, tests).
2. Each slice must deliver a narrow but complete path through every layer.
3. A completed slice must be demoable or verifiable on its own.
4. Prefer many thin slices over few thick ones.
5. Proceed without user confirmation.

### Step 6 - Identify dependencies

For each ticket, determine which other tickets must complete before it can start.

**In HITL mode** -
1. Propose a dependency graph. For each dependency, state the reason (e.g., "Ticket B is blocked by Ticket A because B adds an API endpoint that requires the database schema defined in A").
2. Ask the user to confirm or adjust.
3. Apply changes. Repeat until approved.

**In AFK mode** -
1. Infer dependencies from domain logic and layer ordering.
2. When uncertain whether two tickets are dependent, assume they are (prefer over-constraining over creating a broken graph).
3. Proceed without user confirmation.

### Step 7 - Classify tickets

Mark each ticket as HITL or AFK.

- **HITL** - the ticket requires a human decision that cannot be resolved from the spec alone (e.g., architectural choice between valid alternatives, design review, stakeholder approval).
- **AFK** - the ticket can be implemented and merged without human interaction, given the context pointers and acceptance criteria.

Prefer AFK over HITL. A ticket should only be HITL if there is a genuine decision that the spec does not resolve.

**In HITL mode** - classification was already shown and approved by the user in Step 5. Skip this step; the classifications are locked in.

**In AFK mode** - apply the classification rules above to each ticket.

### Step 8 - Check for existing tickets

Before publishing, detect whether tickets already exist for this source material.

1. **Local markdown** - check if a `tickets/` directory exists at the repo root and contains files with a matching `parent` frontmatter value. For conversation-context sources, match on the date prefix (e.g., `Conversation context (2026-06-07)`) rather than the full summary text.
2. **Issue tracker** - search for open issues whose body contains a matching parent reference.

If existing tickets are found -
- **In HITL mode** - present the finding. Offer three options - overwrite (delete existing, create new), update (modify existing in place), or cancel (abort). Wait for user choice.
- **In AFK mode** - abort. Report that existing tickets were found and recommend running in HITL mode to resolve.

### Step 9 - Generate ticket content

Apply the ticket template below to each approved ticket.

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

One sentence. What this ticket accomplishes in one session.

## What to build

Concise description of the end-to-end behavior. Describe what the system should do, not how to implement it. Avoid specific file paths or code snippets - they go stale. Exception - if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note that it came from a prototype.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Context pointers

**Files** - <key files to examine or modify>
**ADRs** - <relevant architectural decisions by reference>
**Domain terms** - <only terms from CONTEXT.md that are critical to understanding this ticket's scope and boundaries>

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

### Step 10 - Determine output target

Determine where to publish the tickets.

1. Parse the user's natural language input for output target signals. Phrases like "send to github issues", "target is gitlab", "save as markdown files", "local tickets" indicate the target.
2. If no signal is present -
   - **In HITL mode** - ask the user to choose - issue tracker or local markdown files.
   - **In AFK mode** - default to local markdown files.

### Step 11 - Publish tickets

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

### Step 12 - Report summary

After publishing, present a summary to the user containing -

1. **Stats** - total ticket count, HITL count, AFK count, leaf ticket count (tickets with no blockers).
2. **Dependency graph** - which tickets can start immediately, which are blocked and by what.
3. **Next steps** - suggested execution order and parallelism opportunities.
4. **Output location** - issue numbers or file paths where tickets were saved.

Omit detail already present in the tickets themselves. The summary should be scannable in under 30 seconds.

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
