# Decision Ledger

Topic: Locked question format redesign for the `engineering/grilling` skill
(parent of `domain-grilling` and `code-implementation-grilling`). Re-opens
the D009 "Ignore" triage in `DECISIONS-code-impl-grilling-token-efficiency.md`
in light of four reported issues.

## Records

### [D001] — session goal

- **Driver**: the user wants the grilling skill to be less arduous in
  conciseness-encouraging harnesses, in cases where the user has
  pre-stated direction, and in cases where the user has already answered
  the Socratic question, while keeping the skill's value (Decision
  Ledger, options/recommendation formats, tone discipline, convergence
  test).
- **Resolved Answer**: "Fixing the issues with the grilling skill so that
  it is less arduous to use whilst still retaining its key grilling
  aspects."
- **Normalized Requirement**: The engineering/grilling skill (and its
  shared references consumed by `domain-grilling` and
  `code-implementation-grilling`) shall be redesigned so that the
  per-branch locked question format is less arduous under the four
  conditions the user named, while preserving the Decision Ledger
  pattern, the options/recommendation formats, the tone discipline, and
  the convergence test.
- **Constraints**: Key grilling aspects must be retained. The four issues
  named in the user's opening message are in scope: (1) excessive
  terseness in conciseness-encouraging harnesses; (2) the locked
  question format is still emitted after the user has already answered
  the Socratic question (a well-behaved model follows the format, a
  weaker model skips it — both bad); (3) the goal/direction is asked
  twice (D001 goal discovery + per-branch Socratic question); (4) the
  per-branch Socratic question conflicts with the ability to provide an
  answer upfront. The user has stated that "something has to give":
  either the per-branch direction ask is dropped, or the
  answer-upfront capability is dropped — the user has not yet chosen.

### [D002] — high-level design strategy for the per-branch question

- **Driver**: the user wants the per-branch format to be less arduous
  (the current 3-turn separation is too rigid in tight harnesses and
  feels bureaucratic), while preserving the Socratic function
  (per-branch direction-surfacing) and avoiding mental offload (the
  user should not delegate their thinking to the model by just picking
  options without articulating direction).
- **Resolved Answer**: "I think we keep the direction elicitation but
  make it optional. The user gets a chance to steer the direction of
  the options but isn't forced to. In the next turn the user gets the
  locked question format and the options, inviting them to choose an
  option, hybridize, or provide their own answer."
- **Normalized Requirement**: The engineering/grilling skill's
  per-branch format shall consist of two turns: (a) Turn 1 — context
  block (the four elements Goal, Prior decisions, Stakes, Scope) and
  the Socratic elicitation question, presented as an optional
  invitation to steer the direction of the options; the user may
  engage with the elicitation to influence the options, or decline
  and let the agent proceed with the default framing; (b) Turn 2 —
  the locked question line presented together with the options
  (preceded by the reference-set preamble) and the recommendation,
  inviting the user to choose an option, hybridize, or provide their
  own answer. The 3-turn separation (context+Socratic, locked
  question, options+recommendation) is collapsed to a 2-turn
  separation (context+optional Socratic, then locked question +
  options + recommendation together).
- **Constraints**: The Socratic question is kept (not dropped) and made
  optional rather than mandatory; the agent always asks it in Turn 1
  but the user may decline without penalty. The 4-element context
  block, the locked question framing, the reference-set preamble, the
  options/recommendation formats, the convergence test, the tone
  discipline, the Decision Ledger, and the post-pick step are
  preserved unchanged. The user retains the ability to answer upfront
  in Turn 2 (pick an option, hybridize, or provide their own answer).
  Option 1 (drop the Socratic question entirely), Option 2 (combine
  the two questions into a single line in one turn), Option 3
  (conditional Socratic question via direction detection), and Option
  4 (soften the locked question line, drop the Socratic question) are
  all out of scope for the v1.2 skill revision per this branch.
  Sub-decisions deferred to later branches: the exact wording of the
  optional Socratic question; the agent's behavior when the user
  declines the elicitation; the agent's behavior when the user engages
  (how the direction influences the options); the locked question
  line's exact wording under the new combined turn.

