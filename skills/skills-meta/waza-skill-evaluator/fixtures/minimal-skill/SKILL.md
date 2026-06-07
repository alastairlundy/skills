---
name: sample-target-skill
description: A sample skill used as a test fixture for the waza-skill-evaluator eval suite. This skill has no eval files, triggering Phase 1 guidance.
---

# Sample Target Skill

This is a minimal skill directory used as a test fixture. It contains a valid SKILL.md with frontmatter but intentionally has no eval.yaml, tasks/, or fixtures/ directories.

## When to Use

- When testing the waza-skill-evaluator's Phase 1 suite validation workflow.

## When Not to Use

- For any purpose other than as a test fixture.

## Workflow

### Step 1: Placeholder

This skill has no real workflow steps. It exists solely to verify that the evaluator detects the missing eval suite and references eval-generation.md.
