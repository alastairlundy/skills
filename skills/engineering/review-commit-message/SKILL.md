---
name: review-commit-message
description: >-
  Judges the quality of an existing git commit message against its diff using objective quantitative and qualitative criteria, with constructive feedback and optional detailed critique. Use when the user wants to review, audit, score, or critique a commit message, or asks how to improve one. Do not use for drafting a new commit message (use write-commit-message) or for automated linting where a script is sufficient.
license: MIT
---

# Review commit message

This skill provides a framework for assessing the quality of git commit messages, ensuring they are clear, concise, and informative for future maintainers. It pairs with `write-commit-message`: that skill drafts, this one judges.

## When to Use

- Reviewing a draft commit message before finalizing.
- Auditing a history of commits for consistency and quality.
- Providing feedback to developers on commit message best practices.
- When the required context (e.g., which diff belongs to which message) is ambiguous, invoke ask-questions.

## When Not to Use

- When the git diff is unavailable (judgment requires understanding the context of changes).
- For purely automated linting where a script is sufficient (this skill is for AI-driven qualitative analysis).
- For drafting a replacement message from scratch - use `write-commit-message`.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Commit Message | Yes | The full text of the commit message including subject and body. |
| Git Diff | Yes | The associated git diff showing the changes made in the commit. |

## Workflow

### Step 1: Input Validation

Verify that both the **Commit Message** and the **Git Diff** are provided. 
- If either is missing, inform the user that both are required for a meaningful evaluation and decline to provide a judgment.

### Step 2: Quantitative Analysis

Check the message against the following hard limits:
- **Subject Line**: Must be less than 50 characters.
- **Description**: Must be less than 1000 characters.

### Step 3: Qualitative Evaluation

Assess the content based on the following criteria:
- **Clarity**: Is the message unambiguous and clear?
- **Cleanliness**: Is it free from inappropriate or irrelevant content?
- **Accessibility**: Is the summary light on jargon?
- **Intent**: Does it focus on "what" and "why" (rather than just "how") to ensure future readability?

When the repo or the message uses Conventional Commits format, additionally verify the prefix against `write-commit-message`'s Step 2 rules (valid type, imperative description, no trailing period, `!` or `BREAKING CHANGE:` for breaking changes).

### Step 4: Assessment and Correction

- Provide a fair assessment with a clear rationale based on the criteria above.
- Identify any spelling or grammar mistakes and provide respectful corrections.

### Step 5: Detailed Critique (Conditional)

If the user specifically asks for a "detailed critique" or "how to improve", provide the following:
- **Shortcomings**: Highlight weaknesses respectfully.
- **Actionable Tweaks**: Provide specific, quick fixes/rewrites.
- **Pattern Recognition**: Suggest broader patterns for future reference.
- **Positive Feedback**: Point out what was done well.

## Tone and Style Guidelines

- **Be Constructive**: Ensure all feedback is specific and helpful.
- **Professionalism**: Maintain respect; do not judge the user personally.
- **Authenticity**: Avoid false sincerity and unwarranted praise.
- **Balance**: Acknowledge "great" messages without demanding absolute perfection.

## Validation

- [ ] Both commit message and diff are present before analysis begins.
- [ ] Subject line length is verified (< 50 chars).
- [ ] Body length is verified (< 1000 chars).
- [ ] Evaluation covers both "what" and "why".
- [ ] Conventional-format messages (when present) were additionally checked against the Step 3 prefix rules.
- [ ] Spelling/grammar corrections are provided if necessary.

## Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Judging without the diff | Enforce Step 1; decline until both inputs are present. |
| Nitpicking style over substance | Weight "what"/"why" intent above wording preferences in Step 3. |
| Feedback without rationale | Every shortcoming in Step 4 cites the specific criterion it violates. |
| Treating length limits as suggestions | The Step 2 limits are hard; flag any breach explicitly. |
