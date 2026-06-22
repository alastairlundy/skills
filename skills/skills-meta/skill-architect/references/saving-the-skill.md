# Saving the Skill to Disk

Load this reference when the user has accepted a skill design and asked the LLM to write it to the file system. Do not load it during the design phase.

## Attribution

This procedure is adapted from the `create-skill` skill in the [dotnet/skills](https://github.com/dotnet/skills) repository, licensed under MIT by the .NET Foundation and Contributors. The name-validation rules, frontmatter shape, and post-write checklist below derive from that work. The directory-layout assumptions and the eval-stub step are adapted to a more general convention; the user is asked to confirm the target directory rather than assuming a repo-specific path.

## Procedure

### 1. Confirm the target directory with the user

The convention `<skill-name>/SKILL.md` is general, but the *parent* directory is not. Ask the user, in one line, which directory the skill sub-directory should go in. For example:

- `skills/<category>/<skill-name>/SKILL.md` (this repo's convention, where `<category>` is one of `engineering`, `alignment`, `skills-meta`).
- `plugins/<plugin>/skills/<skill-name>/SKILL.md` (the dotnet/skills convention).
- Any other path the user specifies.

Do not infer the parent directory from prior context. Ask.

### 2. Validate the skill name

Confirm the `name` from the design:

- Contains only lowercase letters, numbers, and hyphens.
- Does not start or end with a hyphen.
- Does not contain consecutive hyphens (`--`).
- Is between 1 and 64 characters.

If any rule fails, ask the user for a corrected name before writing.

### 3. Create the directory

Create the skill sub-directory at `<parent>/<skill-name>/`. The `SKILL.md` file will be created at `<parent>/<skill-name>/SKILL.md`.

### 4. Confirm the license with the user

Ask the user, in one line, which license the new skill should be released under. Common choices include `MIT`, `Apache-2.0`, `BSD-3-Clause`, and `GPL-3.0`. The user may also defer the decision — in that case, omit the `license` field from the frontmatter and surface the open question in the completion report. Do not default to a license on the user's behalf.

### 5. Write SKILL.md

Write the file with the schema inlined in `SKILL.md` Step 4:

- YAML frontmatter with `name`, `description` (using `>-` block-fold syntax), and `license` (only if the user confirmed one in Step 4).
- H1 title matching the skill name (Title Case is acceptable).
- Sections: **When to Use**, **When Not to Use**, **Workflow**, **Validation**. The Output Mode and Transitions sections are required for `skill-architect`-style skills; mirror the conventions of the skill being saved.
- The body must remain under 500 lines. If the design exceeds this, move supporting content to `references/` files and load them by trigger from the body.

### 6. Optional: seed the eval directory

If the skill is being saved into a repository that uses the Waza Eval Suite convention (one example: this repo, `skills/<category>/<skill-name>/`), create a stub `evals/<skill-name>/` directory with:

- `eval.yaml` — evaluation configuration. Defer content to the `waza-skill-evaluator` skill if available.
- `tasks/` — task definitions (initially empty).
- `fixtures/` — test inputs and expected outputs (initially empty).

If the user is not using the Waza Eval Suite, skip this step.

### 7. Validate the file

Before reporting completion, verify:

- [ ] Skill name in frontmatter matches the directory name exactly.
- [ ] Skill name is lowercase with hyphens only; no leading, trailing, or consecutive hyphens.
- [ ] Description is non-empty and under 1024 characters.
- [ ] Description uses `>-` block-fold syntax.
- [ ] `license` is present in frontmatter only if the user confirmed a license in Step 4; if the user deferred, the field is omitted and the open question is surfaced in the completion report.
- [ ] All mandatory sections (When to Use, When Not to Use, Workflow, Validation) are present.
- [ ] SKILL.md body is under 500 lines.
- [ ] File references use relative paths.
- [ ] Instructions are specific and actionable (verb-led, concrete action, verifiable outcome).
- [ ] No secrets, tokens, or internal URLs are included.

If any item fails, fix the file and re-check before reporting completion.
