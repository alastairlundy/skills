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

A relentless Socratic interviewing skill. The user has a vague decision; the
agent walks it down a tree of branches, presents options with trade-offs, and
records the resolved answer in a Decision Ledger. The session ends when a
shared understanding is reached and the user picks an exit path.

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
  `Dxxx` record format, lazy creation, soft cap, re-opens.
- `references/options-format.md` — the four-field option block
  (What it is / Benefit / Cost / Risk).
- `references/recommendation-format.md` — the three-field recommendation
  breakdown with the verbatim-name rule.
- `references/locked-question-format.md` — the locked question template
  used at every branch.
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

### Step 3: Open Branch A

Open the first decision branch using the locked question format from
`references/locked-question-format.md`. The locked format is:
`For [Dxxx] – [branch name]: pick an option, or provide your answer.`
Walk the user through it one question at a time.

For every question, present all natural options (typically 2–4) using
the options format from `references/options-format.md`, then the
recommendation using the format from `references/recommendation-format.md`.

### Step 4: Record and continue

After the user resolves a branch, immediately append a `Dxxx` record to
the Decision Ledger using the template in
`references/decision-ledger.md`. Do not batch the writes — append
after each resolution, before opening the next branch.

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

### Step 5: Convergence

Before declaring convergence, run the four-check convergence test from
`references/convergence-test.md`. If any check fails, continue grilling
(or re-open the affected branch). When all four pass, declare: "We have
reached a shared understanding."

### Step 6: Exit paths

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
- [ ] **Must pass — verify in transcript.** One Decision Ledger record
      was appended immediately after every resolved branch (no
      batching at session end). Inspect the transcript for write-time
      evidence: a successful append must be visible between the user's
      resolution of one branch and the agent's first question of the
      next.
- [ ] Every record used the inline template (`Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Every record's field headers matched the reference template
      verbatim (`Resolved Answer` / `Normalized Requirement` /
      `Constraints`).
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx`
      line in `Constraints` rather than amending the prior record.
- [ ] Every question offered all natural options (typically 2–4) with
      the four required fields (What it is, Benefit, Cost, Risk) at one
      sentence per field.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every question used the locked format from
      `references/locked-question-format.md` with the `Dxxx` and name
      verbatim.
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
