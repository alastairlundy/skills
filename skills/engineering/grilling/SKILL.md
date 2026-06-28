---
name: grilling
description: >-
  Relentless Socratic interviewing to extract clear decisions from vague ideas.
  Use when the user wants to think through an ambiguous decision that is neither
  code/tech (defer to `code-implementation-grilling`) nor domain modeling or
  terminology alignment (defer to `domain-grilling`) — business strategy,
  product direction, design choices, process, organizational decisions, and
  similar non-implementation decisions.
license: MIT
---

# Grilling

A relentless Socratic interviewing skill. The user has a vague decision; the
agent walks it down a tree of branches, presents options with trade-offs, and
records the resolved answer in a Decision Ledger. The session ends when a
shared understanding is reached and the user picks an exit path.

This skill is the **generic parent** of `domain-grilling` and
`code-implementation-grilling`. It owns the core machinery — the Decision
Ledger, the options/recommendation formats, the branch-starting prompt, tone
discipline, convergence test. The two specializations add their own
initialization (glossary for domain; spec-reading and tech foundation for
code) and defer to this skill for the core.

## When to Use

- When the user has a vague idea, ambiguous goal, or undecided direction
  and wants the agent to help think it through.
- The decision is **not** primarily about code/tech implementation and
  **not** primarily about domain modeling or terminology.
- Examples: business strategy pivots, product direction, design choices,
  process changes, organizational structure, hiring, pricing, marketing
  positioning, partnership decisions.
- When user input would clarify the request, invoke ask-questions

## When Not to Use

- For code/technical implementation choices (language, framework, dependencies,
  project structure) when a spec/PRD exists — defer to
  `code-implementation-grilling`.
- For domain modeling, ubiquitous language, bounded contexts, glossary, or
  terminology alignment — defer to `domain-grilling`.
- For trivial questions with a clear answer (no grilling needed).
- For executing a decision that has already been made (no grilling needed).
- For implementation, debugging, or code review (no grilling needed).

## Workflow

### Step 1: Load the references

Before the first user question, load and read in full:

- `references/decision-ledger.md` — Decision Ledger path derivation,
  `Dxxx` record format, lazy creation, soft cap, re-opens.
- `references/options-format.md` — the four-field option block
  (What it is / Benefit / Cost / Risk), the eight concrete-natural-option
  criteria, the fuzzy-intent clarifying loop, the scope-too-broad
  meta-question, and the over-constrained trade-off branch.
- `references/recommendation-format.md` — on-demand recommendation only;
  the LLM does not produce a recommendation in the default flow and does
  not pre-suggest.
- `references/locked-question-format.md` — the locked question template
  used at every branch after the LLM has translated the user's answer
  into options.
- `references/branch-starting-prompt.md` — the canonical open-ended
  prompt used to start every branch.
- `references/tone-and-output.md` — tone discipline, forbidden filler
  words, branch transitions, neutral mirroring.
- `references/convergence-test.md` — the four-check convergence test and
  the diverge modes to avoid.

Apply the formats from those files verbatim throughout the session. Do
not paraphrase, abbreviate, or modify the formats. If any of those files
is missing or unreadable, abort the session and report the missing file
to the user.

### Step 2: Decision Ledger state summary

Scan `docs/decisions/DECISIONS-*.md` for any existing ledger that matches
the feature being grilled. If one exists, read it end-to-end and report to
the user:

- The highest existing `Dxxx` number — the next record is `Dxxx + 1`.
- Any unresolved contradictions between existing records.
- The branches already covered, so the user can see what is in scope for
  the current session.

If no matching ledger exists, derive the path
`docs/decisions/DECISIONS-<repo>-<feature>.md` (where `<repo>` is the
directory name of the working repository and `<feature>` is a short
kebab-case slug of the topic) and confirm the path with the user before
the first append.

### Step 3: Open the branch with an open-ended question

Open the first decision branch using the canonical open-ended
branch-starting prompt from `references/branch-starting-prompt.md`. The
prompt is a two-part structure: (a) the LLM's paraphrase of the user's
aim, in the LLM's own voice; (b) a dimension-led open question that
names the branch and the dimension of the user's thinking the LLM is
asking about, with a **comma** (not an em-dash) connecting it to a
follow-on "what would 'good' look like for you there?".

The LLM does **not** lead with options at branch start. The LLM waits
for the user to respond with their thinking on the dimension before
attempting any translation into options.

### Step 4: Translate the user's answer into options

After the user responds, translate the answer into 2–4 concrete natural
options per `references/options-format.md`. The translation is the
LLM's primary work, not a generated list: the LLM paraphrases the
user's words rather than inventing, and each option must satisfy all
eight concrete-natural-option criteria in the reference.

Apply the following checks in order, looping back to the user as
needed. Do not surface options while any check fails.

1. **Fuzzy intent (D004).** If the user's answer is fuzzy — unstated
   specifics or under-constrained — ask a single targeted clarifying
   question, wait for the response, and re-evaluate. Continue until the
   answer is concrete enough to translate or the user explicitly closes
   the branch. See `references/options-format.md` § Fuzzy Intent.
2. **Scope too broad (D007).** If the answer translates to more than
   four natural options, the scope is too broad. Ask the scope
   meta-question — see `references/options-format.md` § Scope Too
   Broad — and re-enter Step 4 with the chosen scope.
3. **Over-constrained (D008).** If the answer translates to a single
   defensible option, the answer is over-constrained. Ask the
   trade-off question — see `references/options-format.md` §
   Over-Constrained — and branch: if the user accepts one or more
   trade-offs, surface the single option and 1–3 new options built
   around the accepted trade-offs; if not, surface the single option
   and ask the user to confirm it or expand the scope.

