---
name: implement-tickets
description: >-
  Coordinate implementation of a normalized ticket set — builds the dependency
  DAG, groups same-file tickets, dispatches each group to a sub-agent with a
  fresh context, runs a judge LLM against acceptance criteria, and commits one
  commit per ticket. Use when a batch of tickets should be implemented in
  parallel/sequential order with per-ticket commits and an end-of-run report.
  Do not use for a single ticket (implement it directly), tickets not yet
  generated (use spec-to-tickets first), or non-ticket work.
license: MIT
---

# Implement Tickets

Coordinates the implementation of a group of tickets produced by `spec-to-tickets`
(or any source that has been converted to the normalized ticket format).
The skill reads the ticket set, builds the dependency DAG, batches parallelizable
work, dispatches each batch to fresh-context sub-agents, runs a judge review
against each ticket's acceptance criteria, commits one commit per ticket, and
writes an end-of-run report. Live updates use a fixed category prefix
vocabulary so progress, errors, deviations, and escalations are scannable in
real time.

## When to Use

- The user has a set of tickets in the normalized format and wants them implemented end-to-end
- The user asks to "run the ticket implementer", "implement the tickets in tickets/", or "execute the spec-to-tickets output"
- The user wants parallel work across independent tickets, with a per-ticket commit history on one branch
- The user explicitly opts into the local `implement-tickets` skill over any globally-installed version
- When user input would clarify the request (workspace choice, circuit-breaker threshold override, partial-ticket set selection, attribution policy), invoke ask-questions

## When Not to Use

- Tickets have not been generated yet — use `spec-to-tickets` first to produce the normalized ticket set
- The work is a single ticket — implement it directly with a single agent session; the coordination overhead is not justified
- The user wants to implement one specific ticket by id — dispatch it directly, do not run the full skill
- The source is an issue tracker that has not been converted to the normalized format — run the source adapter first, then invoke this skill
- The work is non-ticket work (e.g., ad-hoc refactor, exploration, single-PR change)

## Workflow

The skill runs in six steps. Each step has explicit completion criteria;
the next step does not start until the current one reports a stable state.

### Step 1 — Mode and workspace resolution

1. Parse the user's natural language input for mode signals:
   - Phrases like "self-contained", "just do it", "no pausing", or "don't ask me" indicate **Self-Contained mode**.
   - Absence of any signal, or phrases like "check with me", "ask first", "let me confirm", indicates **Collaborative mode** (default).
2. Record the mode. All subsequent steps branch on this value only at user-facing decision points (Step 3 escalations, Step 6 report acknowledgement).
3. Resolve the workspace:
   - Default: create a new branch named `tickets/impl-<run-id>` from the current `HEAD`. Record the branch name; all work stays in this branch unless the user specifies otherwise.
   - Override: if the user specifies a worktree path, branch name, or "use a worktree", initialize a worktree at the resolved path. Record the worktree path.
4. Capture the circuit-breaker threshold override (default = 3 strikes); if the user does not specify, the default applies.
5. Capture the **attribution policy** ∈ {`human-only`, `human+ai-coauthor`, `ai-only`}.
   - Parse the user's input for an explicit policy signal. Accepted phrasings: "as me", "as me with the bot as co-author", "as the bot with me as co-author", "as the bot", or a literal policy name.
   - If the policy is not stated, invoke `ask-questions` with one question and three options: `ai-only`, `human-only`, `human+ai-coauthor`. The recommended default is `human-only` (lowest surprise, matches the default shell git config in most setups). Ask even in Self-Contained mode — identity is an irreversible, audit-visible decision.
   - Record the chosen policy before printing the mode banner. The skill does not advance to Step 2 without a recorded policy.

Before asking the user for the AI identity in sub-step 6, load `references/commit-author-policy.md` to surface canonical bot identities per host platform.

6. If the recorded policy is `human+ai-coauthor` or `ai-only`:
   1. Ask the user for the AI `name` and `email`. The user may copy from `references/commit-author-policy.md` or supply their own. The skill does **not** propose a default value, does **not** invent a handle, and does **not** read the host's CLI version or env vars to auto-fill.
   2. Record the AI name and email as captured strings, verbatim from the user's reply. Trimming whitespace only.
   3. If the user has not provided a name and email, refuse to proceed: emit `[DEVIATION] step=1.sub-step-6 reason=ai-identity-required policy=<recorded>` and abort the run. The skill does not advance to Step 2.
   4. For `human-only`, skip this sub-step. The shell's `git config user.name` / `user.email` is the implicit human identity; if the shell has none, the eventual `git commit` fails with git's own error and the failure routes through Step 4.

