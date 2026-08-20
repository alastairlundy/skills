---
name: automate-workflow-as-skill
description: >-
  Use when the user says "automate me", "turn my working style into a skill",
  "capture my preferences", "create or update my personal skill", or asks the
  agent to follow how they work. Guides the user through turning personal
  working conventions into a new or updated SKILL.md. Auto-triggers on the
  listed phrases and is also invokable by name. Harness-agnostic - works with
  any agent that loads skill files. Defers authoring to the local
  skill-architect; no worktree, push, or PR.
license: MIT
---

# Automate Workflow As Skill

A guided flow for turning the user's working conventions into a new or updated
`SKILL.md` that other agents will follow when invoked. The output is a single
`SKILL.md` the user names (for example `alastair-style` or `priya-style`).

This skill orchestrates user input and the local **`skill-architect`** skill
(for authoring). It sequences them; it does not replace either. The user is
in the loop at every step.

## When to Use

- The user asks to capture their working style into a skill (for example:
  "automate me", "turn my preferences into a skill", "make a personal skill
  for me").
- The user asks to update or revise an existing `SKILL.md` of theirs.
- The user wants a personal skill that other agents will load by name or by
  trigger phrase.
- The user's intent is ambiguous between "new skill" and "update existing
  skill" - load this skill and use the `ask-questions` skill to disambiguate
  before proceeding.

## When Not to Use

- The user wants a one-off task-specific skill (for example "how I write
  commit messages") that is not about their general working style - use
  `skill-architect` directly, no interview needed.
- The user wants to refine a single existing skill on a narrow topic - make
  the change directly or use `skill-architect`; this skill is for personal
  working-style skills specifically.
- The user wants the agent to follow their style without producing a skill
  artifact - that is a system prompt / instruction, not a skill.
- The user is in a non-interactive flow and cannot answer clarifying
  questions - this skill requires user input at multiple gates.

## Output Mode

This skill produces one new or updated `SKILL.md` file as its primary
artifact. The target directory and skill name are confirmed with the user
via `ask-questions` before any file is written. No file is written without
explicit confirmation, and no remote operation (worktree, push, PR) is
performed unless the user explicitly asks.

## Transitions

- **`skill-architect`** - handles the actual authoring of the target
  `SKILL.md` once the user's conventions are gathered (intent intake,
  deterministic translation loop, schema mapping, save).
- **`references/saving-the-skill.md`** - loaded by `skill-architect` when
  the user confirms the skill should be saved.
- **`ask-questions`** - used at multiple gates (scope, evidence preference,
  category selections, path confirmation) to keep options small and
  decisions cheap.

## Workflow

Each step has a single completion signal. Do not advance past a step until
that signal is met.

### Step 0: Confirm invocation mode

Ask the user - using the `ask-questions` skill - whether this is **a new
skill** or **an update to an existing one**. If new, ask the user to name
the skill (no naming convention is imposed). If update, ask the user for
the path to the existing `SKILL.md` so the rest of the flow can preserve
sections the user has not contradicted.

**Completion signal:** the user has confirmed new vs update, named the
skill, and - for updates - supplied the path to the existing file.

### Step 1: Decide whether to mine transcripts (default: mine)

Ask the user - using `ask-questions` - whether they want transcript mining
as an evidence source. The default recommendation in the question is
**mine**.

If the user accepts (default) or opts in:

1. Ask the user for the path to their transcript directory. **Do not glob**
   across harness paths (for example `~/.cursor/projects/*/`,
   `~/.claude/projects/*/`); that crosses project boundaries and reads
   unrelated conversations.
2. Delegate a single, scoped read of that directory to an `explorer`
   agent. Tell the explorer: (a) the directory path, (b) the skill being
   authored, (c) the signals to look for (response style, autonomy,
   subagents, prose discipline, review/verify posture, process, skill
   habits), (d) to return only high-confidence patterns (signal in 2+
   distinct sessions).
3. Use the explorer's output as additional input to Step 2. Treat it as
   evidence, not as ground truth.

If the user declines, proceed directly to Step 2.

**Completion signal:** the user has chosen mine or skip, and - if mining
 -  a scoped explorer report is in hand.

### Step 2: Interview the user

This is the primary input source. Use `ask-questions` for structured
rounds; finish with one open free-form question.

Round 1 (broad categories, multiple-choice, allow multiple): which areas
matter most? Suggested categories: response style, autonomy, subagent and
parallelism habits, prose / code discipline, review and verification,
process, skill habits. Adapt the set to what fits the user's work.

Round 2 (one or two questions per selected category): specific options
within each chosen category. Keep 4–6 options per question; let the user
add their own.

Round 3 (free-form, prose - not `ask-questions`): "Anything else an agent
following your style should know that the structured options missed?"

Limit to two structured rounds plus one open question. Do not dump twenty
questions on the user.

**Completion signal:** at least one option is selected per chosen
category from Round 1, Round 2 has run for those categories, and the user
has had a chance to add anything in Round 3.

### Step 3: Cluster findings

Group the combined signals (Round 1–3 answers plus any explorer report
from Step 1) into sections for the future `SKILL.md`. Common sections,
use only what applies:

- **Response style** - length, tone, format.
- **Autonomy** - how much to do without asking; tool use.
- **Understand first** - which skills to reach for when scoping or
  investigating a change.
- **Subagents** - defaults, parallelism, model-to-task, specialized
  workflows.
- **Prose / code discipline** - principles, lint tools, style guides.
- **Review and verify** - repro posture, verification habits,
  live-testing tools.
- **Process** - git workflow, commits, PRs, review/merge tooling.
- **Skills** - skill-authoring habits, fix-the-skill-first, proposing new
  skills.

Sparse is fine. If the user has no rules worth writing down for a section,
omit that section. Do not pad to look symmetric.

**Completion signal:** a section list is drafted, and only sections with
actual content remain.

### Step 4: Hand off to `skill-architect`

Tell the user that the next step is `skill-architect`, and hand off the
section list from Step 3 along with the user's answers from Step 2 (and
the explorer report from Step 1, if any) as the design input.

