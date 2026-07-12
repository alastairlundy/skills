# Recommendation Format

After presenting the natural options, the agent names a recommendation.
The recommendation is **a three-field breakdown with explicit labels**.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a backticked template or a
worked-example emission **always refer to the user**, not the LLM. The
Recommendation, Reasoning, and Forward-risk templates are addressed to
the user; "your goal" inside the Reasoning template means the user's
goal. Emit the templates verbatim. Free-form instructions to the agent
in this reference use "the LLM" or "the agent" to refer to the agent.

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
- `Reasoning: <one-to-two sentences>.` — goal-aligned reasoning for why
  this option serves the user's stated goal. The reasoning must explain
  why the recommended option aligns with the user's goal; it must not
  compare options against each other. Do not re-justify the rejected
  options.
- `Forward risk: <one sentence naming the most likely failure mode of the
  chosen option>.` — the most likely way this choice goes wrong, in
  one sentence. The point is to surface the failure mode so the user can
  watch for it later, not to repeat the option's `Risk` field.

## Goal-alignment rule

The `Reasoning` field **must explicitly tie the recommended option to
the user's stated goal**. Use phrasing like *"aligns with your goal of
X"* or *"serves your goal of X"*, where X is the session-level goal
recorded in D001 (or the current goal record, if a `Supersedes: Dxxx`
has been issued). The reasoning must explain *why* this option serves
the goal; it must not compare options against each other or
re-justify the rejected options.

A reasoning that cites ledger records (`Dxxx`/`Txxx`) without naming
the user's goal is insufficient. The agent must always surface the
goal-alignment explicitly so the user can verify the recommendation
serves their actual intent, not the agent's assumptions. When ledger
records (e.g., a `Dxxx` constraint) are relevant, they belong in the
reasoning *alongside* the goal-alignment phrasing, not as a
substitute for it.

**Anti-pattern**: `Reasoning: D005's per-stream rule and D004's
per-stream cancellation rule both map cleanly onto two method-shaped
entry points, and two methods is the shape .NET developers reach for
first when two independent async streams exist.` — this reasoning
cites ledger rules and developer ergonomics but never names the
user's goal. The user cannot tell whether the recommendation serves
their intent.

**Correct**: `Reasoning: Option 1 aligns with your goal of exposing
both streams independently — D005's per-stream rule and D004's
per-stream cancellation rule both map cleanly onto two method-shaped
entry points.` — the goal is named first, then the supporting
evidence follows.

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
> `Reasoning: production code keeps the synchronous failure signal, which
> aligns with your goal of catching precondition failures at the call
> site; test scaffolding gets a documented escape hatch that the lint
> rule can flag if it leaks into non-test code.`
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

## Recommendation rationale on request

After presenting the recommendation, the agent reminds the user they can
ask for the recommendation rationale. The reminder is part of the
post-pick template (see `SKILL.md` Step 4), not optional prose.

When the user asks for the rationale, the agent provides concise
goal-aligned rejection reasoning for the other options. The rejection
reasoning must explain why each rejected option is less aligned with the
user's stated goal; it must not compare options against each other.

If the user does not ask, the agent does not volunteer the rationale.
