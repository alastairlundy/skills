# Locked Question Format (Code-Implementation Variant)

The code-implementation-grilling skill extends the parent grilling
skill's parent 4-row context table with a 4th data row: **Spec section**.
This makes the code-impl context block a 5-row table (1 header + 4
data rows) instead of the parent's 4-row table.

The 1-turn wrapper order (round header, frontier statement, context
block, conflict callout, options table, recommendation) is inherited
from the parent grilling skill. See
../grilling/references/locked-question-format.md for the full
wrapper. This file documents the code-impl context block delta only.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**,
not the LLM. The locked question line, the conflict callout, and any
other user-facing template in this reference are addressed to the user.
Emit them verbatim and wait for the user to respond before proceeding.
Free-form instructions to this reference use "the LLM" or "the agent"
to refer to the agent.

## The 5-row code-impl context block

The context block is a **5-row markdown table** with a header row and
4 data rows in fixed order. The first 3 data rows match the parent's
context block. The 4th data row is the code-impl addition.

| Element          | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| **Goal**         | <one sentence — the goal of the overall decision, citing D001>             |
| **Prior decisions** | <one sentence — the prior decisions affecting this branch, with citations> |
| **Scope**        | <one sentence — what is in and out of scope for this branch>               |
| **Spec section** | <one sentence — the spec file path and the specific section or functional requirement, cited inline> |

Each data row's Content is exactly one sentence drawn from the
Decision Ledger, the user's stated goal, and the spec. Cite
Dxxx/Txxx IDs in the Goal and Prior decisions rows. The Spec
section row must include the inline citation in the form
<spec-file-path> §<section>.

### The Spec section element

The Spec section is **required for every code-impl per-decision
context block**, without exception. It is not optional and the agent
must not drop it.

The citation format is fixed: the spec file path plus the section or
functional requirement, in the form <spec-file-path> §<section>
(e.g., specs/feature-x.md §3.2). The agent must use the actual spec
file path and the actual section or requirement number.

## Re-ask mechanic

The re-ask mechanic is inherited from the parent: max 1 re-ask, fixed
preamble, DEFERRED closure. The re-ask uses the same 1-turn wrapper
with the 5-row context block. The re-ask must not re-introduce the
Socratic elicitation turn.

## Worked example

A foundation item (Language) presented in the 5-row code-impl format:

```md
### Round 1

4 branches remain, 1 unblocked this round.

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

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — C# with .NET 8** | Platform built on C# 12 with .NET 8 LTS. | Sealed hierarchies supported natively. | Team needs .NET expertise. | Future contributor uses reflection breaking seals. |
| B — TypeScript with Node.js 20 | Platform built on TypeScript 5 with Node.js 20 LTS. | Same language front and back end. | Structural typing needs runtime guard for sealed. | Type assertion bypasses seal at runtime. |

**Recommendation: A.**
**Reasoning:** C# natively supports sealed class hierarchies, which
aligns with your goal of a testable domain model (D001).
```

## Rules

- **Five rows, in order, each one sentence.** The context block is the
  5-row table above, in order, each element one sentence, each filled
  in from the Decision Ledger, the user's stated goal, and the spec.
- **The Spec section is required, not optional.** Every code-impl
  per-decision context block includes Spec section.
- **The Spec section citation format is fixed.** The inline citation
  is <spec-file-path> §<section>.
- **The first 3 rows stay aligned with the parent.** Goal, Prior
  decisions, Scope are the parent's 3 rows unchanged.
- **Use the same Dxxx/Txxx and name verbatim in every question for
  that branch.** Do not rephrase or rename mid-session.
- **Do not replace the context block with a free-form prose summary,
  a code reading, or an investigation.**