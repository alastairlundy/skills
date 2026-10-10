# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a
technical-grilling question, and here is the branch it belongs to."

This format applies to every per-decision branch in every phase,
whether the branch records a `Dxxx` decision or a `Txxx` decision.
The branch heading and the Decision row (the WHAT context) are
mandatory for both streams. Where a template below shows `[Dxxx/Txxx]`,
use the current branch's own ID and stream.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**, not
the LLM. The locked question line, the conflict callout, and any other
user-facing template in this reference are addressed to the user. Emit
them verbatim and wait for the user to respond before proceeding.
Free-form instructions to the agent in this reference use "the LLM" or
"the agent" to refer to the agent.

## The wrapper

Every locked question uses a fixed wrapper emitted **once per round**,
regardless of how many branches are inside the round. The wrapper is
a single agent turn - there is no inter-turn wait between components.

The fixed order is:

1. **Round header** - identifies the round number.
2. **Frontier statement** - how many branches remain total, how many
   are unblocked this round.
3. **Per-branch block** (repeated 1–3 times, once per unblocked branch
   in this round):
   1. **Branch heading** - the `Dxxx`/`Txxx` ID and verbatim branch label
      plus a one-sentence open point.
   2. **Context block** - the header + 5-data-row table grounding
      the branch.
   3. **Conflict/contradiction callout** (conditional) - only when a
      conflict or contradiction is detected.
   4. **Locked question line** - the fixed `For Dxxx`/`Txxx` line naming
      the branch.
   5. **Options table** - the 4-column reference set (per
      `references/options-format.md`).
   6. **Recommendation** - the 2-line lean block (per
      `references/recommendation-format.md`).

The round header, frontier statement, and at least one per-branch block are
always present. The conflict/contradiction callout within each
per-branch block is conditional on conflict detection. Every other
per-branch element is mandatory.

### Component 1 - Round header

```md
### Round [N]
```

`[N]` is the round number starting at 1. The header is always present.

### Component 2 - Frontier statement

```md
[N] branches remain, [M] unblocked this round.
```

`[N]` is the total number of unresolved branches across all rounds.
`[M]` is the number surfaced in this round (at most 3). If `[M]` equals
`[N]`, the frontier statement is still emitted.

### Component 3 - Branch heading

Every per-branch block opens with a branch heading, emitted before
the context block. The heading states what this branch is deciding
in plain language, so the context table never has to carry that
load alone.

```md
#### [Dxxx/Txxx] – <branch label verbatim>
<one sentence - the open point: what is being decided and why it matters now>
```

- `[Dxxx/Txxx]` is the current branch ID from its own stream
  (`Dxxx` for design branches, `Txxx` for technical branches);
  `<branch label>` is the branch name verbatim - the same string used in the Decision row and the
  locked question line. Do not rephrase, abbreviate, or rename
  mid-session.
- The open-point sentence states the unresolved variable and the
  blocker (what cannot proceed without this decision). It carries no
  required citation format; ledger or spec citations are permitted
  but not required here.
- Exactly one sentence. The heading is the scannable anchor; the
  Decision row below it is the testable statement.

### Component 4 - Context block

The context block is a **markdown table with a header row and
5 data rows in fixed order**. Each data row's Content is exactly one
sentence drawn from the Decision Ledger, the user's stated goal, and
the spec. Cite Dxxx/Txxx IDs in the Decision, Goal, and Prior
decisions rows.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Decision**     | <one sentence - the current branch as `[Dxxx/Txxx] – <verbatim label>`: the open variable as whether/which/how plus what blocks without it> |
| **Goal**         | <one sentence - the goal of the overall decision, citing the goal record as `filename#Dxxx`>             |
| **Prior decisions** | <one sentence - the prior decisions affecting this branch, with path-qualified `filename#Dxxx` citations> |
| **Scope**        | <one sentence - what is in and out of scope for this branch>               |
| **Spec section** | <one sentence - the spec file path and the specific section or functional requirement, cited inline> |

Each data row's Content is exactly one sentence drawn from the
Decision Ledger, the user's stated goal, and the spec. Cite
Dxxx/Txxx IDs in the Decision, Goal, and Prior decisions rows. The Spec
section row must include the inline citation in the form
<spec-file-path> §<section>, or the explicit no-spec form below.

### The Decision element

The Decision row is **required for every per-decision
context block**, without exception. It answers "what is this branch
deciding" without forcing the reader to reconstruct it from Goal,
Scope, or the options table.

- Cite the current branch ID in its own stream and use the branch label verbatim:
  `[Dxxx/Txxx] – <label>`, matching the branch heading and the locked
  question line exactly.
- State the open variable as whether / which / how, plus the
  blocker: what cannot proceed (or what silently defaults) without
  this decision.
- One sentence. Do not restate the session Goal here: Goal is the
  overall purpose, Decision is this branch's choice.

### Citation integrity (Prior decisions row)

