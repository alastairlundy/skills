---
name: code-implementation-grilling
description: >-
  Relentless Socratic interviewing on technical implementation choices —
  language, framework, dependencies, project structure — once a spec/PRD
  exists. Use when implementation is the question. When non-code/tech
  decisions, use `grilling`. When terminology, use `domain-grilling`.
license: MIT
---

# Code Implementation Grilling

A Socratic interviewing skill that resolves technical implementation
choices once a functional spec/PRD exists. Adds spec reading, Foundation
checklist, Technical Decision Point extraction, optional Interface/Model
branch, and code-specific handoff templates on top of `grilling` (which
owns the Decision Ledger, formats, tone, and convergence test).

## When to Use

- A spec/PRD is referenced (file, attachment, or conversation) and the
  goal is a code implementation plan.
- When user input would clarify the request, invoke ask-questions.

## When Not to Use

- Non-code projects (e.g., business plans, runbooks, research).
- Vague ideas, domain modeling, or terminology alignment (use
  `domain-grilling` instead).
- Creating a spec/PRD itself.

## Convention: "you" in this skill

In this skill, "you" and "your" inside a backticked template, a fenced
code block, or a user-facing prompt **always refer to the user**, not
the LLM. The Socratic elicitation question, the locked question line,
the reference-set preamble, the neutral-mirroring template, and any
other text the agent emits to the user are addressed to the user. Emit
them verbatim and wait for the user to respond before proceeding.
Free-form instructions to the agent in this skill use "the LLM" or
"the agent" to refer to the agent. The shared references
(`../grilling/references/*`) state this rule explicitly under their
own "Convention" headers.

## Workflow

**Core Constraint**: Ask exactly one question per turn — hard stop.
Emit one locked question, then stop generating. No exceptions. A
branch question is not a single question; it is the four-part
sequence (context block, Socratic elicitation question, locked
question line, options + recommendation). Each branch is therefore
emitted across **three** separate agent turns, not one — Turn 1 is
the context block + Socratic elicitation question, Turn 2 is the
locked question line, Turn 3 is the options + recommendation. Re-asks
restart at Turn 1; the agent does not skip the context block or
Socratic elicitation question, and does not collapse the four parts
into a single turn. See the three-turn branch procedure below.

### Three-turn branch procedure

Every branch question in this skill — Foundation Establishment
(Step 3), Spec-Driven Technical Extraction (Step 4), and any
re-ask or follow-up — follows the four-part locked question sequence
from `../grilling/references/locked-question-format.md`. The four
parts are emitted across three separate agent turns with mandatory
waits between them. The agent must not collapse them into a single
turn and must not skip the context block or Socratic elicitation
question, even on a re-ask or a follow-up after the user has answered
earlier parts.

In the four-part sequence, "you" and "your" always refer to the
**user**, not the LLM. The locked question line, the Socratic
elicitation question, the reference-set preamble, and any other
user-facing prompt are addressed to the user. The agent emits them
verbatim and waits for the user to respond.

The three turns are:

1. **Turn 1 — Context block (Part 1) + Socratic elicitation question
   (Part 2).** Present the fixed context block (goal, prior decisions,
   stakes, scope), each element one sentence, citing the goal record
   and any prior branch records. Then ask the Socratic elicitation
   question verbatim. **Stop and wait for the user's response.**

   The Socratic elicitation question is:

   ```
   **What are you working toward in this decision?**
   ```

2. **Turn 2 — Locked question line (Part 3).** After the user answers
   the Socratic elicitation question, present the locked question line
   verbatim. **Stop and wait for the user's answer.**

   The locked question line is:

   ```
   **For [Dxxx | Txxx] – [branch name]: required — state your answer
   before the LLM presents options. You may also pick an option, or
   provide your answer.**
   ```

   The `[Dxxx | Txxx]` is `max(existing Dxxx/Txxx) + 1` — use `Dxxx`
   for functional decisions and `Txxx` for technical decisions. The
   `[branch name]` is a short, descriptive, stable name for the
   branch (do not embed the full question in it). The "you" and
   "your" inside the template refer to the user.

3. **Turn 3 — Options and recommendation (Part 4).** After the user
   answers the locked question, present the options block (with the
   reference-set preamble from `../grilling/references/options-format.md`)
   and the recommendation (with goal-aligned reasoning from
   `../grilling/references/recommendation-format.md`).

   The reference-set preamble is:

   ```
   Here are options to help you refine or confirm your answer. Pick
   one, reject all, or hybridize.
   ```

   Again, the "you" and "your" inside the preamble refer to the user.

The user may confirm their answer, revise it in light of the options,
or hybridize. The user's own answer is the anchor; the options are a
reference set.

Walk the user through one branch at a time. For every branch, the
three turns above are mandatory. Re-asking a branch (because the user
did not answer, asked for clarification, or because of a follow-up)
restarts at Turn 1 with a fresh context block and Socratic elicitation
question — do not skip straight to the locked question line or the
options.

### Step 1: Load the references

Before the first question, load and read in full:
`../grilling/references/decision-ledger.md`,
`../grilling/references/options-format.md`,
`../grilling/references/recommendation-format.md`,
`../grilling/references/locked-question-format.md`,
`../grilling/references/tone-and-output.md`,
`../grilling/references/convergence-test.md`.

Apply their formats verbatim. If any file is missing, abort and report.