7. Print a one-line mode banner in this exact shape:

   `[OK] mode=<Collaborative|Self-Contained> workspace=<branch-or-worktree> breaker=<n> attribution=<policy>`

   If the policy is `human+ai-coauthor` or `ai-only`, append a single space and `ai=<name> <email>` to the banner.

**Completion criterion**: mode recorded, workspace initialized and clean, breaker threshold recorded, attribution policy recorded, AI identity recorded (if policy involves AI), mode banner printed.

### Step 2 — Ticket loading and dependency graph

1. Resolve the ticket source:
   - Default: load markdown files from `tickets/` matching the normalized ticket format (frontmatter with `id`, `title`, `status`, `Depends on:`, `Acceptance criteria`).
   - If the user provides a path or glob, load from that location.
   - If the user names an external source (e.g., "GitHub Issues in repo X"), abort with a clear message: "External sources must be converted to the normalized format by a source adapter before this skill runs. Run the adapter for <source> first, then re-invoke."
2. For each ticket file, parse the frontmatter and body. Validate that the ticket has all four required normalized fields: `id`, `title`, `status`, `Depends on:`. Reject tickets missing any field with a per-file error.
3. Filter the ticket set to those with `status` ∈ {`ready`, `in-progress`} and whose dependencies all resolve to other tickets in the set. Tickets with `status: blocked` or with unresolved dependencies are listed in the run summary as **Skipped** with a reason.
4. Build the dependency DAG from `Depends on:` edges. Detect cycles; if any cycle exists, abort with the cycle printed and a recommended resolution (re-derive the dependency graph via `spec-to-tickets`).
5. Compute **topological batches**: a batch is a maximal set of tickets with no inter-batch dependencies (all tickets in batch N depend only on tickets in batches < N).
6. For each batch, group tickets that share at least one file path (in their recommended workflow's `Where:` lines or in their `Files` context pointer). Each group becomes a single dispatch unit. Tickets with no file overlap remain individual dispatch units.
7. Print the batching result: `[OK] loaded=<N> ready=<N> skipped=<N> batches=<N> dispatch-units=<N>`. List the dispatch units with their constituent ticket ids and shared files.

**Completion criterion**: ticket set loaded, DAG acyclic, batches and dispatch units computed, batch summary printed.

Load `references/sub-agent-dispatch.md` before Step 3 for the full dispatch template variables and prompt shape; load `references/judge-prompt.md` before the judge-loop sub-step in Step 3.

### Sub-Agent Contract (MANDATORY)

These rules are non-negotiable. They apply to every sub-agent dispatch regardless of
ticket content, batch, or mode. The coordinator enforces them; the sub-agent is bound
by them. Violations are contract breaches, not suggestions.

- **REQUIRED**: All work happens inside `<STAGING_PATH>`. No file outside the staging area may be written. VIOLATION: return `status: error` with `notes: wrote-outside-staging`.
- **REQUIRED**: No commits. The sub-agent must not run `git add`, `git commit`, `git push`, `git checkout` to a different branch, or any commit-related or branch-switching command. The coordinator owns all commits. VIOLATION: return `status: error` with `notes: attempted-commit`.
- **REQUIRED**: The sub-agent must return the structured response format exactly as specified (status / files_changed / criteria_check / notes). VIOLATION: treat as `status: error` with `notes: malformed-response`.
- **REQUIRED**: The sub-agent must not ask the coordinator questions mid-dispatch. One prompt in, one structured response out. VIOLATION: treat as `status: error` with `notes: attempted-interaction`.
- **REQUIRED**: The sub-agent must not see other in-flight staging areas. Each dispatch gets a clean, pinned checkout.
- **REQUIRED**: Changes must be scoped to the ticket's acceptance criteria. No refactoring unrelated code; no reformatting untouched lines.

### Step 3 — Per-dispatch-unit execution

For each dispatch unit (in batch order; units within a batch may run in parallel
via multiple sub-agents), the following sub-steps apply. The per-ticket loop
inside the dispatch unit runs in ticket order within the group.

1. **Extract completion criteria** from the ticket body:
   - Read the `Acceptance criteria` section.
   - If absent, read the `Definition of Done` section.
   - If neither is present, treat the ticket's `Goal` + `What to build` sections as the criteria and surface a `[DEVIATION] ticket=<id> no explicit criteria — using Goal+What to build` line.
2. **Create a per-sub-agent staging area**:
   - Default: a directory at `.implement-runs/<run-id>/staging/<ticket-id>/` reachable from the shared branch.
   - The sub-agent's working copy for this ticket is a clean checkout pinned to the commit at which the dispatch began, plus all already-applied staging areas from earlier (DAG-respecting) tickets in the same run.
   - The sub-agent does **not** see any other in-flight staging areas.
3. **Dispatch a sub-agent with a fresh context**:
    - **Pre-dispatch checklist** — before sending the dispatch prompt, verify every item:
      - [ ] Prompt includes the no-commit rule (verbatim from the Sub-Agent Contract above).
      - [ ] Prompt includes the staging-area-only rule (verbatim from the Sub-Agent Contract above).
      - [ ] Prompt includes the structured response format (status / files_changed / criteria_check / notes).
      - [ ] Prompt includes the no-interaction rule (one prompt in, one response out).
      - [ ] Prompt uses imperative language (REQUIRED / VIOLATION) for all constraints — not advisory language ("should", "please", "try to").
      - If any item is missing, abort the dispatch and fix the prompt before sending. Do not dispatch with a partial contract.
    - Load `references/sub-agent-dispatch.md` and follow the dispatch template.
    - The sub-agent is told: ticket id, normalized ticket body, the resolved completion criteria, the list of files it owns, and the staging-area path.
    - The sub-agent accumulates all changes silently. No WIP commits appear in the shared branch's history. Sub-agents are forbidden from committing during dispatch; the coordinator owns commits.
4. **Capture the sub-agent's diff and validate**:
    - Capture the staging area's `git status` + `git diff` once the sub-agent reports done.
    - **Post-dispatch validation** — verify every item before proceeding to the judge loop:
      - [ ] The sub-agent did not run any commit-related command (check the staging area's `git log`; only `<STARTING_COMMIT>` should be reachable before the coordinator commits).
      - [ ] All paths in `files_changed` are within `<OWNED_FILES>`. If not, treat as `status: error` with the offending path in `notes` and increment the strike counter.
      - [ ] The sub-agent returned the structured response format (status / files_changed / criteria_check / notes). If unstructured or missing required fields, treat as `status: error` with `notes: malformed-response` and increment the strike counter.
      - [ ] The sub-agent did not write outside `<STAGING_PATH>`. If it did, treat as `status: error` with `notes: wrote-outside-staging` and increment the strike counter.
      - If any check fails, do not proceed to the judge loop. Record the violation, increment the strike counter, and route through failure handling (Step 4).
5. **Run the judge loop**:
   - Load `references/judge-prompt.md` and follow the judge template.
   - The judge receives: the ticket's completion criteria, the sub-agent's diff, and the staging-area state.
   - The judge returns one of three verdicts: `approve`, `reject-with-feedback`, `reject-with-ambiguity`.
   - On `approve`: proceed to commit (step 6).
   - On `reject-with-feedback`: re-dispatch the sub-agent with the judge's feedback as additional context. Increment the strike counter for this ticket.
   - On `reject-with-ambiguity`: surface the ambiguity to the user immediately with `[ESCALATION] ticket=<id> ambiguity=<one-line-summary>` (Collaborative mode) or auto-skip with a recorded reason (Self-Contained mode).
6. **Commit on the shared branch**:
   - **Subject line**: starts with the ticket-id bracket prefix, followed by a plain-language description.
     - Single-ticket dispatch: prefix is `[<ticket-id>]`. Example: `[T003] add subject-quality gate to commit step`.
     - Same-file-group dispatch (multiple tickets in one commit unit): prefix is `[<ticket-id-1>,<ticket-id-2>,...]` (comma-separated, no spaces). Example: `[T003,T007] add subject-quality gate and post-commit identity check`.
     - The bracket prefix **stays in the subject**. It is what makes commits greppable against the ticket set. It is not moved to the body footer.
     - Treat 72 characters as a soft cap, not a hard limit. A 90-character self-explanatory subject is preferable to a truncated cryptic one.
     - The rest of the subject (after the bracket prefix) reads as a public changelog entry. The reader has not read the ticket, the decision ledger, or any prior work.
     - The negative rules (no ledger IDs, no other-ticket IDs, no host-tool acronyms, plain-language verb/noun) are enforced by the subject-quality gate below; the format description does not restate them.
   - **Body**: bullet list of what was done (one bullet per discrete change).
   - **Footer**: references to related tickets and decision-ledger records (`Refs: ticket-<id>, DECISIONS-<name>.md#Dxxx`), and any `BREAKING CHANGE:` line if applicable.
   - **Commit invocation by policy**:
     - `human-only`: `git commit -m '<subject>' -m '<body>' -m '<footer>'`. The shell's `git config user.name` / `user.email` is the human identity.
     - `human+ai-coauthor`: the coordinator reads `git config user.name` and `git config user.email` immediately before the commit to obtain the shell human identity, then runs `git -c user.name='<shell-human-name>' -c user.email='<shell-human-email>' commit -m '<subject>' -m '<body>' -m '<footer>' -m 'Co-authored-by: <ai-name> <<ai-email>>'`.
     - `ai-only`: `git -c user.name='<ai-name>' -c user.email='<ai-email>' commit -m '<subject>' -m '<body>' -m '<footer>'`.
     - In all three cases, the identity is supplied at commit time via the `-c` flag. The skill does not call `git config user.name` / `git config user.email` to mutate the shell's persistent git config.
   - **Subject-quality gate** (run before the commit invocation): the coordinator inspects the subject against the following rules; any failure rejects the subject. These are the canonical home for the negative rules — the subject-format description above does not restate them.
     - No ledger IDs in the subject: subject does not match the regex `\bD\d{3}\b` or `\bT\d{3}\b` outside the ticket-id bracket.
     - No other-ticket IDs in the subject: subject does not match `T\d{3}` for any ticket id other than the one in the bracket prefix.
     - No host-tool acronyms in the subject: the subject must not contain host-tool acronyms that the repo glossary in `CONTEXT.md` does not recognise as universal (e.g. `MTP`, `VSTest`, `CPM`, `TFM`, `AOT`).
     - Plain-language: subject contains at least one verb or noun phrase that names the user-visible effect of the change.
     - On rejection: the coordinator increments the strike counter for this ticket and re-dispatches the sub-agent with the gate's feedback (mirroring the `reject-with-feedback` re-dispatch path). A second rejection on the same ticket escalates to the user via the circuit breaker.
   - One commit per ticket. No WIP commits, no merge commits inside a ticket's staging area, no squash — the per-ticket commit is the source of truth.
7. **Reconcile the staging area into the shared branch**: the commit is the reconciliation artefact. Staging-area files are now on the shared branch in DAG order. Staging directories are retained until end of run, then removed.
8. **Live update** after each ticket:
   - `[OK] ticket=<id> commit=<sha> batch=<n>` on success.
   - `[ERROR] ticket=<id> reason=<one-line>` on judge rejection that hits the circuit breaker.
   - `[DEVIATION] ticket=<id> <detail>` on criteria-source fallbacks, conflict-resolution events, or other plan deviations.
   - `[ESCALATION] ticket=<id> <detail>` on user-facing interrupts.

**Completion criterion (per ticket)**: either a commit on the shared branch, a recorded skip with reason, or a recorded escalation to the user. Strike count for the ticket is reset to 0 on commit.

### Common Sub-Agent Violations

These are contract violations, not warnings. Each one increments the strike counter
and routes through failure handling (Step 4). The coordinator must detect and record
every instance.

- **Sub-agent committed**: The sub-agent ran `git add`, `git commit`, or any commit-related command. Contract violation — the coordinator owns commits. Treat as `status: error` with `notes: attempted-commit`.
- **Sub-agent wrote outside staging**: The sub-agent modified a file outside `<STAGING_PATH>` or `<OWNED_FILES>`. Contract violation — the staging area is the only writable surface. Treat as `status: error` with `notes: wrote-outside-staging`.
- **Sub-agent returned unstructured response**: The sub-agent's response does not match the required format (status / files_changed / criteria_check / notes). Contract violation — the judge cannot evaluate an unstructured response. Treat as `status: error` with `notes: malformed-response`.
- **Sub-agent attempted interaction**: The sub-agent asked the coordinator a question or waited for input mid-dispatch. Contract violation — one prompt in, one response out. Treat as `status: error` with `notes: attempted-interaction`.
- **Sub-agent refactored out of scope**: The sub-agent changed code outside the ticket's acceptance criteria (unrelated refactors, reformatting of untouched lines). Not a hard error, but the judge should flag it; if the judge rejects, route through the normal re-dispatch path.

### Step 4 — Failure handling and circuit breaker

Every failure is categorized and routed. The categorization rules live in
`references/failure-categorization.md` (load on first failure, not before).

1. **Categorize** each failure as one of: `transient`, `persistent`, `dependency`, `ambiguous`. Rules in the reference file.
2. **Route** by category:
   - `transient` → auto-retry, with exponential backoff capped at 3 retries before falling through to the circuit breaker.
   - `persistent` → auto-skip with a recorded reason; do not retry.
   - `dependency` → auto-skip and mark downstream tickets as blocked in the run summary.
   - `ambiguous` → escalate to the user (Collaborative) or auto-skip with a recorded reason (Self-Contained).
3. **Circuit breaker**: any task (commit, file edit, sub-agent dispatch, judge call) that fails more than `N` times for the same ticket — regardless of category — escalates to the user with `[ESCALATION] ticket=<id> task=<name> strikes=<n>` (Collaborative) or aborts the run (Self-Contained). The threshold `N` is the Step 1 value (default 3).
4. **Visibility**: every auto-handled failure and every circuit-breaker escalation appears in the run summary (Step 6) with its category, ticket id, and one-line reason.

**Completion criterion**: every failure has a recorded category, a recorded route, and either an action (retry / skip) taken or a recorded escalation. The strike counter for each ticket is consistent with the route taken.

### Step 5 — Cross-dispatch conflict resolution

When two dispatch units within the same batch touch the same file, the rule
below applies. Conflict-resolution rules live in
`references/conflict-resolution.md`; load on first conflict.

1. **Detection**: at the end of each batch, the coordinator diffs the per-ticket commits in topological order and flags any overlapping file regions.
2. **Default resolution**: last-writer-wins (LWW) by commit order on the shared branch. The overlapping region in the earlier commit is preserved only if the later commit's diff did not touch that region.
3. **Escalation**: if the LWW rule would produce a result that contradicts a ticket's stated acceptance criteria, escalate to the user with `[ESCALATION] ticket=<id> conflict=<file> reason=<one-line>` and pause that batch.
4. **Recording**: every conflict, the rule applied, and the resulting resolution is recorded in the run summary under `Conflicts`.

**Completion criterion**: every detected conflict has a recorded resolution, and either a follow-up commit (if LWW is re-applied) or a recorded escalation. The shared branch's history contains no unresolved overlap.

### Step 6 — End-of-run report

1. Compose a markdown report at `tickets/.runs/<run-id>.md` with these sections:
   - **Run header**: run id, mode, workspace, breaker threshold, start/end timestamps, total wall-clock.
   - **Stats**: loaded, ready, skipped, batches, dispatch units, committed, escalated, conflicted.
   - **Per-ticket outcomes**: one row per ticket with `id`, `title`, `status` (`committed` / `skipped` / `escalated` / `pending`), commit sha, strikes used.
   - **Failures**: category, ticket id, one-line reason, route taken.
   - **Conflicts**: file, tickets involved, rule applied, result, escalation flag.
   - **Deviations**: any plan deviations surfaced during the run (e.g., criteria-source fallbacks, skipped tickets, escalation events).
   - **Next steps**: tickets remaining in the ticket set, blocked tickets, and recommended follow-up actions for the user.
2. Commit the report to the shared branch with subject `[run/<run-id>] implement-tickets end-of-run report`.
3. In **Collaborative mode**: print the report to the conversation and ask the user to acknowledge before finalizing. In **Self-Contained mode**: print a one-line summary to the conversation and commit.
4. Clean up staging directories under `.implement-runs/<run-id>/staging/` after the report is committed.

**Completion criterion**: report file exists at `tickets/.runs/<run-id>.md`, report is committed on the shared branch, staging directories are removed.

## Output Mode

This skill writes a structured end-of-run markdown report to `tickets/.runs/<run-id>.md` and commits per-ticket changes plus the report to the shared branch. It does not draft in conversation by default; the conversation receives live updates and a final one-line summary. The user may request an additional `tickets/.runs/<run-id>-draft.md` in conversation before the report is committed by pausing after Step 6.3's report composition.

## Transitions

- **`write-changelog`** — may run after this skill to summarize the per-ticket commits as user-facing release notes. The per-ticket commit subjects (`[<ticket-id(s)>] <plain-language description>`) are designed to be changelog-friendly.

## Validation

- [ ] Step 1 resolved mode, workspace, breaker threshold, and attribution policy before any ticket work began.
- [ ] Mode banner was printed at Step 1 completion in the form `[OK] mode=... workspace=... breaker=... attribution=<policy>[ ai=<name> <email>]`.
- [ ] Step 2 rejected tickets with missing normalized frontmatter fields with a per-file error.
- [ ] Step 2 detected cycles in the dependency DAG and aborted with the cycle printed, or confirmed acyclic.
- [ ] Step 2's batch summary was printed (`[OK] loaded=... ready=... skipped=... batches=... dispatch-units=...`).
- [ ] Same-file tickets were grouped into a single dispatch unit.
- [ ] Each sub-agent received a fresh context (no shared scratchpad, no carry-over context from prior tickets).
- [ ] Pre-dispatch checklist was completed before each dispatch (all five items verified; no dispatch sent with a partial contract).
- [ ] Post-dispatch validation was completed after each sub-agent response (all four items verified; no judge loop started with a failed validation).
- [ ] Common sub-agent violations (commit attempts, writes outside staging, unstructured responses, interaction attempts) were detected, recorded, and routed through failure handling.
- [ ] No WIP commits appear on the shared branch between per-ticket commits (the per-ticket commit is the only commit authored for the ticket).
- [ ] Each per-ticket commit subject matches the form `[<ticket-id(s)>] <plain-language description>`. The 72-character limit is a soft cap.
- [ ] Each per-ticket commit's cross-references appear in the body footer in the `Refs: ticket-<id>, DECISIONS-<name>.md#Dxxx` format, never in the subject.
- [ ] Step 1 captured the attribution policy before any ticket work began. The mode banner shows `attribution=<policy>` (and `ai=<name> <email>` when policy involves AI).
- [ ] For `human+ai-coauthor` and `ai-only` policies, the user supplied the AI name and email; the skill did not auto-fill, did not invent a handle, and did not mutate the shell git config.
- [ ] For `human+ai-coauthor` policy, the per-ticket commit carries a `Co-authored-by: <ai-name> <<ai-email>>` trailer; for `ai-only` policy, the commit's author is the AI identity.
- [ ] `references/commit-author-policy.md` was loaded before sub-step 6 of Step 1 when the policy involved AI.
- [ ] The subject-quality gate ran before every per-ticket commit and rejected any subject that violated the four rules in Step 3.6.
- [ ] Each per-ticket commit body is a bullet list of changes; each footer has references or is explicitly empty.
- [ ] Judge loop ran for every ticket; no ticket was committed without a judge `approve` verdict.
- [ ] Sub-agents did not see other in-flight staging areas (verified by the staging-area path and the pinned starting commit).
- [ ] Cross-batch conflicts were detected, resolved per the rule in `references/conflict-resolution.md` (default LWW until that reference overrides it), and recorded in the report.
- [ ] Every failure has a category from {transient, persistent, dependency, ambiguous} and a recorded route.
- [ ] Circuit breaker escalated or aborted after `N` strikes (default 3) for any task on any ticket, regardless of category.
- [ ] Every auto-handled failure and circuit-breaker escalation is visible in the run summary.
- [ ] Live updates used the four-prefix vocabulary (`[OK]`, `[ERROR]`, `[DEVIATION]`, `[ESCALATION]`) consistently.
- [ ] End-of-run report exists at `tickets/.runs/<run-id>.md` and is committed on the shared branch.
- [ ] Staging directories under `.implement-runs/<run-id>/staging/` are removed after the report is committed.
- [ ] In Collaborative mode, Step 6.3 asked the user to acknowledge before finalizing; in Self-Contained mode, only a one-line summary was printed.
- [ ] `references/sub-agent-dispatch.md`, `references/judge-prompt.md`, `references/failure-categorization.md`, and `references/conflict-resolution.md` exist as referenced (or the skill surfaces their absence as `[DEVIATION] missing-reference ...`).
- [ ] External ticket sources (e.g., GitHub Issues) were converted to the normalized format by an adapter before the skill ran; the skill did not consume a non-normalized source directly.
