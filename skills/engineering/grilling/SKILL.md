---
name: grilling
description: >-
  Relentless Socratic interviewing to extract clear decisions from vague ideas.
  Use when the user wants to think through an ambiguous decision that is neither
  code/tech nor domain modeling or terminology alignment — business strategy,
  product direction, design choices, process, organizational decisions, and
  similar non-implementation decisions. Do not use for code/technical
  implementation choices — use `code-implementation-grilling` instead. Do not
  use for domain modeling or terminology alignment — use `domain-grilling`
  instead.
license: MIT
---

# Grilling

A relentless Socratic interviewing skill. The user has a vague decision;
the agent facilitates — the user owns each decision. The agent walks the
decision down a tree of branches, asks Socratic questions to surface the
user's values, presents options as a reference set, and records the
resolved answer in a Decision Ledger. The session ends when a shared
understanding is reached and the user picks an exit path.

This skill is the **generic parent** of `domain-grilling` and
`code-implementation-grilling`. It owns the core machinery — the Decision
Ledger, the options/recommendation formats, tone discipline, convergence
test. The two specializations add their own initialization (glossary for
domain; spec-reading and tech foundation for code) and defer to this skill
for the core.

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
  project structure) when a spec/PRD exists — use `code-implementation-grilling`
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

1. `references/decision-ledger.md`
2. `references/options-format.md`
3. `references/recommendation-format.md`
4. `references/locked-question-format.md`
5. `references/tone-and-output.md`
6. `references/convergence-test.md`

If any entry is missing or unreadable, stop, collect every missing path
into a single list, abort the session, and report the list to the user.
Do not load any reference until the pre-flight passes for all six.

#### 1.1 Load and read

After the pre-flight passes, load and read each of the six references
in full before the first user question:

- `references/decision-ledger.md` — Decision Ledger path derivation,
  `Dxxx` record format with Driver field, goal record, lazy creation,
  soft cap, re-opens.
- `references/options-format.md` — the reference-set preamble and the
  four-field option block (What it is / Benefit / Cost / Risk).
- `references/recommendation-format.md` — the three-field recommendation
  breakdown with goal-aligned reasoning, the verbatim-name rule, and the
  recommendation-rationale-on-request mechanism.
- `references/locked-question-format.md` — the four-part locked question
  sequence: context block, Socratic elicitation question, locked question
  line with explicit required framing, options and recommendation.
- `references/tone-and-output.md` — tone discipline, forbidden filler
  words, branch transitions, neutral mirroring.
- `references/convergence-test.md` — the four-check convergence test and
  the diverge modes to avoid.

Apply the formats from those files verbatim throughout the session. Do
not paraphrase, abbreviate, or modify the formats. If any of those files
is missing or unreadable, abort the session and report the missing file
to the user.

### Step 2: Decision Ledger state summary

Detect any existing Decision Ledger at runtime before deriving a path:

- Test whether `docs/decisions/` exists in the working repo
  (`Test-Path docs/decisions`).
- If the directory exists, scan it for every `DECISIONS-*.md` file — do
  not limit the search to a feature-specific match.

Branch on the detection result:

- **One existing ledger**: use it. Read it end-to-end and report to the
  user:
  - The highest existing `Dxxx` number — the next record is `Dxxx + 1`.
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
proceeding.** The path confirmation in Step 2, the goal discovery in
Step 3, and the first branch in Step 4 are three separate turns. Do
not emit the goal-discovery question or the first branch question in
the same turn as the path confirmation.

### Step 3: Goal discovery

The first turn after the user has confirmed the ledger path in Step 2
is an open Socratic question to surface the goal of the session. This
is step zero of the grilling — it happens before any branch is opened.
The goal-discovery turn, the locked-question turn, and the
options/recommendation turn for the first branch are all separate
turns — do not collapse any of them into the path-confirmation turn
or into each other.

