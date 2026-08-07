# Locked Question Format

When asking the user to choose between options, the agent uses an exact
template. The format is locked because it makes the question
unmistakable: the user sees a stable line that means "this is a grilling
question, and here is the branch it belongs to."

## Convention: "you" in this reference

In this reference, "you" and "your" inside a blockquote, a backticked
template, or a worked-example emission **always refer to the user**, not
the LLM. The locked question line, the conflict callout, and any other
user-facing template in this reference are addressed to the user. Emit
them verbatim and wait for the user to respond before proceeding.
Free-form instructions to the agent in this reference use "the LLM" or
"the agent" to refer to the agent.

## The wrapper

Every locked question uses a fixed wrapper emitted **once per round**,
regardless of how many branches are inside the round. The wrapper is
a single agent turn — there is no inter-turn wait between components.

The fixed order is:

1. **Round header** — identifies the round number.
2. **Frontier statement** — how many branches remain total, how many
   are unblocked this round.
3. **Context block** — the 4-row table grounding the branch.
4. **Conflict/contradiction callout** (conditional) — only when a
   conflict or contradiction is detected.
5. **Options table** — the 5-column reference set (per
   `references/options-format.md`).
6. **Recommendation** — the 2-line lean block (per
   `references/recommendation-format.md`).

Components that are empty are omitted (not left blank). The round
header, frontier statement, context block, options table, and
recommendation are always present. The conflict/contradiction callout
is conditional on conflict detection.

### Component 1 — Round header

```md
### Round [N]
```

`[N]` is the round number starting at 1. The header is always present.

### Component 2 — Frontier statement

```md
[N] branches remain, [M] unblocked this round.
```

`[N]` is the total number of unresolved branches across all rounds.
`[M]` is the number surfaced in this round (at most 3). If `[M]` equals
`[N]`, the frontier statement is still emitted.

### Component 3 — Context block

The context block is a **4-row markdown table** with a header row and
3 data rows in fixed order. Each data row's Content is exactly one
sentence drawn from the Decision Ledger and the user's stated goal.
Cite path-qualified `filename#Dxxx` IDs in the Goal and Prior decisions rows.

| Element         | Content                                                                     |
|-----------------|-----------------------------------------------------------------------------|
| **Goal**        | <one sentence — the goal of the overall decision, citing the goal record as `filename#Dxxx`>             |
| **Prior decisions** | <one sentence — the prior decisions affecting this branch, with path-qualified `filename#Dxxx` citations> |
| **Scope**       | <one sentence — what is in and out of scope for this branch>               |

The context block is **not** a free-form prose summary, a "current
state of the type" reading, a code investigation, a domain-glossary
recap, or any other kind of analysis. If the agent has done a code
reading or an investigation, that work belongs in the agent's
reasoning, not in the user-facing context block. If the agent wants
to surface that information to the user, paraphrase it into one of
the three elements (typically **Scope**) or present it as a separate
explicit step *before* the context block with its own heading — never
in place of the table.

### Component 4 — Conflict/contradiction callout (conditional)

Only emitted when conflict detection fires before the branch
resolves. The callout appears between the context block and the options
table.

**Static conflict** (two records with mutually-exclusive Normalized
Requirements):

```md
> **Conflict detected.** [filename#Dxxx] and [Dyyy] have contradictory
> Normalized Requirements: "<quote from filename#Dxxx>" vs. "<quote from Dyyy>".
> Which resolution stands?
```

**Dynamic contradiction** (new resolution contradicts a prior
resolution):

```md
> **Contradiction detected.** Your answer contradicts [filename#Dxxx]
> ("<brief quote of Resolved Answer>"). Would you like to confirm
> your new answer, revise it, or re-open the prior branch?
```

The callout does not re-introduce the Socratic elicitation turn
It is a fixed-format notification, not an open-ended question.

### Component 5 — Options table

Present the 5-column options table from `references/options-format.md`,
preceded by the reference-set preamble:

```md
Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.
```

The options table is the reference set the user picks from. See
`references/options-format.md` for the table shape, cell caps, and
defensible-options guidance.

### Component 6 — Recommendation

