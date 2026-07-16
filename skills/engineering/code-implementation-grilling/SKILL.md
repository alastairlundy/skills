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
- Questions that require back-and-forth clarification — use the
  `ask-questions` skill instead.
- Creating a spec/PRD itself.

## Workflow

Every branch question in this skill follows the two-turn locked
question sequence from `../grilling/references/locked-question-format.md`.
The skill's steps (4, 5, 6) call the sequence, but the format itself —
context block, Socratic elicitation question, locked question line,
options + recommendation — is defined by that reference. The shared
references (`../grilling/references/*`) also define the "you"
convention, tone discipline, options format, and recommendation
format. This skill defers to those references for all of those
formats. Re-asking a branch restarts at Turn 1 with a fresh context
block and Socratic elicitation question — do not skip straight to
the locked question line or the options.

### Re-ask cycle cap

A branch question may be re-asked at most **once** (max 2 total
attempts: 1 initial + 1 re-ask). The re-ask preamble **must** state
explicitly that this is the final re-ask, and that the question will
be **closed without resolution** if a clear answer is not provided.
Closure without resolution produces a `Dxxx` (or `Txxx` for
technical decisions) record with status `closed without resolution`
in `Constraints`; the agent does not stay silent and does not loop
indefinitely. After closure, the agent moves to the next branch.

### Step 1: Load the references

Run the pre-flight check from `../grilling/SKILL.md` Step 1.0 to
confirm all required reference files exist and are readable. If any
are missing, abort and report. After the pre-flight passes, apply
the per-reference load policy from the **References** section below:
load each eager reference in full before the first user question;
leave the lazy references unloaded and load them only on their
declared trigger.

Apply the loaded formats verbatim. Do not paraphrase, abbreviate, or
modify the formats.

### Step 2: Spec and Decision Ledger resolution

Follow grilling's Step 2 (Decision Ledger state summary) with the
following code-specific additions:

1. **Locate the spec.** Derive the spec identifier by precedence:
   file path > issue tracker > conversation context.
2. **Locate the ledger.** Same as grilling's Step 2.
3. **Read records.** Note the highest `Dxxx`/`Txxx` and every `Dxxx`
   answer/constraint — the functional requirements the tech decisions
   must satisfy.
4. **Confirm paths** before the first append.
5. **Conflict pre-check.** Surface any `Dxxx`-`Dxxx` contradictions
   and resolve before proceeding.

The first turn of this step is one agent turn: confirm the spec and
ledger paths, then stop. Do not surface TDPs, foundation items, or
any other branch content in this turn. If no ledger exists, recommend
running `domain-grilling` first.

Load `references/recording-decisions.md` before the first `Txxx`
append.

### Step 3: Goal discovery

Follow grilling's Step 3 (Goal discovery). The first turn after the
user has confirmed the spec and ledger paths in Step 2 is an open
Socratic question to surface the goal. The goal-discovery turn, the
locked-question turn, and the options/recommendation turn for the
first branch are all separate turns — do not collapse them. The goal
record (D001) is recorded in the shared Decision Ledger using the
goal record template from `../grilling/references/decision-ledger.md`.

### Step 4: Foundation Establishment (mandatory)

Resolve one-by-one using the two-turn locked question sequence from
`../grilling/references/locked-question-format.md`. For each
foundation item, emit a context block, Socratic elicitation question,
locked question line, and options + recommendation across two
separate agent turns. Resolve with 2-4 options:

1. **Language** — primary language?
2. **Framework/Runtime** — primary framework?
3. **Key Dependencies** — critical libraries/APIs?
4. **Project Structure** — layout (layered, vertical slices, etc.)?
5. **Sub-projects** — scope and purpose of each?
6. **Project Type** — CLI, library, desktop GUI, etc.?

### Step 4.1: Foundational Preferences (optional)

Ask if the user wants to clarify other preferences (async model, CSS
framework, ORM, test framework, logging, etc.). Skip if not interested.

### Step 5: Spec-Driven Technical Extraction

