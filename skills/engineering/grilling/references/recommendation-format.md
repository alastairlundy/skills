# Recommendation Format

After presenting the natural options, the agent names a recommendation.
The recommendation is **a three-field breakdown with explicit labels**.

## Format

```md
`Recommendation: Option N — <name>.`
`Reasoning: <one-to-two sentences>.`
`Forward risk: <one sentence naming the most likely failure mode of the chosen option>.`
```

- `Recommendation: Option N — <name>.` — `<name>` is copied **verbatim**
  from the option's heading in `options-format.md`. Do not paraphrase,
  abbreviate, or re-order the name. Do not modify, augment, combine, or
  qualify the option. If a clause is essential, promote it to a
  *separate* option first, then recommend that option.
- `Reasoning: <one-to-two sentences>.` — why this option's trade-offs
  and risks are acceptable in this specific context. Justify the
  recommended option only; do not re-justify the rejected options.
- `Forward risk: <one sentence naming the most likely failure mode of the
  chosen option>.` — the most likely way this choice goes wrong, in
  one sentence. The point is to surface the failure mode so the user can
  watch for it later, not to repeat the option's `Risk` field.

## Worked example — violation and correction

**Violation.** The agent tries to qualify the recommended option with an
extension clause:

> `Recommendation: Option 1 — Constructor check, with a "spirit-of-the-rule"
> extension clause for test scaffolding.`

**Correction.** Either drop the clause and recommend `Option 1 —
Constructor check.` cleanly, or promote the clause to a new `Option 4`
and recommend that:

> - **Option 4 — Constructor check with a `TryCreate` escape hatch.**
>   What it is: a constructor for normal use, plus a static
>   `TryCreate` factory that returns a `Result` for test scaffolding.
>   Benefit: production code keeps the throwing precondition; tests can
>   build partial containers without exception handling. Cost: two
>   construction paths to maintain. Risk: future developers use
>   `TryCreate` in production to "tidy up" error handling.
>
> `Recommendation: Option 4 — Constructor check with a TryCreate escape hatch.`
> `Reasoning: production code keeps the synchronous failure signal, and
> test scaffolding gets a documented escape hatch that the lint rule can
> flag if it leaks into non-test code.`
> `Forward risk: a future developer uses TryCreate in production code to
> "tidy up" error handling, hiding the precondition failure.`

## Why the verbatim-name rule

The recommendation line is the agent's compact, falsifiable claim:
"this is the option, and here is its name." Paraphrasing the name
breaks the link between the options block the user just read and the
recommendation line they are being asked to confirm. A user reading
"Option 1" and the agent saying "Option 1 — Constructor check (with a
guard clause)" has to re-read the option block to figure out what
changed.

The fix is to keep the recommendation line a pure reference: copy the
name verbatim, copy the option number verbatim, and put any nuance in
`Reasoning` or `Forward risk`. The recommendation is the *pointer*; the
nuance is the *justification*.
