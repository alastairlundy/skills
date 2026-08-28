---
name: technical-grilling
description: >-
  Technical and code-related decision elicitation - both domain/concept
  alignment (bounded contexts, ubiquitous language, glossary, terminology)
  and spec-driven implementation planning (language, framework,
  dependencies, project structure). Use when the user has a technical or
  code-related decision to think through - a vague idea needing concept
  alignment, a terminology question, or implementation choices with or
  without a spec/PRD. Defer to `grilling` for non-technical decisions
  (business, product, process, organizational).
license: MIT
---

# Technical `grilling`

A structured decision-elicitation skill for technical and code-related
decisions. It specializes `grilling` and covers the full technical track in
one continuous session:

- **Phase 1 - Concept / domain alignment** (carried over from the former `domain-grilling` skill): establish the vocabulary, bounded contexts,
  ubiquitous language, and glossary terms before any "how" is decided.
- **Phase 2 - Implementation planning** (carried over from the former `code-implementation-grilling` skill): resolve language, framework,
  dependencies, project structure, and spec-driven technical decision
  points once the concept is settled or a spec/PRD is supplied.

The core `grilling` machinery (Decision Ledger, options/recommendation
formats, locked question format, tone discipline, convergence test) is
owned by the `grilling` skill. This skill adds: a **spec/ledger intake
gate** (Gate A, anti-redundancy), DDD initialization and term resolution
(Phase 1), and the foundation checklist, TDP extraction, and implementation
plan output (Phase 2). Two hard gates prevent the two failure modes this
merge exists to fix: skipping concept alignment before implementation
(Gate B), and re-grilling decisions the user already supplied (Gate A).

## When to Use

### Triggers

- When the user has a technical or code-related decision to think through:
  a vague idea that needs concept/terminology alignment, a terminology or
  vocabulary question, or implementation choices (language, framework,
  dependencies, project structure).
- When the user supplies a spec/PRD and wants the technical decisions
  extracted and resolved.
- When starting a new feature or architectural change that requires
  conceptual alignment and/or implementation planning.
- When user input would clarify the request, invoke ask-questions.

### Examples

- "What should we call this concept and how should the bounded context be
  drawn?" (Phase 1)
- "We have this PRD - help us pick the language, framework, and structure."
  (Phase 2, spec supplied)
- "I have a vague idea for a CLI tool - let's think it through." (Phase 1
  then Phase 2)

## When Not to Use

- For non-technical decisions (business, product, process, organizational)
  that do not need conceptual or implementation alignment - use `grilling`
  instead.
- For trivial technical questions with a clear answer (no grilling needed).
- For executing a decision that has already been made (no grilling needed).
- For implementation, debugging, or code review (no grilling needed).

## Convention: "you" in this skill