### Step 2: Spec and Decision Ledger resolution

The Decision Ledger is shared across `grilling`, `domain-grilling`, and
this skill. Functional decisions are `Dxxx` records; technical decisions
are `Txxx` records. Both live in
`docs/decisions/DECISIONS-<repo>-<feature>.md`.

1. **Locate the spec.** Derive the spec identifier by precedence:
   file path > issue tracker > conversation context.
2. **Locate the ledger.** Scan `docs/decisions/` for a match. If
   multiple exist, ask which to extend. If none, ask whether to start
   a new one or abort.
3. **Read records.** Note the highest `Dxxx`/`Txxx` and every `Dxxx`
   answer/constraint — the functional requirements the tech decisions
   must satisfy.
4. **Confirm paths** before the first append.
5. **Conflict pre-check.** Surface any `Dxxx`-`Dxxx` contradictions
   and resolve before proceeding.

If no ledger exists, recommend running `domain-grilling` first.

Load `references/recording-decisions.md` before the first `Txxx` append.

### Step 3: Foundation Establishment (mandatory)

Resolve one-by-one with 2-4 options, trade-offs, and a recommendation:

1. **Language** — primary language?
2. **Framework/Runtime** — primary framework?
3. **Key Dependencies** — critical libraries/APIs?
4. **Project Structure** — layout (layered, vertical slices, etc.)?
5. **Sub-projects** — scope and purpose of each?
6. **Project Type** — CLI, library, desktop GUI, etc.?

### Step 3.1: Foundational Preferences (optional)

Ask if the user wants to clarify other preferences (async model, CSS
framework, ORM, test framework, logging, etc.). Skip if not interested.

### Step 4: Spec-Driven Technical Extraction

1. **Identify TDPs**: Extract every functional requirement that implies
   a technical choice (e.g., "Real-time updates" → WebSocket vs Long
   Polling).
2. **Filter deferred features**: Skip items marked "deferred" or "out
   of scope".
3. **Resolve**: Grill on each point using Options → Recommendation →
   Risk. Never use the abbreviation "TDP" with the user.

Load `references/interface-and-model-branch.md` before asking the user
whether they want interface grilling.

Load `references/output-selection.md` before presenting the output
format choice to the user.

### Step 7: Final Alignment Check & Convergence

1. **Cross-reference** the technical output against the original spec.
2. **Conflict detection** — any tech choices contradict functional reqs?
3. **Resolve** any contradictions.
4. **Ledger coverage** — every resolved TDP has a `Txxx`, every cited
   statement uses `filename#<Dxxx|Txxx>`, and the blueprint lists all
   cited records.
5. **Declare**: "We have reached a shared implementation understanding."

Load `references/validation.md` before declaring convergence.

Load `references/terminal-output.md` before emitting the terminal
handoff template.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All six reference files were loaded and read in full before the
      first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] Spec was located and Decision Ledger path was derived (or
      located) and confirmed with the user before the first write.
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Driver`, `Resolved
      Answer`, `Normalized Requirement`, `Constraints`) and a fresh
      `Dxxx` or `Txxx` ID incremented from the highest existing one.
- [ ] Every record's `Driver` field captured the user's underlying
      principle or motivation, distinct from `Resolved Answer` (the
      what) and `Normalized Requirement` (the testable outcome).
- [ ] Re-opened branches produced a new record with a `Supersedes:
      Dxxx` line in `Constraints` rather than amending the prior
      record.
- [ ] Every branch question followed the four-part locked question
      sequence: context block, Socratic elicitation question, locked
      question line with explicit required framing, options and
      recommendation.
- [ ] Every branch question, including re-asks and follow-ups, emitted
      the full four-part sequence across three separate agent turns:
      a context block + Socratic elicitation question turn, a locked
      question line turn, and an options + recommendation turn. The
      agent did not skip the context block or Socratic elicitation
      question on a re-ask, and did not collapse the four parts into
      a single turn.
- [ ] Every context block was emitted as the four-element bullet list
      (Goal, Prior decisions, Stakes, Scope) in that order, each
      element exactly one sentence, with ledger citations. The context
      block was not replaced with a free-form prose summary, a "current
      state" investigation, a code reading, a domain-glossary recap,
      or any other kind of analysis.
- [ ] Every Socratic elicitation question used the fixed phrasing:
      "What are you working toward in this decision?"
- [ ] Every locked question line included the explicit required framing:
      `required — state your answer before the LLM presents options.`
- [ ] Every options block was preceded by the reference-set preamble:
      "Here are options to help you refine or confirm your answer. Pick
      one, reject all, or hybridize."
- [ ] Every question offered all natural options (typically 2–4) with
      the four required fields (What it is, Benefit, Cost, Risk) at
      one sentence per field.
- [ ] Every recommendation used the three-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`,
      `Forward risk: ...`) with the option name copied verbatim.
- [ ] Every recommendation's `Reasoning` field was goal-aligned (not
      option-comparison), explaining why the recommended option serves
      the user's stated goal.
- [ ] The "you" and "your" inside every user-facing template (Socratic
      elicitation question, locked question line, reference-set
      preamble, neutral-mirroring template) referred to the **user**,
      not the LLM. The Convention section in this skill and the
      "Convention: 'you' in this reference" headers in
      `../grilling/references/*` make the rule explicit.
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
      downstream skills can cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the
      ledger file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
