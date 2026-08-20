---
name: code-implementation-grilling
description: >-
  Code implementation planning - language, framework, dependencies,
  project structure, sub-projects. Use when a spec/PRD exists (referenced
  document, attachment, or substantively present in conversation) and the
  question turns to technical choices. Defer to `domain-grilling` for
  vague ideas, domain modeling, or terminology alignment; defer to
  `grilling` for non-code, non-domain decisions.
license: MIT
---

# Code Implementation `grilling`

A structured decision-elicitation skill that resolves technical implementation
choices once a functional spec/PRD exists. Adds spec reading, Foundation
checklist, Technical Decision Point extraction, optional Interface/Model
branch, and code-specific handoff templates on top of `grilling` (which
owns the Decision Ledger, formats, tone, and convergence test).

## When to Use

- A spec or PRD is referenced (file, attachment, or conversation) and the
  goal is a code implementation plan.

## When Not to Use

- For vague ideas, domain modeling, ubiquitous language, glossary, bounded contexts, or terminology alignment - use `domain-grilling` instead.
- For non-code, non-domain decisions (business, product, process, organizational) - use `grilling` instead.
- Questions that require back-and-forth clarification - use the ask-questions skill instead.
- Creating a spec or PRD itself.

## Workflow

Every branch question in this skill follows the 1-turn wrapper from
the parent `grilling` skill. The skill's per-decision context block is
the 5-row code-impl variant (Goal, Prior decisions, Scope, Spec
section - 4 data rows + header = 5 rows) defined in

