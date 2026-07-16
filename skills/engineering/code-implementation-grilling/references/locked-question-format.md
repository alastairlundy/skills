# Locked Question Format (Code-Implementation Variant)

The code-implementation-grilling skill uses a 5-element context block
on every per-decision question (foundation items in Step 4, TDPs in
Step 5.3, Interface & Model Branch decisions in Step 6, and any other
per-decision question emitted by the workflow). The first four
elements are the parent grilling skill's 4-element context block
unchanged. The 5th element is the **Spec section** — a one-sentence
spec citation that names the spec file path and the specific section
or functional requirement the branch addresses.

The 2-turn sequence (Turn 1 = context block + optional Socratic
elicitation question; Turn 2 = locked question line + options +
recommendation), the Socratic question wording (D003), the locked
question line wording (D004), the engage and decline behaviors, the
options format, the recommendation format, the tone discipline, and
the convergence test are all inherited from the parent grilling
skill. See `../grilling/references/locked-question-format.md` for the
full format. This file documents the 5-element code-impl delta only.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**,
not the LLM. The Socratic elicitation question, the locked question
line, and any other user-facing template in this reference are
addressed to the user. Emit them verbatim and wait for the user to
respond before proceeding. Free-form instructions to this reference
use "the LLM" or "the agent" to refer to the agent.

## The 5-element code-impl context block

Before the Socratic elicitation question on every per-decision
question, present a fixed context block with **exactly five
elements**, in the order shown below. Each element is **exactly one
sentence**. No element may be omitted. The first four elements match
the parent grilling skill's 4-element context block (Goal, Prior
decisions, Stakes, Scope) in name, order, and shape. The 5th element
— **Spec section** — is the code-impl addition.

The context block is a **structured bullet list with exactly five
items, in the order shown below**. It is the *only* content the agent
emits between the prior turn's resolution and the Socratic
elicitation question. The five items are fixed and named: **Goal**,
**Prior decisions**, **Stakes**, **Scope**, **Spec section**.

The context block is **not** a free-form prose summary, a "current
state of the type" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis. If the agent has done a code
reading or an investigation, that work belongs in the agent's
reasoning, not in the user-facing context block. If the agent wants
to surface that information to the user, paraphrase it into one of
the five elements (typically **Stakes** or **Scope**) or present it
as a separate explicit step *before* the context block with its own
heading — never in place of the five-element bullet list.

### Template

The `<one sentence — ...>` placeholders below are substituted with
real content drawn from the Decision Ledger, the user's stated goal,
and the spec. Do not emit the angle brackets or the placeholder text
literally. Each substituted element is exactly one sentence. Cite
`Dxxx`/`Txxx` IDs in the **Goal**, **Prior decisions**, and
**Stakes** items. The **Scope** item names what is in and out of
scope for this branch. The **Spec section** item names the spec
file path and the specific section or functional requirement the
branch addresses, with an inline citation.

```md
- **Goal**: <one sentence — the goal of the overall decision, citing D001>
- **Prior decisions**: <one sentence — the prior decisions that affect
  this branch, with ledger citations (e.g., D002, D003, T001)>
- **Stakes**: <one sentence — why this decision matters>
- **Scope**: <one sentence — what is in and out of this decision>
- **Spec section**: <one sentence — the spec file path and the
  specific section or functional requirement the branch addresses,
  cited inline (e.g., `specs/feature-x.md §3.2`)>
```

### The 5th element — Spec section

The 5th element is **required for every code-impl per-decision
question**, without exception. It is not optional and the agent must
not drop it, abbreviate it, or substitute a different element in its
place. The element is one sentence and must include the inline
citation.

The citation format is fixed: the spec file path plus the section or
functional requirement, in the form `<spec-file-path> §<section>`
(e.g., `specs/feature-x.md §3.2`). The citation goes inline in the
sentence so the user can see which spec section the branch
addresses at a glance. The agent must use the actual spec file path
and the actual section or requirement number — not a paraphrase, not
a generic reference to "the spec", not a placeholder.

The **Spec section** element exists so the agent has full context for
the branch (the functional requirements the technical choice must
satisfy) and so the user can audit the spec-to-decision mapping at
any branch. Without the 5th element, the agent's context is
incomplete and the user may lose track of which spec section the
branch is resolving.

## The two-turn sequence

The 2-turn sequence — Turn 1 emits the context block plus the
optional Socratic elicitation question and stops; Turn 2 emits the
locked question line plus the options block plus the recommendation
and stops — is inherited from the parent grilling skill unchanged.
The two turns are mandatory and the agent must not collapse them
into a single turn, even on a re-ask or a follow-up.

The Socratic elicitation question wording (D003) and the locked
question line wording (D004) are inherited from the parent verbatim;
the agent emits them exactly as specified in
`../grilling/references/locked-question-format.md` and waits for the
user's response before proceeding. The engage case (D005) and the
decline case (D013) also apply unchanged.

## Rules

- **Five elements, in order, each one sentence.** The context block
  is the 5-element bullet list above, in order, each element one
  sentence, each filled in from the Decision Ledger, the user's
  stated goal, and the spec. See "Counter-example — what the context
  block is not" below for the wrong and right forms side by side.
- **The 5th element is required, not optional.** Every code-impl
  per-decision context block includes **Spec section**. Dropping the
  5th element is a non-parity context block and the validation check
  in `references/validation.md` will catch it.