1. **Identify TDPs** (internal agent step): Extract every functional
   requirement that implies a technical choice (e.g., "Real-time
   updates" → WebSocket vs Long Polling). Skip items marked "deferred"
   or "out of scope". Never use the abbreviation "TDP" with the user.
2. **Surface TDP list** (separate turn): After the foundation is
   resolved, present the TDP list to the user in dependency order.
   State that the agent will walk through them one at a time using
   the two-turn sequence, starting with the first. Do not include
   the context block or Socratic question for the first TDP in this
   turn — that comes in the next turn. The TDP list surfacing is a
   meta-step (not a branch); the context block is not emitted on
   this turn. The first TDP's full context block appears in the next
   turn when the agent begins resolving the first TDP.
3. **Resolve**: Grill on each TDP using the two-turn sequence from
   `../grilling/references/locked-question-format.md`.

Load `references/interface-and-model-branch.md` before asking the user
whether they want interface grilling.

Load `references/output-selection.md` before presenting the output
format choice to the user.

### Step 6: Interface & Model Branch (optional)

Follow `references/interface-and-model-branch.md`. The phases are
sequential, not nested. Use the two-turn locked question sequence
from `../grilling/references/locked-question-format.md` for each
architectural decision, source-of-truth conflict, and type
introduction.

### Step 7: Output Selection

Follow `references/output-selection.md`. Present the two-part choice
one part at a time, using the two-turn sequence for each part. The
output is **not** a per-branch Implementation Blueprint; the
consolidated plan is produced once at the endpoint of the grilling
(see Step 8.5).

### Step 8: Final Alignment Check & Convergence

The convergence test runs at two cadences with different bullet
counts, per `../grilling/references/convergence-test.md`:

- **Per-item convergence** — after each Address item is resolved, run
  the four universal bullets (Implementability, Enforceability,
  Internal consistency, Format compliance).
- **End-of-grilling convergence** — after the last Address item, run
  the four universal bullets plus the fifth cross-record consistency
  bullet.

1. **Cross-reference** the technical output against the original spec.
2. **Conflict detection** — any tech choices contradict functional reqs?
3. **Resolve** any contradictions.
4. **Ledger coverage** — every resolved TDP has a `Txxx`, every cited
   statement uses `filename#<Dxxx|Txxx>`, and the consolidated plan
   lists all cited records.
5. **Declare**: "We have reached a shared implementation understanding."

Load `references/validation.md` before declaring convergence.

Load `references/terminal-output.md` before emitting the terminal
handoff template.

### Step 8.5: Consolidated Implementation Plan

At the natural endpoint of the grilling — after the last Address
item passes the end-of-grilling convergence check — produce a single
**Consolidated Implementation Plan** that lists every file change
across all Address items, grouped by file. The plan is the source of
truth for downstream ticket generation.

**Format options (pick one at end-of-grilling):**

- **Standalone file** — write
  `IMPLEMENTATION-<spec-identifier>.md` at the repo root, with a
  `Scope Binding` section linking it to the source spec and the
  Decision Ledger.
- **Ledger appendix** — append a "Consolidated Implementation Plan"
  section to the Decision Ledger file itself, listing the same
  content.

The filename derivation (standalone option) follows the precedence
**file path > issue tracker reference > conversation context**, per
`references/output-selection.md` Step 7.1.

**Plan contents:**

- **Per-file sections** — every file that any Address item touches,
  grouped by file path. Within each section, list each change with
  the `Txxx` (or `Dxxx`) record that drives it in
  `filename#<Dxxx|Txxx>` format.
- **## Ledger Reference** — every `Dxxx` and `Txxx` record the plan
  cites, so a reader can audit the binding in one pass.
- **Scope binding** (standalone only) —
  `Linked Spec: <path_to_spec>`, `Decision Ledger: <ledger-path>`,
  and a notice that the plan is a context pointer valid ONLY for
  the linked spec.

The consolidated plan replaces the prior per-branch Implementation
Blueprints. Branches do not emit their own blueprints during the
grilling; they only contribute `Dxxx`/`Txxx` records, and the plan
collects all of them at the endpoint.

## References

The skill consumes the following references. The **default** load
policy for a new reference is **no-load**; a contributor must opt
in by listing the reference here with an explicit `eager` or
`lazy (trigger: ...)` policy.

### Parent grilling references (`../grilling/references/*`)

- **`../grilling/references/decision-ledger.md`** — *eager*. Load in
  full before the first user question. Defines the ledger file
  layout, the per-branch record template, the `Dxxx`/`Txxx` ID
  format, the trailing `<!-- next-id: Dxxx -->` sentinel, and the
  real-time appending rule.
- **`../grilling/references/options-format.md`** — *eager*. Load in
  full before the first user question. Defines the 4-field option
  block (What it is / Benefit / Cost / Risk) and the per-field cap
  (20 words or 1 sentence per field).
- **`../grilling/references/recommendation-format.md`** — *eager*.
  Load in full before the first user question. Defines the
  two-field recommendation block (Recommendation / Reasoning) with
  the 1-2 sentence cap on Reasoning and the verbatim-name rule.
- **`../grilling/references/locked-question-format.md`** — *eager*.
  Load in full before the first user question. Defines the
  two-turn locked question sequence (context block + Socratic
  elicitation question; locked question line + options +
  recommendation).

### Lazy references (load on demand)

- **`../grilling/references/tone-and-output.md`** — *lazy*. Load on
  demand when a tone or style question arises during the session.
- **`../grilling/references/convergence-test.md`** — *lazy*. Load
  on demand once convergence is believed reached; do not load
  speculatively during grilling.

### Skill-local references (`references/*`)

- **`references/recording-decisions.md`** — *eager*. Load in full
  before the first `Txxx` append. Defines the `Txxx` record
  template, the `Driver`/`Cites` field semantics, the
  trailing-sentinel lookup, and the real-time appending rule for
  technical decisions.
- **`references/interface-and-model-branch.md`** — *lazy*. Load on
  demand before asking the user whether they want interface
  grilling (Step 6).
- **`references/output-selection.md`** — *lazy*. Load on demand
  before presenting the output format choice to the user (Step 7).
- **`references/validation.md`** — *lazy*. Load on demand before
  declaring convergence (Step 8).
- **`references/terminal-output.md`** — *lazy*. Load on demand
  before emitting the terminal handoff template (Step 8).

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] The References section was applied: every eager reference was
      loaded in full before the first user question; no lazy
      reference was loaded speculatively before its trigger.
