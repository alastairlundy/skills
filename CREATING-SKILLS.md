# Creating Skills

This guide explains how to create agent skills for this repository.

## Skill File Structure

Every skill must be placed in `skills/<category>/<skill-name>/SKILL.md` where:
- `<category>` is either `engineering/` (domain tasks) or `skills-meta/` (creating/evaluating skills)
- `<skill-name>` is a kebab-case identifier

If your skill doesn't fit into an existing category, open an issue to discuss creating a new category before submitting.

## Required SKILL.md Sections

Every `SKILL.md` must contain:

### 1. YAML Frontmatter

```yaml
---
name: skill-name
description: Concise description of what the skill does and when to use it
---
```

The `description` field is critical for skill discovery — it determines when the skill triggers.

### 2. When to Use

Define precise triggers for the skill. List specific scenarios where the skill should be activated.

### 3. When Not to Use

Define clear boundaries to prevent misuse. List scenarios where the skill should NOT be used, and suggest alternatives when appropriate.

### 4. Workflow

Document the sequence of steps the agent should follow. **All steps must be deterministic** — no vague language like "be smart", "as appropriate", or "handle accordingly".

Each step should be:
- Actionable and specific
- Testable against observable outcomes
- Free of ambiguity about what constitutes completion

### 5. Validation

Provide a checklist that allows agents to verify they have correctly followed the skill's workflow. Each item should be verifiable against the skill's output or process.

## Optional Files

### evals.json

Define evaluation test cases for the skill:

```json
{
  "performance": [
    {
      "id": "test-1",
      "description": "What this test validates",
      "input": "The input to provide to the skill",
      "assertion": "regex or description of expected output"
    }
  ],
  "trigger": [
    {
      "id": "trigger-1",
      "description": "Should trigger on this input",
      "input": "Test input",
      "expected": "trigger"
    },
    {
      "id": "trigger-2",
      "description": "Should NOT trigger on this input",
      "input": "Test input",
      "expected": "no-trigger"
    }
  ]
}
```

### evals/

Every skill must include a Waza Eval Suite in `evals/<skill-name>/`:
- `eval.yaml` — evaluation configuration
- `tasks/` — individual task definitions
- `fixtures/` — test inputs and expected outputs

Run evaluations with `waza run` and serve the eval UI with `waza serve`.

See the [Waza documentation](https://github.com/microsoft/waza) for format details.

## Design Principles

### Determinism Over Flexibility

Skills must work reliably across different AI models and contexts. Prefer explicit instructions over implicit assumptions.

**Bad:** "Analyze the code and make appropriate improvements"

**Good:** "1. Read all .ts files in src/. 2. For each file, check for unused imports. 3. Remove any import not referenced in the file body. 4. Run `npm run lint` to verify no errors."

### Context Awareness

Skills should reference the repository's domain documentation:
- Read `CONTEXT.md` for domain terminology
- Check `docs/adr/` for architectural decisions
- Use the glossary vocabulary consistently

### Bounded Scope

Each skill should solve one specific problem. If a skill is trying to do too much, split it into multiple skills with clear boundaries.

## Testing Your Skill

Before submitting a skill:

1. **Manual testing** — Load the skill and run it through representative scenarios
2. **Trigger testing** — Verify the skill triggers when it should and doesn't trigger when it shouldn't
3. **Eval suite** — Create `evals.json` or Waza eval suite covering key scenarios
4. **Peer review** — Have another developer review the skill for clarity and completeness

## Example Skill Structure

```
skills/
└── engineering/
    └── example-skill/
        ├── SKILL.md
        ├── evals.json
        └── README.md (optional, for complex skills)
```

## Getting Help

- Review existing skills in `skills/` for examples
- Check `CONTEXT.md` for domain terminology
- Consult `docs/adr/` for architectural decisions affecting skill design
