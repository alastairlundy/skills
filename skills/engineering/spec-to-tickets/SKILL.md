---
name: spec-to-tickets
description: >-
  Create implementation tickets with dependency graphs and Independent/Collaborative classification. Use when a user wants to break down a spec or tasks into tickets, or wants to create implementation tickets. Don't use when - spec is incomplete or vague (use domain-grilling first), a different granularity is needed (epics, tasks), direct implementation is the goal, or the user explicitly wants to send tickets to an issue tracker without dependency graphs or classification.
license: MIT
---

# Spec to Tickets

Break a spec, PRD, or conversation context into focused tickets with dependency graphs, optimized for implementation by agents or humans.

## When to Use

- A spec, PRD, or design document exists and is complete enough to decompose
- The conversation context contains a resolved plan with problem statement, solution approach, scope boundaries, and acceptance criteria
- Tickets need to be sized for focused work sessions (3-4 hours each)
- Output should target an issue tracker or local markdown files
- Parallel work is desired (dependency graph enables concurrent work on leaf tickets)
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- The spec is incomplete, vague, or unresolved (use `domain-grilling` to resolve, or `to-prd` to capture)
- A different granularity is needed (epics, milestones, tasks)
- The goal is direct implementation rather than decomposition
- The source material is a single trivial change that does not benefit from decomposition

## Workflow

Use a conversational tone. Provide a brief opening statement that frames the workflow (e.g., "Following the spec to tickets workflow to break down this spec, as requested"), then use transitional phrases between major sections. Avoid step-by-step narration or broadcasting internal step numbers.

**Abbreviation rules** - In workflow output, avoid all abbreviations except terms previously defined in CONTEXT.md or the project glossary. When writing ticket content, prohibit abbreviations not previously agreed upon in CONTEXT.md/glossary unless they are explicitly used by the user or spec. In such cases, clarify unfamiliar abbreviations in brackets on first use (e.g., "SSO (Single Sign-On)").

### Step 1 - Mode Detection

Determine whether the skill is running in Interactive or Autonomous mode.

1. Parse the user's natural language input for explicit mode signals. Phrases like "autonomous", "just do it", "no need to ask me", or other affirmative authorizations for autonomous action indicate Autonomous mode. **If an explicit Autonomous signal is present, use Autonomous mode regardless of conversation history.**
2. **Autonomous negative signals** - phrases requesting to overwrite, replace, rewrite, or delete existing tickets are NOT Autonomous signals. These involve destructive operations on existing work and always require Interactive mode. If the user uses these phrases in the same request, treat the request as Interactive.
3. If no explicit signal is present and the user has previously replied to the agent in the current conversation, default to Interactive.
4. If no signal is present and no prior conversation exists, default to Interactive.

Record the mode. All subsequent steps branch on this value.

### Step 2 - Input Gathering

Determine the source material to decompose. Accept one of three input types.

1. **Issue tracker reference** - If the user provides an issue number, URL, or path, fetch it using the project's git host CLI. Read the full body and comments.
2. **File path** - If the user provides a path to a local file (e.g., `docs/prds/feature-x.md`), read it.
3. **Conversation context** - If neither of the above is provided, assess whether the current conversation contains sufficient context. Proceed to Input Sufficiency Check.

### Step 3 - Input Sufficiency Check

Verify the input contains enough detail to produce actionable tickets. This check applies to all input types - a 2-line PRD file is as insufficient as a vague conversation.

The input must contain all four of -
1. A problem statement (what is being solved)
2. A solution approach (how it will be solved - architecture, modules, key decisions)
3. Scope boundaries (what is in and out of scope)
4. Acceptance criteria or verifiable outcomes (how to know when done)

