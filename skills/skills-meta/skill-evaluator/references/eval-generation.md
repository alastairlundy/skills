# Eval Suite Generation Workflow

This document describes the process for generating a comprehensive evaluation suite for a skill, ensuring that both trigger accuracy and performance can be rigorously measured.

## 1. Identifying "Tracer Bullet" Scenarios
Tracer bullets are the minimum viable set of test cases that exercise the core value proposition of the skill. 

- **Identify Key Capabilities**: List the primary features or problems the skill is designed to solve.
- **Define Critical Paths**: For each capability, identify the "golden path" and the most common "failure path".
- **Draft Scenarios**: Create short, representative prompts that would realistically trigger the skill in a real-world engineering context.

## 2. Defining Success Criteria (Assertions)
To avoid subjective grading, each evaluation must have objectively verifiable success criteria.

### Assertion Types
- **Binary**: The output contains a specific keyword or follows a specific format (e.g., "Contains `/local-review-uncommitted`").
- **Structural**: The response follows a specific template or includes required sections (e.g., "Contains both a Summary and a Prescription section").
- **Functional**: The output can be executed (if applicable) or matches a known good output (golden file).
- **Negative**: The response must NOT contain certain elements (e.g., "Does not suggest creating a file when requested to review").

### Defining the Assertion
Every eval should have a clear assertion:
`Assertion: The response must [specific requirement].`

## 3. Eval Suite Construction
The `evals.json` file should be structured to support both Performance and Trigger tracks.

### Performance Evals
Focus on the quality of the result given that the skill triggered.
- **Input**: A prompt that clearly intends to use the skill.
- **Expected**: The assertion criteria defined above.

### Trigger Evals
Focus on whether the skill triggers when it should, and does not trigger when it shouldn't.
- **Input**: A variety of prompts: some explicitly calling the skill, some implicitly requiring it, and some that are similar but should NOT trigger it.
- **Expected**: Trigger/No-Trigger result.
- **Surgical Prompt**: A minimal "YES/NO" check to verify the trigger event in isolated probes.


## 4. User Approval Loop
The agent must not generate and execute evaluations without user oversight.

1. **Propose Scenarios**: The agent presents the identified Tracer Bullet scenarios and assertions.
2. **Review and Refine**: The user reviews the scenarios and adjusts the assertions or adds missing cases.
3. **Confirm Suite**: The user explicitly approves the final set of evaluations.
4. **Generate JSON**: Only after approval, the agent writes the `evals.json` file.