If the user has pre-stated a goal in the initial message, acknowledge it
and ask for confirmation or refinement. If the user has not stated a
goal, ask the goal-discovery question.

The goal-discovery question is:

> **What are your goals for this idea?**

The question's instruction explicitly states that the user may provide
one goal or multiple goals. The LLM does not pressure the user to
provide multiple goals when they have one.

**Stop and wait for the user's response.** Do not proceed to Step 4
or open any branch question until the user has answered. Record the
response as the foundational goal record (D001) in the Decision Ledger
using the goal record template from `references/decision-ledger.md`.
Append the record immediately. Subsequent context blocks (per
`references/locked-question-format.md`) and recommendation reasoning
reference this record.

### Step 4: Open Branch A

Open the first decision branch using the locked question sequence
from `references/locked-question-format.md`. The four parts (context
block, Socratic elicitation question, locked question line, options
plus recommendation) are emitted across **two separate agent turns**
with a mandatory wait between them. The agent must not collapse the
two turns into a single turn and must not skip the context block or
the optional Socratic elicitation question, even on a re-ask or a
follow-up after the user has answered earlier parts. The locked
question line, the options, and the recommendation are emitted
together in Turn 2 — they are not split into separate turns.

In the locked question sequence, "you" and "your" always refer to the
**user**, not the LLM. The optional Socratic elicitation question,
the locked question line, the reference-set preamble, and any other
user-facing prompt are addressed to the user. The agent emits them
verbatim and waits for the user to respond.

The two turns are:

1. **Turn 1 — Context block (Part 1) + optional Socratic elicitation
   question (Part 2).** Present the fixed context block (Goal, Prior
   decisions, Stakes, Scope), each element one sentence, citing the
   goal record (D001) and any prior branch records. Then ask the
   optional Socratic elicitation question verbatim. **Stop and wait
   for the user's response.**

   The Socratic elicitation question is:

   ```
   What are you working toward in this decision? You may answer, or
   skip and see the options as-is.
   ```

   The Socratic elicitation question is **optional**. The user may
   engage to steer the direction of the options, or decline. The
   agent recognizes decline signals — "skip", "no", "as-is", or a
   no-op response — and proceeds to Turn 2 in the next user turn
   without re-asking and without attempting to extract direction
   from a "skip". The agent must not pressure the user to engage
   with the Socratic question and must not treat a no-op response
   as a missing answer.

   - **Engage case (per D005).** When the user provides a direction
     rather than declining, the agent uses the direction as a soft
     steering signal in Turn 2: it informs the option names, the
     "What it is" descriptions, and the recommendation's `Reasoning`
     field. The underlying choice space is unchanged; the reframing
     is a soft signal across all options, not a filter. Defensible
     options are not dropped.
   - **Decline case (per D013).** When the user declines, the agent
     proceeds to Turn 2 with options framed on the branch context
     (Goal, Prior decisions, Stakes, Scope) without steering; the
     recommendation's `Reasoning` field is based on the branch
     context, not on a direction.

2. **Turn 2 — Locked question line (Part 3) + options and
   recommendation (Part 4).** Present the locked question line
   verbatim, then the options block (preceded by the reference-set
   preamble from `references/options-format.md`) and the
   recommendation (with goal-aligned reasoning from
   `references/recommendation-format.md`). **Stop and wait for the
   user's response.**

   The locked question line is:

   ```
   **For [Dxxx] – [branch name]: pick an option, hybridize, or
   provide your own answer.**
   ```

   The `[Dxxx]` is `max(existing Dxxx) + 1`. The `[branch name]` is a
   short, descriptive, stable name for the branch (do not embed the
   full question in it). The "you" and "your" inside the template
   refer to the user.

   All three response types are **equally valid**: pick an option,
   hybridize, or provide your own answer. The agent must not default
   to a closed-ended "pick one" framing, and must not treat the
   locked question line as demanding a specific answer format.

   The reference-set preamble is:

   ```
   Here are options to help you refine or confirm your answer. Pick
   one, reject all, or hybridize.
   ```

   Again, the "you" and "your" inside the preamble refer to the user.

