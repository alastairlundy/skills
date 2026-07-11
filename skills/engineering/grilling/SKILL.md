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

### Step 3: Goal discovery

The first turn after the ledger state summary is an open Socratic
question to surface the goal of the session. This is step zero of the
grilling — it happens before any branch is opened.

If the user has pre-stated a goal in the initial message, acknowledge it
and ask for confirmation or refinement. If the user has not stated a
goal, ask the goal-discovery question.

The goal-discovery question is:

> **What are your goals for this idea?**

The question's instruction explicitly states that the user may provide
one goal or multiple goals. The LLM does not pressure the user to
provide multiple goals when they have one.

Wait for the user's response. Record the response as the foundational
goal record (D001) in the Decision Ledger using the goal record template
from `references/decision-ledger.md`. Append the record immediately.
Subsequent context blocks (per `references/locked-question-format.md`)
and recommendation reasoning reference this record.

### Step 4: Open Branch A

Open the first decision branch using the four-part locked question
sequence from `references/locked-question-format.md`:

1. **Context block** — present the fixed context block (goal, prior
   decisions, stakes, scope), each element one sentence, citing the
   goal record (D001) and any prior branch records.
2. **Socratic elicitation question** — ask "What are you working toward
   in this decision?" Wait for the user's response.
3. **Locked question line** — present the locked question line with the
   explicit required framing: `required — state your answer before the
   LLM presents options.` Wait for the user's answer.
4. **Options and recommendation** — present the options block (with the
   reference-set preamble from `references/options-format.md`) and the
   recommendation (with goal-aligned reasoning from
   `references/recommendation-format.md`).

The user may confirm their answer, revise it in light of the options, or
hybridize. The user's own answer is the anchor; the options are a
reference set.

Walk the user through one question at a time. For every question,
present all natural options (typically 2–4) using the options format
from `references/options-format.md`, then the recommendation using the
format from `references/recommendation-format.md`.

### Step 5: Record and continue

After the user resolves a branch, perform the post-pick step:

1. Confirm the pick in one sentence.
2. Remind the user they can ask for the goal-aligned rejection rationale
   for the other options.
3. Immediately append a `Dxxx` record to the Decision Ledger using the
   template in `references/decision-ledger.md` (including the Driver
   field). Do not batch the writes — append after each resolution,
   before opening the next branch.
4. Move to the next branch.

The post-pick confirmation is one sentence. The "you can ask" reminder
is part of the post-pick template, not optional prose. The LLM does not
volunteer analysis the user did not ask for.

If the write fails — permissions error, race with another process, or
the parent directory does not exist — abort the branch transition,
report the failure to the user (with the failure mode and the affected
ledger path), and offer three recovery options: retry the write, skip
the append and continue, or save the record locally for later
back-fill. Do not proceed to the next branch until the user picks a
recovery option.

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
- [ ] **Must pass — verify in transcript.** One Decision Ledger record
      was appended immediately after every resolved branch (no
      batching at session end). Inspect the transcript for write-time
      evidence: a successful append must be visible between the user's
      resolution of one branch and the agent's first question of the
      next.
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
      question line with explicit required framing, options and
      recommendation.
- [ ] Every context block included all four mandatory elements (goal,
      prior decisions, stakes, scope), each one sentence, with ledger
      citations.
- [ ] Every Socratic elicitation question used the fixed phrasing:
      "What are you working toward in this decision?"
- [ ] Every locked question line included the explicit required framing:
      `required — state your answer before the LLM presents options.`
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
- [ ] The post-pick step included: (1) one-sentence confirmation, (2)
      reminder that the user can ask for the goal-aligned rejection
      rationale, (3) immediate ledger append, (4) transition to the next
      branch.
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
      no skipping a branch, no bundling options, no accepting a
      contradictory answer without a `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path so
      downstream skills (memos, tickets, specialized grilling) can
      cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger
      file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