**Decision Ledger pairing.** If a Decision Ledger exists at `docs/decisions/DECISIONS-<repo>-<feature>.md` (produced by `domain-grilling` and/or `code-implementation-grilling`), read it alongside the spec. The ledger is the authoritative source for resolved functional (`Dxxx`) and technical (`Txxx`) decisions. Every ticket's acceptance criteria and constraints must cite a `Dxxx` or `Txxx` record — paraphrase the ledger record, never the spec's summary of it. A spec that ships without a ledger, or a ledger whose `Dxxx`/`Txxx` records are not all covered by at least one ticket, is a coverage gap to surface (not to silently fix).

**In Interactive mode** - present the heuristic results to the user. List which criteria are met and which are missing, and state which `Dxxx`/`Txxx` records the proposed tickets would cover. Ask whether to proceed or provide a spec first.

**In Autonomous mode** - if all four criteria are met, proceed. If any are missing, abort and report which criteria are unsatisfied. Suggest using `domain-grilling` or `to-prd` to fill the gaps.

### Step 4 - Codebase Exploration

If not already explored in the current conversation -

1. Read `CONTEXT.md` at the repo root. If `CONTEXT-MAP.md` exists instead, read it and then read each `CONTEXT.md` it references.
2. Scan `docs/adr/` for architectural decisions relevant to the spec's area. In multi-context repos, also check `src/<context>/docs/adr/`.
3. Scan `docs/decisions/DECISIONS-*.md` for any Decision Ledger covering this feature. If a ledger is found, read it end-to-end and treat its `Dxxx`/`Txxx` records as the source of truth for resolved decisions — every ticket's acceptance criteria and constraints will cite one or more of these IDs. If a `code-implementation-grilling` blueprint exists for the feature, the blueprint's `## Ledger Reference` section is a pre-built index; use it to confirm coverage before publishing.
4. Identify key files and modules that the tickets will likely reference.

Use the domain glossary vocabulary throughout all ticket content. Respect ADRs in the area being decomposed. Cite Decision Ledger records by ID (`[D012]`, `[T003]`) — never paraphrase a ledger record into a ticket's acceptance criteria without preserving the ID.

### Step 5 - Output Target Resolution

Determine where to publish the tickets. This must be resolved before decomposition because the output target affects ticket content (e.g., `blocked_by` uses issue numbers vs file basenames).

1. Parse the user's natural language input for output target signals. Phrases like "send to github issues", "target is gitlab", "save as markdown files", "local tickets" indicate the target.
2. If no signal is present -
   - **In Interactive mode** - ask the user to choose from the following options: local markdown files, GitHub Issues, GitLab Issues, Gitea Issues, Codeberg Issues, or a hosted Forgejo Instance's Issues. Use the `ask_question` tool to present these options if available.
   - **In Autonomous mode** - default to local markdown files.

### Step 6 - Ticket Decomposition Proposal

Break the source material into focused tickets in two phases - first choose the decomposition pattern, then propose the tickets. These phases are separate because the pattern choice determines the structure of the entire decomposition, and should be validated before generating tickets.

#### 6.1 Pattern Choice

**Decomposition patterns** - choose one based on the spec's structure -
- **Vertical slices** - each ticket cuts end-to-end through all layers (schema, API, UI, tests). For non-code projects, "layers" means the distinct deliverable components - e.g., for a documentation skill - instructions, reference documents, agent definitions, test suite. Each slice delivers a narrow but complete path and is demoable or verifiable on its own. Best for feature work with clear functional boundaries.
- **Domain** - group tickets by domain concept or module. Best for large refactors or work organized around distinct subsystems.
- **Features** - group tickets by user-facing capability or user story. Best for product-oriented specs with clear feature boundaries.

When the spec explicitly enumerates components or modules, note this constraint during pattern selection - the chosen pattern must accommodate the enumerated structure. Full guidance on handling enumerated components is in section 6.2.

**In Interactive mode:**

1. Present the pattern recommendation with embedded context and alternatives:
   - State the recommended pattern with a brief parenthetical definition
   - Explain why this pattern fits the spec's structure
   - For each alternative pattern, state whether it was competitive or not suitable, with reasons
   - Example: "I recommend Vertical Slices (each ticket delivers a complete end-to-end feature) because the spec has clear functional boundaries. Domain (grouping by module) wasn't suitable because the work spans multiple modules per feature. Features (grouping by user capability) was competitive but the spec is more architecture-driven than user-story-driven."