### [D003] — wording of the optional Socratic question

- **Driver**: the user wants the Socratic question to invite
  direction-surfacing (so the user can steer the options) while making
  skipping acceptable (so the user isn't pressured to engage), which
  preserves the Socratic function without forcing engagement.
- **Resolved Answer**: "Option A - Direct question makes the most sense
  and is closest to what we want to accomplish"
- **Normalized Requirement**: The optional Socratic question in Turn 1
  shall be worded as: "What are you working toward in this decision?
  You may answer, or skip and see the options as-is." The wording
  combines a direct question (inviting direction-surfacing) with an
  explicit opt-out (making skipping acceptable). The skill shall
  include an explicit instruction that the Socratic question is
  optional, so weaker models do not treat the user's response as a
  mandatory answer; the agent shall recognize a skip (e.g., "skip",
  "no", "as-is", or a no-op response) and proceed to Turn 2 in the
  next user turn.
- **Constraints**: The wording is fixed as above. The "you may answer,
  or skip" clause is part of the wording and is not optional. The
  4-element context block, the locked question framing, the
  reference-set preamble, the options/recommendation formats, the
  convergence test, the tone discipline, the Decision Ledger, and the
  post-pick step are preserved unchanged. Options B (light check-in),
  C (meta-question about steering), and D (hybrid check-in) are out of
  scope for the v1.2 skill revision per this branch. Sub-decisions
  deferred to later branches: the agent's behavior when the user
  engages (how the direction influences the options); the agent's
  behavior when the user declines; the locked question line's exact
  wording under the new combined turn.

### [D004] — wording of the locked question line in Turn 2

- **Driver**: the user wants the locked question line in Turn 2 to be a
  concise invitation that matches the user's stated direction ("choose
  an option, hybridize, or provide their own answer") and preserves
  traceability via the `Dxxx` and branch name, without pressuring any
  one response type.
- **Resolved Answer**: "Option 1"
- **Normalized Requirement**: The locked question line in Turn 2 shall
  be worded as: "**For [Dxxx] – [branch name]: pick an option,
  hybridize, or provide your own answer.**" The wording is a concise
  invitation that names the branch (for traceability) and presents
  three equally valid response options (pick, hybridize, provide). The
  skill shall include an explicit instruction that all three response
  types are equally valid, so weaker models do not default to a
  closed-ended "pick one" framing and do not treat the line as
  demanding a specific answer format.
- **Constraints**: The wording is fixed as above. The `[Dxxx]` and
  `[branch name]` placeholders are filled in from the Decision Ledger
  per the existing convention (`max(existing) + 1` for `Dxxx`; short
  descriptive name for the branch). The 4-element context block, the
  optional Socratic question wording (per D003), the reference-set
  preamble, the options/recommendation formats, the convergence test,
  the tone discipline, the Decision Ledger, and the post-pick step are
  preserved unchanged. Options 2 (direct question + invitation), 3
  (keep current wording minus the rigid clause), and 4 (combine with
  the reference-set preamble) are out of scope for the v1.2 skill
  revision per this branch. Sub-decisions deferred to later branches:
  the agent's behavior when the user engages with the Socratic
  question (how the direction influences the options); the agent's
  behavior when the user declines the elicitation.

### [D005] — engage case: how the agent uses the direction to influence the options

- **Driver**: the user wants the direction from the Socratic question to
  actually steer the options (a too-light touch means the options are
  generic and the user's input is wasted; a too-heavy touch means the
  agent filters out options the user might have wanted to see), while
  preserving the user's access to the full choice space.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: When the user engages with the optional
  Socratic question in Turn 1 (i.e., provides a direction rather than
  declining), the agent shall use the direction as a steering signal to
  inform the option names, the "What it is" descriptions, and the
  recommendation's `Reasoning` field in Turn 2. The underlying choice
  space is unchanged; the options are reframed in terms of the
  direction. The reframing is a soft signal across all options, not a
  filter.
- **Constraints**: The direction is a steering signal, not a hard
  constraint; defensible options are not dropped. The 4-element
  context block, the optional Socratic question wording (per D003),
  the locked question line wording (per D004), the reference-set
  preamble, the options/recommendation formats, the convergence test,
  the tone discipline, the Decision Ledger, and the post-pick step are
  preserved unchanged. The skill shall include an explicit instruction
  that the reframing is a soft signal across all options, so weaker
  models do not filter options based on the direction. Options B (hard
  filter), C (add direction as a 5th context element), and D (use
  direction only in the recommendation's reasoning) are out of scope
  for the v1.2 skill revision per this branch. The agent's behavior
  when the user declines the elicitation is a separate branch
  (forthcoming).
- **Future branch (queued by the user)**: code-implementation-grilling
  does not follow the same context format as the parent grilling
  skill; this branch is to be opened later in the same session to
  diagnose the deviation and decide on the fix.

### [D006] — code-impl context format: diagnose the deviation, then fix

- **Driver**: the user reported that code-implementation-grilling does
  not follow the same context format as the parent grilling skill; the
  user wants a precise fix, so diagnosing the specific deviation first
  is more accurate than guessing the fix upfront.
- **Resolved Answer**: "Option A is likely to be more accurate so let's
  go with that"
- **Normalized Requirement**: The agent shall diagnose the specific
  deviation in code-implementation-grilling's context block by reading
  the skill and its reference files and comparing them to the parent's
  4-element context block (Goal, Prior decisions, Stakes, Scope). The
  diagnosis shall produce a concrete list of differences, organized as
  one or more of: missing elements (parent has, code-impl does not),
  extra elements (code-impl has, parent does not), different ordering,
  or inconsistent application. The diagnosis is read-only; the fix is
  a separate branch that depends on the diagnosis.
- **Constraints**: The diagnosis is read-only (no edits to the
  code-implementation-grilling skill or its references until the
  diagnosis is reviewed and the fix is decided). The parent's
  4-element context block is the reference format. The diagnosis
  covers the context block specifically, not the full per-branch
  format (the per-branch format changes from D002-D005 apply to the
  parent and will propagate to code-implementation-grilling in a
  separate branch). Options B (apply parent's 4-element block
  verbatim), C (same block plus code-specific elements), and D
  (redesign with a code-specific context block) are deferred to the
  fix branch, which depends on the diagnosis.

### [D007] — reach parity: validation checklist context block check

- **Driver**: the user wants the code-implementation-grilling skill to
  reach parity with the parent grilling skill's validation checklist;
  the 4-element context block check is present in the parent's
  validation but missing from the code-impl skill's
  `references/validation.md`, so the agent may emit a non-parity
  context block for code branches and the gap will not be caught at
  validation time.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: Add to the
  code-implementation-grilling skill's `references/validation.md` the
  check: "Every context block was emitted as the four-element bullet
  list (Goal, Prior decisions, Stakes, Scope) in that order, each
  element exactly one sentence, with ledger citations. The context
  block was not replaced with a free-form prose summary, a 'current
  state' investigation, a code reading, a domain-glossary recap, or
  any other kind of analysis." The check is an exact copy of the
  parent grilling skill's validation check.
- **Constraints**: The check is the verbatim parent check. The rest of
  the code-impl validation checklist is unchanged. Options B
  (code-impl-specific check that references the parent) and C (four
  separate checks, one per element) are out of scope for the v1.2
  skill revision per this branch. The other 7 deviations from D006 are
  queued for subsequent branches: #5 output selection option format,
  #7 Driver field on Txxx, #1/#2/#4 exploratory; #6/#7 Cites/#8
  deferred.

### [D008] — reach parity: output selection option format

- **Driver**: the user wants the Output Selection step in
  code-implementation-grilling to use the parent grilling skill's
  4-field option format for full parity; the current "What /
  Trade-offs / Risks" format is less structured and inconsistent with
  the rest of the grilling skills.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: Update the
  code-implementation-grilling skill's `references/output-selection.md`
  Part A (Output format) so both Option A (Implementation Blueprint)
  and Option B (PRD Augmentation) use the parent grilling skill's
  4-field format: "What it is" (one sentence describing the option),
  "Benefit" (one sentence describing the gain), "Cost" (one sentence
  describing the sacrifice), "Risk" (one sentence describing the most
  likely failure mode). Rename "Trade-offs" to "Benefit" and "Risks"
  to "Risk" to match the parent. The skill shall include an explicit
  instruction that each field is one sentence and that all four
  fields are required.
- **Constraints**: The format is the verbatim parent 4-field format.
  Part B (Downstream consumer) is unchanged. Options B
  (code-impl-specific 4-field format) and C (keep "Trade-offs" naming)
  are out of scope for the v1.2 skill revision per this branch. The
  other deviations are queued for subsequent branches: #7 Driver
  field on Txxx, #1/#2/#4 exploratory; #6/#7 Cites/#8 deferred.

### [D009] — reach parity: Txxx record template Driver field

- **Driver**: the user wants the Txxx record template in
  code-implementation-grilling to include the `Driver` field for
  parity with the parent grilling skill's Dxxx template; without the
  `Driver` field, the user's underlying principle or motivation for
  each technical decision is not captured, and the ledger loses the
  "why" that makes the decision auditable.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: Update the
  code-implementation-grilling skill's `references/recording-decisions.md`
  so the Txxx template has five fields in order: `Driver` (one to two
  sentences — the user's underlying principle or motivation, matching
  the parent's Dxxx template; write `None.` if no principle is
  articulated), `Resolved Answer` (verbatim user choice), `Normalized
  Requirement` (concise, testable statement), `Constraints` (negative
  requirements, edge cases, or defaults), `Cites` (Dxxx or earlier
  Txxx ids whose constraints the answer respects). The `Driver` field
  is required, not optional, and the skill shall include an explicit
  instruction that the `Driver` must be specific to the user's stated
  principle, not a generic restatement of the resolved answer.
- **Constraints**: The Txxx template matches the parent's Dxxx template
  plus the existing `Cites` field (which stays as-is per the user's
  triage of the Cites deviation as deferred). Options B
  (code-impl-specific Driver wording) and C (optional Driver field)
  are out of scope for the v1.2 skill revision per this branch. The
  other deviations are queued for subsequent branches: #1, #2, #4
  exploratory; #6, #7 Cites, #8 deferred.

### [D010] — explore: TDP list surfacing context block exclusion

- **Driver**: the user wants to resolve the TDP list surfacing
  deviation in code-implementation-grilling Step 5.2; the TDP list
  surfacing is a meta-step (presenting the list of TDPs in
  dependency order) rather than a branch decision, so the context
  block (which is for branches) does not apply on this turn.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: The TDP list surfacing in
  `code-implementation-grilling/SKILL.md` Step 5.2 shall remain as a
  meta-step that does not emit the context block. The skill shall
  include an explicit instruction that the TDP list surfacing is a
  meta-step (not a branch) and that the context block is not emitted
  on this turn, so weaker models do not treat it as a branch and emit
  a non-parity context block. The first TDP's full context block
  appears in the next turn when the agent begins resolving the first
  TDP.
- **Constraints**: The deviation is kept (justified by the meta-step
  nature of the turn). The parent's "every branch has a context
  block" rule is preserved (the TDP list surfacing is not a branch).
  Options B (include full context block on the TDP list surfacing
  turn), C (brief 1-2 sentence summary), and D (5th element for the
  TDP list) are out of scope for the v1.2 skill revision per this
  branch. The other deviations are queued for subsequent branches:
  #2, #4 exploratory; #6, #7 Cites, #8 deferred.

### [D011] — explore: spec context in code-impl context block

- **Driver**: the user wants spec content (functional requirements,
  acceptance criteria) to be captured in the
  code-implementation-grilling context block so the agent has full
  context for code branches and the user can see which spec section
  each branch addresses; without spec content in the context block,
  the agent's context is incomplete and the user may lose track of
  the spec mapping.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: Extend the context block for
  code-implementation-grilling branches to five elements: Goal, Prior
  decisions, Stakes, Scope (the parent's four elements, unchanged),
  and "Spec section" (one sentence naming the spec file path and the
  specific section or functional requirement the branch addresses,
  with an inline citation such as `specs/feature-x.md §3.2`). The 5th
  element is required for every code-impl branch; the citation must
  include the spec file path and the specific section or requirement.
  The skill shall include an explicit instruction that the 5th
  element is required and that the citation format is fixed.
- **Constraints**: The 5th element is purely additive; the parent's
  four elements (Goal, Prior decisions, Stakes, Scope) stay aligned.
  The D007 validation check is updated to verify the 5th element is
  present for code-impl branches. Options B (citations in existing 4
  elements only), C (promote spec to Goal element), and D (replace
  with a code-impl-specific context block) are out of scope for the
  v1.2 skill revision per this branch. The other deviations are
  queued for subsequent branches: #4 exploratory; #6, #7 Cites, #8
  deferred.

### [D012] — explore: Interface & Model Branch question format

- **Driver**: the user wants the Interface & Model Branch in
  code-implementation-grilling to use the parent grilling skill's
  locked question format for per-decision questions (architectural
  decisions, source-of-truth conflicts, type introductions) while
  keeping the lightweight meta-questions for phase transitions
  (count questions, ready-to-move questions); the meta-questions
  serve a pacing function that the parent's formal format would
  over-engineer.
- **Resolved Answer**: "Option C"
- **Normalized Requirement**: The Interface & Model Branch in
  `code-implementation-grilling/references/interface-and-model-branch.md`
  shall use a hybrid format: per-decision questions (architectural
  decisions, source-of-truth conflicts, type introductions) follow
  the parent grilling skill's locked question format (context block
  with the 5-element code-impl variant per D011, plus the optional
  Socratic question, the concise locked question line per D004, and
  the options + recommendation); phase-transition meta-questions
  (count questions such as "How many architectural decisions do you
  want to resolve? (0-3)" and ready-to-move questions such as "Ready
  to move to Source of Truth?") keep their current lightweight
  format. The skill shall include an explicit instruction that
  distinguishes phase-transition meta-questions (not subject to the
  locked question format) from per-decision questions (subject to
  the locked question format), so weaker models apply the right
  format to the right question type.
- **Constraints**: The phase-transition meta-questions keep their
  current format. The per-decision questions follow the parent's
  locked question format with the 5-element code-impl context block
  per D011. Options A (keep the deviation entirely), B (convert all
  to parent's format), and D (restructure with formal branches) are
  out of scope for the v1.2 skill revision per this branch. The
  other deviations are queued for subsequent branches or deferred:
  #6 (Type Loop) and #7 Cites deferred; #8 (Re-shaped context
  preambles) deferred to the code-impl token-efficiency ledger.

### [D013] — decline case: agent behavior when user skips Socratic question

- **Driver**: the user wants the decline case to be the default
  behavior (proceed to Turn 2 with options framed on the branch
  context, no direction extraction); the decline case is what most
  users will hit when the branch context is clear, so the default
  behavior should be simple and lightweight.
- **Resolved Answer**: "Option A"
- **Normalized Requirement**: When the user declines the optional
  Socratic question in Turn 1 (e.g., "skip", "no", "as-is", or a
  no-op response), the agent shall recognize the decline and proceed
  to Turn 2 in the next user turn. The options are framed on the
  branch context (Goal, Prior decisions, Stakes, Scope) without
  steering; the recommendation's `Reasoning` field is based on the
  branch context, not on a direction. The agent shall not try to
  extract direction from a "skip" response. The skill shall include
  an explicit instruction that a decline is recognized by specific
  signals ("skip", "no", "as-is", or a no-op response) and that the
  agent proceeds to Turn 2 without re-asking or extracting direction.
- **Constraints**: The decline case is the default behavior. Options
  B (decline confirmation before Turn 2) and C (treat decline the
  same as engage but without the steering signal) are out of scope
  for the v1.2 skill revision per this branch. The deferred items
  from D006 (#6 Type Loop, #7 Cites on Txxx, #8 Re-shaped context
  preambles) are not open follow-ups in this session — they are
  explicitly deferred to other decisions or other ledgers per the
  user's triage, and the Decision Ledger captures the deferral
  reasons in the relevant records' Constraints.

<!-- next-id: D014 -->
