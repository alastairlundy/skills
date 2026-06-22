# Glossary

Reference for the terms the ask-questions workflow uses. Load on demand from the workflow body.

| Term | Meaning |
|---|---|
| `ask_question` | The abstract discrete-choice clarification tool affordance. In opencode, the `question` tool. |
| `label` | The option''s short scannable title. |
| `description` | The option''s short discriminative explanation, shown beneath the label. |
| `context prose` | The LLM''s message text *before* the tool call, carrying the longer setup. |
| `call` | A single invocation of the `ask_question` tool. |
| `trigger` | The Gate 1 inverted-trigger test: is there a real question whose answer would change the LLM''s next action? |
| `Real Decision` | The Gate 1.2 precondition: the user has a narrowed space of 2-4 options they would actually pick. |
| `Realistic alternative` | An option the user, given their stated context, would actually pick. The discriminator that separates a real decision from an over-asking trap. |
| `fit test` | The Gate 2 test: does the question fit the tool after adaptations? |
| `adaptation` | A way to consolidate a question: raise abstraction, sequence, subsume, or consolidate. |
| `Tool Call Path` | Gate 3 path that uses the discrete-choice tool. |
| `Prose Fallback` | Gate 3 path that asks in prose (used when adaptations fail, or by default when in doubt). |
| `gate` | A hard checkpoint in the workflow; if it fails, the LLM does not proceed. |