Within `skill-architect`, expect to:

- Run its Step 1 (intent intake) to confirm the goal, audience, trigger
  context, and an example or output-shape.
- Run its Step 3 (collaborative deterministic translation loop) once per
  section from Step 3, so the user can accept / modify / reject each.
- Use the `skill-architect` defaults for frontmatter shape, when-to-use /
  when-not-to-use, workflow, validation.

Do **not** paste the source cursor skill into `skill-architect` as a
template - its conventions are different from ours.

**Completion signal:** `skill-architect` has produced a converged draft
for the new or updated `SKILL.md`.

### Step 5: Light prose pass

Read the draft once end-to-end. Cut anything that is restatement of
another skill, invented metaphor, or poetic prose - agents do not benefit
from it. Keep it operational. Reference other skills by path rather than
pasting their content. Use "the user" or "the human" in imperatives, not
the author's first name; others may read or adopt the skill.

If the draft has substantive prose issues, hand back to `skill-architect`
for another loop rather than editing around it.

**Completion signal:** the draft reads end-to-end without prose issues
that need a second `skill-architect` pass.

### Step 6: Save the skill

Hand the draft to `skill-architect`'s save flow (it loads
`references/saving-the-skill.md`). Confirm the target directory and skill
name with the user via `ask-questions` before any file is written. Do not
open a pull request or push to a remote unless the user explicitly asks.

**Completion signal:** the new or updated `SKILL.md` exists at the
confirmed path, and the user has acknowledged the file.

## Validation

Before declaring done, verify each item. Each is a yes/no pass/fail
condition.

- [ ] **Invocation scope confirmed**: the user confirmed new vs update and
      named the skill at Step 0.
- [ ] **Evidence source chosen**: the user chose mine or skip at Step 1;
      if mine, the path was user-supplied and the explorer was scoped to
      that path only.
- [ ] **Interview completed**: at least one category selected in Round 1,
      Round 2 ran for each selected category, Round 3 free-form was
      offered.
- [ ] **Section list is sparse**: each section in the Step 3 list maps to
      a user-stated rule; padding sections have been dropped.
- [ ] **`skill-architect` produced the draft**: the target `SKILL.md`
      text came out of `skill-architect`'s collaborative loop, not pasted
      in from the cursor source.
- [ ] **Prose pass complete**: no restatement, metaphor, or poetic filler
      survives in the draft; other skills are referenced by path only.
- [ ] **Path confirmed before write**: the target directory and skill
      name were confirmed with the user via `ask-questions` before any
      file was created or modified.
- [ ] **File on disk**: the target `SKILL.md` exists at the confirmed
      path and the user has acknowledged it.
- [ ] **No remote side-effects**: no worktree was created, no push
      occurred, no PR was opened, no commit was made unless the user
      explicitly asked.

## Attribution

Adapted from `cursor/plugins` repository's
`pstack/skills/automate-me/SKILL.md` (MIT, © Cursor). The original skill's
flow is preserved at the step level (confirm → gather evidence →
interview → cluster → author → save); the cross-harness portability, the
swap of Cursor's `create-skill` for the local `skill-architect`, and the
removal of the source's auto PR/push step are the adaptations for this
repo.
