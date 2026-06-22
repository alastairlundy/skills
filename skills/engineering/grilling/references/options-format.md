# Options Format

Every decision point the agent presents must show the user the full range
of natural options, not just the recommended one. The user must see the
landscape of choices to make an informed decision.

## How many options

Typically 2–4. An option is defensible if all four fields below can be
filled with non-trivial, option-specific content. If any field would read
`TBD`, `same as Option N`, or `none`, the option is not defensible —
drop it or replace it.

## The four required fields

Each option is a structured block. **One sentence per field.** Write in
Professional Minimalist style: punchy, direct, clear. No filler.

- **What it is** — one sentence describing the option.
- **Benefit** — one sentence describing the gain if this option is chosen.
  Answers: "What do I get?"
- **Cost** — one sentence describing the realistic/actual sacrifice.
  Answers: "What do I definitely give up?"
- **Risk** — one sentence describing what might go wrong later.
  Answers: "What could happen in the future?"

## Format

```md
- **Option N — <Name>.** What it is: <one sentence>. Benefit: <one
  sentence>. Cost: <one sentence>. Risk: <one sentence>.
```

The `<Name>` is copied verbatim into the recommendation block — see
`recommendation-format.md`.

## Worked example

**For D007 – where the precondition check lives: pick an option, or
provide your answer.**

- **Option 1 — Constructor check.** What it is: the precondition runs in
  the tab container's constructor, throwing on null dependencies.
  Benefit: failures surface synchronously at the call site, which makes
  the bug obvious in test output. Cost: the container cannot be
  constructed for serialization or test scaffolding without supplying
  every dependency. Risk: a future caller may bypass the check with a
  factory that swallows the exception.
- **Option 2 — Static factory validation.** What it is: a `Create`
  factory runs the precondition and returns a `Result<TabContainer>`
  rather than throwing. Benefit: errors are values, not exceptions, and
  can be pattern-matched in calling code. Cost: every call site grows
  from one line to a `match` or `if let` block. Risk: a future developer
  may unwrap the result without inspecting it, silently discarding the
  failure.
- **Option 3 — Post-construction validator.** What it is: the
  container is built unconditionally and a separate `Validate` method
  reports dependency health on demand. Benefit: construction is cheap
  and side-effect free, which is friendly to ORMs and serializers.
  Cost: invalid containers exist in memory until something calls
  `Validate`. Risk: the validator is forgotten in a code path, and the
  invalid container reaches production.

## Anti-patterns

- **Fewer than two options.** A "decision" with a single option is not
  a decision — present the choice or skip the branch.
- **More than four options.** A question with five-plus options is
  usually two decisions bundled together. Split it.
- **A "default" option that the user is steered into.** All options must
  be defensible. If the agent believes one is correct, it is the
  recommendation, not an option.
- **"Same as Option N" fields.** Each option must stand on its own. The
  four fields are how the user discriminates; shared fields defeat the
  test.
