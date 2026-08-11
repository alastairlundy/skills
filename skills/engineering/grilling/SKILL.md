---
name: grilling
description: >-
  Structured decision elicitation that surfaces clear decisions from vague ideas.
  Use when the user wants to think through an ambiguous or unclear
  decision that doesn't relate to code/tech nor domain modeling or terminology alignment. Do not use for working towards code/technical 
  implementation choices — use `code-implementation-grilling` instead. Do not
  use when aligning on terminology or domain modelling — use `domain-grilling`
  instead.
license: MIT
---

# Grilling

A structured decision-elicitation skill. The user has a vague decision or idea they want to explore;
the agent facilitates — the user owns each decision. The agent walks the
decision down a tree of branches, presents options as a reference option set, 
gives a goal-aligned recommendation, and records the resolved answer in a Decision Ledger.
 The session is a sequence of rounds, each surfacing at most 3 branches, and each branch
 resolving in a single agent turn.

## When to Use

### Triggers

- When the user has a vague idea, ambiguous goal, or undecided direction
  and wants the agent to help think it through.
- The decision is **not** primarily about code/tech implementation and
  **not** primarily about domain modeling or terminology.
- When user input would clarify the request, invoke ask-questions

### Examples

- Business strategy pivots, product direction, design choices, process
  changes, organizational structure, hiring, pricing, marketing
  positioning, partnership decisions.

## When Not to Use

- For code/technical implementation choices (language, framework, dependencies,
  project structure) when a spec exists — use `code-implementation-grilling`
  instead.
- For domain modeling, ubiquitous language, bounded contexts, glossary, or
  terminology alignment — use `domain-grilling` instead.
- For trivial questions with a clear answer (no grilling needed).
- For executing a decision that has already been made (no grilling needed).
- For implementation, debugging, or code review (no grilling needed).

## Workflow

### Step 1: Load the references

#### 1.0 Pre-flight — verify all six references exist

Before loading or reading, walk this list in order. For each entry,
confirm the file exists and is readable on disk:

1. references/decision-ledger.md
2. references/options-format.md
3. references/recommendation-format.md
4. references/locked-question-format.md
5. references/tone-and-output.md
6. references/convergence-test.md

If any entry is missing or unreadable, stop, collect every missing path
into a single list, abort the session, and report the list to the user.
Do not load any reference until the pre-flight passes for all six.

#### 1.1 Load and read

After the pre-flight passes, load and read each of the six references
in full before the first user question:

- references/decision-ledger.md — Decision Ledger path derivation,
  parallel `Dxxx` and `Ixxx` ID streams with sentinel comments, the
  `Dxxx` record format, the `Ixxx` record format, goal record, lazy
  creation, soft cap, re-opens, lifecycle by skill group, storage
  conventions, conflict resolution mechanics (static/dynamic), and
  DEFERRED re-ask closure.
- references/options-format.md — the reference-set preamble and the
  5-column options table (Option | What it is | Benefit | Cost | Risk)
  with cell caps.
- references/recommendation-format.md — the 2-line lean recommendation
  block with goal-aligned reasoning.
- references/locked-question-format.md — the 1-turn wrapper order:
  round header, frontier statement, context block (3-row table),
  conflict/contradiction callout (conditional), options table,
  recommendation.
- references/tone-and-output.md — tone discipline, forbidden filler
  words, branch transitions, neutral mirroring.
- references/convergence-test.md — the per-round 5-check convergence
  test and the diverge modes to avoid.

Apply the formats from those files verbatim throughout the session. Do
not paraphrase, abbreviate, or modify the formats. If any of those files
is missing or unreadable, abort the session and report the missing file
to the user.

### Step 2: Decision Ledger state summary

Detect any existing Decision Ledger at runtime before deriving a path:

- Test whether `docs/decisions/` exists in the working repo
  (`Test-Path docs/decisions`).
- If the directory exists, scan it for every DECISIONS-*.md file — do
  not limit the search to a feature-specific match.

Branch on the detection result:

- **One existing ledger**: use it. Read it end-to-end and report to the
  user:
  - The highest existing `Dxxx` number — the next record is `Dxxx` + 1.
  - Any unresolved contradictions between existing records.
  - The branches already covered, so the user can see what is in scope
    for the current session.
  Confirm the ledger path with the user before the first append.
- **Multiple existing ledgers**: present every match to the user. Let
  the user pick one to continue, or specify a new path. Do not
  auto-choose. Once the user picks, read it end-to-end and report the
  same three points (highest `Dxxx`, contradictions, branches covered)
  before the first append.
- **No existing ledger**: derive the path
  `docs/decisions/DECISIONS-<repo>-<feature>.md` (where `<repo>` is the
  directory name of the working repository and `<feature>` is a short
  kebab-case slug of the topic), default the parent directory to
  `docs/decisions/`, and confirm the path with the user before the
  first append.

