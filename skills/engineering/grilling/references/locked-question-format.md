# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a grilling
question, and here is the branch it belongs to."

## The template

```md
**For [Dxxx] – [branch name]: pick an option, or provide your answer.**
```

- `[Dxxx]` is the stable identifier from the Decision Ledger template.
  Use the `Dxxx` you expect to assign *next* — i.e. `max(existing) + 1`
  at the time the question is asked. If the user later opens a new
  branch before the record is written, the `Dxxx` is updated in the
  record itself, not in the question.
- `[branch name]` is the human-readable name of the branch. It should be
  short, descriptive, and stable for the life of the branch.
- The `: pick an option, or provide your answer.` suffix is fixed; do
  not vary it. The user is always permitted to push back, modify, or
  replace the options.

## Rules

- **Use the same `Dxxx` and name verbatim in every question for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
- **Place the template on its own line**, separated by blank lines from
  the surrounding options block and recommendation.
- **One question per turn.** Wait for the user's response before
  presenting the next question.

## Worked example

```md
**For D007 – where the precondition check lives: pick an option, or
provide your answer.**

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
`Reasoning: synchronous failure at construction makes the bug visible in
test output, and the only escape hatch needed (test scaffolding) is
already supported by the test framework's exception assertions.`
`Forward risk: a future factory method bypasses the constructor and
silently constructs an invalid container.`
```