In this skill, "you" and "your" inside a backticked template, a fenced code
block, or a user-facing prompt **always refer to the user**, not the LLM.
The shared references (../`grilling`/references/*) state this rule
explicitly under their own "Convention" headers.

## Workflow

### Step 1: Load the references

Before the first user question, run the pre-flight from `grilling` Step 1.0
to confirm all required reference files exist and are readable. Then load
and read in full:

**Parent `grilling` references (../`grilling`/references/*) - eager:**
- decision-ledger.md, options-format.md, recommendation-format.md,
  locked-question-format.md (4-row context table), tone-and-output.md,
  convergence-test.md.

**Skill-local references (references/*):**
- ddd-initialization.md - *eager*. DDD scan, glossary/ADR challenge, fuzzy
  language, scenario discussion, ADR offer.
- term-resolution.md - *eager*. Writing resolved terms to GLOSSARY.md.
- ADR-FORMAT.md - *eager*. ADR structure and when to offer one.
- locked-question-format.md - *eager*. The 5-row code-impl context table
  (parent 4 rows + Spec section).
- recording-decisions.md - *eager*. The `Txxx` record template.
- interface-and-model-branch.md - *lazy*. Load before Phase 2 interface
  decisions.
- output-selection.md - *lazy*. Load before the output-format question.
- validation.md - *lazy*. Load before convergence.
- terminal-output.md - *lazy*. Load before the terminal handoff template.

Apply the formats verbatim. If any file is missing or unreadable, abort and
report the missing path.

### Step 2: Gate A - Spec / ledger intake (anti-redundancy)

Detect any existing decision artifact **before** opening any branch:

1. **Scan for artifacts.** Test whether `docs/decisions/` exists
   (`Test-Path docs/decisions`) and scan for every `DECISIONS-*.md`. Also
   check whether the user supplied a spec/PRD in this turn (file path,
   attachment, or substantively present in conversation).
2. **Summarize settled decisions.** If an artifact exists, read it
   end-to-end and report: the highest `Dxxx`/`Txxx`, every resolved
   answer/constraint, and which decisions are already settled.
3. **Mark locked via user confirmation.** For each apparently-settled
   item, apply the `grilling` Step 4.0a rule: ask *"Does [this spec/ledger
   record] lock this item, or is it still open?"* Do **not** treat any
   prior record or supplied spec as binding until the user confirms.
   Settled items are recorded as `Dxxx`/`Txxx` with Resolved Answer =
   "Resolved (by provided spec)" and are **never re-grilled**.
4. **Open only open items.** Branches are opened only for items the user
   confirms are still open.

**Stop and wait for the user to confirm or change the locked-item
determinations before the first append.** If no artifact exists and the
request is vague, proceed to Phase 1. If an artifact covers the concept,
you may proceed past Phase 1 directly to Phase 2 after Gate B.

### Step 3: Goal discovery

The first turn after Gate A is an open question to surface the goal
(per `grilling` Step 3). Record the response as the goal record in the
Decision Ledger. **Stop and wait** for the user's response.

### Phase 1: Concept / domain alignment

Follow the concept-alignment workflow:

1. **DDD initialization** (references/ddd-initialization.md): scan
   `GLOSSARY.md`, `docs/adr/`, and any existing Decision Ledger; summarize
   the known domain state *before* the first question. If `GLOSSARY.md` is
   missing, suggest `setup-matt-pocock-skills` but do not create it
   pre-emptively.
2. **Open branches in rounds** using the 1-turn wrapper from
   ../`grilling`/references/locked-question-format.md (the 4-row table for
   Phase 1). Apply the DDD techniques (challenge against glossary, sharpen
   fuzzy language, discuss concrete scenarios, cross-reference with code,
   offer ADRs sparingly).
3. **Term Resolution** (references/term-resolution.md): after each resolved
   branch that introduces a glossary term, propose the term and definition,
   and on acceptance write it to `GLOSSARY.md` (lazily created if needed).

Phase 1 may end here: if the user only wanted terminology/concept
alignment, proceed to the Exit gate and offer "document the decision."

### Gate B: Concept-readiness (anti-skip)

Before opening **any** Phase 2 implementation branch, the skill must
confirm concept readiness. Concept is ready when **either**:
- Phase 1 concept alignment completed in this session (a concept/goal
  record exists and the user has not indicated the concept is still open),
  **or**
- A supplied spec/PRD already covers the concept (confirmed in Gate A).

If the user asks an implementation-shaped question ("which framework?",
"what language?") with **no spec and no concept record**, the skill must
**redirect to Phase 1** and must not open implementation branches.

**Gate B is a blocking turn.** Emit a one-line readiness statement and
obtain explicit user confirmation (or a Phase 1 redirect) before any Phase
2 branch. The convergence test treats "implementation branch opened
without concept readiness" as a violation.

### Phase 2: Implementation planning

Follow the implementation-planning workflow:

1. **Foundation Establishment** (mandatory): resolve Language, Framework,
   Key Dependencies, Project Structure, Sub-projects, Project Type in
   rounds of up to 3 using the 1-turn wrapper with the 5-row context block
   (Goal, Prior decisions, Scope, Spec section). Optional foundational
   preferences step.
2. **Spec-Driven Technical Extraction**: identify TDPs from the spec/ledger
   (or from Phase 1 outcomes), surface them in dependency-ordered rounds
   of at most 3, resolve with the 1-turn wrapper. Never use "TDP" with the
   user; branch titles use the `Txxx` ID.
3. **Interface & Model Branch** (optional): load
   references/interface-and-model-branch.md before asking.
4. **Output Selection** (required): load references/output-selection.md;
   ask the user to choose Implementation Blueprint vs PRD Augmentation and
   the downstream consumer. Do not produce the plan in this step.
5. **Consolidated Implementation Plan**: produce the plan in the chosen
   format, grouped by file, citing `Dxxx`/`Txxx`.

### Convergence

After the last branch in a round, run the 5-check convergence test from
../`grilling`/references/convergence-test.md. If any check fails, continue
or re-open the affected branch. When all five pass, offer close-out; the
user decides.

### Exit gate

Before listing exits, ask: "Will resolving this require writing code?"
with Yes / No / I'm not sure (skip if unambiguous). Every exit that drives
downstream work includes the Decision Ledger path so downstream skills can
cite records as filename#`Dxxx`/`Txxx`:

| Path | Drives downstream work? | Ledger path required? |
|------|------------------------|------------------------|
| Hand off to `spec-to-tickets` | Yes | Yes |
| Handoff to another agent | Yes | Yes |
| Custom Save | No | No |

### Post-session deletion reminder

The Decision Ledger is **persisted by default**. After the chosen exit,
remind the user in one short turn that it remains on disk and can be
deleted once implementation is complete. Suppress the reminder when the
exit hands off to `spec-to-tickets`.

## References

### Parent `grilling` references (../`grilling`/references/*) - eager
- decision-ledger.md, options-format.md, recommendation-format.md,
  locked-question-format.md, tone-and-output.md, convergence-test.md.

### Skill-local references (references/*)
- ddd-initialization.md - eager
- term-resolution.md - eager
- ADR-FORMAT.md - eager
- locked-question-format.md - eager (5-row code-impl variant)
- recording-decisions.md - eager
- interface-and-model-branch.md - lazy
- output-selection.md - lazy
- validation.md - lazy
- terminal-output.md - lazy

## Validation

After completing the workflow, verify each item against the session
transcript:

### Pre-conditions
- [ ] All reference files (base 6 + local 9) were loaded and read in full
      before the first user question; no lazy reference was loaded
      speculatively.
- [ ] If any reference file was missing or unreadable, the session aborted
      and the missing file was reported.

### Gate A (spec/ledger intake)
- [ ] Existing Decision Ledger and/or supplied spec/PRD were detected
      before any branch opened.
- [ ] Settled decisions from the supplied artifact were summarized to the
      user.
- [ ] Each settled item was confirmed locked via the Step 4.0a question;
      none were assumed binding.
- [ ] Settled decisions were recorded as `Dxxx`/`Txxx` with Resolved Answer
      = "Resolved (by provided spec)" and were **not** re-grilled.
- [ ] Branches were opened only for items the user confirmed still open.

### Gate B (concept-readiness)
- [ ] Before the first Phase 2 implementation branch, concept readiness
      was confirmed (Phase 1 done in-session OR supplied spec covers
      concept).
- [ ] Gate B was a blocking turn with explicit user confirmation; no
      implementation branch opened without concept readiness.
- [ ] If the user asked an implementation question with no spec and no
      concept record, the skill redirected to Phase 1.

### Output checks
- [ ] Decision Ledger path was confirmed before the first write.
- [ ] Goal-discovery question was asked; response recorded as goal record.
- [ ] One Decision Ledger record appended immediately after every resolved
      branch (no batching). Multi-pick rounds wrote all records in one call.
- [ ] Every record used a fresh `Dxxx`/`Txxx` ID and the inline template.
- [ ] Phase 1 used the 4-row context table; Phase 2 used the 5-row context
      table (with Spec section).
- [ ] Term Resolution ran as a post-pick step; glossary terms proposed
      before writing to GLOSSARY.md.
- [ ] TDPs grouped into rounds of at most 3; no round surfaced more than 3
      branches; branch titles used `Txxx`, never "TDP".
- [ ] Conflict detection ran before each branch resolution.
- [ ] Convergence was a per-round check; close-out offered, user decided.
- [ ] Output-selection question asked; format + consumer recorded before
      the Consolidated Implementation Plan was produced.
- [ ] Consolidated Implementation Plan produced at endpoint in chosen
      format, grouped by file, citing `Dxxx`/`Txxx`.
- [ ] Exit gate asked; chosen exit handed off with Decision Ledger path.
- [ ] Every citation used filename#`Dxxx`/`Txxx` format.
- [ ] Post-session deletion reminder emitted (suppressed for
      `spec-to-tickets` handoff).
