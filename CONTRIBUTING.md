# Contributing to Skills

This guide covers how to contribute skills and improvements to this repository.

## Types of Contributions

### 1. Creating New Skills

**Before creating a new skill, open an issue to discuss your proposal.** This allows maintainers to:
- Evaluate whether the skill fits the repository's scope and goals
- Discuss the skill's design, workflow, and boundaries before implementation
- Ensure the skill doesn't duplicate existing functionality
- Provide feedback on structure and conventions early

Drive-by PRs (unsolicited pull requests without prior discussion) are discouraged. They may be accepted on a case-by-case basis if they clearly align with the repository's goals and follow all conventions, but opening an issue first significantly increases the likelihood of acceptance.

See [CREATING-SKILLS.md](CREATING-SKILLS.md) for the complete guide on skill structure and conventions.

**After discussion, quick start:**
1. Create `skills/<category>/<skill-name>/SKILL.md`
2. Include all required sections: frontmatter, When to Use, When Not to Use, Workflow, Validation
3. Ensure all workflow steps are deterministic
4. Add evaluation test cases (`evals.json` or Waza eval suite)
5. Test the skill manually before submitting

### 2. Improving Existing Skills

When modifying an existing skill:

1. **Understand the current behavior** — Read the skill and its evaluation suite
2. **Identify the improvement** — Bug fix, missing scenario, unclear instruction, etc.
3. **Update the skill** — Make changes following the conventions in CREATING-SKILLS.md
4. **Update or add evals** — Ensure your changes don't break existing tests; add tests for new behavior
5. **Test thoroughly** — Run the skill through representative scenarios

### 3. Evaluating Skills

Use the Waza CLI to evaluate skill performance and trigger accuracy.

**Prerequisites:**
- Install [Waza CLI](https://github.com/microsoft/waza)
- Ensure the skill has a Waza-compatible eval suite (`eval.yaml` + `tasks/` + `fixtures/`)

**Running an evaluation:**

```bash
# Run performance evaluation with baseline comparison
waza run --baseline

# Run with multiple trials for trigger evaluation
waza run --trials 5

# Launch interactive dashboard
waza serve
```

**What the evaluation measures:**
- **Performance lift** — How much better the skill performs vs. no skill
- **Trigger accuracy** — Whether the skill triggers when it should and doesn't when it shouldn't
- **Diagnostic insights** — Per-failure analysis with conservative and structural fix prescriptions

**Important:** The evaluator diagnoses issues but does not modify skills. Apply fixes manually based on the diagnostic report.

### 4. AI-Assisted Skill Creation

For complex skills or when you need help translating fuzzy requirements into deterministic workflows, use the `skill-architect` skill.

**When to use skill-architect:**
- You have a high-level goal but no concrete workflow
- You need to refine ambiguous agent behaviors into deterministic steps
- You want to ensure the skill adheres to project standards before implementation

**Workflow:**
1. Load the `skill-architect` skill
2. Describe your skill's intent and target scenarios
3. Collaborate with the agent to translate intent into deterministic steps
4. Review the generated SKILL.md content
5. Request the agent to write the skill to the file system when ready

**Note:** For straightforward skills with clear workflows, you can write the SKILL.md directly without using skill-architect.

## Contribution Guidelines

### Code Style

- Use kebab-case for skill names and file names
- Follow the exact section structure specified in CREATING-SKILLS.md
- Use markdown formatting consistently
- Keep descriptions concise but complete

### Documentation

- Update CONTEXT.md if introducing new domain terms
- Create ADRs in `docs/adr/` for hard-to-reverse architectural decisions
- Ensure all referenced files and paths are accurate

### Testing Requirements

Before submitting a contribution:

- [ ] Skill loads without errors
- [ ] Workflow steps are deterministic and testable
- [ ] Evaluation suite covers key scenarios (performance and trigger tests)
- [ ] Manual testing confirms expected behavior
- [ ] Documentation is accurate and complete

### Pull Request Process

1. **Fork and branch** — Create a feature branch from `main`
2. **Make changes** — Follow the guidelines above
3. **Test locally** — Verify the skill works as expected
4. **Update documentation** — Ensure README, CONTEXT.md, and ADRs are current
5. **Submit PR** — Provide clear description of changes and testing performed
6. **Address feedback** — Respond to review comments promptly

## Questions?

- Check existing skills in `skills/` for examples
- Review CONTEXT.md for domain terminology
- Consult docs/adr/ for architectural decisions
- Open an issue for clarification or discussion