2. Ask the explicit comparison question:
   "I recommend [pattern] because [rationale]. [Other patterns] weren't suitable/competitive because [reasons]. Does this pattern fit the work, or do you see a better structure?"

3. Handle pattern rejection:
   - If the user rejects the pattern, propose an alternative with the same level of detail
   - If the user rejects the second pattern, escalate: "I've proposed two patterns and neither fits. Can you describe what structure you're envisioning, or should we revisit the spec?"

4. Handle custom patterns:
   - If the user proposes a pattern not in the three listed, validate it:
   - "I can use [custom pattern] if it produces focused, demoable tickets with clear dependencies and Independent vs Collaborative classification. Here's a scenario to validate: [specific edge case from spec]. How does the pattern handle this?"
   - Proceed only after the user confirms the pattern satisfies the constraints

5. Transition to ticket proposal:
   "Proceeding with ticket decomposition using [pattern] pattern. Generating tickets now - let me know if you'd like to pause or adjust the approach."

**In Autonomous mode:**

1. Select the decomposition pattern most appropriate for the spec
2. State the pattern with brief rationale (no rejected alternatives): "Using [pattern] because [reason]"
3. Proceed to ticket proposal

#### 6.2 Ticket Proposal

**Classification rules** - mark each ticket as Independent or Collaborative -
- **Independent** - the ticket has sufficient context, acceptance criteria, and clear boundaries to be picked up and completed without further discussion. Can be implemented by a human or agent.
- **Collaborative** - the ticket requires discussion, decision-making, or review that cannot be resolved from the spec alone (e.g., architectural choice between valid alternatives, design review, stakeholder approval). Needs human involvement before or during implementation.

Prefer Independent over Collaborative. A ticket should only be Collaborative if there is a genuine decision or discussion that the spec does not resolve.

**Sizing heuristic** - applies to all modes. Each ticket should represent at most 3-4 hours of focused work. There is no upper limit on the number of tickets produced from a single PRD. However, if decomposition produces more than 15 tickets, review the decomposition pattern - it may be too fine-grained or unsuitable for the spec's structure. Fewer than 2 tickets suggests tickets are too coarse (each should be a focused unit of work), unless the scope of the work is already narrowly scoped. Prefer many thin slices over few thick ones.

**Decision Ledger coverage** - if a Decision Ledger is present, every `Dxxx` and `Txxx` record must be cited by at least one ticket's acceptance criteria or context pointers, and every ticket must cite at least one ledger record (or, if the ticket covers work explicitly out of ledger scope, cite the absence explicitly with `No ledger record — out of scope: <reason>`). Build a coverage matrix during proposal: rows are ledger records, columns are tickets, cells mark which ticket satisfies which record. A record with no citing ticket is a coverage gap to surface before publishing. A ticket with no cited record is a scope gap to surface before publishing.

When the spec explicitly enumerates components or modules, use them as the basis for decomposition rather than deriving slices independently. Each component becomes a ticket, with a scaffolding/integration ticket if needed.

**In Interactive mode:**

1. Propose the full decomposition as a table or structured list. For each ticket, show:
   - Title
   - Goal
   - Classification (Independent or Collaborative)
   - Which User Stories or spec sections it covers (do not abbreviate "User Stories")
   - Which other tickets it depends on (with reasons)
   - Do not abbreviate column headers - use full, clear terms

2. Include decomposition rationale only for non-obvious decisions:
   - Explain why tickets were grouped or split when the reasoning isn't obvious from the spec
   - Skip rationale for straightforward decisions (e.g., "this is one ticket because it's a single endpoint")

3. Ask the multi-part validation question:
   "Take a look at the ticket breakdown. A few things to check:
   - Are any tickets too large or too small?
   - Is anything missing or unnecessary?
   - Do the dependencies and Independent vs Collaborative classifications feel right?"

