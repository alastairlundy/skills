---
name: ask-questions
description: >-
   Assists agents with when to ask questions via tools vs prose. Use when a request is ambiguous, has multiple valid interpretations, or needs a discrete choice before proceeding. Do not use if user input is not required, or a request has clear discrete options with concise descriptions.
license: MIT
---

# Ask Questions

**opencode dialect.** This skill targets the opencode agent platform. In opencode, the abstract `ask_question` affordance is bound to the `question` tool. On other hosts, substitute the equivalent discrete-choice tool.

This skill governs how the LLM uses the `ask_question` tool (and equivalent discrete-choice clarification tools) to interact with the user. It addresses two failure modes in balance:

1. **Over-asking** — invoking the tool for open-ended or non-decision questions the tool cannot answer usefully, or for questions where prose (or no question at all) is the better response.
2. **Under-asking** — having the tool but not using it when a real decision is on the table that the LLM cannot resolve from context, code, or safe inference.

Both directions are weighted equally; the skill is not an instruction to ask more.

**Tool unavailable.** If no discrete-choice tool is available, treat every question as Prose Fallback.

Glossary: see `references/glossary.md`. Worked examples: see `references/examples.md`.

## When to Use

- The LLM is about to call the `ask_question` (or equivalent) tool.
- The LLM is considering whether to ask the user a question and is unsure whether to ask, how many to ask, or how to shape them.
- The LLM has a real question whose answer would change its next action and that cannot be resolved from context, code, or safe inference.

## When Not to Use

- For questions where the LLM is making a point rather than soliciting input (e.g., a sentence ending in "isn't it?" that the LLM does not expect the user to answer).
- When the user has explicitly opted out of being asked.
- When the LLM can resolve the question from context, code, or safe inference.
- For trivial confirmations better handled by proceeding and showing the work.

## Step 0: Mode Detection

The LLM operates in one of three modes, detected from the user''s current and recent messages. All downstream gate behavior is keyed to the active mode.

The keyword lists below are a first-pass hint, not a deterministic gate. If the surrounding context clearly contradicts the detected mode, override the keyword match — treat the mode as Neutral and proceed.

### Invited mode

The user has explicitly licensed broad questioning. The LLM may ask several questions across multiple turns, one per turn, knowing the user wants to be asked. Phrasings include:

- "grill me"
- "ask me anything"
- "ask me everything"
- "what do you need to know?"
- "what would you ask me?"

### Opt-out mode

The user has explicitly declined being asked. Ask only if the LLM cannot proceed without the answer. Phrasings include:

- "just do it"
- "use your judgment"
- "don't ask"
- "figure it out"
- "stop asking"

### Neutral mode (default)

Neither invited nor opted-out. Apply the inverted trigger without modification.

**Override rule.** If the detected mode clearly contradicts the surrounding context, default to Neutral and proceed as if no mode were detected. Common contradiction cases:
- Quoted complaint or reported speech containing a keyword (e.g., the user says "the developer told me 'just do it'")
- Example phrasing meant to illustrate, not request (e.g., "for example, the user might say 'use your judgment'")
- Quoted block containing a keyword from the mode lists

## Workflow

Four gates run in order. At every gate, failure stops the workflow.

0. **Load glossary.** Load `references/glossary.md` to confirm the term definitions used in the gates below.

**Default: Prose.** When the LLM is in doubt between Tool Call Path and Prose Fallback (or no question at all), the default is Prose Fallback. The over-asking cost (user friction, leaky options) exceeds the under-asking cost (the LLM proposes a default in prose that the user can correct).

### Gate 1: Trigger

Two tests; both must pass.

1. **Inverted trigger test.** Is there a real question whose answer would change the LLM''s next action AND that the LLM cannot resolve from context, code, or safe inference? If the LLM finds itself writing "I can probably infer X," that is not resolution — ask. In opt-out mode, the bar is stricter: ask only if the LLM cannot proceed without the answer. Neutral and invited modes apply the inverted trigger as written.
2. **Real Decision precondition.** Is this a real decision — does the user have a narrowed space of 2-4 options they would actually pick? An option is *realistic* iff the user, given their stated context, would actually pick it. If the constructed options would all have the LLM do the same work, or if the user has not narrowed the space, this is not a real decision and Gate 1 fails.

If either test fails, do not ask. Proceed with a sensible default, document the default, and let the user correct.

### Gate 2: Fit

Two sub-checks.

