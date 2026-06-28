# Options Format

Every decision point the LLM presents must show the user the full
range of natural options, not just a recommended one. The LLM
translates the user's answer into options; the user picks. This file
defines the per-option format, the criteria each option must satisfy,
and the pre-option checks the LLM runs before surfacing any options.

## How the user reaches the options block

A branch opens with the open-ended branch-starting prompt from
`branch-starting-prompt.md` — the LLM does not lead with options. The
options block is presented only after the user has responded and the
LLM has translated the response. The translation runs the pre-option
checks below in order, looping back to the user as needed.

## Pre-option checks

Run the following checks in order. Do not surface options while any
check fails. Each check has its own named section below; this list is
the order of application.

1. **Fuzzy intent (D004).** If the user's answer is fuzzy, ask a
   clarifying question and re-evaluate.
2. **Scope too broad (D007).** If the answer translates to more than
   four natural options, ask the scope meta-question and re-enter with
   the chosen scope.
3. **Over-constrained (D008).** If the answer translates to a single
   defensible option, ask the trade-off question and branch on the
   user's response.

## Concrete natural option (D002)

A concrete natural option satisfies **all eight** of the following
criteria. If any criterion fails, the option is not defensible and
must be sharpened, replaced, or dropped.

1. **Actionable.** Describes a specific single-step action the user
   could commit to right now.
2. **Phrased in the user's words.** Preserves the user's own
   terminology and phrasing as much as possible. The LLM paraphrases;
   it does not invent. If the user's phrasing is not actionable, the
   LLM must sharpen it but must surface the sharpening to the user
   rather than silently rewriting.
3. **Substantively or semantically different.** Each option in the
   set must differ from the others in substance or meaning such that
   each could be justified as the answer on its own.
4. **Not contrived.** The option must arise from the user's stated
   context, not be created for the sake of having options.
5. **Contextually sensible.** The option must make sense given the
   context the user has provided.
6. **Performable.** The option must have a basis in reality; the user
   can reasonably perform it.
7. **Individually defensible.** Each option must stand on its own
   merits. The four fields (below) are how the user discriminates;
   shared fields defeat the test.
8. **Aim-advancing.** Each option must advance the user's stated
   aim(s) or objective(s).

The LLM shall present **at most 4** concrete natural options per
branch. A hybrid of multiple options is rarely the answer; a hybrid
may be surfaced only when the user's own answer explicitly described
one.

## Fuzzy intent (D004)

A user answer is **fuzzy intent** when it satisfies EITHER of:

- **Unstated specifics** — the answer omits one or more specifics the
  LLM needs to translate into a concrete natural option (who, what,
  when, where, how much, by what mechanism).
- **Under-constrained** — the answer could plausibly mean five or
  more different concrete natural options. The 5+ threshold is the
  signal for under-constrained; if the LLM can paraphrase into 2–4
  defensible concrete natural options, the answer is concrete, not
  fuzzy.

The two conditions are detected independently — a single answer can
fail one or both. When the LLM detects a fuzzy intent:

- Ask a **single targeted clarifying question** aimed at the
  condition the LLM detected (specifics, or over-breadth). Do not
  bundle both conditions into one two-part question.
- Wait for the user's response before attempting any option
  generation.
- Re-evaluate. Continue until the answer is concrete enough to
  translate, or the user explicitly closes the branch.

The over-constrained failure mode (specific answer with no meaningful
trade-off space) is **not** classified as fuzzy intent under this
rule — it is handled by the over-constrained check below.

## Scope too broad (D007)

When the LLM detects that a branch's scope is too broad to resolve
into 2–4 concrete natural options, the LLM constructs the scope
meta-question as follows:

1. Identify the high number of natural options the LLM would have
   surfaced under the broad scope.
2. Cluster those natural options into **2–3 mutually exclusive**
   candidate scopes, where selecting one candidate scope excludes
   the others.
3. Present the 2–3 candidate scopes as the scope question's options,
   marked as candidate scopes (not as the final options) and labelled
   "for example, but not limited to" so the user can still name a
   scope the LLM has not clustered.

After the user picks or names a scope, the LLM re-enters the normal
option-generation path within the chosen scope.

### Rules for candidate scopes

- **Mutually exclusive.** Selecting one candidate scope excludes the
  others. Mutual exclusivity is a glossary term parallel to
  "substantively or semantically different" for options.
- **2–3 candidate scopes.** The 2–3 cap mirrors the 2–4 cap on
  concrete natural options. More than 3 candidate scopes is itself a
  sign the scope is still too broad.
- **Do not list the underlying natural options.** Showing the
  underlying options would re-introduce the "options upfront"
  failure mode. The scopes are the only surface.
