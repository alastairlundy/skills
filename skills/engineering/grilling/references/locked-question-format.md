# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a grilling
question, and here is the branch it belongs to."

## The sequence

Every branch question follows a fixed four-part sequence. The parts are
not optional and their order is fixed.

### Part 1 — Context block

Before the Socratic question, present a fixed context block with exactly
four elements. Each element is one sentence. No element may be omitted.

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

> **What are you working toward in this decision?**

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