4. Handle user feedback:
   - Infer from feedback content whether it's a ticket-level adjustment or pattern-level concern
   - For ticket-level feedback (granularity, composition, dependencies): adjust tickets within current pattern
   - For pattern-level feedback (e.g., "this doesn't feel like vertical slices", "the structure is wrong"): signal the shift: "Your feedback about [specific concern] suggests the [pattern] pattern isn't the right fit. Let me propose a different approach." Return to section 6.1.
   - Repeat until the user approves the decomposition, dependencies, and classifications

**In Autonomous mode:**

1. Decompose into tickets using the selected pattern. Each ticket must be demoable or verifiable on its own.
2. Infer dependencies from domain logic and layer ordering. When uncertain whether two tickets are dependent, assume they are (prefer over-constraining over creating a broken graph).
3. Apply classification rules to each ticket.
4. Include brief rationale for non-obvious decomposition decisions (e.g., "Tickets 2 and 3 were split because they have different Independent vs Collaborative classifications")
5. Proceed without user confirmation.

### Step 7 - Existing Ticket Detection

Before publishing, detect whether tickets already exist for this source material.

1. **Local markdown** - check if a `tickets/` directory exists at the repo root and contains files with a matching `parent` frontmatter value. Matching rules by input type -
   - Issue tracker reference - exact issue number or URL match in `parent` field.
   - File path - exact relative path match in `parent` field.
   - Conversation context - match on the date prefix (e.g., `Conversation context (2026-06-07)`) rather than the full summary text.
2. **Issue tracker** - search for open issues whose body contains a matching parent reference, using the same matching rules above.

**If existing tickets are found and the user explicitly asked to overwrite/replace them** (this is always Interactive mode per Mode Detection):
- **If the spec/PRD is available** - proceed with the normal workflow as if the tickets don't exist. The new tickets will overwrite the existing ones.
- **If the spec/PRD is NOT available** - read the existing tickets and update them to conform to the skill's template and guidance (goal, what to build, acceptance criteria, context pointers, etc.). Preserve the existing ticket content and structure where it meets the guidance.
  - **If the existing tickets lack sufficient information to enable meaningful improvements** - gracefully fail. Explain to the user why the update is not possible (insufficient context in existing tickets) and suggest creating or providing the spec/PRD to enable proper decomposition.

**If existing tickets are found but the user did not explicitly ask to overwrite/replace them:**
- **In Interactive mode** - present the finding. Offer three options - overwrite (delete existing, create new), update (modify existing in place to match skill guidance), or cancel (abort). Use the `ask_question` tool to present these options if available. Wait for user choice. If the user chooses overwrite or update, apply the logic above.
- **In Autonomous mode** - abort. Report that existing tickets were found and recommend running in Interactive mode to resolve.

### Step 8 - Ticket Generation

Apply the ticket template below to each approved ticket.

**Abbreviation rule** - Do not use abbreviations in ticket content unless they are defined in CONTEXT.md, the project glossary, or explicitly used by the user/spec. When using an abbreviation that may be unfamiliar, clarify it in brackets on first use (e.g., "SSO (Single Sign-On)"). Never abbreviate "User Stories" to "US".

**Recommended Workflow generation** - As part of ticket creation, generate a Recommended Workflow for each ticket. The workflow is a step-by-step breakdown of how to implement the ticket. Apply these rules:
- Always present. Minimum 1 step, even for trivial tickets. Recommended range is 2-8 steps; decide granularity based on ticket scope.
- Derive the workflow from three inputs in priority order: (1) spec structure (what the spec prescribes or implies about sequencing), (2) codebase context (file layout, module boundaries, conventions from exploration), (3) standard patterns (common implementation sequences for this type of work).
- Each step must have all four elements: verb-phrase title, Where (file paths), bulleted actions, Verify (verification check). Use `N/A` as a filler when an element does not apply.
- Per-step `Verify:` lines are micro-verifications. Per-ticket `Acceptance criteria` are macro-verifications. These are distinct levels.
- Steps can be reordered by the implementer. Respect dependencies between steps.