- **"For example, but not limited to"** preserves the user's right
  to name a scope outside the LLM's clustering. If the user names
  such a scope, the LLM proceeds with it, not with the candidates —
  the LLM's candidates are guidance, not a gate.
- **No invented categories.** Candidates must be clusters of real
  options, not invented categories.

## Over-constrained (D008)

When the LLM detects an over-constrained user answer, the LLM does
**not** surface the single concrete natural option directly. The LLM
runs the trade-off question:

1. Identify **2–3 potentially relevant trade-offs** the user might
   accept in exchange for a different choice.
2. Filter the list to exclude any trade-off the user has previously
   rejected or refused in the same session. Maintain a session-level
   rejection history so the LLM does not re-offer them.
3. Ask the user which of the surfaced trade-offs, if any, they would
   accept.

Then branch:

- **If the user accepts one or more trade-offs.** Surface the single
  concrete natural option AND present new concrete natural options
  constructed around the newly accepted trade-offs. A trade-off
  acceptance is treated as a new constraint the LLM uses to construct
  2–4 new options.
- **If the user accepts no new trade-offs.** Fallback: surface the
  single concrete natural option and ask the user to confirm it or
  expand the scope by naming what they would change. The fallback is
  a terminal state, not an infinite loop; the LLM does not ask
  trade-off questions indefinitely.

## The four required fields (per-option format)

Once the pre-option checks pass, present each option as a structured
block. **One sentence per field.** Write in Professional Minimalist
style: punchy, direct, clear. No filler.

- **What it is** — one sentence describing the option.
- **Benefit** — one sentence describing the gain if this option is
  chosen. Answers: "What do I get?"
- **Cost** — one sentence describing the realistic/actual sacrifice.
  Answers: "What do I definitely give up?"
- **Risk** — one sentence describing what might go wrong later.
  Answers: "What could happen in the future?"

## Format

```md
- **Option N — <Name>.** What it is: <one sentence>. Benefit: <one
  sentence>. Cost: <one sentence>. Risk: <one sentence>.
```

The `<Name>` is copied verbatim into the recommendation block when a
recommendation is produced on request — see `recommendation-format.md`.

## Worked example

**Branch opened with the open-ended prompt:**

> Within that, the part of the work is where the precondition check
> lives. What's your thinking on where the gate should sit, and what
> would "good" look like for you there?

**User responds:** "I want it to fail at the call site, and the test
scaffolding needs to be able to build partial containers."

**Translation (no fuzzy intent, scope fits, not over-constrained
after the trade-off question is resolved — assume a trade-off was
accepted that opens Option 3).** Options surfaced:

**For D007 – where the precondition check lives: pick an option, or
provide your answer.**

- **Option 1 — Constructor check.** What it is: the precondition runs
  in the tab container's constructor, throwing on null dependencies.
  Benefit: failures surface synchronously at the call site, which
  makes the bug obvious in test output. Cost: the container cannot be
  constructed for serialization or test scaffolding without supplying
  every dependency. Risk: a future caller may bypass the check with a
  factory that swallows the exception.
- **Option 2 — Static factory validation.** What it is: a `Create`
  factory runs the precondition and returns a `Result<TabContainer>`
  rather than throwing. Benefit: errors are values, not exceptions,
  and can be pattern-matched in calling code. Cost: every call site
  grows from one line to a `match` or `if let` block. Risk: a future
  developer may unwrap the result without inspecting it, silently
  discarding the failure.
- **Option 3 — Constructor check with a `TryCreate` escape hatch.**
  What it is: a constructor for normal use, plus a static
  `TryCreate` factory that returns a `Result` for test scaffolding.
  Benefit: production code keeps the throwing precondition; tests can
  build partial containers without exception handling. Cost: two
  construction paths to maintain. Risk: future developers use
  `TryCreate` in production to "tidy up" error handling.

No recommendation is produced in the default flow. The LLM waits
for the user to pick.

## Anti-patterns

- **Fewer than two options.** A "decision" with a single option is
  not a decision — present the choice or skip the branch.
- **More than four options.** A question with five-plus options is
  usually two decisions bundled together. Split it via the scope
  meta-question (D007), or sharpen the scope.
- **A "default" option that the user is steered into.** All options
  must be defensible. If the LLM believes one is correct, that
  belief is held in reserve and surfaced only if the user explicitly
  asks for a recommendation — see `recommendation-format.md`.
- **"Same as Option N" fields.** Each option must stand on its own.
  The four fields are how the user discriminates; shared fields
  defeat the test.
- **Options at branch start.** Surfacing options before the user
  has responded to the open-ended branch-starting prompt is the
  "LLM leads with options" failure mode. The pre-option checks
  above are the structural guard against it.
