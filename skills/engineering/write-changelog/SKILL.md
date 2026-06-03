---
name: write-changelog
description: Generates a repo-agnostic, user-facing markdown changelog by analyzing git history, transforming commit messages, and categorizing changes into logical sub-projects.
---

## When to Use

- Creating release notes for a new version.
- Summarizing changes between two git tags or a tag and the current HEAD.
- Generating structured changelogs for monorepos with multiple sub-projects.

## When Not to Use

- For extremely large commit ranges where high-level manual curation is required.
- In repositories without any git tags or clear history.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Prior Git Tag/Commit | Yes | The starting point of the changelog range. |
| Target Branch/Commit | No | The end point of the range. Defaults to current HEAD. |
| Destination file | No | Path to save the output. If omitted, outputs to the conversation. |

## Workflow

### Step 1: Project Discovery
- Identify sub-projects/packages in a repo-agnostic manner:
    1. Scan for project files (`.csproj`, `package.json`, `go.mod`, `pom.xml`, etc.) using `glob`.
    2. If no project files are found, group by top-level directories (excluding `docs/`, `.github/`, `tests/`).
    3. If the structure is ambiguous, list detected directories and ask the user to define the packages.

### Step 2: Commit Retrieval & Analysis
- Retrieve git history for the specified range.
- For each commit, determine the category using a tiered analysis:
    1. **Conventional Commit Check**: Check for `feat:`, `fix:`, `chore:`, `refactor:`, `perf:`, `docs:`.
    2. **Diff Analysis**: If ambiguous, analyze the `git diff` for additions, removals, or modifications.
    3. **User Guidance**: If still unclear, present the commit message and diff to the user and ask for the correct category and description.

### Step 3: Message Transformation
- Rewrite commit messages to be "changelog style":
    - Convert imperative ("Add X") to descriptive ("Added X").
    - Remove technical noise (e.g., "closes #123", JIRA IDs).
    - Summarize long, rambling messages into concise, impact-focused sentences.
    - Validate the transformation against the diff to ensure no meaning is lost.

### Step 4: Markdown Construction
- Start the document with: `## Changes since [Prior Git Tag]`
- Organize the layout as follows:
    1. **Global/Infrastructure Section**: Changes at the root or in global folders.
    2. **Sub-project Sections**: Grouped by the packages identified in Step 1.
- Within each section, group changes by category in the following order:
    - 🆕 Additions
    - 🗑️ Removals
    - ⚙️ Modifications
    - 🐛 Bug Fixes
    - 📄 Non Source Code
    - ⚠️ Deprecations
- Use markdown bullet points for each entry.

### Step 5: Output Phase
- If a destination file is provided, check if it exists. If so, ask the user for permission to overwrite before writing.
- Otherwise, output the final markdown string to the conversation.

## Validation

- [ ] The header accurately reflects the starting Git tag.
- [ ] Changes are grouped by sub-projects and categorized by impact.
- [ ] Commit messages are transformed from developer-style to user-facing style.
- [ ] "Non Source Code" changes are appropriately split between Global and Package sections.

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Incorrect project mapping | Ensure the discovery process prioritizes project files over simple directory names. |
| Over-simplifying messages | Always validate the rewritten message against the `git diff` to ensure technical accuracy. |
| Missing category | Fall back to "Modifications" if a change is source-code related but doesn't fit elsewhere. |