- [ ] If any eager reference was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] Spec was located and Decision Ledger path was derived (or
      located) and confirmed with the user before the first write.
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Driver`, `Resolved
      Answer`, `Normalized Requirement`, `Constraints`) and a fresh
      `Dxxx` or `Txxx` ID read from the trailing
      `<!-- next-id: Dxxx|Txxx -->` sentinel (with the scan-file
      fallback when the sentinel is missing or out of sync).
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
      the full four-part sequence across two separate agent turns:
      a context block + Socratic elicitation question turn, and a
      locked question line + options + recommendation turn. The agent
      did not skip the context block or Socratic elicitation question
      on a re-ask, and did not collapse the two turns into a single
      turn.
- [ ] The re-ask cycle was capped at 1 re-ask (max 2 total attempts
      per question); the re-ask preamble explicitly stated this was
      the final re-ask; closure without resolution produced a
      `Dxxx`/`Txxx` record with status `closed without resolution` in
      `Constraints`, not silence.
- [ ] Every context block was emitted as the four-element bullet list
      (Goal, Prior decisions, Stakes, Scope) in that order, each
      element exactly one sentence, with ledger citations. The context
      block was not replaced with a free-form prose summary, a "current
      state" investigation, a code reading, a domain-glossary recap,
      or any other kind of analysis.
- [ ] Every preamble before an options block was capped at 2
      sentences, with mandatory ID-citation of the relevant prior
      record(s), per `references/output-selection.md` Step 7.
- [ ] Every Socratic elicitation question used the D003 verbatim
      phrasing: "What are you working toward in this decision? You may
      answer, or skip and see the options as-is."
- [ ] Every locked question line used the D004 verbatim phrasing:
      "**For [Txxx] – [branch name]: pick an option, hybridize, or
      provide your own answer.**"
- [ ] Every options block was preceded by the reference-set preamble:
      "Here are options to help you refine or confirm your answer. Pick
      one, reject all, or hybridize."
- [ ] Every question offered all natural options (typically 2–4) with
      the four required fields (What it is, Benefit, Cost, Risk) at
      one sentence per field, and each field stayed under the
      per-field cap (20 words or 1 sentence) per
      `../grilling/references/options-format.md`.
- [ ] Every recommendation used the two-field breakdown
      (`Recommendation: Option N — <name>.`, `Reasoning: ...`) with
      the option name copied verbatim and the `Reasoning` field at
      1-2 sentences.
- [ ] Every recommendation's `Reasoning` field was goal-aligned (not
      option-comparison), explaining why the recommended option serves
      the user's stated goal.
- [ ] The "you" and "your" inside every user-facing template (Socratic
      elicitation question, locked question line, reference-set
      preamble, neutral-mirroring template) referred to the **user**,
      not the LLM. The "Convention: 'you' in this reference" headers in
      `../grilling/references/*` make the rule explicit.
- [ ] No sentence began with a word whose function is to praise or
      judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn
      (`basically`, `essentially`, `actually`, `just`, `simply`,
      `in order to`, `it is important to note`, `it's worth noting`,
      `keep in mind`, `note that`, `needless to say`,
      `at the end of the day`, `when all is said and done`).
- [ ] Per-item convergence ran after each Address item (4 universal
      bullets) and end-of-grilling convergence ran after the last
      Address item (4 universal bullets + 1 cross-record consistency
      bullet) per `../grilling/references/convergence-test.md`.
- [ ] Convergence was declared only when all checks for the current
      cadence passed.
- [ ] No diverge mode occurred (no paraphrasing the verbatim answer,
      no skipping a branch, no bundling options, no asking multiple
      questions in one turn, no accepting a contradictory answer
      without a `Supersedes: Dxxx` record).
- [ ] The Consolidated Implementation Plan was produced at the
      endpoint of the grilling as a single plan (standalone
      `IMPLEMENTATION-<spec-identifier>.md` file or ledger appendix),
      grouped by file, listing every file change with its driving
      `Dxxx`/`Txxx` record in `filename#<Dxxx|Txxx>` format and a
      `## Ledger Reference` section. No per-branch Implementation
      Blueprint was emitted during the grilling.
- [ ] The chosen exit was handed off with the Decision Ledger path so
      downstream skills can cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the
      ledger file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
