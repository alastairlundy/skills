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

## Workflow

**Core Constraint**: Ask exactly one question at a time. Wait for the
response and resolve before proceeding.

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
