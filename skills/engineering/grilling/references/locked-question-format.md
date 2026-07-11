# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a grilling
question, and here is the branch it belongs to."

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**, not
the LLM. The Socratic elicitation question, the locked question line, and
any other user-facing template in this reference are addressed to the
user. Emit them verbatim and wait for the user to respond before
proceeding. Free-form instructions to the agent in this reference use
"the LLM" or "the agent" to refer to the agent.

## The sequence

Every branch question follows a fixed four-part sequence. The parts are
not optional and their order is fixed.

### Part 1 — Context block

Before the Socratic question, present a fixed context block with exactly
four elements. Each element is one sentence. No element may be omitted.

The context block is a **structured bullet list with exactly four
items, in the order shown below**. It is the *only* content the agent
emits between the prior turn's resolution and the Socratic elicitation
question. The four items are fixed and named: **Goal**, **Prior
decisions**, **Stakes**, **Scope**.

The context block is **not** a free-form prose summary, a "current
state of the type" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis. If the agent has done a code
reading or an investigation, that work belongs in the agent's
reasoning, not in the user-facing context block. If the agent wants
to surface that information to the user, paraphrase it into one of
the four elements (typically **Stakes** or **Scope**) or present it
as a separate explicit step *before* the context block with its own
heading — never in place of the four-element bullet list.

The `<one sentence — ...>` placeholders below are substituted with
real content drawn from the Decision Ledger and the user's stated
goal. Do not emit the angle brackets or the placeholder text
literally. Each substituted element is exactly one sentence. Cite
`Dxxx` IDs in the **Goal**, **Prior decisions**, and **Stakes**
items. The **Scope** item names what is in and out of scope for this
branch.

```md
- **Goal**: <one sentence — the goal of the overall decision, citing D001>
- **Prior decisions**: <one sentence — the prior decisions that affect
  this branch, with ledger citations (e.g., D002, D003)>
- **Stakes**: <one sentence — why this decision matters>
- **Scope**: <one sentence — what is in and out of this decision>
```

### Part 2 — Socratic elicitation question

After the context block, ask the per-branch Socratic elicitation
question. The question is open-ended and value-surfacing. It does not
presuppose what matters or narrow the user's thinking to a preset
dimension.

The fixed question is:

The Socratic elicitation question is the following user-facing template.
The "you" inside refers to the user; emit it verbatim and wait for the
user to respond before proceeding.

```md
**What are you working toward in this decision?**
```

Wait for the user's response before proceeding. The response grounds the
options that follow in the user's actual values rather than the agent's
assumptions.

### Part 3 — Locked question line

After the user answers the Socratic question, present the locked
question line. The line makes the requirement explicit:

```md
**For [Dxxx] – [branch name]: required — state your answer before the
LLM presents options. You may also pick an option, or provide your
answer.**
```

- `[Dxxx]` is the stable identifier from the Decision Ledger template.
  Use the `Dxxx` you expect to assign *next* — i.e. `max(existing) + 1`
  at the time the question is asked. If the user later opens a new
  branch before the record is written, the `Dxxx` is updated in the
  record itself, not in the question.
- `[branch name]` is the human-readable name of the branch. It should be
  short, descriptive, and stable for the life of the branch.
- The `: required — state your answer before the LLM presents options.`
  suffix is fixed. The user is required to state their own answer before
  the agent presents options. The user may also pick from the options or
  provide a hybrid.

Wait for the user's answer before presenting options.

### Part 4 — Options and recommendation

After the user states their answer, present the options block from
`references/options-format.md` (preceded by the reference-set preamble)
and the recommendation from `references/recommendation-format.md`. The
user may confirm their answer, revise it in light of the options, or
hybridize.

## Rules

- **Use the same `Dxxx` and name verbatim in every question for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
- **Place the context block, Socratic question, and locked question line
  on their own lines**, separated by blank lines from the surrounding
  options block and recommendation.