references/locked-question-format.md. The shared references
(../`grilling`/references/*) define the wrapper order, the parent's 4-row
context table, the locked question line wording, the "you" convention,
tone discipline, options format, and recommendation format. The local

references/locked-question-format.md extends the parent with the
Spec section row.

### Re-ask cycle cap

A branch question may be re-asked at most **once** (max 2 total
attempts: 1 initial + 1 re-ask). The re-ask preamble **must** state
explicitly that this is the final re-ask, and that the question will
close with DEFERRED if no clear answer is provided. After closure,
the agent moves to the next branch.

### Step 1: Load the references

Run the pre-flight check from ../`grilling`/SKILL.md Step 1.0 to
confirm all required reference files exist and are readable. If any
are missing, abort and report. After the pre-flight passes, apply
the per-reference load policy from the **References** section below.

Apply the loaded formats verbatim. Do not paraphrase, abbreviate, or
modify the formats.

### Step 2: Spec and Decision Ledger resolution

Follow `grilling`'s Step 2 (Decision Ledger state summary) with the
following code-specific additions:

1. **Locate the spec.** Derive the spec identifier by precedence:
   file path > issue tracker > conversation context.
2. **Locate the ledger.** Same as `grilling`'s Step 2.
3. **Read records.** Note the highest `Dxxx`/`Txxx` and every `Dxxx`
   answer/constraint - the functional requirements the tech decisions
   must satisfy.
4. **Confirm paths** before the first append.
5. **Conflict pre-check.** Surface any `Dxxx`-`Dxxx` contradictions
   and resolve before proceeding.

The first turn of this step is one agent turn: confirm the spec and
ledger paths, then stop. Do not surface TDPs, foundation items, or
any other branch content in this turn. If no ledger exists, recommend
running domain-`grilling` first - but if the user proceeds directly,
create `docs/decisions/DECISIONS-<repo>-<feature>.md` with the
file-format header and all three trailing sentinels:

```md
<!-- next-d: D001 -->
<!-- next-t: T001 -->
<!-- next-i: I001 -->
```

Load 
references/recording-decisions.md before the first `Txxx`
append.

### Step 3: Goal discovery

Follow `grilling`'s Step 3 (Goal discovery). The first turn after the
user has confirmed the spec and ledger paths in Step 2 is an open
question to surface the goal. Record the response as the goal record in the
Decision Ledger.

### Step 4: Foundation Establishment (mandatory)

Resolve in rounds of up to 3 foundation items using the 1-turn wrapper
from ../`grilling`/`references/locked-question-format.md`. Each round
is a single agent turn: emit the round header, frontier statement,
then for each unblocked foundation item emit the full wrapper (5-row
context block, conflict callout if any, options table, recommendation).
No inter-turn wait between items within a round. Resolve with 2-4
options:

1. **Language** - primary language?
2. **Framework/Runtime** - primary framework?
3. **Key Dependencies** - critical libraries/APIs?
4. **Project Structure** - layout (layered, vertical slices, etc.)?
5. **Sub-projects** - scope and purpose of each?
6. **Project Type** - CLI, library, desktop GUI, etc.?

### Step 4.1: Foundational Preferences (optional)

Ask if the user wants to clarify other preferences (async model, CSS
framework, ORM, test framework, logging, etc.). Skip if not interested.

### Step 5: Spec-Driven Technical Extraction

1. **Identify TDPs** (internal agent step): Extract every functional
   requirement that implies a technical choice. Skip items marked
   "deferred" or "out of scope". Never use the abbreviation "TDP"
   with the user.
2. **Surface TDP list** (separate turn): After the foundation is
   resolved, present the TDP list to the user grouped into
   dependency-ordered rounds of at most 3 unblocked items. Use the
   same FIFO grouping as the parent grilling skill's Step 4.0: order
   by dependency, surface the first 3 unblocked items this round,
   and let blocked items wait. Emit a round header and frontier
   statement ("N TDPs remain, M unblocked this round") before
   surfacing each group. The TDP list surfacing is a meta-step (not
   a branch) - it presents the items without the full 1-turn wrapper
   yet; the wrapper is emitted during resolution.
3. **Resolve**: Grill on each TDP using the 1-turn wrapper. Each round
   resolves at most 3 TDPs. Run the convergence check from
   ../`grilling`/references/convergence-test.md after the last TDP
   in each round before opening the next round. TDPs blocked by
   unresolved dependencies wait for a subsequent round.

Load 
references/interface-and-model-branch.md before asking the user
whether they want interface `grilling`.

Load 
references/output-selection.md before presenting the output
format choice to the user.

### Step 6: Interface & Model Branch (optional)

Follow 
references/interface-and-model-branch.md. Use the 1-turn
wrapper for each architectural decision, source-of-truth conflict,
and type introduction.

### Step 7: Output Selection

Follow 
references/output-selection.md. The output selection question is **not**
a branch decision and must **not** use the locked question format (no
5-row context block, no locked question line). Use the format defined
in output-selection.md: a brief preamble, the options table, and the
recommendation. The output is **not** a per-branch Implementation
Blueprint; the consolidated plan is produced once at the endpoint of
the `grilling` (see Step 8.5).

### Step 8: Final Alignment Check & Convergence

After the last branch in a round, run the 5-check convergence test
from ../`grilling`/references/convergence-test.md. If any check
fails, continue `grilling` or re-open the affected branch.

1. **Cross-reference** the technical output against the original spec.
2. **Conflict detection** - any tech choices contradict functional reqs?
3. **Resolve** any contradictions.
4. **Ledger coverage** - every resolved TDP has a `Txxx`.
5. The agent may prompt for close-out; the user decides.

Load 
references/validation.md before convergence.

Load 
references/terminal-output.md before emitting the terminal
handoff template.

### Step 8.5: Consolidated Implementation Plan

At the natural endpoint of the `grilling` - after convergence - produce
a single **Consolidated Implementation Plan** that lists every file
change across all Address items, grouped by file. The plan is the
source of truth for downstream ticket generation.

**Format options (pick one at end-of-`grilling`):**

- **Standalone file** - write
  IMPLEMENTATION-<spec-identifier>.md at the repo root, with a
  Scope Binding section linking it to the source spec and the
  Decision Ledger.
- **Ledger appendix** - append a "Consolidated Implementation Plan"
  section to the Decision Ledger file itself.

**Plan contents:**

- **Per-file sections** - every file that any Address item touches,
  grouped by file path. Within each section, list each change with
  the `Txxx` (or `Dxxx`) record that drives it in
  filename#<`Dxxx`|`Txxx`> format.
- **## Ledger Reference** - every `Dxxx` and `Txxx` record the plan
  cites.
- **Scope binding** (standalone only).

### Step 9: Post-session deletion reminder

Per the Lifecycle by skill group table in
../`grilling`/references/decision-ledger.md, this skill's Decision
Ledger is **persisted by default**. After convergence is declared,
remind the user in a single short turn that the Decision Ledger is
still on disk and can be deleted once implementation is complete. The
reminder is non-blocking. When the Consolidated Implementation Plan
is consumed by `spec-to-tickets`, the deletion reminder is suppressed.

## References

The skill consumes the following references.

### Parent `grilling` references (../`grilling`/references/*)

- **../`grilling`/references/decision-ledger.md** - *eager*. Defines
  the ledger file layout, record templates, ID format, sentinels,
  real-time appending, conflict resolution mechanics, and DEFERRED
  re-ask closure.
- **../`grilling`/references/options-format.md** - *eager*. Defines
  the 5-column options table (Option | What it is | Benefit | Cost |
  Risk) with cell caps (90 chars, 2 sentences).
- **../`grilling`/references/recommendation-format.md** - *eager*.
  Defines the 2-line lean recommendation block.
- **../`grilling`/`references/locked-question-format.md`** - *eager*.
  Defines the 1-turn wrapper order and the parent's 4-row context table. The
  local 
references/locked-question-format.md extends this with the
  Spec section row.

### Skill-local references (
references/*)

- **
references/locked-question-format.md** - *eager*. Defines the
  5-row code-impl context table (parent 3 rows + Spec section).
- **
references/recording-decisions.md** - *eager*. Defines the `Txxx`
  record template.
- **
references/interface-and-model-branch.md** - *lazy*. Load on
  demand before Step 6.
- **
references/output-selection.md** - *lazy*. Load on demand
  before Step 7.
- **
references/validation.md** - *lazy*. Load on demand before
  convergence.
- **
references/terminal-output.md** - *lazy*. Load on demand
  before Step 8.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All eager references were loaded in full before the first user
      question; no lazy reference was loaded speculatively.
- [ ] Spec was located and Decision Ledger path was confirmed before
      the first write.
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching). In multi-pick rounds, all records
      were written in one tool call.
- [ ] Every record used the inline template and a fresh `Dxxx`/`Txxx` ID.
- [ ] When a new Decision Ledger was created during the session, all
      three trailing sentinels (`next-d`, `next-t`, `next-i`) were seeded
      at initialisation.
- [ ] TDPs were grouped into rounds of at most 3 unblocked items
      before resolution; no round surfaced more than 3 branches.
- [ ] Every branch question followed the 1-turn wrapper: round header,
      frontier statement, 5-row context block (Goal, Prior decisions,
      Scope, Spec section), conflict callout (if any), options table,
      recommendation.
- [ ] The re-ask cycle was capped at 1 re-ask; closure without
      resolution produced a DEFERRED record.
- [ ] Every context block was the 5-row table with the required Spec
      section row and inline citation.
- [ ] Every options block used the 5-column table format.
- [ ] Every recommendation used the 2-line format (letter + period,
      reasoning sentence).
- [ ] Conflict detection ran before each branch resolution.
- [ ] Convergence was a per-round check; the agent offered close-out
      but the user decided.
- [ ] The Consolidated Implementation Plan was produced at the endpoint.
- [ ] The chosen exit was handed off with the Decision Ledger path.
- [ ] Every citation used the filename#`Dxxx` format.
- [ ] Post-session deletion reminder was emitted (suppressed for
      `spec-to-tickets` handoff).