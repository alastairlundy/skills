# Eval Suite Generation Workflow

This document describes the process for generating a comprehensive evaluation suite for a skill using the Waza YAML eval format. It covers scenario design methodology, the Waza YAML structure, validator selection, and the user approval loop.

## 1. Identifying "Tracer Bullet" Scenarios

Tracer bullets are the minimum viable set of test cases that exercise the core value proposition of the skill. Each scenario is a vertical slice that is independently verifiable.

- **Identify Key Capabilities**: List the primary features or problems the skill is designed to solve.
- **Define Critical Paths**: For each capability, identify the "golden path" and the most common "failure path".
- **Draft Scenarios**: Create short, representative prompts that would realistically trigger the skill in a real-world engineering context.

Each scenario should be a self-contained vertical slice: a prompt, the expected behavior, and a way to verify the outcome. Scenarios must be independently runnable and verifiable without depending on other scenarios.

## 2. Waza YAML Eval Structure

A Waza eval suite consists of three parts:

### `eval.yaml` (Suite Metadata)

The top-level file that defines the eval suite identity, configuration, and task references.

```yaml
name: my-skill-eval
description: Evaluate the my-skill agent skill
skill: my-skill
version: "1.0"

config:
  trials_per_task: 3
  timeout_seconds: 300
  parallel: false

tasks:
  - include: tasks/*.yaml
```

| Field | Purpose |
|-------|---------|
| `name` | Unique identifier for this eval suite |
| `skill` | Name of the skill being evaluated |
| `version` | Eval spec version (default: `"1.0"`) |
| `config` | Runtime settings: trials, timeout, parallelism |
| `tasks` | Glob patterns referencing task files in `tasks/` |

### `tasks/` (Task Definitions)

Individual YAML files, each containing one or more task definitions. A task pairs a prompt with expected behavior and validator configurations.

```yaml
- id: trigger-basic-usage
  name: "Trigger: basic skill usage"
  prompt: "Can you evaluate my code-review skill?"
  expected: "Should activate the code-review skill"
  validators:
    - type: regex
      config:
        pattern: "code.review|skill.*triggered"
```

| Field | Purpose |
|-------|---------|
| `id` | Unique task identifier |
| `name` | Human-readable task name |
| `prompt` | The input prompt sent to the agent |
| `expected` | Description of expected behavior |
| `validators` | List of validator configurations to verify the outcome |

### `fixtures/` (Test Data)

Static files, mock inputs, and setup data that tasks reference. Waza copies fixtures into an isolated temp workspace for each task execution, so originals are never modified.

```
my-skill-eval/
├── eval.yaml
├── tasks/
│   ├── performance.yaml
│   └── triggers.yaml
└── fixtures/
    ├── sample-input.txt
    ├── expected-output.md
    └── mock-project/
        └── src/
            └── main.go
```

## 3. Assertion Type Mapping

Map the conceptual assertion types to specific Waza validators:

| Assertion Type | Description | Waza Validator | Example |
|---------------|-------------|----------------|---------|
| **Binary** (pass/fail pattern match) | Output contains a specific keyword or follows a format | `regex` or `text` | Output contains `/local-review-uncommitted` |
| **Structural** (code structure, file existence) | Response follows a template or includes required sections | `code` or `text` | Generated code compiles; output contains both Summary and Recommended Fix sections |
| **Functional** (behavioral outcomes, tool usage) | Output can be executed or matches known-good behavior | `behavior` or `diff` | Agent called the correct tool; file written to expected path |
| **Negative** (absence of pattern) | Response must NOT contain certain elements | `regex` with negative pattern | Output does not contain `rm -rf` |

### Validator Reference

| Validator | What it checks |
|-----------|---------------|
| `regex` | Output matches a regex pattern |
| `text` | Exact or fuzzy text comparison |
| `code` | Code compiles or passes syntax check |
| `behavior` | Runtime behavior, tool-call verification, side-effect observation |
| `action_sequence` | Specific sequence of actions or tool calls occurred in order |
| `diff` | Snapshot comparison, structural diff against expected output |

## 4. Generation Tools

### `waza new eval`

Scaffolds a new eval suite from scratch, creating the directory structure with starter files:

```bash
waza new eval my-skill-eval
```

Creates:
```
my-skill-eval/
├── eval.yaml          # Suite metadata with placeholder values
├── tasks/
│   └── example.yaml   # Example task definition
└── fixtures/
    └── example.txt    # Example fixture file
```

Use this when starting a new eval suite from scratch or when you want full control over the scenario design.

### `waza suggest`

Generates AI-assisted task suggestions based on the skill's SKILL.md content:

```bash
waza suggest path/to/SKILL.md --output-dir ./my-skill-eval
```

Parses the skill's frontmatter (name, description) and workflow sections to propose tasks covering the skill's key capabilities. Use this as a starting point, then refine the generated tasks with the user.

## 5. User Approval Loop

The agent must not generate and execute evaluations without user oversight.

1. **Propose Scenarios**: Present the identified tracer bullet scenarios and their associated validators to the user.
2. **Review and Refine**: The user reviews the scenarios and adjusts the validators, adds missing cases, or removes unnecessary ones.
3. **Confirm Suite**: The user explicitly approves the final set of evaluations.
4. **Generate YAML**: Only after approval, write the `eval.yaml`, task files, and fixture files.

## 6. Deterministic vs Soft Assertions

### Deterministic Assertions (Waza Validators)

Use Waza validators when the outcome can be verified by pattern matching, compilation, tool-call verification, or structural comparison. These produce definitive pass/fail results with no ambiguity.

**When to use:**
- Output must contain specific keywords or patterns → `regex`
- Generated code must compile or pass syntax checks → `code`
- Agent must call specific tools in a specific order → `action_sequence`
- Output must match an expected structure → `diff`
- Agent must produce specific text or sections → `text`
- Agent must perform specific runtime actions → `behavior`

**Example — deterministic task with multiple validators:**

```yaml
- id: perf-generate-and-compile
  name: "Performance: generate compilable code"
  prompt: "Generate a Go function that validates an email address"
  expected: "Must produce valid Go code that compiles and contains a regex pattern"
  validators:
    - type: code
      config:
        language: go
    - type: regex
      config:
        pattern: "func.*[Vv]alidate.*[Ee]mail"
    - type: text
      config:
        pattern: "regexp"
```

### Soft Assertions (Agent-Graded)

Use agent-based grading when the outcome is qualitative and cannot be deterministically verified. These require LLM judgment against a rubric.

**When to use:**
- Tone or style requirements (e.g., "professional tone")
- Quality assessments (e.g., "analysis is insightful")
- Clarity or structure evaluation (e.g., "explanation is well-organized")
- Domain expertise demonstration (e.g., "response shows deep understanding")

**Design guidance for soft assertions:**
- Define a clear rubric with specific criteria for pass/fail
- Provide examples of passing and failing outputs in fixtures
- Run soft-assertion tasks with multiple trials (`trials_per_task: 3` or higher) to account for LLM variance
- Pair soft assertions with at least one deterministic validator where possible to anchor quality

**Example — task with both deterministic and soft validation:**

```yaml
- id: perf-diagnostic-report
  name: "Performance: diagnostic report quality"
  prompt: "Analyze this failing test suite and produce a diagnostic report"
  expected: "Report must contain a summary section and provide actionable recommendations"
  validators:
    - type: text
      config:
        pattern: "## Summary"
    - type: regex
      config:
        pattern: "recommend|suggestion|fix|action"
  grading:
    type: llm
    rubric: |
      Score 1-5 on:
      1. Correctness: Are the identified root causes accurate?
      2. Actionability: Can the developer act on each recommendation?
      3. Clarity: Is the report well-structured and easy to follow?
    threshold: 3
```

### Decision Matrix

| Question | If Yes | If No |
|----------|--------|-------|
| Can the outcome be checked by pattern matching? | Use `regex` or `text` validator | → |
| Can the outcome be checked by compilation? | Use `code` validator | → |
| Can the outcome be checked by tool-call inspection? | Use `behavior` or `action_sequence` validator | → |
| Can the outcome be checked by structural comparison? | Use `diff` validator | → |
| Is the outcome qualitative (tone, insight, clarity)? | → | Use `llm` grading with rubric |
