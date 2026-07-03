# Multi-part Prose Pattern

A first-class concept in the ask-questions workflow. Use when a single prose turn needs to cover two or more related sub-questions that are checks (not choices).

## Definition

A **Multi-part Prose Pattern** is a single prose turn containing two or more related sub-questions that are binary or scoping checks (yes/no or "which of these apply?") rather than discrete choices. Each sub-question is independently skippable — the user may answer some, pass on others, or answer in a single reply that covers multiple sub-questions.

## Rules

- **Skippability:** each sub-question is skippable. The LLM shall not require an answer to any individual sub-question before proceeding.
- **Pacing:** the LLM waits for an explicit response or a clear pass before proceeding past the multi-part turn. Partial answers are accepted.
- **Not for choices:** genuine discrete choices (2-4 enumerated options the user would actually pick) go through the Tool Call Path. The multi-part pattern is a prose-path construct.

## When not to use

- Do not use for genuine discrete choices — those go to the Tool Call Path.
- Do not use for open-ended exploration questions (use a single prose question instead).
- Do not use when the sub-questions are unrelated — group only related checks.

## Worked example

**Context:** the user has shared a PR diff and the LLM needs to know a few things before proceeding with a review.

```
A few things to check before I review:

- Is this PR targeting the `main` branch?
- Are there any draft commits you'd like me to ignore?
- Do you want me to focus on correctness, style, or both?

Let me know what works for you.
```

The user may answer all three, answer one and pass on the others, or say "just review it" (clear pass).