For the ticket body schema, see [ticket-template.md](./references/ticket-template.md). Load it before generating any ticket.

**Parent field values by input type** -
- Issue tracker reference - the issue number or URL (e.g., `#123`)
- File path - the relative file path (e.g., `docs/prds/feature-x.md`)
- Conversation context - the date and a 1-3 sentence summary sufficient for a reader who was not part of the original conversation (e.g., `Conversation context (2026-06-07) - Implementing user authentication with OAuth2 and session management. Agreed on PKCE flow with refresh token rotation. Out of scope - social login providers.`)

**Context pointers rules** -
- Include only files directly relevant to this ticket's scope.
- Include only ADRs that constrain this ticket's implementation.
- Include only domain terms that define boundaries or clarify ambiguity for this ticket. Do not reproduce the glossary.
- Include only Decision Ledger records (`Dxxx`/`Txxx`) whose `Constraints` or `Normalized Requirement` this ticket must honour. Do not reproduce the ledger.

### Step 9 - Ticket Publishing

Publish the generated tickets to the chosen target.

#### Issue tracker target

1. Detect the project's git host -
   a. Parse `git remote -v` to extract the hostname.
   b. If the hostname is ambiguous (e.g., self-hosted with custom domain), check for host-specific config files (`.github/`, `.gitlab-ci.yml`, `.gitea/`).
   c. If detection fails, ask the user which host the project uses. The options to present are: GitHub Issues, GitLab Issues, Gitea, Codeberg Issues, or a hosted Forgejo Instance. Use the `ask_question` tool to present these options if available.
2. Look up the expected CLI for the detected host -
   - `github.com` → `gh`
   - `gitlab.com` or self-hosted GitLab → `glab`
   - `gitea.com` or Gitea instances → `tea`
    - `codeberg.org` or Forgejo instances → `fj` (community-maintained, not official - codeberg.org/forgejo-contrib/forgejo-cli)
   - Other hosts → search PATH for known CLIs, or ask the user.
3. Verify the CLI is installed by checking if it is available in PATH. If not found, inform the user and provide installation guidance.
4. Publish tickets in dependency order - blockers first, then dependents. This ensures blocking ticket issue numbers exist before they are referenced in "Blocked by" fields.
5. For each ticket, create an issue using the host CLI. Fill in the "Blocked by" field with real issue numbers of previously published blocking tickets.
6. Do NOT close or modify any parent issue.

#### Local markdown target

1. **Resolve the tickets directory** - scan the repo for an existing convention in this priority order: `tickets/`, then `docs/tickets/`, then `.tickets/`. Use the first match found. If none match, default to `tickets/` at the repo root. Record the resolved path as `<tickets-dir>` for the remaining sub-steps.
2. Create the `<tickets-dir>` directory at its resolved location if it does not exist.
3. Determine directory structure based on ticket count -
   - **Fewer than 8 tickets** - flat structure. All files in `<tickets-dir>`.
   - **8 or more tickets** - structured subdirectories -
      - **In Interactive mode** - ask the user to choose a grouping strategy - dependency graph position (topological layers), domain concept, or feature area.
      - **In Autonomous mode** - group by domain concept.
4. Name files with zero-padded sequential numbers - `001-authentication.md`, `002-user-profiles.md`.
5. If using structured directories, place files in the group subdirectory - e.g., `<tickets-dir>/authentication/001-login-endpoint.md`.
6. Write each ticket as a markdown file with YAML frontmatter matching the ticket template.

### Step 10 - Summary Report

After publishing, present a summary to the user containing -

