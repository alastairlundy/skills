# Branch Starting Prompt

Every branch opens with an open-ended question, not with options. The
LLM paraphrases the user's aim, then asks a dimension-led open question
to elicit the user's thinking before any translation into options
happens. The shape is the design's recognisable signal that the LLM is
not leading the user.

## The template

```md
Within that, the part of the work is <branch name>. What's your thinking
on <dimension>, and what would "good" look like for you there?
```

## Two-part structure

The prompt has two parts, in this order:

1. **Aim paraphrase** — the LLM's one-sentence restatement of the
   user's aim, in the LLM's own voice. Not verbatim from the user. The
   point is to confirm the LLM has understood the aim without
   re-presenting the user's words in a way that could be mistaken for
   a quotation the user endorses.
2. **Dimension-led open question** — a comma (not an em-dash)
   connecting the dimension question to a follow-on "what would 'good'
   look like for you there?". The dimension is drawn from the
   branch's substance, not invented. A generic dimension is
   acceptable when the branch has no clean dimension (e.g., "how do
   you want this named").

## Rules

- **No options at branch start.** The LLM does not surface any
  options, recommendation, or trade-off summary before the user has
  responded. The first user-facing message of every branch is the
  open-ended prompt and nothing else.
- **Comma, not em-dash.** The connector between the dimension
  question and the follow-on "what would 'good' look like for you
  there?" is a comma. An em-dash is forbidden.
- **"What's your thinking on" replaces "what would you want to do on
  that".** The "what would you want to do on that" phrasing was
  rejected because it is too action-led and vague about the answer
  shape. The "what's your thinking on <dimension>" phrasing gives
  the user room to express their reasoning without leading the
  conclusion.
- **One sentence for the aim paraphrase.** A multi-sentence restatement
  becomes noise across many branches. If the aim is complex enough to
  need multiple sentences, the LLM should pick the most operative
  sentence rather than restate the whole aim.
- **Dimension named directly, not as an example.** Do not write "you
  might think about <dimension>". Name the dimension directly.
- **Substitution permitted, structure locked.** The LLM may substitute
  a more natural phrasing that preserves the two-part structure and
  the comma rule, but the wording above is the recognisable shape the
  design aims for across branches.

## Worked example — violation and correction

**Violation.** The LLM leads with a closed question or a hint at the
option space:

> For D007, where should the precondition check live? You might
> think about constructor vs factory vs validator.

**Correction.** Open with the two-part structure, no options surfaced:

> Within that, the part of the work is where the precondition check
> lives. What's your thinking on where the gate should sit, and what
> would "good" look like for you there?

## Why no options at branch start

The user is the named decision-maker on every branch. Surfacing
options before the user has articulated their own thinking gives the
LLM's framing a head start and makes it easy for the user to adopt
the LLM's framing verbatim. The open-ended prompt is the structural
guard against that failure mode: the user speaks first, the LLM
translates second. The translation step itself (fuzzy-intent check,
scope-too-broad check, over-constrained check) lives in
`options-format.md` and runs after the user has responded.
