# Sub-Agent Dispatch Template

The prompt template below is sent to a fresh-context sub-agent for each
dispatch unit. The sub-agent implements one ticket (or one same-file group of
tickets, dispatched as a single unit) without committing to the shared branch
— the coordinator owns commits per `DECISIONS-skills-ticket-implementer.md#D007`.

The dispatch is one prompt; the sub-agent returns one structured response. The
coordinator does not inject additional context mid-run.

## Variables (coordinator fills before sending)

The coordinator fills these placeholders before sending the prompt:

- `<RUN_ID>` — the unique run id (also the staging-area namespace).
- `<TICKET_IDS>` — comma-separated ticket ids in the dispatch unit (one for
  single-ticket dispatches; multiple for same-file groups).
- `<NORMALIZED_TICKETS>` — the full normalized ticket body or bodies, with
  frontmatter and sections (Goal, What to build, Recommended Workflow, Context
  pointers, Acceptance criteria, Dependencies) verbatim.
- `<COMPLETION_CRITERIA>` — the resolved criteria list (Acceptance criteria or
  Definition of Done, per Phase 2.1 of `SKILL.md`).
- `<OWNED_FILES>` — the union of `Where:` lines and `Files` context pointers
  across the dispatch unit's tickets, as a bullet list.
- `<STARTING_COMMIT>` — the SHA the staging area was pinned to.
- `<STAGING_PATH>` — absolute path to the per-dispatch-unit staging directory,
  e.g. `<repo>/.implement-runs/<RUN_ID>/staging/<TICKET_ID>/`.
- `<SHARED_BRANCH>` — the name of the shared branch all work lands on.
- `<JUDGE_FEEDBACK>` — empty on first dispatch; on re-dispatch, the verbatim
  feedback from the judge's prior `reject-with-feedback` verdict.

## Outputs (sub-agent returns)

These fields appear in the sub-agent's structured response. The coordinator consumes them after the dispatch.

- `<PROPOSED_SUBJECT>` — the sub-agent's plain-language commit subject proposal, written as a public changelog entry. The coordinator reviews it against the subject-quality gate before using it.

## Prompt

```
You are implementing one or more tickets on a shared branch, in a per-dispatch
staging area. You have a fresh context; do not assume any state from the
coordinator other than what is in this prompt.

## Run id
<RUN_ID>

## Dispatch unit ticket ids
<TICKET_IDS>

## Shared branch
<SHARED_BRANCH>

## Starting commit (pinned)
<STARTING_COMMIT>

## Staging area
<STAGING_PATH>

You must do all work inside <STAGING_PATH>. Do not modify any file outside
<STAGING_PATH>. Do not commit. The coordinator owns commits.

## Tickets
<NORMALIZED_TICKETS>

## Completion criteria
<COMPLETION_CRITERIA>

## Files you own (read and write)
<OWNED_FILES>

You may read files outside <OWNED_FILES> to gain context, but you may not
write to them. If you need to write to a file outside <OWNED_FILES>, stop and
return `blocked: <file-path>` in your response.

## Prior judge feedback (empty on first dispatch)
<JUDGE_FEEDBACK>

## What to do

1. Read the ticket(s) and the completion criteria end to end.
2. Read each file in <OWNED_FILES> from the staging area's pinned commit.
3. Implement the ticket(s) in the staging area. Follow each ticket's
   Recommended Workflow in order; reorder only if a step's dependencies make
   the original order impossible.
4. For each file you change, keep the change scoped to the ticket's acceptance
   criteria. Do not refactor unrelated code; do not reformat untouched lines.
5. Do not run `git add`, `git commit`, or any commit-related command. The
   coordinator commits.
6. Do not run `git push`, `git checkout` to a different branch, or any branch-
   switching command.
7. Do not modify files outside <OWNED_FILES>. If a ticket's criteria require
   touching a file you do not own, return `blocked: <file-path>` and stop.
8. Propose a commit subject in the `proposed_subject` field of your response. The subject must read as a public changelog entry — a future maintainer who has not read the ticket should understand what the change does. Do not include ledger IDs, other-ticket IDs, or host-tool acronyms in the subject. Put cross-references in `notes:` instead.

## What to return

Return a single structured response, in plain text, in this exact shape:

```
status: done | blocked | error
tickets: <TICKET_IDS>
proposed_subject: "[<ticket-id>] <plain-language description>"
files_changed:
  - <path> — <one-line summary of the change>
  - <path> — <one-line summary of the change>
criteria_check:
  - <criterion verbatim from <COMPLETION_CRITERIA>> — met | unmet | partial
  - <criterion verbatim from <COMPLETION_CRITERIA>> — met | unmet | partial
notes: <free-form notes for the judge, including anything you could not
        determine or any deviations from the ticket's Recommended Workflow>
```

If `status: blocked`, replace `files_changed` with `blocked_files:
  - <path>` and put the reason in `notes`.

If `status: error`, put the error message in `notes` and leave
`files_changed` empty. `proposed_subject:` is required only for
`status: done`; for `status: blocked` and `status: error`, omit the
field.

## Constraints

- One response. Do not loop. Do not ask the coordinator questions.
- The staging area is your only writable surface. Anything else is a contract
  violation; return `status: error` with `notes: wrote-outside-staging` if it
  happens.
- If the ticket's Recommended Workflow step order is wrong, follow the
  dependency-respecting order and note the reorder in `notes`. Do not silently
  re-order.
- No WIP commits, no stashes, no untracked-file leaks across dispatch
  boundaries.
```

## Coordinator-side validation

After the sub-agent responds, the coordinator:

1. Confirms the sub-agent did not run any commit-related command by checking
   the staging area's `git log` (only `<STARTING_COMMIT>` should be reachable
   from the staging area's HEAD before the coordinator commits).
2. Confirms all paths in `files_changed` are within `<OWNED_FILES>`. If not,
   the dispatch is treated as `status: error` with the offending path in
   `notes`, and the strike counter increments.
3. Hands the response and the staging-area diff to the judge.