The user may engage with the Socratic question to steer the options,
decline and let the agent proceed with the default framing, confirm
an answer, revise it in light of the options, or hybridize. The
user's own answer is the anchor; the options are a reference set.

Walk the user through one branch at a time. For every branch, the
two turns above are mandatory. Re-asking a branch (because the user
did not answer, asked for clarification, or because of a follow-up)
restarts at Turn 1 with a fresh context block and optional Socratic
elicitation question — do not skip straight to Turn 2, and do not
collapse the two turns into one.

### Step 5: Record and continue

After the user resolves a branch, run the post-pick step. The
post-pick step is a **gated step**: the next branch must not open
until both the write and the read-back have succeeded. The step has
five actions in a fixed order; actions 3 and 4 are load-bearing and
are not optional.

1. Confirm the pick in one sentence.
2. Remind the user they can ask for the goal-aligned rejection rationale
   for the other options.
3. Issue a tool call to append the new `Dxxx` record to the Decision
   Ledger using the template in `references/decision-ledger.md`
   (including the `Driver` field). The write is **bound to a
   successful tool-call result** — a narrative statement that the
   file was updated is not a write. Do not batch writes; append
   after each resolution, before opening the next branch.
4. **Read-back verification.** After the tool call returns success,
   re-read the ledger file and confirm the new `Dxxx` line is the
   last record in the file (tolerating benign differences such as
   trailing newlines and byte-order). The next branch must not open
   until the read-back confirms the new record is last. If the
   read-back does not show the new `Dxxx` as the last record, treat
   the write as failed and apply the recovery options below.
5. Move to the next branch.

The post-pick confirmation is one sentence. The "you can ask" reminder
is part of the post-pick template, not optional prose. The LLM does not
volunteer analysis the user did not ask for.

If the write or read-back fails — permissions error, race with
another process, parent directory does not exist, or the read-back
does not show the new `Dxxx` as the last record — abort the branch
transition, report the failure to the user (with the failure mode and
the affected ledger path), and offer three recovery options: retry
the write, skip the append and continue, or save the record locally
for later back-fill. Do not proceed to the next branch until the
user picks a recovery option.

Apply the tone discipline from `references/tone-and-output.md` on every
branch transition: no evaluative openers, neutral mirroring, structural
transitions.

**Open follow-up** (source-of-truth definition): a branch left
intentionally unresolved at session end, captured in the ledger with
`Resolved Answer = "DEFERRED"` and a `Constraints` line noting why.
Child skills (e.g., `domain-grilling`) may reference but not redefine
this term.

**Abort rule**: if the user aborts the session, stop grilling. Do not
write a record. Do not run the convergence test. The partial ledger
state is preserved as-is until the user decides to delete or continue
it.

### Step 6: Goal-change handling

The goal-change handling workflow supports two paths:

**User-initiated goal change.** The user explicitly states their goal has
changed. The LLM confirms the change with the user, then:

1. Documents the change as a new goal record in the Decision Ledger
   (with a fresh `Dxxx` ID, a Driver field, and a `Supersedes: Dxxx`
   line in Constraints linking to the prior goal record).
2. Re-asks all open branches with the updated context.
3. Asks the user whether closed branches need revisiting. The LLM does
   not decide unilaterally.

**LLM-flagged potential shift.** The LLM notices the user's answers may
reflect a shift in goals. The LLM flags the potential shift as a
question, not a determination. The user decides whether the goal has
changed. If the user confirms, the same three steps apply.

The goal change or clarification is documented as its own record (with
its own Driver field), not amended into the prior goal record.

### Step 7: Convergence

Before declaring convergence, run the four-check convergence test from
`references/convergence-test.md`. If any check fails, continue grilling
(or re-open the affected branch). When all four pass, declare: "We have
reached a shared understanding."

