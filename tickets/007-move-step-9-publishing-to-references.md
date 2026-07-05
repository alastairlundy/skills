---
title: Move Step 9 publishing rules to references
classification: Independent
blocked_by: ['001-restructure-workflow-into-sub-workflows']
parent: Conversation context (2026-07-03) - Implementing the 23-record Decision Ledger for the spec-to-tickets skill review. Edits SKILL.md only. Out of scope - changes to references/, ticket generation evals, or skills other than spec-to-tickets.
---

## Goal

Move Step 9's ticket-publishing rules (host-CLI detection, installation flow, issue-tracker and local-markdown branches) to a new `references/publishing-rules.md` file. Reduce `SKILL.md`'s Step 9 to a load-trigger sentence that points to the reference.

## What to build

Trim `SKILL.md` by moving the long Step 9 content to a reference file:

- Create `skills/engineering/spec-to-tickets/references/publishing-rules.md` containing the existing Step 9 content: host-CLI detection procedure, the installation flow (present the install command, then ask before running), the issue-tracker publishing branch (publish in dependency order, create issues, fill `Blocked by` with real issue numbers), the local-markdown publishing branch (resolve tickets directory, determine structure, name files, write frontmatter), and the `do NOT close or modify any parent issue` rule.
- Replace the Step 9 section in both sub-workflows of `SKILL.md` with a short load-trigger sentence and a one-line link to the reference. The trigger sentence names the situation that requires loading the reference ("Load `references/publishing-rules.md` before executing Step 9's publish step").
- Add the reference to the `references/` directory's existing convention (the file joins `host-cli-detection.md` and `ticket-template.md` in the same directory; no new directory is needed).

The move applies to both the Collaborative and Self-Contained sub-workflows.

## Recommended Workflow

### Step 1 - Create references/publishing-rules.md

Where: `skills/engineering/spec-to-tickets/references/publishing-rules.md`

- Create the new file.
- Copy the existing Step 9 content from `SKILL.md` into the new file with no semantic changes: host-CLI detection procedure, installation flow, issue-tracker branch, local-markdown branch, parent-issue rule.

Verify: `publishing-rules.md` exists at the path; its content is a faithful copy of the pre-move Step 9.

### Step 2 - Trim Step 9 in both sub-workflows

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- In Step 9 of both sub-workflows, replace the long body with a load-trigger sentence: "Load `references/publishing-rules.md` before executing Step 9's publish step."
- Keep the `### Step 9 - Ticket Publishing` heading in both sub-workflows.
- Do not remove the existing `> Mode banner` callout in this ticket (ticket 001 will remove it as part of the workflow restructure; the order of these tickets is 001 -> 007, so by the time 007 runs, the callout is already gone).

Verify: Both sub-workflows' Step 9 sections are short (one or two sentences plus the heading); the long publishing rules are not duplicated in `SKILL.md`.

### Step 3 - Update the Validation list

Where: `skills/engineering/spec-to-tickets/SKILL.md`

- Add a bullet that the long Step 9 content lives in `references/publishing-rules.md` and `SKILL.md` carries only the load-trigger sentence.
- Add a bullet that the move applies to both sub-workflows.

Verify: Both new Validation bullets are present.

## Context pointers

**Files** - `skills/engineering/spec-to-tickets/SKILL.md` (Step 9 trimmed in both sub-workflows, plus the Validation list), `skills/engineering/spec-to-tickets/references/publishing-rules.md` (new file, destination of the moved content).
**ADRs** - None.
**Domain terms** - `load trigger` (relevant because the trimmed Step 9 is itself a load trigger).
**Ledger records** - `DECISIONS-skills-spec-to-tickets-review.md#D001`.

## Acceptance criteria

- [ ] `skills/engineering/spec-to-tickets/references/publishing-rules.md` exists and contains the host-CLI detection procedure, installation flow, issue-tracker branch, local-markdown branch, and parent-issue rule.
- [ ] Both sub-workflows' Step 9 in `SKILL.md` is reduced to a load-trigger sentence plus the heading.
- [ ] The long publishing rules are not duplicated in `SKILL.md`.
- [ ] The Validation list gains two new bullets corresponding to the move.

## Dependencies

All dependencies are tracked via the `Blocked by` field; the `Blocks` field is reserved for forward-looking dependency statements only and shall not be used in tickets produced by this skill.

**Blocked by** - `001-restructure-workflow-into-sub-workflows` (the Step 9 trim applies to both sub-workflows created by ticket 001; ticket 001 also removes the mode-banner callout, so the trim in this ticket operates on the post-restructure Step 9).