1. **Stats** - total ticket count, Independent count, Collaborative count, leaf ticket count (tickets with no blockers).
2. **Ticket overview** - a table with each ticket's title, classification, estimated effort, domain area, and review complexity:
   - **Estimated effort** - approximate hours or S/M/L estimate for each ticket
   - **Domain area** - the subsystem or domain concept the ticket touches (helps identify which tickets match a team member's expertise)
   - **Review complexity** - Low/Medium/High assessment of how much code review the ticket is likely to require
3. **Dependency graph** - which tickets can start immediately, which are blocked and by what.
4. **Next steps** - suggested execution order and parallelism opportunities. Note which tickets can be worked in parallel by different team members.
5. **Output location** - issue numbers or file paths where tickets were saved.
6. **Decision Ledger coverage matrix** - a summary of how the proposed tickets cover every `Dxxx`/`Txxx` record in the ledger. A single-line "All ledger records cited" is sufficient if coverage is full; otherwise list gaps and unresolved records.

The summary should be scannable - use clear structure (headings, tables, lists) so key information is quickly findable. Include enough detail to be useful without requiring the user to read the tickets, but avoid reproducing ticket content verbatim.

## Validation

- [ ] Every ticket has a goal, recommended workflow, acceptance criteria, context pointers, blocked-by field, parent reference, and classification.
- [ ] No ticket requires context beyond its own body and its context pointers to begin work.
- [ ] The dependency graph has no cycles.
- [ ] Context pointers reference only files, ADRs, domain terms, and Decision Ledger records directly relevant to the ticket.
- [ ] The glossary is not reproduced in any ticket's context pointers.
- [ ] Decision Ledger records are not reproduced in any ticket's context pointers.
- [ ] Every ticket that covers in-scope work cites at least one `Dxxx` or `Txxx` record in its acceptance criteria or context pointers, using the ID format (`[D012]`, `[T003]`).
- [ ] If a Decision Ledger is present, a coverage matrix was built during proposal and every record has at least one citing ticket. Uncovered records were surfaced as gaps and resolved before publishing.
- [ ] If no Decision Ledger is present, the summary report notes its absence.
- [ ] Parent field contains a 1-3 sentence summary when the source is conversation context.
- [ ] Tickets were published in dependency order (blockers first) when targeting an issue tracker.
- [ ] The summary report includes stats, ticket overview table, dependency graph, and next steps.
- [ ] The "Blocks" field is not used anywhere - dependencies are tracked via "Blocked by" only.
- [ ] The description contains no YAML-breaking characters (colons, unquoted special chars).
- [ ] Ticket count is at least 2, unless the spec scope is already narrowly scoped.
- [ ] Each ticket represents at most 3-4 hours of focused work.
- [ ] If ticket count exceeds 15, the decomposition pattern was reviewed for suitability.
- [ ] No abbreviations are used in ticket content or workflow output unless defined in CONTEXT.md/glossary or explicitly used by the user/spec. Unfamiliar abbreviations are clarified in brackets on first use. "User Stories" is never abbreviated to "US".
- [ ] Pattern choice includes recommendation with parenthetical definition and alternatives with rejection reasons (Interactive mode).
- [ ] Pattern choice includes brief rationale for selected pattern (Autonomous mode).
- [ ] Ticket proposal includes decomposition rationale for non-obvious decisions.
- [ ] Closing questions use explicit multi-part format (not binary approval).
- [ ] Custom patterns are validated against skill constraints before proceeding.
- [ ] Every ticket has a Recommended Workflow section with at least 1 step.
- [ ] Each workflow step has all four elements: verb-phrase title, Where (file paths or N/A), bulleted actions, Verify (verification check or N/A).
- [ ] Workflow steps respect the 3-4 hour sizing rule for the overall ticket.
- [ ] Workflow derivation follows the mixed rule: spec structure, then codebase context, then standard patterns.
- [ ] Workflow steps respect dependencies between steps (a step producing an artifact consumed by another comes first). Reordering by the implementer is permitted.
- [ ] Per-step Verify lines are micro-verifications distinct from per-ticket Acceptance criteria (macro-verifications).
