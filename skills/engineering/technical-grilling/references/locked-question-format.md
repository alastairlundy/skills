# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a
technical-grilling question, and here is the branch it belongs to."

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
   1. **Context block** - the 5-row table grounding the branch.
   2. **Conflict/contradiction callout** (conditional) - only when a
      conflict or contradiction is detected.
   3. **Options table** - the 4-column reference set (per
      `references/options-format.md`).
   4. **Recommendation** - the 2-line lean block (per
      `references/recommendation-format.md`).

The round header, frontier statement, and at least one per-branch block are
always present. The conflict/contradiction callout within each
per-branch block is conditional on conflict detection.

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

### Component 3 - Context block

The context block is a **5-row markdown table** with a header row and
4 data rows in fixed order. Each data row's Content is exactly one
sentence drawn from the Decision Ledger, the user's stated goal, and
the spec. Cite Dxxx/Txxx IDs in the Goal and Prior decisions rows.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | <one sentence - the goal of the overall decision, citing the goal record as `filename#Dxxx`>             |
| **Prior decisions** | <one sentence - the prior decisions affecting this branch, with path-qualified `filename#Dxxx` citations> |
| **Scope**        | <one sentence - what is in and out of scope for this branch>               |
| **Spec section** | <one sentence - the spec file path and the specific section or functional requirement, cited inline> |

Each data row's Content is exactly one sentence drawn from the
Decision Ledger, the user's stated goal, and the spec. Cite
Dxxx/Txxx IDs in the Goal and Prior decisions rows. The Spec
section row must include the inline citation in the form
<spec-file-path> §<section>.

### The Spec section element

The Spec section is **required for every per-decision
context block**, without exception. It is not optional and the agent
must not drop it.

The citation format is fixed: the spec file path plus the section or
functional requirement, in the form <spec-file-path> §<section>
(e.g., specs/feature-x.md §3.2). The agent must use the actual spec
file path and the actual section or requirement number.

The context block is **not** a free-form prose summary, a "current
state of the type" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis. If the agent has done a code
reading or an investigation, that work belongs in the agent's
reasoning, not in the user-facing context block. If the agent wants
to surface that information to the user, paraphrase it into one of
the four elements (typically **Scope**) or present it as a separate
explicit step *before* the context block with its own heading - never
in place of the table.

### Component 4 - Conflict/contradiction callout (conditional)

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

### Component 5 - Options table

Present the 4-column options table from `references/options-format.md`,
preceded by the reference-set preamble:

```md
Here are options to help you refine or confirm your answer. Pick one, hybridize,
or reject all.
```

The options table is the reference set the user picks from. See
`references/options-format.md` for the table shape, cell caps, and
defensible-options guidance.

### Component 6 - Recommendation

Present the 2-line lean recommendation block from
`references/recommendation-format.md` below the options table. See
that reference for the exact format (option letter + period, reasoning
sentence).

## Re-ask mechanic

Each branch may be re-asked at most once. The re-ask uses the same
1-turn wrapper format with a fixed preamble:

```md
> **Final re-ask.** No answer was provided for [branch name]. This is your last chance to clarify, confirm, or
> revise your answer on [branch name]. If no clear answer is provided,
> the branch will close without resolution.
```

The preamble is emitted before the context block. After 1 re-ask with
no clear answer, the branch closes with `Resolved Answer = "DEFERRED"`
and a `Constraints` line noting why. The same `filename#Dxxx` record is
updated; no new record is created for the re-ask itself.

It uses the identical wrapper format as the initial branch emission.

## Rules

- **Use the same `filename#Dxxx` and name verbatim in every question for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
- **Up to 3 branches per round.** Emit 1–3 complete branch wrappers
  (each with context block, conflict callout if any, options table,
  and recommendation) in a single turn, then stop and wait for the
  user's response. Each branch wrapper is self-contained. Do not
  emit more than 3 branches in one round. Do not mix unrelated
  decisions in one branch emission - each branch in a round must be
  an unblocked branch from the same decision tree.
- **Complete wrapper per branch - hard stop.** Each branch's wrapper
  (context block through recommendation) must be emitted in full,
  not split across turns. The agent must not emit a context block
  in one turn and the options table in the next.
- **The context block is mandatory for every branch.** Do not skip it,
  even when the prior decisions are few or the scope seems obvious.
- **All three response types in the locked question line are equally
  valid.** The agent must not default to a closed-ended "pick one"
  framing and must not treat the line as demanding a specific answer
  format.
- **Do not replace the context block with a free-form prose summary,
  a code reading, or an investigation.** The context block is the
  5-row table above, in order, each element one sentence, each
  filled in from the Decision Ledger, the user's stated goal, and
  the spec.
- **Conflict callouts are fixed-format.** Use the exact "Conflict
  detected" or "Contradiction detected" wording. Do not paraphrase
  or extend the callout with open-ended questions.
- **Five rows, in order, each one sentence.** The context block is the
  5-row table above, in order, each element one sentence, each filled
  in from the Decision Ledger, the user's stated goal, and the spec.
- **The Spec section is required, not optional.** Every per-decision
  context block includes Spec section.
- **The Spec section citation format is fixed.** The inline citation
  is <spec-file-path> §<section>.

## Worked example - round with 2 branches

```md
### Round 1

3 branches remain, 2 unblocked this round.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | Pick the primary language for the freelancing platform (D001).              |
| **Prior decisions** | No prior Txxx records yet (T001 is the next slot).                       |
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

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | Pick the ORM for the freelancing platform (D001).                          |
| **Prior decisions** | T001 established C# with .NET 8.                                         |
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
