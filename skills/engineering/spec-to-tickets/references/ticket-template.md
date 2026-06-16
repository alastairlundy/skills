# Ticket Template

```yaml
---
title: <short descriptive name>
classification: <Independent|Collaborative>
blocked_by: [<ticket references or empty>]
parent: <spec reference>
---
```

**blocked_by reference format by output target:**
- Issue tracker: issue numbers (e.g., `#42`)
- Local markdown: zero-padded file basenames without extension (e.g., `001-authentication`)

## Goal

Brief statement of what this ticket accomplishes and why it matters. One to three sentences - enough to orient a reader without requiring them to read the full ticket.

## What to build

Description of the end-to-end behavior with sufficient context for an implementer to understand what to do and why. Describe what the system should do and the outcomes it must achieve. Include file paths when they help the implementer orient themselves, but avoid prescribing exact file paths or code snippets as implementation requirements unless the file structure is itself a deliverable. Exceptions - if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note that it came from a prototype.

## Recommended Workflow

A step-by-step breakdown of how to implement this ticket. Always present (minimum 1 step), even for trivial tickets. Recommended range is 2-8 steps; the agent decides granularity based on ticket scope.

**Derivation** - Build the workflow from three inputs in priority order: (1) the spec structure (what the spec prescribes or implies about sequencing), (2) codebase context (existing file layout, module boundaries, conventions discovered during exploration), (3) standard patterns (common implementation sequences for this type of work).

**Reorder latitude** - Steps can be reordered by the implementer as needed. The recommended workflow is a suggested sequence, not a rigid prescription. Respect dependencies between steps (a step that produces an artifact consumed by another must come first).

**Verification distinction** - Per-step `Verify:` lines are micro-verifications (confirming a single step's output). Per-ticket `Acceptance criteria` are macro-verifications (confirming the ticket's overall goal is met). These are distinct levels; a step may verify without satisfying acceptance criteria, and acceptance criteria may span multiple steps.

**Per-step format** - Every step has all four elements. Use `N/A` as a filler when an element does not apply.

```
### Step N — <verb-phrase title>

Where: <file paths or N/A>

- <action>
- <action>

Verify: <verification check or N/A>
```

### Step 1 — <verb-phrase title>

Where: <file paths or N/A>

- <action>
- <action>

Verify: <verification check or N/A>

### Step 2 — <verb-phrase title>

Where: <file paths or N/A>

- <action>
- <action>

Verify: <verification check or N/A>

## Context pointers

**Files** - <key files to examine or modify, with brief notes on why they're relevant>
**ADRs** - <relevant architectural decisions by reference>
**Domain terms** - <terms from CONTEXT.md that help understand this ticket's scope and boundaries - include enough to prevent confusion, but do not reproduce the glossary>

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Dependencies

**Blocked by** - <ticket references that must complete first, or "None - can start immediately">