Present the 2-line lean recommendation block from
`references/recommendation-format.md` below the options table. See
that reference for the exact format (option letter + period, reasoning
sentence).

## Re-ask mechanic

Each branch may be re-asked at most once. The re-ask uses the same
1-turn wrapper format with a fixed preamble:

```md
> **Final re-ask.** This is your last chance to clarify, confirm, or
> revise your answer on [branch name]. If no clear answer is provided,
> the branch will close without resolution.
```

The preamble is emitted before the context block. After 1 re-ask with
no clear answer, the branch closes with `Resolved Answer = "DEFERRED"`
and a `Constraints` line noting why. The same `filename#Dxxx` record is
updated; no new record is created for the re-ask itself.

The re-ask must not re-introduce the Socratic elicitation turn. It
uses the identical wrapper format as the initial branch emission.

## Rules

- **Use the same `filename#Dxxx` and name verbatim in every question for that
  branch.** Do not rephrase, abbreviate, or rename mid-session.
- **One turn per branch — hard stop.** Emit the full wrapper
  (round header through recommendation), then stop and wait for
  the user's response. The agent must not split the wrapper across
  multiple turns.
- **One question per turn — hard stop.** Emit exactly one locked
  question (one branch's wrapper), then stop generating. No
  exceptions, no escape hatches, no self-check mechanisms. Asking
  multiple questions at once confuses the user.
- **The context block is mandatory for every branch.** Do not skip it,
  even when the prior decisions are few or the scope seems obvious.
- **All three response types in the locked question line are equally
  valid.** The agent must not default to a closed-ended "pick one"
  framing and must not treat the line as demanding a specific answer
  format.
- **Do not replace the context block with a free-form prose summary,
  a code reading, or an investigation.** The context block is the
  4-row table above, in order, each element one sentence, each
  filled in from the Decision Ledger and the user's stated goal.
- **Conflict callouts are fixed-format.** Use the exact "Conflict
  detected" or "Contradiction detected" wording. Do not paraphrase
  or extend the callout with open-ended questions.

## Worked example — round with 2 branches

```md
### Round 1

3 branches remain, 2 unblocked this round.

| Element          | Content                                                                  |
|------------------|--------------------------------------------------------------------------|
| **Goal**         | Find a pricing model that supports growth without alienating customers (D001). |
| **Prior decisions** | No prior branch decisions yet.                                        |
| **Scope**        | This branch covers the pricing model structure; it does not cover feature gating. |

**For D002 – pricing model: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Per-seat** | Price scales with number of users on the account. | Revenue tracks usage; easy to justify to buyers. | Existing flat-rate customers see a price increase. | Small teams may share accounts to avoid seats. |
| B — Flat tier | Fixed price per plan tier regardless of users. | Predictable for customers; simple billing. | Revenue does not scale with adoption. | Large teams get outsized value at flat cost. |

**Recommendation: A.**
**Reasoning:** Per-seat aligns with your goal of growth-friendly pricing — revenue scales with adoption, which is the mechanism you need.

<user picks A>

Resolved: per-seat pricing model.

| Element          | Content                                                                  |
|------------------|--------------------------------------------------------------------------|
| **Goal**         | Find a pricing model that supports growth without alienating customers (D001). |
| **Prior decisions** | D002 established per-seat pricing.                                   |
| **Scope**        | This branch covers the transition timeline; it does not cover legacy grandfathering. |

**For D003 – transition timeline: pick an option, hybridize, or provide
your own answer.**

Here are options to help you refine or confirm your answer. Pick one,
reject all, or hybridize.

| Option | What it is | Benefit | Cost | Risk |
|--------|-----------|---------|------|------|
| **A — Immediate** | Switch all accounts to per-seat on the next billing cycle. | Clean cutover; no dual-system overhead. | Existing customers face an immediate price change. | Churn spike from sticker shock. |
| B — 90-day grace | Give existing customers 90 days at current rate before switching. | Retention buffer; time to communicate value. | Revenue delay; dual-system billing complexity. | Customers delay migration to avoid price increase. |

**Recommendation: A.**
**Reasoning:** Immediate switch aligns with your goal of clean growth pricing — the grace period delays the revenue signal you need.
```
