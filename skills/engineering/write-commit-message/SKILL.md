---
name: write-commit-message
description: >-
  Drafts clear, high-quality git commit messages from a diff, choosing between Conventional Commits format and plain non-conventional format from an explicit request or the repo's commit history. Use when the user wants to write or draft a commit message for proposed or staged changes. Do not use for reviewing or critiquing an existing commit message (use review-commit-message) or for generating changelogs (use write-changelog).
license: MIT
---

# Write commit message

The goal of this skill is to produce git commit messages that provide lasting value to future readers by clearly articulating both the "what" and the "why" of a change. The message may be plain (non-conventional) or Conventional Commits format; Step 2 selects the format before any drafting begins.

## When to Use

- Finalizing a new feature implementation.
- Documenting a bug fix and its root cause.
- Recording the reasoning behind a refactor.
- Consolidating multiple small changes into a meaningful commit.
- When user input would clarify which commit format to use, invoke ask-questions.

## When Not to Use

- Trivial changes (e.g., fixing a single typo in a comment) that do not require a detailed explanation, although a clear subject line is still required.
- Reviewing, grading, or critiquing an already-written commit message - use `review-commit-message`.
- Generating release notes or changelogs from git history - use `write-changelog`.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Git Diff | Yes | The output of `git diff` containing the changes to be committed. |
| Context | No | Additional information about the task, issue tracker IDs, or project-specific requirements. |
| Branch | No | The current branch name to help identify the context (e.g., feature vs hotfix). |
| Format request | No | An explicit request for Conventional Commits format or for plain/non-conventional format. |

## Workflow

### Step 1: Analyze Changes
Examine the provided git diff. If no git diff is provided as input, return the exact error: "Error: Expected a Git diff but one was not provided."

### Step 2: Select the commit format
Decide between Conventional Commits and non-conventional output. Apply the rules in this exact order; the first rule that fires decides the format:

1. **Explicit request wins.** If the user asked for Conventional Commits format (or named a specific convention), use Conventional Commits. If the user asked for plain, free-form, or "normal" format, use non-conventional output.
2. **Repo standard detection.** Otherwise, inspect the repository's commit history with `git log --format=%s -n 20` (up to the 20 most recent non-merge subjects). Count a subject as conventional if it matches `<type>[optional scope][!]: <description>` where `<type>` is one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. If more than half of the counted subjects match, use Conventional Commits.
3. **Derived default.** If neither an explicit request nor a detectable repo standard exists (no usable git history, or no majority match), default to non-conventional output and flag the default to the user in one line: "No commit convention detected - wrote a plain commit message; tell me if this repo uses Conventional Commits." The user may correct it.

When the format is Conventional Commits, load `references/specification.md` before drafting; the inline rules below mirror that specification and the two must be kept together.

Conventional rules that apply from this point onward:
- **Types**: use `feat` for new user-facing features, `fix` for bug fixes; other types (`docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`) for non-functional changes.
- **Subject shape**: `<type>(<scope>): <description>` - scope is a noun in parentheses (e.g., `fix(parser):`), description is imperative, no trailing period.
- **Breaking changes**: mark with `!` before the colon (e.g., `feat(api)!: drop v1 endpoints`) and/or a `BREAKING CHANGE:` footer describing the break.
- **Footers**: optional, one blank line after the body or subject, each `token: value` or `token #value` (e.g., `Refs: #123`, `Closes: #456`). `BREAKING CHANGE` must be uppercase.

### Step 3: Identify "What" and "Why"
Determine the primary purpose of the change. Distinguish between the mechanical change (what happened) and the rationale (why it was necessary and what it solves).

### Step 4: Draft Subject Line
Create a concise summary of the change.
- Maximum 50 characters (non-conventional and conventional alike).
- Use the imperative mood (e.g., "Fix", "Add", "Update" instead of "Fixed", "Adds", "Updated").
- Non-conventional only: capitalize the first letter.
- Conventional only: start with the type/scope prefix from Step 2.
- Avoid including specific file paths, long variable names, or "old vs new" values in the subject; move these details to the body.

### Step 5: Draft Message Body
Write a detailed description explaining the reasoning and impact.
- Maximum 1000 characters.
- Focus on the "why" (the problem it solves) and "how" (the high-level approach), rather than listing every line changed.
- Use a blank line between the subject and the body.

### Step 6: Add Footers (Conventional format only)
If the change has a linked issue, a breaking change described in the footer, or a revert reference, append footers one blank line after the body or subject using `token: value` or `token #value` format. Skip this step for non-conventional output.

### Step 7: Final Review
Review the draft against the quality criteria in the Validation section.
- Specifically for the subject line, perform a "Draft -> Count -> Trim" loop: count the exact characters of the subject line; if it exceeds 50 characters, rewrite it to be more concise by removing technical specifics (e.g., namespaces, file paths) while retaining the core intent.

## Examples

### Good Example (non-conventional)
`Fix race condition in user session timeout`

`The session timeout timer was not being reset on active requests, causing users to be logged out while actively interacting with the API. This change ensures the timer is refreshed on every authenticated request.`

### Good Example (conventional)
`fix(api): resolve race condition in session timeout`

`The session timeout timer was not being reset on active requests, causing users to be logged out while actively interacting with the API. This change ensures the timer is refreshed on every authenticated request.

Refs: #482`

### Bad Example
`fix bug`
`updates`
`wip: working on the login screen`

## Validation

- [ ] Step 2 ran before any drafting, and its decision order was followed (explicit request → repo history → non-conventional default with the one-line flag).
- [ ] For Conventional Commits output, `references/specification.md` was loaded before drafting.
- [ ] The subject line is 50 characters or fewer.
- [ ] Conventional output starts with a valid type, uses imperative description, and does not end with a period.
- [ ] Breaking changes are marked with `!` and/or a `BREAKING CHANGE:` footer (conventional output only).
- [ ] The body explains the reasoning ("why") behind the change.
- [ ] The body is 1000 characters or fewer.
- [ ] The language is clear, unambiguous, and articulated for a reader six months from now.
- [ ] There is a blank line between the subject and the body.

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Drafting before choosing a format | Run Step 2 first; format choice shapes the subject line from the start. |
| Vague descriptions | Avoid "fixed things" or "updated code". Describe the specific problem solved. |
| Over-detailing "what" | Don't list every file changed; the diff already does that. Focus on the intent. |
| Using past tense | Use the imperative mood: "Add feature" instead of "Added feature". |
| Over-descriptive subject lines | Including too many technical details (like file paths or specific variables) in the subject. Keep the subject for "what" and the body for "how/where". |
| Invented conventional types | Use only the types listed in Step 2; `feat` and `fix` strictly for user-facing features and bug fixes. |
| Silent format default | When Step 2 falls through to the derived default, flag it to the user in one line. |

## Final Output Format
Return ONLY the final commit message. 
Do not include your internal analysis, the step-by-step workflow, 
the validation checklist, or any conversational filler (e.g., "Here is the message").
The output must start immediately with the subject line.
