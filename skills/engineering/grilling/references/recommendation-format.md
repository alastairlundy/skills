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
**Recommendation: Option <N> - <One short sentence of what Option N is>.**
**Reasoning:** <one goal-aligned sentence, non-bold, on the same line as the label>
```
- **Line 1:** `**Recommendation: Option <N> - <One short sentence of what Option N is>.**` — `<N>` is the option letter
  (e.g., `A`, `B`). The dash and sentence stating what the option is followed by the trailing period is **mandatory**;
  omitting it (e.g., `Recommendation: Option A`) is a violation. 
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
recorded in the current goal record (or a new goal record, if a `Supersedes`
has been issued). The reasoning must explain *why* this option serves
the goal; it must not compare options against each other or
re-justify the rejected options.

A reasoning that cites ledger records (`Dxxx`/`Txxx`) without naming
the user's goal is insufficient. The agent must always surface the
goal-alignment explicitly so the user can verify the recommendation
serves their actual intent, not the agent's assumptions.

## Informational turns

When the turn is purely informational (no recommendation to give —
e.g., a conflict callout or a status update), omit the recommendation
block entirely.

## Worked example

```md
**Recommendation: Option B - Per seat pricing.**
**Reasoning:** Per-seat pricing aligns with your goal of growth-friendly revenue — adoption drives cost, which is the signal you need.
```

## Violation and correction

**Violation.** The agent qualifies the recommendation with an extension
clause or adds a third line:

> **Recommendation: Option A — Constructor check, with a "spirit-of-the-rule" extension for test scaffolding.**
> **Reasoning:** ... catches failures early.
> **Forward risk:** a future factory bypasses the check.

**Correction.** Drop the clause and the third line:

> **Recommendation: Option A -Constructor check,  with a "spirit-of-the-rule" extension for test scaffolding.**
> **Reasoning:** Synchronous failure at construction aligns with your goal of catching precondition failures early.

## Why the lean format
The 2-line format keeps the recommendation a pure pointer; nuance belongs in the option table's Cost and Risk columns
or in the Reasoning sentence.