### Step 8: Exit paths

Once convergence is declared, offer the user the exit paths appropriate
to the type of decision reached. Every exit that drives downstream
action must include the Decision Ledger path so downstream skills can
cite records as `filename#Dxxx`.

- **Document the decision** — write a decision memo or notes file that
  cites the ledger records as `filename#Dxxx`. Suitable when the outcome is
  a decision the user will act on later, not a body of work to be implemented.
- **Specialize to DDD** — if the discussion surfaced DDD concerns
  (bounded contexts, ubiquitous language, glossary) that need a deeper
  domain pass. The new skill inherits the existing ledger and continues
  with `Dxxx` records.
- **Specialize to code** — if the discussion surfaced implementation
  choices (language, framework, dependencies) and a spec/PRD exists or
  can be created. The new skill inherits the ledger and continues with
  `Txxx` records.
- **Decompose** — if the decision has produced discrete action items.
  Use a tree-shape decomposer (with the ledger) or a flat-shape
  decomposer for simpler flat decomposition.
- **Handoff to another agent** — pass the Decision Ledger path as the
  source of truth.
- **Custom save** — save the shared understanding in another way,
  citing records as `filename#Dxxx` so citations survive file relocation.

**Tool mapping** — each generic verb resolves to the tool the calling
environment provides. If the named tool is not available, fall back to
the generic behaviour described in the body of each exit.

| Generic name            | Resolves to                                       | Fallback when unavailable                       |
|-------------------------|---------------------------------------------------|--------------------------------------------------|
| Document the decision   | `to-prd` (decision memo / PRD tool)               | Local memo file in `docs/decisions/`             |
| Specialize to DDD       | `domain-grilling` skill                           | Stay in grilling; do not spawn specialization    |
| Specialize to code      | `code-implementation-grilling` skill              | Stay in grilling; do not spawn specialization    |
| Decompose               | `spec-to-tickets`                                  | Hand-roll a checklist file with ledger citations |
| Handoff to another agent| User-specified target agent                       | Save the ledger path; user passes it manually    |
| Custom save             | User-specified destination                        | n/a — by definition user-supplied                |

## Validation

After completing the workflow, verify each item against the session
transcript:

### Pre-conditions

- [ ] All six reference files were loaded and read in full before the
      first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] Decision Ledger path was derived (or located) and confirmed with
      the user before the first write.

### Output checks

- [ ] Existing Decision Ledger state was summarized to the user before
      the first question.
- [ ] **Must pass — verify in transcript.** The goal-discovery question
      ("What are your goals for this idea?") was asked as Step 3, and
      the user's response was recorded as D001 (the goal record) in the
      Decision Ledger.
- [ ] **Must pass — verify in ledger file.** One Decision Ledger record
      was appended immediately after every resolved branch (no
      batching at session end). Inspect the ledger file's last record
      to confirm it matches the user's most recent resolution: the
      record must be the last `Dxxx` block in the file (tolerating
      benign differences such as trailing newlines and byte-order).
      The ledger file is the single source of truth for post-pick
      correctness; transcript evidence alone is not sufficient.