When the translation yields 2–4 defensible concrete natural options,
proceed to Step 5.

### Step 5: Present the options

Present the options to the user using the locked question format from
`references/locked-question-format.md`. The question template is
`For [Dxxx] – [branch name]: pick an option, or provide your answer.`
with the `Dxxx` and name verbatim.

**Do not produce a recommendation in the default flow.** Per
`docs/adr/0003-recommendations-on-demand-only.md` (D005), the LLM
surfaces a recommendation only if the user explicitly asks for one
("what's your take?", "what do you think?", "what would you do?"). The
LLM shall not pre-suggest ("would you like my take?") at the end of a
branch.

### Step 6: Record and continue

After the user resolves a branch, immediately append a `Dxxx` record to
the Decision Ledger using the template in
`references/decision-ledger.md`. Do not batch the writes — append
after each resolution, before opening the next branch.

Apply the tone discipline from `references/tone-and-output.md` on every
branch transition: no evaluative openers, neutral mirroring, structural
transitions.

### Step 7: Convergence

Before declaring convergence, run the four-check convergence test from
`references/convergence-test.md`. If any check fails, continue grilling
(or re-open the affected branch). When all four pass, declare: "We have
reached a shared understanding."

### Step 8: Exit paths

Once convergence is declared, offer the user the exit paths appropriate
to the type of decision reached. Every exit that drives downstream
action must include the Decision Ledger path so downstream skills can
cite records as `filename#Dxxx`.

- **Document the decision** — write a decision memo or notes file that
  cites the ledger records as `filename#Dxxx`. Suitable when the outcome is
  a decision the user will act on later, not a body of work to be implemented.
- **Hand off to `domain-grilling`** — if the discussion surfaced DDD
  concerns (bounded contexts, ubiquitous language, glossary) that need
  a deeper domain pass. The new skill inherits the existing ledger and
  continues with `Dxxx` records.
- **Hand off to `code-implementation-grilling`** — if the discussion
  surfaced implementation choices (language, framework, dependencies)
  and a spec/PRD exists or can be created. The new skill inherits the
  ledger and continues with `Txxx` records.
- **Break into tickets or issues** — if the decision has produced
  discrete action items. Use `spec-to-tickets` (with the ledger) or
  `to-issues` for simpler flat decomposition.
- **Handoff to another agent** — pass the Decision Ledger path as the
  source of truth.
- **Custom save** — save the shared understanding in another way,
  citing records as `filename#Dxxx` so citations survive file relocation.

## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] All seven reference files were loaded and read in full before the
      first user question.
- [ ] If any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] Decision Ledger path was derived (or located) and confirmed with
      the user before the first write.
- [ ] Existing Decision Ledger state was summarized to the user before
      the first question.
- [ ] Every branch was opened with the canonical open-ended
      branch-starting prompt from `references/branch-starting-prompt.md`,
      and the LLM did not surface options before the user responded.
- [ ] Every set of options contained 2–4 concrete natural options
      satisfying the eight criteria in
      `references/options-format.md` § Concrete Natural Option.
- [ ] The fuzzy-intent clarifying loop was applied when the user's
      answer was fuzzy; no options were surfaced while a fuzzy intent
      was unresolved.
- [ ] The scope-too-broad meta-question was applied when the answer
      translated to more than four natural options; the chosen scope
      preceded option generation.
- [ ] The over-constrained trade-off branch was applied when the answer
      translated to a single defensible option.
- [ ] No recommendation was produced in the default flow of any
      branch. A recommendation appeared only if the user explicitly
      asked for one; the LLM did not pre-suggest ("would you like my
      take?").
- [ ] When a recommendation was produced on request, it used the
      three-field breakdown (`Recommendation: Option N — <name>.`,
      `Reasoning: ...`, `Forward risk: ...`) with the option name
      copied verbatim.
- [ ] One Decision Ledger record was appended immediately after every
      resolved branch (no batching at session end).
- [ ] Every record used the inline template (`Resolved Answer`,
      `Normalized Requirement`, `Constraints`) and a fresh `Dxxx` ID
      incremented from the highest existing one.
- [ ] Re-opened branches produced a new record with a `Supersedes: Dxxx`
      line in `Constraints` rather than amending the prior record.
- [ ] Every question used the locked format
      `For [Dxxx] – [branch name]: pick an option, or provide your answer.`
      with the `Dxxx` and name verbatim.
- [ ] No sentence began with a word whose function is to praise or
      judge the user's prior input.
- [ ] No forbidden filler word appeared in any agent turn
      (`basically`, `essentially`, `actually`, `just`, `simply`,
      `in order to`, `it is important to note`, `it's worth noting`,
      `keep in mind`, `note that`, `needless to say`,
      `at the end of the day`, `when all is said and done`).
- [ ] Convergence was declared only when all four checks
      (all branches resolved, no contradictions, no new question in
      the last three turns, Decision Ledger complete) passed.
- [ ] No diverge mode occurred (no paraphrasing the verbatim answer,
      no skipping a branch, no bundling options, no accepting a
      contradictory answer without a `Supersedes: Dxxx` record).
- [ ] The chosen exit was handed off with the Decision Ledger path so
      downstream skills (memos, tickets, specialized grilling) can
      cite records as `filename#Dxxx`.
- [ ] Every citation of a Decision Ledger record from outside the ledger
      file used the `filename#Dxxx` format (e.g.,
      `DECISIONS-repo-feature.md#D001`), not a bare `Dxxx` ID.