**Sub-check A — Realistic alternative confirmation.** For each option, name the user-stated fact (quoted or paraphrased from the user's current or recent messages) that makes the option realistic. If no such fact exists for an option, drop or replace that option before proceeding. Do not proceed with options that lack a user-stated basis.

**Sub-check B — Adaptability test.** Can the question be honestly consolidated into 2-4 options? Try these adaptations, in any combination:

- **Raise abstraction:** consolidate by raising the level of abstraction. E.g., "Which of these 6 logging libraries?" → "Heavy framework or lightweight?" (2 options subsume the 6).
- **Sequence:** break a branched decision into multiple independent questions, each with 2-4 options, asked one at a time across turns.
- **Subsume:** reframe a long option list as a more abstract single decision.
- **Consolidate:** merge adjacent options.

If any adaptation works without losing essential information, proceed to Gate 3 Tool Call Path. If all adaptations lose essential meaning, proceed to Gate 3 Prose Fallback.

### Gate 3: Construct

Two paths from Gate 2.

#### Tool Call Path

1. **Write context prose first.** The prose sets up the decision. It exists to make the choice legible, not to teach the topic. *Test:* if the user can pick correctly without reading the prose, the prose is too long.
2. **Construct the tool call:**
   - **1 question per call. Always.** No batching.
   - **2-4 options per question.** Each option must pass the realistic alternative test.
   - **Alphabetical order** by the option''s underlying name. The `(Recommended)` marker is appended to the label as a suffix and does not change sort position.
   - **Mark the recommended option** (if the LLM has one) with `(Recommended)`. The recommendation is what the LLM would commit to on the user''s behalf given the user''s stated context — not the LLM''s preferred architecture, not the most common choice.
   - **Labels:** ≤6 words, parallel grammatical form (e.g., all noun phrases or all verb phrases).
   - **Descriptions:** ≤80 characters, discriminative only. *Test:* each description must answer "why pick this over the others?" If the description teaches rather than discriminates, move it to context prose.
   - **Headers:** ≤30 characters, scannable, in domain language.

#### Prose Fallback

Use only when Gate 2 Sub-check B''s adaptations all fail, or by the Default: Prose tie-breaker. Construct the prose question in the LLM''s message:

1. **1 question at a time.**
2. **Options as a numbered or bulleted list.**
3. **Prose discipline:** the prose must be necessary to make the choice. *Test:* if the user can pick correctly without reading the prose, the prose is too long.
4. The LLM may indicate a recommendation in the prose ("I''d suggest B because..."), but not via a UI marker (prose questions don''t have one).
5. **Multi-part Prose Pattern** (see `references/multi-part-pattern.md`) is permitted under Prose Fallback when the sub-questions are checks (not choices). Load `references/multi-part-pattern.md` before constructing a multi-part prose turn.

### Gate 4: Validate

Before submitting, run the mechanical checks listed in the [Validation](#validation) section. If any check fails, fix and re-validate. Do not submit a failing draft.

### End condition

After three rounds of clarifying questions, the LLM should propose a default in prose or hand off to `grilling` for structured decision-making. This is a soft cap (a "should", not a "must"): more rounds are permitted if the LLM can justify that the trajectory is converging. The hand-off to `grilling` is the preferred escape hatch when the situation is a genuine multi-decision exploration.

## Validation

The final output (tool call + context prose, or prose fallback) must pass these mechanical gates. Each gate is independently verifiable.

- [ ] **Trigger Gate** — the inverted trigger passed; the Real Decision precondition passed; opt-out (if active) did not block; the LLM has a real question whose answer would change its next action.
- [ ] **Fit Gate** — Sub-check A (realistic alternatives) passed; Sub-check B adaptations were tried before Prose Fallback.
- [ ] **Count Gate** — 1 question per call (applies to tool calls only; prose path governed by Multi-part Prose Pattern in `references/multi-part-pattern.md`).
- [ ] **Order Gate** — alphabetical by underlying option name; `(Recommended)` marker is a suffix and does not change position; the recommendation is what the LLM would commit to on the user''s behalf given the user''s stated context.
- [ ] **Prose Discipline Gate** — context prose is necessary to make the choice (test: user can pick without it = too long); descriptions are discriminative (test: each answers "why pick this over the others?"); Prose Fallback (if used) is justified by failed adaptations or by the Default: Prose tie-breaker.
- [ ] **Term Purity Gate** — no internal field names, no tool names, and no skill names the user did not name first appear in user-facing prose or option text.