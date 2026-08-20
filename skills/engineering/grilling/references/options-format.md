# Options Format

Every decision point the agent presents must show the user the full range
of natural options, not just the recommended one. The user must see
all available options to make an informed decision.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**, not
the LLM. The reference-set preamble and any other user-facing template
in this reference are addressed to the user. Emit them verbatim and wait
for the user to respond before proceeding. Free-form instructions to
the agent in this reference use "the LLM" or "the agent" to refer to
the agent.

## Reference-set preamble

The options block is preceded by a brief preamble that frames the options
as a reference set. The preamble is part of the options block - it is not
optional prose. The preamble must convey:

- The options are a reference set the user can use to confirm, revise,
  or hybridize their own answer.
- The user may pick one, reject all, or combine elements.

The fixed preamble is:

```md
Here are options to help you refine or confirm your answer. Pick one, hybridize, or
reject all.
```

## How many options

Typically 2–4. Do not present more than 5 options or less than 1 option. An option is defensible if all five columns below can be
filled with non-trivial, option-specific content, and if the option genuinely makes sense given the decision - an option that is a strawman is not defensible. If any column would read
`TBD`, `same as Option N`, `none`, or as if it is a strawman then the option is not defensible - replace it.

## The five-column table

Every option is a row in a 5-column markdown table. The columns are
fixed and ordered. The recommended option's name is **bolded** in the
Option column.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|

- **Option** - the option number and name. The recommended option's
  name is **bolded**. Do not use a separate "Recommended" suffix or
  annotation; the bolded name is the signal.
- **What it is** - one sentence describing the option.
- **Benefit** - one sentence describing the gain. Answers: "What do I
  get?"
- **Cost** - one sentence describing the realistic sacrifice. Answers:
  "What do I definitely give up?"
- **Risk** - one sentence describing what might go wrong later. Answers:
  "What could happen in the future?"

### Cell-level caps (enforceable)

- Each cell is ≤ **90 characters** and ≤ **2 sentences**.
- Dropping a field entirely is a violation.
- If a cell would exceed the cap, the agent compresses the wording.
  Promote additional detail into a subsequent branch or into the
  recommendation's `Reasoning` field - never by exceeding the cap or
  by dropping the field.

The cap is applied at write time or in CI, not by reader judgment.

## Worked example

```md
Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A - Constructor check** | Precondition runs in the container constructor, throwing on null. | Failures surface synchronously at the call site. | Container cannot be built for serialization without all deps. | Future caller bypasses check via a swallowing factory. |
| B - Static factory validation | A `Create` factory returns `Result<T>` instead of throwing. | Errors are values, not exceptions. | Every call site grows to a `match` block. | Developer unwraps result without inspecting it. |
| C - Post-construction validator | Container built unconditionally; `Validate` reports health on demand. | Construction is cheap and side-effect free. | Invalid containers exist until Validate is called. | Validator forgotten; invalid container reaches production. |
```

## Anti-patterns

- **Fewer than two options.** A "decision" with a single option is not
  a decision - present the choice or skip the branch.
- **More than four options.** A question with five-plus options is
  usually two decisions bundled together. Split it.
- **A "default" option that the user is steered into.** All options must
  be defensible. If the agent believes one is correct, it is the
  recommendation, not an option.
- **"Same as Option N" fields.** Each option must stand on its own. The
  five columns are how the user discriminates; shared columns defeat the
  test.
- **Dropping a field to fit the cap.** All five columns are mandatory
  in every row.