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

Typically 2–4. Do not present more than 5 options or less than 1 option. An option is defensible if all four columns below can be
filled with non-trivial, option-specific content, and if the option genuinely makes sense given the decision - an option that is a strawman is not defensible. If any column would read
`TBD`, `same as Option N`, `none`, or as if it is a strawman then the option is not defensible - replace it.

## The four-column table

Every option is a row in a 4-column markdown table. The columns are
fixed and ordered. The recommended option's name is **bolded** in the
Option column.

| Option | What it is | Benefit | Cost |
|--------|-----------|---------|------|

- **Option** - the option number and name. The recommended option's
  name is **bolded**. Do not use a separate "Recommended" suffix or
  annotation; the bolded name is the signal.
- **Cell rendering** - each Option cell is `**<letter> — <name>**`
  (e.g., `**A — Constructor check**`). The word "Option" appears only
  in this column header and in the Recommendation line (`Option A`);
  never write `Option A —` inside the cell.
- **What it is** - one sentence describing the option.
- **Benefit** - one sentence describing the gain. Answers: "What do I
  get?"
- **Cost** - one sentence describing the realistic sacrifice. Answers:
  "What do I definitely give up?"

### Cell-level caps (enforceable)

- Each cell is ≤ **90 characters** and ≤ **2 sentences**.
- Dropping a field entirely is a violation.
- If a cell would exceed the cap, the agent compresses the wording.
  Promote additional detail into a subsequent branch or into the
  recommendation's `Reasoning` field - never by exceeding the cap or
  by dropping the field.

The cap is applied at write time or in CI, not by reader judgment.

## Bolding discipline

The Option column carries exactly **one** bold span per table: the
recommended option's full label (letter + name). The bolded option
must be the same option named in the `Recommendation:` line below
the table. If the two disagree, the table is invalid and must be
  re-emitted before the recommendation is written.

  Mechanical check: before emitting, confirm the bolded row letter
  equals the `Recommendation:` letter. If they differ, correct the bold
  (never the recommendation) before writing the recommendation line.

**No `**` characters may appear as visible text in any option cell.**
The bold markers are markdown syntax consumed by the renderer. If a
`**` is visible in the rendered output - for example, a stray `**`
appended to the end of a non-recommended option's label like
`B — Few-shot prompting with example diversity**` - the bold span is
malformed (an opening or closing `**` was lost or escaped) and the
table must be re-emitted with the malformed `**` removed. Only the
recommended option's full label (letter + name) carries the bold
span; every other cell in the Option column renders as plain text
with zero `**` characters - no opening, no closing, no orphan.

No other bolding is permitted in the Option column:

- Technology, library, CLI, and product names inside an option label
  render as inline code (`` `Microsoft.Data.Sqlite` ``), never as
  bold. Bold on these terms would collide with the recommendation
  marker and is a rendering bug.
- Words the agent wants to emphasise inside a label (e.g. "Hybrid",
  "Fallback") render as plain text. Bold on them is reserved for the
  recommendation marker only.
- Do not append `(Recommended)` or any other annotation to the
  bolded label. The bold alone is the signal.

## Worked example

```md
Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost |
|--------|-----------|---------|------|
| **A — Constructor check** | Precondition runs in the container constructor, throwing on null. | Failures surface synchronously at the call site. | Container cannot be built for serialization without all deps. |
| B — Static factory validation | A `Create` factory returns `Result<T>` instead of throwing. | Errors are values, not exceptions. | Every call site grows to a `match` block. |
| C — Post-construction validator | Container built unconditionally; `Validate` reports health on demand. | Construction is cheap and side-effect free. | Invalid containers exist until Validate is called. |
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
  four columns are how the user discriminates; shared columns defeat the
  test.
- **Dropping a field to fit the cap.**   All four columns are mandatory
  in every row.
- **Stray `**` characters in non-recommended option cells.** A cell
  that renders as `B — Few-shot prompting with example diversity**`
  (note the trailing `**`) is a rendering bug. The bold span is
  malformed - either the opening `**` was lost, or the closing `**`
  was duplicated. Re-emit the row with no `**` characters at all;
  only the recommended option's label uses `**`.
- **Bolded option disagrees with the Recommendation line.** A table
  that bolds Option A's row while `Recommendation: Option B - ...`
  names Option B is invalid. The bold span in the Option column is
  the recommendation marker; the recommendation line must agree.
  Re-emit the table with the bold moved to the recommended option -
  do not rewrite the recommendation to match the table.
