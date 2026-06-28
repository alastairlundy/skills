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
- `[branch name]` is the human-readable name of the branch. It should
  be short, descriptive, and stable for the life of the branch.
- The `: pick an option, or provide your answer.` suffix is fixed; do
  not vary it. The user is always permitted to push back, modify, or
  replace the options.

## Rules

- **Use the same `Dxxx` and name verbatim in every question for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
- **Place the template on its own line**, separated by blank lines from
  the surrounding options block.
- **One question per turn.** Wait for the user's response before
  presenting the next question.

## No recommendation in the default flow

The locked question format does **not** include a recommendation
block. Per `docs/adr/0003-recommendations-on-demand-only.md` (D005),
the LLM does not produce a recommendation in the default flow of any
branch. After the LLM presents the options block and the locked
question, the LLM stops. The LLM does not fill the silence with a
recommendation, a steering comment, or a pre-suggest ("would you
like my take?").

If the user explicitly asks for a recommendation ("what's your
take?", "what do you think?", "what would you do?"), the LLM
produces the three-field breakdown from `recommendation-format.md` in
a follow-up turn. See that file for the on-demand format and the
no-pre-suggest rule.

## Worked example

The branch was opened with the open-ended prompt from
`branch-starting-prompt.md` and the LLM has translated the user's
response into 2–4 concrete natural options per `options-format.md`.
The LLM now presents the options block and the locked question:

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
```

The LLM stops here and waits for the user to pick, push back, or
ask for the LLM's opinion. The LLM does not append a recommendation
or a pre-suggest.

## Worked example — violation and correction

**Violation.** The LLM appends a recommendation and a pre-suggest
after the locked question:

> **For D007 – where the precondition check lives: pick an option,
> or provide your answer.**
>
> [options block]
>
> `Recommendation: Option 1 — Constructor check.`
> `Reasoning: ...`
> `Forward risk: ...`
>
> Want my take?

**Correction.** Drop the recommendation and the pre-suggest. The
LLM stops after the options block:

> **For D007 – where the precondition check lives: pick an option,
> or provide your answer.**
>
> [options block]