- [ ] Every record used the inline template (`Driver`, `Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Every record's field headers matched the reference template
      verbatim (`Driver` / `Resolved Answer` / `Normalized Requirement` /
      `Constraints`).
- [ ] Every record's `Driver` field captured the user's underlying
      principle or motivation, distinct from `Resolved Answer` (the
      what) and `Normalized Requirement` (the testable outcome).
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx`
      line in `Constraints` rather than amending the prior record.
- [ ] Every branch question followed the four-part locked question
      sequence: context block, Socratic elicitation question, locked
      question line, options and recommendation. The four parts were
      emitted across **two separate agent turns** (Turn 1: context
      block plus optional Socratic elicitation question; Turn 2:
      locked question line, options, and recommendation together).
- [ ] Every branch question, including re-asks and follow-ups, emitted
      the full two-turn sequence: a context block + Socratic
      elicitation question turn, and a locked question line + options
      + recommendation turn. The agent did not skip the context block
      or the optional Socratic elicitation question on a re-ask, and
      did not collapse the two turns into a single turn. The locked
      question line, the options, and the recommendation were emitted
      together in Turn 2 — they were not split into separate turns.
- [ ] Every context block was emitted as the four-element bullet list
      (Goal, Prior decisions, Stakes, Scope) in that order, each
      element exactly one sentence, with ledger citations. The context
      block was not replaced with a free-form prose summary, a "current
      state" investigation, a code reading, a domain-glossary recap,
      or any other kind of analysis.
- [ ] Every Socratic elicitation question used the D003 verbatim
      phrasing: "What are you working toward in this decision? You may
      answer, or skip and see the options as-is."
- [ ] Every Socratic elicitation question was presented as optional.
      When the user declined (signals: "skip", "no", "as-is", or a
      no-op response), the agent recognized the decline and proceeded
      to Turn 2 without re-asking and without attempting to extract
      direction from a "skip". The agent did not pressure the user to
      engage with the Socratic question.
- [ ] When the user engaged with the Socratic question, the agent
      used the direction as a soft steering signal in Turn 2 —
      informing the option names, the "What it is" descriptions, and
      the recommendation's `Reasoning` field — without dropping
      defensible options. The underlying choice space was unchanged.
- [ ] Every locked question line used the D004 verbatim phrasing:
      "**For [Dxxx] – [branch name]: pick an option, hybridize, or
      provide your own answer.**"
- [ ] Every locked question line presented all three response types
      (pick an option, hybridize, provide your own answer) as equally
      valid. The agent did not default to a closed-ended "pick one"
      framing, and did not treat the locked question line as demanding
      a specific answer format.
- [ ] Every options block was preceded by the reference-set preamble:
      "Here are options to help you refine or confirm your answer. Pick
      one, reject all, or hybridize."
- [ ] Every question offered all natural options (typically 2–4) with
      the four required fields (What it is, Benefit, Cost, Risk) at one
      sentence per field.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every recommendation's `Reasoning` field was goal-aligned (not
      option-comparison), explaining why the recommended option serves
      the user's stated goal.
- [ ] The post-pick step ran as a **gated step** and did not open the
      next branch until both the write and the read-back succeeded:
      (1) one-sentence confirmation, (2) reminder that the user can
      ask for the goal-aligned rejection rationale, (3) tool call to
      append the `Dxxx` record (bound to a successful tool-call
      result — a narrative statement is not a write), (4) read-back
      verification confirming the new `Dxxx` is the last record in
      the file, (5) transition to the next branch.
- [ ] When the user asked for the recommendation rationale, the agent
      provided concise goal-aligned rejection reasoning for the other
      options (not option-comparison).
- [ ] When the user's goal changed mid-session, the change was documented
      as a new goal record with a `Supersedes: Dxxx` line linking to the
      prior goal record, open branches were re-asked, and the user was
      asked whether closed branches need revisiting.
- [ ] No sentence began with a word whose function is to praise or
      judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn
      (`basically`, `essentially`, `actually`, `just`, `simply`,
      `in order to`, `it is important to note`, `it's worth noting`,
      `keep in mind`, `note that`, `needless to say`,
      `at the end of the day`, `when all is said and done`).
- [ ] Convergence was declared only when all four checks
      (all branches resolved, no contradictions, no new question in
      the last three turns, Decision Ledger complete) passed.
- [ ] No diverge mode occurred (no paraphrasing the verbatim answer,
      no skipping a branch, no bundling options, no asking multiple
      questions in one turn, no accepting a contradictory answer
      without a `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path so
      downstream skills (memos, tickets, specialized grilling) can
      cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger
      file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
