---
title: Diagnose code-impl context block deviation from parent format
classification: Independent
blocked_by: []
parent: docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md
---

## Goal

Read the code-implementation-grilling skill and its references; compare the context block to the parent's 4-element block; produce a concrete list of differences organized as one or more of: missing elements, extra elements, different ordering, or inconsistent application. Read-only — no edits to the code-impl skill or its references.

## What to build

A diagnosis document (deliverable: a new markdown file at `tickets/grilling-redesign/diagnosis-d006.md`, or an inline appendix appended to the Decision Ledger source file). The diagnosis must contain five sections.

1. **Parent 4-element block (reference format)** — the verbatim definition from `skills/engineering/grilling/SKILL.md` Step 4 and `references/locked-question-format.md` Part 1: Goal, Prior decisions, Stakes, Scope (in order, each one sentence, with `Dxxx` citations in Goal, Prior decisions, and Stakes).

2. **Code-impl current context block** — the verbatim text from every location in `skills/engineering/code-implementation-grilling/SKILL.md` and `skills/engineering/code-implementation-grilling/references/` that defines, references, or emits a context block. For each location, record the file path, section, line range, and verbatim text (template or sample).

3. **Differences** — a list of differences between the code-impl context block and the parent's 4-element block, organized as one or more of:
   - **Missing elements** — parent has, code-impl does not.
   - **Extra elements** — code-impl has, parent does not.
   - **Different ordering** — elements present in both but in a different order.
   - **Inconsistent application** — the format is defined in one place but not followed in another, or the format is only partially applied.

4. **Where the format is defined** in code-impl — file path and section heading for the canonical definition (if any).

5. **Where the format is applied** in code-impl — file path, section, and per-step usage for each emission site.

What NOT to do:

- Do not edit any skill file or reference.
- Do not propose a fix in the diagnosis (the fix is per a separate ticket that depends on this diagnosis).
- Do not invent deviations that the source does not support.

## Recommended Workflow

### Step 1 — Read the parent 4-element block definition

Where: `skills/engineering/grilling/SKILL.md` Step 4, `skills/engineering/grilling/references/locked-question-format.md` Part 1

- Capture the verbatim 4-element bullet list template.
- Note the constraints: each element one sentence, in the named order, with `Dxxx` citations in Goal, Prior decisions, and Stakes.

Verify: A copy of the parent's 4-element template and its constraints is in the diagnosis.

### Step 2 — Read the code-impl skill and references for context block usage

Where: `skills/engineering/code-implementation-grilling/SKILL.md` (full), `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md` (full), and any other reference in `skills/engineering/code-implementation-grilling/references/` that emits or references a context block

- For each location, record: file path, section, line range, and verbatim text of the context block (if emitted as a sample) or verbatim definition of the context block (if defined as a template).
- Note which elements are present and in what order.
- Note any elements that appear in code-impl but not in the parent.

Verify: A list of every location in code-impl that defines, references, or emits a context block, with verbatim text and line ranges.

### Step 3 — Compare and produce the difference list

Where: the diagnosis file

- Side-by-side: parent 4-element block vs. each code-impl instance.
- Classify each difference as: missing, extra, different ordering, or inconsistent application.
- For each difference, note the affected file path, section, and the parent requirement that is not met.

Verify: The diagnosis contains a difference list classified into the four categories, with file paths and section headings for each entry.

## Context pointers

**Files**:
- `skills/engineering/grilling/SKILL.md` — the parent's 4-element block reference (read-only)
- `skills/engineering/grilling/references/locked-question-format.md` — the parent's Part 1 template (read-only)
- `skills/engineering/code-implementation-grilling/SKILL.md` — primary target of the diagnosis (read-only)
- `skills/engineering/code-implementation-grilling/references/interface-and-model-branch.md` — likely primary target (read-only)
- `skills/engineering/code-implementation-grilling/references/` — other references may also define or reference a context block; audit all of them

**ADRs**: None.

**Domain terms**:
- 4-element context block — the parent's bullet list: Goal, Prior decisions, Stakes, Scope (in order, one sentence each, with `Dxxx` citations)
- Context block deviation — a difference between the code-impl context block format and the parent's 4-element format, in one of the four categories: missing, extra, different ordering, or inconsistent application
- Read-only diagnosis — analysis of the source without modifying it; the fix follows in a separate ticket

**Ledger records**:
- `docs/decisions/DECISIONS-skills-grilling-locked-question-redesign.md#D006` — the diagnosis requirement; the fix is a separate ticket that depends on this diagnosis

## Acceptance criteria

- [ ] A diagnosis file exists at `tickets/grilling-redesign/diagnosis-d006.md` (or an inline Decision Ledger appendix), containing the five sections from the "What to build" list.
- [ ] The parent's 4-element block is captured verbatim with its constraints.
- [ ] Every code-impl location that defines, references, or emits a context block is listed with verbatim text and line ranges.
- [ ] The difference list is organized into the four categories (missing, extra, different ordering, inconsistent application), with file paths and section headings for each entry.
- [ ] The diagnosis does not modify any skill file or reference.
- [ ] The diagnosis does not propose a fix (the fix is per a separate ticket that depends on this diagnosis).

## Dependencies

**Blocked by**: None — can start immediately.
