---
name: architecture-survey
description: >-
  Surveys a codebase for deepening opportunities and delivers them as a visual HTML report, then grills the chosen candidate through to a decision. Use when a user asks to improve codebase architecture, find refactoring or module-deepening candidates, review how module design has degraded, or run a periodic architecture survey on an actively changing codebase. Defer building the chosen refactor to technical-grilling and spec-to-tickets; defer third-party dependency health to dependency-review.
license: MIT
---

# Architecture Survey

Surface architectural friction and propose **deepening opportunities**: refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability. The survey finds and ranks candidates. Building them is a separate job.

Everything uses the shared design vocabulary (module, interface, depth, seam, adapter, leverage, locality) in `references/design-vocabulary.md`. `GLOSSARY.md` names the domain. `docs/adr/` holds settled cross-cutting architecture decisions; `docs/decisions/` ledgers hold session decisions, including past rejections of survey candidates. The survey reads both and re-litigates neither.

## When to Use

- A user asks to find architectural friction or deepening opportunities in a codebase
- A user asks which modules are too shallow, hard to test, or hard to navigate
- A user asks for an architecture review or survey report, or wants one on a schedule (every few days fits active repos)
- A user names a module or subsystem and asks whether its interface should be deeper
- A user asks what changed architecturally since the last survey
- An agent needs a ranked list of refactoring candidates before planning a larger change
- When user input would clarify the request, invoke `ask-questions`

## When Not to Use

- The user wants a chosen refactor built now. Hand the decision to `technical-grilling`, then `spec-to-tickets` or direct implementation.
- The question is about third-party packages rather than internal module design. Use `dependency-review`.
- The target is not source code (docs, skill definitions, content repos). There are no modules to deepen.
- The review covers a single diff or PR. Review the diff; a whole-codebase survey answers a different question.

## Workflow

Six steps. Load `references/design-vocabulary.md` before Step 2 and `references/html-report.md` before Step 5.

### Step 1 - Select scope

1. If the user named a direction (module, subsystem, pain point), record it as the scope and go to Step 2.
2. Otherwise run `git log --oneline -n 200` and count how often each file path appears. Take the 3-5 paths with the most churn as the scope. A deepening pays back only where code keeps changing.
3. If history has fewer than 30 commits or churn is flat, widen the scope to the repo's source roots (`src/`, `app/`, `lib/`, or language equivalents) and say so in the report header.

### Step 2 - Load context

1. Read `GLOSSARY.md` at the repo root when it exists; when it does not, note that and continue.
2. List `docs/adr/` and read every ADR that overlaps the scope.
3. List `docs/decisions/` and scan the `DECISIONS-*.md` ledgers for `Dxxx` or `Txxx` records that rejected earlier survey candidates in the scope.
4. Read `references/design-vocabulary.md`. Every later artifact uses its terms exactly.

### Step 3 - Explore for friction

Spawn one subagent to walk the scope. Give it the probe list below verbatim. Each candidate it returns records: **Files**, the probe ids that fired, **Evidence** (paths plus what the code shows), **Proposed change**, and the **deletion test** answer, either "complexity concentrates here" or "complexity just moves".

Probes:

- **P1 Concept bouncing** - does understanding one concept require tracing through 3 or more modules?
- **P2 Shallowness** - is the interface nearly as complex as the implementation, counting exported surface, parameters, and the invariants a caller must know?
- **P3 Locality theft** - are pure functions extracted in the name of testability while the bugs live in how callers orchestrate them?
- **P4 Seam leakage** - does private knowledge of one module, such as its types, ordering, or configuration, leak into callers across the interface?
- **P5 Test surface** - is the area untested, or testable only by driving a public entry point because the interface is the wrong shape?

Filter and rank:

1. Keep candidates where at least one probe fired and the deletion test answers "complexity concentrates here".
2. Rank by churn: candidates inside the Step 1 hot spots outrank the rest.
3. Fewer than 3 candidates: widen the scope one directory level and re-run. More than 7: keep the top 7.

### Step 4 - Screen against settled decisions

1. Compare each candidate against the ADRs from Step 2. An ADR that settles the question drops the candidate, unless Step 3 evidence shows the friction the ADR was written against has recurred; keep such a candidate with a "contradicts ADR-NNNN" callout.
2. Compare each candidate against the Step 2 ledger rejections. A candidate a `Dxxx`/`Txxx` record already rejected is dropped, cited in the form `filename#Dxxx`. Revive it only when the user explicitly asks to re-open that decision.
3. Collect the dropped candidates with their ADR or ledger references for the report's not-proposed footer.