- **One question per turn — hard stop.** Emit exactly one locked
  question, then stop generating. No exceptions, no escape hatches, no
  self-check mechanisms. Asking multiple questions at once confuses the
  user and is bewildering.
- **The context block is mandatory for every branch.** Do not skip it,
  even when the prior decisions are few or the stakes seem obvious.
- **Do not replace the context block with a free-form prose summary,
  a code reading, or an investigation.** A "current state of the
  type" summary, a domain recap, a file walk-through, or any other
  analysis is **not** a context block. The context block is the
  four-element bullet list above, in order, each element one
  sentence, each filled in from the Decision Ledger and the user's
  stated goal. See "Counter-example — what the context block is not"
  below for the wrong and right forms side by side.

## Worked example

```md
- **Goal**: clarify the domain model for a freelancing platform where
  contacts message on behalf of client organizations (D001).
- **Prior decisions**: D002 established that the contact acts for a
  client organization; D003 established the payment flow.
- **Stakes**: the choice determines whether precondition failures are
  caught at construction or deferred to a later validation step.
- **Scope**: this decision covers where the precondition check lives;
  it does not cover what the precondition checks.

**What are you working toward in this decision?**

<user answers>

**For D007 – where the precondition check lives: required — state your
answer before the LLM presents options. You may also pick an option, or
provide your answer.**

<user states their answer>

- **Option 1 — Constructor check.** What it is: the precondition runs
  in the tab container's constructor, throwing on null dependencies.
  Benefit: failures surface synchronously at the call site. Cost: the
  container cannot be constructed for serialization without supplying
  every dependency. Risk: a future caller may bypass the check with a
  factory that swallows the exception.
- **Option 2 — Static factory validation.** What it is: a `Create`
  factory runs the precondition and returns a `Result<TabContainer>`.
  Benefit: errors are values, not exceptions. Cost: every call site
  grows from one line to a `match` block. Risk: a future developer
  unwraps the result without inspecting it.

`Recommendation: Option 1 — Constructor check.`
`Reasoning: synchronous failure at construction aligns with your goal of
catching precondition failures early.`
`Forward risk: a future factory method bypasses the constructor and
silently constructs an invalid container.`
```

## Counter-example — what the context block is not

The agent must emit the four-element bullet list verbatim, in order,
with each element filled in. The following emission is **not** a
context block and must not appear in its place, even partially.

**Wrong** — an investigation or code reading in place of the context
block:

```md
**Current state of the type**

`ProcessConfiguration` (346 lines, `CLIinvoke.Core/Primitives/`):

- Two ctors. Public 3-param ctor at line 29 (the friendly one used by
  `CliRun` and direct callers). Protected 15-param ctor at line 59
  (the builder-grade one). They produce *different* default states...
- `ProcessConfigurationWrapper` at
  `ProcessConfigurationBuilder.cs:426-443`. An internal subclass
  whose sole constructor delegates to the protected 15-param base
  ctor...
- 13 properties. 10 are `{ get; }` only. 3 have setters and are the
  leak surface...

The wrapper exists because the builder needs the protected ctor's
shape (every field as a parameter) and the protected ctor isn't
reachable from the builder class. The two-ctor shape is the seam
problem; the wrapper is the workaround.
```

**Right** — the four-element bullet list, each element one sentence,
each filled in from the Decision Ledger and the user's stated goal:

```md
- **Goal**: decide whether `ProcessConfiguration` should be a frozen
  value object or remain a mutable config (D001).
- **Prior decisions**: D001 established the session goal; no prior
  branch decisions yet (D002 is the next slot).
- **Stakes**: the choice determines whether precondition failures
  are caught at construction or deferred to a later validation step.
- **Scope**: this decision covers the mutability of
  `ProcessConfiguration`; it does not cover the builder API.
```

The "Current state of the type" reading is useful agent reasoning.
It does not belong in the user-facing context block. If the agent
wants to share it with the user, paraphrase the key finding into
one of the four elements (typically **Stakes** or **Scope**) or
present it as a separate explicit step *before* the context block
with its own heading — never in place of the four-element bullet
list.
