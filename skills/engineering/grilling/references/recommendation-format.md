# Recommendation Format (on-demand only)

Per `docs/adr/0003-recommendations-on-demand-only.md` (D005), the LLM
**does not produce a recommendation in the default flow** of any
branch. This file is the guide for the on-demand case: the LLM
surfaces a recommendation only if the user explicitly asks for one,
and never pre-suggests ("would you like my take?") at the end of a
branch.

The user is the named decision-maker on every branch. The LLM's
default role is translator of the user's intent into 2–4 concrete
natural options; the LLM surfaces a recommendation only when the
user invites it. The on-demand affordance preserves the second
opinion for users who want it, with the user's question as the
observable signal that the user has chosen to see it.

## When a recommendation is produced

A recommendation appears only in response to an explicit user
request. Any unambiguous phrasing qualifies — the skill does not
lock the affordance behind a specific magic phrase. Examples:

- "what's your take?"
- "what do you think?"
- "what would you do?"
- "any recommendation?"
- "if you were picking, which would you pick?"

When the user asks, the LLM produces the three-field breakdown
below. The user's exact wording is not required; any unambiguous
request for the LLM's opinion qualifies.

## The no-pre-suggest rule

The LLM shall **not** pre-suggest a recommendation at the end of a
branch. Phrasings to avoid include:

- "Would you like my take on these?"
- "Want my recommendation?"
- "Should I tell you which one I prefer?"
- Any closing remark that invites the user to ask for a
  recommendation.

The user is expected to know the affordance exists; the LLM
surfaces it on request, not by invitation. A pre-suggestion is a
silent violation of the on-demand rule, regardless of whether the
user takes the bait.

## When the user does not ask

After the LLM surfaces the options block in the default flow, the
LLM stops. The LLM does not fill the silence with a recommendation,
a steering comment, a recap of the user's own words as a
recommendation, or a pre-suggest. The user picks, pushes back, or
asks for the LLM's opinion. Any of those three is a valid response;
the LLM only acts on the third.

## Format (when produced on request)

When the user asks, the recommendation is a three-field breakdown
with explicit labels:

```md
`Recommendation: Option N — <name>.`
`Reasoning: <one-to-two sentences>.`
`Forward risk: <one sentence naming the most likely failure mode of the chosen option>.`
```

- `Recommendation: Option N — <name>.` — `<name>` is copied
  **verbatim** from the option's heading in `options-format.md`. Do
  not paraphrase, abbreviate, or re-order the name. Do not modify,
  augment, combine, or qualify the option. If a clause is essential,
  promote it to a *separate* option first, then recommend that
  option.
- `Reasoning: <one-to-two sentences>.` — why this option's
  trade-offs and risks are acceptable in this specific context.
  Justify the recommended option only; do not re-justify the
  rejected options.
- `Forward risk: <one sentence naming the most likely failure mode
  of the chosen option>.` — the most likely way this choice goes
  wrong, in one sentence. The point is to surface the failure mode
  so the user can watch for it later, not to repeat the option's
  `Risk` field.

## Worked example (produced on request)

The options block for D007 was presented in the default flow (see
`options-format.md` worked example). The user replies:

> What's your take?

The LLM produces:

> `Recommendation: Option 3 — Constructor check with a TryCreate escape hatch.`
> `Reasoning: production code keeps the synchronous failure signal,
> and test scaffolding gets a documented escape hatch that the lint
> rule can flag if it leaks into non-test code.`
> `Forward risk: a future developer uses TryCreate in production code
> to "tidy up" error handling, hiding the precondition failure.`

## Worked example — violation and correction

**Violation.** The LLM pre-suggests at the end of the options
block:

> For D007 – where the precondition check lives: pick an option, or
> provide your answer.
>
> [options block]
>
> Want my take?

**Correction.** Drop the pre-suggest. The LLM stops after the
options block and waits:

> For D007 – where the precondition check lives: pick an option, or
> provide your answer.
>
> [options block]

## Why the verbatim-name rule

The recommendation line is the LLM's compact, falsifiable claim:
"this is the option, and here is its name." Paraphrasing the name
breaks the link between the options block the user just read and
the recommendation line they are being asked to confirm. A user
reading "Option 1" and the LLM saying "Option 1 — Constructor check
(with a guard clause)" has to re-read the option block to figure
out what changed.

The fix is to keep the recommendation line a pure reference: copy
the name verbatim, copy the option number verbatim, and put any
nuance in `Reasoning` or `Forward risk`. The recommendation is the
*pointer*; the nuance is the *justification*.

## Authority

This file is the operational guide. The durable rule lives in
`docs/adr/0003-recommendations-on-demand-only.md`. If this file and
the ADR ever disagree, the ADR is authoritative.
