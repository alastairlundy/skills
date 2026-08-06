# Recommendation Format

After presenting the options, the agent names a recommendation. The
recommendation is **exactly two separate lines** — a lean, falsifiable
pick that does not re-state the option table.

## Convention: "you" in this reference

In this reference, "you" and "your" inside a backticked template or a
worked-example emission **always refer to the user**, not the LLM. The
Recommendation and Reasoning templates are addressed to the user;
"your goal" inside the Reasoning template means the user's goal. Emit
the templates verbatim. Free-form instructions to the agent in this
reference use "the LLM" or "the agent" to refer to the agent.

## Format

The block is exactly two **separate lines** (a line break between them,
not a paragraph break):

```md
**Recommendation: <N>.**
**Reasoning:** <one goal-aligned sentence, non-bold, on the same line as the label>
```

- **Line 1:** `**Recommendation: <N>.**` — `<N>` is the option letter
  (e.g., `A`, `B`). The trailing period after `<N>` is **mandatory**;
  omitting it (e.g., `Recommendation: A`) is a violation. No option
  name, no em-dash, no extra fields. All bolded.
- **Line 2:** `**Reasoning:** <one sentence>` — the label `Reasoning:`
  is bolded; the reasoning text itself is non-bold. One goal-aligned
  sentence on the same line as the label. No third line. No
  `Forward risk`. Cost lives in the option table, not here.

Both labels are bolded; only the labels are bolded. The reasoning
text is plain.

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
serves their actual intent, not the agent's assumptions.

## No-recommendation case

When the agent follows up on a prior branch (e.g., re-asking after
clarification) and does not recommend a new option, the
`Recommendation:` line names the user's prior pick and the `Reasoning:`
line states why the branch is open. Example:

```md
**Recommendation: A.**
**Reasoning:** This branch is open because the prior answer needs clarification on the transition timeline.
```

## Informational turns

When the turn is purely informational (no recommendation to give —
e.g., a conflict callout or a status update), omit the recommendation
block entirely.

## Worked example

```md
**Recommendation: A.**
**Reasoning:** Per-seat pricing aligns with your goal of growth-friendly revenue — adoption drives cost, which is the signal you need.
```

## Violation and correction

**Violation.** The agent qualifies the recommendation with an extension
clause or adds a third line:

> **Recommendation: A — Constructor check, with a "spirit-of-the-rule"
> extension clause for test scaffolding.**
> **Reasoning:** ... catches failures early.
> **Forward risk:** a future factory bypasses the check.

**Correction.** Drop the clause and the third line:

> **Recommendation: A.**
> **Reasoning:** Synchronous failure at construction aligns with your
> goal of catching precondition failures early.

## Why the lean format

The recommendation line is the agent's compact, falsifiable claim:
"this is the option." The old multi-field block (Recommendation with
name, Reasoning, Forward risk) duplicated the option table and
added friction. The 2-line format keeps the recommendation a pure
pointer; nuance belongs in the option table's Cost and Risk columns
or in the Reasoning sentence.