- Every `filename#Dxxx` / `filename#Txxx` citation in the Prior
  decisions row must correspond to a claim stated in that same
  sentence, and every claim about a prior decision in that sentence
  must carry its citation.
- Cited IDs must match the claimed records. Citing `#T011` twice to
  cover a T011 claim and a T012 claim is a violation; each claim
  cites its own record, in whichever stream (`Dxxx` or `Txxx`) the
  prior record lives in.
- When no prior records exist, write the explicit empty form naming
  the next slot in the current branch's own stream (e.g. `No prior
  Dxxx/Txxx records yet (D001 is the next slot).` for a `Dxxx`
  branch, `No prior Dxxx/Txxx records yet (T001 is the next slot).`
  for a `Txxx` branch). Do not leave
  the row blank and do not cite a future record.

### The Spec section element

The Spec section is **required for every per-decision
context block**, without exception. It is not optional and the agent
must not drop it.

The citation format is fixed: the spec file path plus the section or
functional requirement, in the form <spec-file-path> §<section>
(e.g., specs/feature-x.md §3.2). The agent must use the actual spec
file path and the actual section or requirement number.

When no separate spec file exists, use the explicit no-spec form in
the same row (still one sentence): `No separate spec; grounded in
<goal-record citation or named goal area>.` A Decision Ledger file
(`docs/decisions/DECISIONS-*.md`) is never a spec path: never cite a
ledger file with `§Dxxx` / `§Txxx` in the Spec section row. Ledger citations
belong in the Decision, Goal, and Prior decisions rows only.

The context block is **not** a free-form prose summary, a "current
state of the type" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis. If the agent has done a code
reading or an investigation, that work belongs in the agent's
reasoning, not in the user-facing context block. If the agent wants
to surface that information to the user, paraphrase it into one of
the five elements (typically **Scope**) or present it as a separate
explicit step *before* the context block with its own heading - never
in place of the table.

### Component 5 - Conflict/contradiction callout (conditional)

Only emitted when conflict detection fires before the branch
resolves. The callout appears between the context block and the options
table.

**Static conflict** (two records with mutually-exclusive Normalized
Requirements):

```md
> **Conflict detected.** [filename#Dxxx] and [filename#Dyyy] have contradictory
> Normalized Requirements: "<quote from filename#Dxxx>" vs. "<quote from filename#Dyyy>".
> Which resolution stands?
```

**Dynamic contradiction** (new resolution contradicts a prior
resolution):

```md
> **Contradiction detected.** Your answer for [filename#Dxxx] contradicts [filename#Dyyy]
> ("<brief quote of Resolved Answer>"). Would you like to confirm
> your new answer, revise it, or re-open the prior branch?
```

The callout is a fixed-format notification, not an open-ended question.

### Component 6 - Locked question line

Every per-branch block carries the locked question line between the
conflict callout (when present) and the options-table preamble:

```md
**For [Dxxx/Txxx] – <branch label verbatim>: pick an option, hybridize, or provide
your own answer.**
```

- `[Dxxx/Txxx]` and `<branch label>` match the branch heading and the
  Decision row exactly.
- Emit the line verbatim in form; only the ID and label vary.

### Component 7 - Options table

Present the 4-column options table from `references/options-format.md`,
preceded by the reference-set preamble:

```md
Here are options to help you refine or confirm your answer. Pick one, hybridize,
or reject all.
```

The options table is the reference set the user picks from. See
`references/options-format.md` for the table shape, cell caps, and
defensible-options guidance.

### Component 8 - Recommendation

Present the 2-line lean recommendation block from
`references/recommendation-format.md` below the options table. See
that reference for the exact format (option letter + period, reasoning
sentence).

## Re-ask mechanic and explicit deferral

There is no limit on re-asks. When the user's response to a branch is
unclear, incomplete, or evasive, the agent re-emits the branch in the
same 1-turn wrapper format (without the "final" preamble) and waits:

```md
> **Re-ask.** Your answer for [branch name] didn't settle [the open
> point]. Please clarify, confirm, or revise your answer on
> [branch name].
```

The branch stays open until the user resolves it. The branch closes
with `Resolved Answer = "DEFERRED"` **only** when the user explicitly
defers it (per `references/decision-ledger.md`, DEFERRED closure):
the user's response names the deferral, and the DEFERRED record's
`Constraints` line records that deferral verbatim plus the fallback
default. Silence, an unrelated answer, or a repeated non-answer never
auto-closes a branch; it stays open and the convergence test keeps it
on the surface.

It uses the identical wrapper format as the initial branch emission.

## Rules

- **Use the same `Dxxx`/`Txxx` ID and branch label verbatim in the heading,
  the Decision row, and the locked question line for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
  `filename#Dxxx` / `filename#Txxx` citations in Goal and Prior decisions rows use the
  ledger filename plus ID; the branch's own ID in Decision matches
  the heading ID.
- **Up to 3 branches per round.** Emit 1–3 complete branch blocks
  (each with branch heading, context block, conflict callout if any,
  locked question line, options table, and recommendation) in a
  single turn, then stop and wait for the user's response. Each branch
  block is self-contained. Do not emit more than 3 branches in one
  round. Do not mix unrelated decisions in one branch emission - each
  branch in a round must be an unblocked branch from the same decision
  tree.
- **Complete block per branch - hard stop.** Each branch's block
  (branch heading through recommendation) must be emitted in full,
  not split across turns. The agent must not emit a heading and
  context block in one turn and the options table in the next.
- **The branch heading and context block are mandatory for every
  branch.** Do not skip them, even when the prior decisions are few
  or the scope seems obvious.
- **All three response types in the locked question line are equally
  valid.** The agent must not default to a closed-ended "pick one"
  framing and must not treat the line as demanding a specific answer
  format.
- **Do not replace the heading or context block with a free-form prose
  summary, a code reading, or an investigation.** The heading is the
  `#### Dxxx/Txxx` line plus one open-point sentence; the context block is
  the header + 5-data-row table above, in order, each element one
  sentence, each filled in from the Decision Ledger, the user's stated
  goal, and the spec.
- **Conflict callouts are fixed-format.** Use the exact "Conflict
  detected" or "Contradiction detected" wording. Do not paraphrase
  or extend the callout with open-ended questions.
- **Header + 5 data rows, in order, each one sentence.** The context
  block rows are Decision, Goal, Prior decisions, Scope, Spec section,
  each exactly one sentence, each filled in from the Decision Ledger,
  the user's stated goal, and the spec. Cite Dxxx/Txxx IDs in the
  Decision, Goal, and Prior decisions rows.
- **The Decision row is required, not optional.** Every per-decision
  context block states the current branch ID, verbatim label, open
  variable, and blocker.
- **Prior-decision citations must match their claims.** Every cited
  `filename#Dxxx` / `filename#Txxx` corresponds to a claim in the same
  sentence; every prior-decision claim carries its own citation.
- **The Spec section is required, not optional.** Every per-decision
  context block includes Spec section.
- **The Spec section citation format is fixed.** The inline citation
  is <spec-file-path> §<section> when a spec exists, or the explicit
  `No separate spec; grounded in ...` form when none exists. A ledger
  file is never a spec path.

## Worked example - round with 2 branches

`Txxx` IDs below are the current branch's own stream; a `Dxxx`
branch uses the identical shape with its own `Dxxx` ID.

```md
### Round 1

3 branches remain, 2 unblocked this round.

#### T001 – primary language
This branch decides which primary language the freelancing platform is built on, which blocks framework and ORM selection.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Decision**     | T001 – primary language: decide whether the platform builds on C# or TypeScript, which blocks framework choice. |
| **Goal**         | Pick the primary language for the freelancing platform (DECISIONS-demo.md#D001). |
| **Prior decisions** | No prior Dxxx/Txxx records yet (T001 is the next slot).                       |
| **Scope**        | This decision covers the primary language only; not the framework.          |
| **Spec section** | Language required by specs/freelancing-platform.md §2.1 to support sealed class hierarchies. |

**For T001 – primary language: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost |
|--------|-----------|---------|------|
| **A - C# with .NET 8** | Platform built on C# 12 with .NET 8 LTS. | Sealed hierarchies supported natively. | Team needs .NET expertise. |
| B - TypeScript with Node.js 20 | Platform built on TypeScript 5 with Node.js 20 LTS. | Same language front and back end. | Structural typing needs runtime guard for sealed. |

**Recommendation: A.**
**Reasoning:** C# natively supports sealed class hierarchies, which
aligns with your goal of a testable domain model (D001).

<user picks A>

Resolved: C# with .NET 8.

#### T002 – ORM
This branch decides which ORM the freelancing platform uses, which blocks repository implementation.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Decision**     | T002 – ORM: decide which ORM persists the domain model, which blocks repository implementation. |
| **Goal**         | Pick the ORM for the freelancing platform (DECISIONS-demo.md#D001).                          |
| **Prior decisions** | DECISIONS-demo.md#T001 established C# with .NET 8.                                         |
| **Scope**        | This decision covers the ORM only; not the database provider.              |
| **Spec section** | ORM required by specs/freelancing-platform.md §3.1 for fluent LINQ queries. |

**For T002 – ORM: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost |
|--------|-----------|---------|------|
| **A — EF Core** | Microsoft's ORM for .NET, built into the framework. | First-party support; LINQ integration. | Migrations can be fragile for complex schemas. |
| B — Dapper | Lightweight micro-ORM with raw SQL control. | Full SQL control; minimal overhead. | No built-in migration tooling. |

**Recommendation: Option A - EF Core.**
**Reasoning:** EF Core's LINQ integration aligns with your goal of a testable domain model (D001) by keeping queries in managed code.
```