### Step 5 - Write and present the report

1. Follow `references/html-report.md` for the scaffold, cards, diagram patterns, and tone.
2. Resolve the temp directory from `$TMPDIR`, `%TEMP%` on Windows, or `/tmp`, and write `architecture-survey-<repo>-<YYYYMMDD-HHMM>.html`. Nothing lands in the repo.
3. Give every candidate a card with Files, Problem, Solution, Wins, a before/after diagram, and a strength badge (`Strong`, `Worth exploring`, `Speculative`). End with a Top recommendation section naming the candidate to tackle first and why.
4. Open the file for the user (`start <path>` on Windows, `open <path>` on macOS, `xdg-open <path>` on Linux) and state the absolute path.
5. Ask which candidate the user wants to explore. Do not propose replacement interfaces before the user picks.

### Step 6 - Grill the chosen candidate

1. Invoke the `technical-grilling` skill on the picked candidate: constraints, dependencies, the shape of the deepened module, what sits behind the seam, which tests survive.
2. Keep the domain model current as decisions crystallize:
   - A concept named that `GLOSSARY.md` lacks: add the term. Create `GLOSSARY.md` when the repo has none.
   - A fuzzy term sharpened in conversation: update `GLOSSARY.md` in place.
   - The user rejects a candidate for a load-bearing reason: make sure `technical-grilling` records the rejection in its Decision Ledger (`docs/decisions/DECISIONS-<repo>-<slug>.md`, created lazily). Step 4 of future surveys screens candidates against that record. A rejection never earns an ADR. An ADR records a cross-cutting architecture decision that meets `technical-grilling`'s criteria, and that skill owns the offer.
   - The user wants alternative interfaces for the deepened module: run the design-it-twice pattern in `references/design-vocabulary.md`.

## Output Mode

The default artifact is one self-contained HTML file in the OS temp directory plus its absolute path in the conversation; the in-conversation summary is a 3-5 line pointer list of candidates, not a prose dump. Steps 1-5 write nothing into the repo. Writes to `GLOSSARY.md` and `docs/decisions/` happen only in Step 6, each with the user's agreement in the moment. ADR writes follow `technical-grilling`'s own criteria.

## Validation

- [ ] Scope was recorded before code was scanned: user-named direction, or a churn path list from `git log`
- [ ] `GLOSSARY.md`, `docs/adr/`, and `docs/decisions/` were read when present; absence noted, not invented
- [ ] Every candidate names at least one fired probe (P1-P5), cites file evidence, and passes the deletion test
- [ ] Candidate count is 3-7 after filtering and re-run
- [ ] ADR contradictions carry a callout or a drop; ledger rejections drop the candidate with a `filename#Dxxx` citation; every dropped candidate appears in the not-proposed footer
- [ ] The report is a self-contained HTML file in the temp directory, named `architecture-survey-<repo>-<timestamp>.html`, opened for the user with its absolute path stated
- [ ] Every card has Files, Problem, Solution, Wins, a before/after diagram, and a strength badge; the report ends with a Top recommendation section
- [ ] Output uses the vocabulary exactly: module, interface, depth, seam, adapter, leverage, locality; component, service, API, and boundary never substitute
- [ ] No interface proposal was made before the user picked a candidate
- [ ] The picked candidate was handed to `technical-grilling`; glossary and ledger writes happened only in Step 6 with agreement; no ADR was offered for a candidate rejection

## Transitions

- **Before**: `technical-grilling` sharpens the domain concepts this survey names; a glossary it keeps current makes later surveys more precise.
- **After**: a resolved deepening design becomes tickets via `spec-to-tickets`, or one focused refactor via `technical-grilling` into implementation.
- **Adjacent**: `dependency-review` audits third-party packages; this skill audits internal module structure.

## Attribution

Adapted from the `improve-codebase-architecture` skill in the [`mattpocock/skills`](https://github.com/mattpocock/skills) repository, licensed under MIT by Matt Pocock and Contributors. The report format derives from that repo's `HTML-REPORT.md` and the vocabulary from its `codebase-design` skill. This fork rewires the skill for this repository: `CONTEXT.md` becomes `GLOSSARY.md`, the `grilling` and `domain-modeling` calls become `technical-grilling`, candidate rejections route to the Decision Ledger instead of an ADR offer, the `codebase-design` dependency becomes a self-contained `references/design-vocabulary.md` (per ADR 0004), and the process steps are deterministic.
