---
name: grilling
description: >-
  Relentless Socratic interviewing to extract clear decisions from vague ideas.
  Use when the user wants to think through an ambiguous decision that is neither
  code/tech (defer to `code-implementation-grilling`) nor domain modeling or
  terminology alignment (defer to `domain-grilling`) — business strategy,
  product direction, design choices, process, organizational decisions, and
  similar non-implementation decisions.
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

- When the user has a vague idea, ambiguous goal, or undecided direction
  and wants the agent to help think it through.
- The decision is **not** primarily about code/tech implementation and
  **not** primarily about domain modeling or terminology.
- Examples: business strategy pivots, product direction, design choices,
  process changes, organizational structure, hiring, pricing, marketing
  positioning, partnership decisions.
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- For code/technical implementation choices (language, framework, dependencies,
  project structure) when a spec/PRD exists — defer to
  `code-implementation-grilling`.
- For domain modeling, ubiquitous language, bounded contexts, glossary, or
  terminology alignment — defer to `domain-grilling`.
- For trivial questions with a clear answer (no grilling needed).
- For executing a decision that has already been made (no grilling needed).
- For implementation, debugging, or code review (no grilling needed).

## Workflow

### Step 1: Load the references

Before the first user question, load and read in full:

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

Scan `docs/decisions/DECISIONS-*.md` for any existing ledger that matches
the feature being grilled. If one exists, read it end-to-end and report to
the user:

- The highest existing `Dxxx` number — the next record is `Dxxx + 1`.
- Any unresolved contradictions between existing records.
- The branches already covered, so the user can see what is in scope for
  the current session.

If no matching ledger exists, derive the path
`docs/decisions/DECISIONS-<repo>-<feature>.md` (where `<repo>` is the
directory name of the working repository and `<feature>` is a short
kebab-case slug of the topic) and confirm the path with the user before
the first append.

### Step 3: Open Branch A

Open the first decision branch using the locked question format from
`references/locked-question-format.md`. Walk the user through it one
question at a time.

For every question, present all natural options (typically 2–4) using
the options format from `references/options-format.md`, then the
recommendation using the format from `references/recommendation-format.md`.

### Step 4: Record and continue

After the user resolves a branch, immediately append a `Dxxx` record to
the Decision Ledger using the template in
`references/decision-ledger.md`. Do not batch the writes — append
after each resolution, before opening the next branch.

Apply the tone discipline from `references/tone-and-output.md` on every
branch transition: no evaluative openers, neutral mirroring, structural
transitions.

### Step 5: Convergence

Before declaring convergence, run the four-check convergence test from
`references/convergence-test.md`. If any check fails, continue grilling
(or re-open the affected branch). When all four pass, declare: "We have
reached a shared understanding."

### Step 6: Exit paths

Once convergence is declared, offer the user the exit paths appropriate
to the type of decision reached. Every exit that drives downstream
action must include the Decision Ledger path so downstream skills can
cite records by ID.

- **Document the decision** — write a decision memo or notes file that
  cites the ledger records. Suitable when the outcome is a decision the
  user will act on later, not a body of work to be implemented.
- **Hand off to `domain-grilling`** — if the discussion surfaced DDD
  concerns (bounded contexts, ubiquitous language, glossary) that need
  a deeper domain pass. The new skill inherits the existing ledger and
  continues with `Dxxx` records.
- **Hand off to `code-implementation-grilling`** — if the discussion
  surfaced implementation choices (language, framework, dependencies)
  and a spec/PRD exists or can be created. The new skill inherits the
  ledger and continues with `Txxx` records.
- **Break into tickets or issues** — if the decision has produced
  discrete action items. Use `spec-to-tickets` (with the ledger) or
  `to-issues` for simpler flat decomposition.
- **Handoff to another agent** — pass the Decision Ledger path as the
  source of truth.
- **Custom save** — save the shared understanding in another way,
  citing the Decision Ledger path so records stay linked to the artifact.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All six reference files were loaded and read in full before the
      first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] Decision Ledger path was derived (or located) and confirmed with
      the user before the first write.
- [ ] Existing Decision Ledger state was summarized to the user before
      the first question.
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx`
      line in `Constraints` rather than amending the prior record.
- [ ] Every question offered all natural options (typically 2–4) with
      the four required fields (What it is, Benefit, Cost, Risk) at one
      sentence per field.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every question used the locked format
      `For [Dxxx] – [branch name]: pick an option, or provide your answer.`
      with the `Dxxx` and name verbatim.
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
      cite records by ID.