**Stop and wait for the user to confirm or change the path before
proceeding.** The path confirmation in Step 2 and the goal discovery in
Step 3 are separate turns. Do not emit the goal-discovery question in
the same turn as the path confirmation.

### Step 3: Goal discovery

The first turn after the user has confirmed the ledger path in Step 2
is an open question to surface the goal of the session. This happens
before any branch is opened.

If the user has pre-stated a goal in the initial message, acknowledge it
and ask for confirmation or refinement. If the user has not stated a
goal, ask the goal-discovery question.

The goal-discovery question is:

> **What are your goals for this idea?**

The question's instruction explicitly states that the user may provide
one goal or multiple goals. The LLM does not pressure the user to
provide multiple goals when they have one.

**Stop and wait for the user's response.** Do not proceed to Step 4
or open any branch question until the user has answered. Allocate the
next available `Dxxx` ID — `D001` for a new ledger, or `max(existing) + 1`
for an existing one (read from the `<!-- next-d: Dxxx -->` sentinel or
by scanning). Record the response as the goal record in the Decision
Ledger using the goal record template from
references/decision-ledger.md.
Append the record immediately. Subsequent context blocks (per

references/locked-question-format.md) and recommendation reasoning
reference this record.

### Step 4: Open branches in rounds

The session is a sequence of rounds. Each round surfaces at most 3
unblocked branches, FIFO by ledger ID. Each branch resolves in a
single agent turn using the 1-turn wrapper from

references/locked-question-format.md.

#### 4.0 Branch discovery and frontier

Before each round, identify all unblocked branches (branches whose
dependencies are resolved or have no dependencies). Order them by
ledger ID (FIFO). Surface the first 3 in this round. Overflow branches
wait for the next round.

The frontier statement reports: "N branches remain, M unblocked this
round."

#### 4.0a Foundation and scope: user owns the determination

The LLM must not declare foundation items "locked" or "already
decided" without explicit user confirmation. Before treating any
prior record or repo state as binding, ask: "Does [prior record /
repo state] lock this item, or is it still open?" Do not use it as a
binding constraint until the user confirms.

After running the five-check convergence test, the LLM may prompt for
close-out only when all five checks pass. It presents every check result
and identifies only user-confirmed records as binding evidence. It asks:
"Ready to close out, or shall we open the next round?" The user decides.
The LLM never declares convergence as a statement of fact.

#### 4.1 Brief exploration (subagent delegation)

Before each locked question, delegate the brief exploration to a
subagent. The primary agent does not read source files directly.

- Per decision branch, file reads (named files + 1 grep per option)
  are dispatched to a subagent. The subagent investigates and reports
  back to the primary agent.
- If the question surfaces no file concerns, the primary agent spawns
  two subagents: (1) a `GLOSSARY.md` subagent that reads `GLOSSARY.md`
  for relevant terms; (2) a repo-state subagent that explores tests +
  source code and produces a summary.
- Subagent reports are summarized into the locked-question context.

#### 4.2 Conflict detection

Before any branch resolves, run both conflict checks:

- **Static conflict**: two records with mutually-exclusive
  Normalized Requirements. Surface "Conflict detected" callout naming
  both records. User owns resolution.
- **Dynamic conflict**: new resolution contradicts a prior
  resolution. Surface "Contradiction detected" callout naming the prior
  record. Re-ask the branch.

Conflict callouts use fixed wording from

references/locked-question-format.md. They do not re-introduce the
Socratic elicitation turn.

#### 4.3 Emit the wrapper

Emit the full wrapper for each branch in a single round turn.
The round header and frontier statement appear once. Then for each
unblocked branch (up to 3), emit the per-branch block:

1. Context block (3-row table: Goal, Prior decisions, Scope)
2. Conflict/contradiction callout (if any)
3. Options table (5-column, per 
references/options-format.md)
4. Recommendation (2-line, per 
references/recommendation-format.md)

**Emit up to 3 branch wrappers in one round turn.** Each branch
wrapper is self-contained (context block, conflict callout if any,
options table, recommendation). Stop generating after the last
branch wrapper and wait for the user's response.

#### 4.4 User response