- **The 5th element's citation format is fixed.** The inline citation
  is the spec file path plus the section or requirement, in the form
  `<spec-file-path> §<section>`. The agent must not paraphrase, omit,
  or use a placeholder.
- **The first four elements stay aligned with the parent.** Goal,
  Prior decisions, Stakes, Scope are the parent's four elements
  unchanged. The 5th element is the only code-impl addition.
- **The 2-turn sequence is mandatory.** Emit Turn 1 (5-element
  context block plus optional Socratic elicitation question), stop
  and wait for the user's response, then emit Turn 2 (locked
  question line plus options plus recommendation), and stop and wait
  for the user's response. The agent must not collapse the two turns
  into one and must not split Turn 2 into multiple turns.
- **Use the same `Dxxx`/`Txxx` and name verbatim in every question
  for that branch.** Do not rephrase, abbreviate, or rename
  mid-session.
- **The Socratic elicitation question is optional.** The user may
  engage to steer the options or decline. The agent recognizes
  decline signals ("skip", "no", "as-is", or a no-op response) and
  proceeds to Turn 2 without re-asking. The agent must not pressure
  the user to engage and must not treat a no-op response as a missing
  answer.
- **All three response types in the locked question line are equally
  valid.** The agent must not default to a closed-ended "pick one"
  framing and must not treat the line as demanding a specific answer
  format.
- **Do not replace the context block with a free-form prose summary,
  a code reading, or an investigation.** A "current state of the
  type" summary, a domain recap, a file walk-through, or any other
  analysis is **not** a context block. The context block is the
  5-element bullet list above, in order, each element one sentence,
  each filled in from the Decision Ledger, the user's stated goal,
  and the spec.

## Worked example

A foundation item (Language) presented in the 5-element code-impl
format:

```md
- **Goal**: pick the primary language for the freelancing platform
  implementation (D001).
- **Prior decisions**: D002 established the goal of a testable
  domain model; no prior Txxx records yet (T001 is the next slot).
- **Stakes**: the language choice constrains every downstream
  technical decision (framework, dependency direction, type system).
- **Scope**: this decision covers the primary language only; it does
  not cover the framework, the test framework, or the build tooling.
- **Spec section**: the language is required by
  `specs/freelancing-platform.md §2.1 (Architecture)` to support a
  static type system with sealed class hierarchies for the domain
  model.

What are you working toward in this decision? You may answer, or skip
and see the options as-is.

<user answers, or says "skip">

**For T001 – primary language: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

- **Option 1 — C# with .NET 8.** What it is: the platform is built
  on C# 12 with .NET 8 LTS as the target framework. Benefit: the
  language supports sealed class hierarchies natively, which matches
  the spec's domain-model requirement. Cost: the team needs .NET
  expertise or ramp-up time. Risk: a future contributor reaches for
  reflection or dynamic features that break the static type guarantees.
- **Option 2 — TypeScript with Node.js 20 LTS.** What it is: the
  platform is built on TypeScript 5 with Node.js 20 LTS as the
  runtime. Benefit: the team can move quickly with the same language
  on the front end and the back end. Cost: TypeScript's type system
  is structurally typed, so "sealed" hierarchies need a runtime
  guard. Risk: a future contributor adds a type assertion that
  bypasses the seal, leaving a runtime gap.

`Recommendation: Option 1 — C# with .NET 8.`
`Reasoning: the spec's requirement for sealed class hierarchies is
met natively by C#, and the static type system aligns with your goal
of a testable domain model (D001).`
`Forward risk: a future contributor reaches for reflection or
dynamic features that break the static type guarantees.`
```

## Counter-example — what the context block is not

The agent must emit the 5-element bullet list verbatim, in order,
with each element filled in. The following emissions are **not** a
code-impl context block and must not appear in its place, even
partially.

**Wrong** — a 4-element context block (missing the required 5th
element):

```md
- **Goal**: pick the primary language for the freelancing platform
  implementation (D001).
- **Prior decisions**: D002 established the goal of a testable
  domain model.
- **Stakes**: the language choice constrains every downstream
  technical decision.
- **Scope**: this decision covers the primary language only.
```

**Wrong** — a 5-element context block whose 5th element drops the
inline citation:

```md
- **Goal**: pick the primary language for the freelancing platform
  implementation (D001).
- **Prior decisions**: D002 established the goal of a testable
  domain model.
- **Stakes**: the language choice constrains every downstream
  technical decision.
- **Scope**: this decision covers the primary language only.
- **Spec section**: the language must support sealed class hierarchies.
```

**Right** — the 5-element bullet list with the inline citation:

```md
- **Goal**: pick the primary language for the freelancing platform
  implementation (D001).
- **Prior decisions**: D002 established the goal of a testable
  domain model; no prior Txxx records yet (T001 is the next slot).
- **Stakes**: the language choice constrains every downstream
  technical decision (framework, dependency direction, type system).
- **Scope**: this decision covers the primary language only; it does
  not cover the framework, the test framework, or the build tooling.
- **Spec section**: the language is required by
  `specs/freelancing-platform.md §2.1 (Architecture)` to support a
  static type system with sealed class hierarchies for the domain
  model.
```

A "current state of the spec" reading, a code walk-through, or a
domain recap is useful agent reasoning. It does not belong in the
user-facing context block. If the agent wants to share it with the
user, paraphrase the key finding into one of the five elements
(typically **Stakes** or **Scope**) or present it as a separate
explicit step *before* the context block with its own heading — never
in place of the 5-element bullet list.