The user may:
- Pick an option by name or number
- Provide their own answer
- Hybridize options
- Clarify (correct the agent's understanding without selecting)

When clarification is detected, mirror the clarification and re-ask.
The branch remains open.

When resolution is detected, proceed to Step 5.

### Step 5: Record and continue

After the user resolves a branch, run the post-pick step. Before
entering the post-pick step, confirm the user's response is a
resolution, not a clarification.

The post-pick step is a **gated step**: the next branch must not open
until the write and read-back have succeeded.

1. Confirm the pick in one sentence.
2. Remind the user they can ask for the goal-aligned rejection rationale
   for the other options.
3. Write the `Dxxx` record(s) to the Decision Ledger. In a multi-pick
   round, write all records in one tool call. The write is bound to a
   successful tool-call result.
4. **Read-back verification.** Re-read the ledger and confirm the new
   `Dxxx` line is the last record.
5. Complete the `Ixxx` for this branch (fill the three TBD fields).
6. Move to the next branch or round.

If the write or read-back fails, abort the branch transition, report
the failure, and offer recovery options.

Apply the tone discipline from 
references/tone-and-output.md on every
branch transition.

**Open follow-up**: a branch left intentionally unresolved at session
end, captured in the ledger with Resolved Answer = "DEFERRED" and a
Constraints line noting why.

**Abort rule**: if the user aborts the session, stop grilling. Do not
write a record. Do not run the convergence test.

### Step 6: Per-round convergence

After the last branch in a round, run the 5-check convergence test
from 
references/convergence-test.md. If any check fails, continue
grilling (or re-open the affected branch). When all five pass, the
agent may prompt for close-out: "All checks pass. Ready to close out,
or shall we open the next round?" The user decides whether to stop.

### Step 7: Goal-change handling

The goal-change handling workflow supports two paths:

**User-initiated goal change.** The user explicitly states their goal has
changed. The LLM confirms the change with the user, then:

1. Documents the change as a new goal record in the Decision Ledger
   (with a fresh `Dxxx` ID, a Driver field, and a Supersedes: `Dxxx`
   line in Constraints linking to the prior goal record).
2. Re-asks all open branches with the updated context.
3. Asks the user whether closed branches need revisiting.

**LLM-flagged potential shift.** The LLM notices the user's answers may
reflect a shift in goals. The LLM flags the potential shift as a
question, not a determination. The user decides whether the goal has
changed. If the user confirms, the same three steps apply.

### Step 8: Exit paths

Once convergence is declared, offer the user the exit paths appropriate
to the type of decision reached. Every exit that drives downstream
action must include the Decision Ledger path so downstream skills can
cite records as ilename#`Dxxx`.

- **Specialize to DDD** — if DDD concerns surfaced.
- **Specialize to code** — if implementation choices surfaced.
- **Decompose** — if discrete action items were produced.
- **Handoff to another agent** — pass the Decision Ledger path.
- **Custom save** — save the shared understanding another way.

**Tool mapping** — each generic verb resolves to the tool the calling
environment provides.

| Generic name            | Resolves to                                       | Fallback when unavailable                       |
|-------------------------|---------------------------------------------------|--------------------------------------------------|
| Specialize to DDD       | `domain-grilling` skill                           | Stay in grilling; do not spawn specialization    |
| Specialize to code      | `code-implementation-grilling` skill              | Stay in grilling; do not spawn specialization    |
| Decompose               | `spec-to-tickets`                                  | Hand-roll a checklist file with ledger citations |
| Handoff to another agent| User-specified target agent                       | Save the ledger path; user passes it manually    |
| Custom save             | User-specified destination                        | n/a — by definition user-supplied                |

### Step 9: Post-session deletion reminder

After the chosen exit is handed off, issue a one-sentence reminder that
the Decision Ledger is persisted by default and that the user can delete
it once implementation is complete. If the exit hands off to
`spec-to-tickets`, suppress this reminder.

The reminder is non-blocking. Do not delete the file without explicit
user instruction.

## Validation

After completing the workflow, verify each item against the session
transcript:

### Pre-conditions

- [ ] All six reference files were loaded and read in full before the
      first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported.
- [ ] Decision Ledger path was derived (or located) and confirmed with
      the user before the first write.

### Output checks

- [ ] Existing Decision Ledger state was summarized to the user.
- [ ] The goal-discovery question was asked as Step 3, and the user's
      response was recorded as the goal record (the first `Dxxx` in a
      new ledger, or the next available `Dxxx` in an existing one).
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching at session end). In multi-pick
      rounds, all records were written in one tool call.
- [ ] Every record used the inline template (Driver, Resolved Answer,
      Normalized Requirement, Constraints) and a fresh `Dxxx` ID.
- [ ] Every branch question followed the 1-turn wrapper from
      locked-question-format.md: round header, frontier statement,
      context block (3-row table), conflict callout (if any), options
      table, recommendation. No Socratic elicitation question was
      emitted.
- [ ] Every context block was emitted as the 3-row table (Goal, Prior
      decisions, Scope) in that order, each element one sentence.
- [ ] Every options block used the 5-column table format (Option, What
      it is, Benefit, Cost, Risk).
- [ ] Every recommendation used the 2-line format (Recommendation
      letter + period, Reasoning sentence).
- [ ] Conflict detection ran before each branch resolution. Static and
      dynamic conflicts were surfaced with fixed callout wording.
- [ ] The post-pick step ran as a gated step with write and read-back.
- [ ] Convergence was declared as a per-round check; the agent offered
      close-out but the user decided.
- [ ] No diverge mode occurred.
- [ ] The chosen exit was handed off with the Decision Ledger path.
- [ ] Every citation of a Decision Ledger record used the
      filename#`Dxxx` format.