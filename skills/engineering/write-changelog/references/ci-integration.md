---
name: ci-integration
description: >-
  Canonical home for the marker vocabulary that write-changelog emits to the conversation so a CI wrapper can translate structured markers into process exit codes. Covers the empty-range abort (D017), the defaulted marker (D001), and the autonomous-mode overwrite-refusal marker (D003, follow-up).
license: MIT
---

# CI Integration

A skill is a prompt template, not an executable — it cannot return a process exit code. This file is the canonical home for the marker vocabulary that `write-changelog` emits to the conversation so a CI wrapper can translate structured markers into non-zero exit codes, machine-readable warnings, or deterministic fallbacks.

## Marker contract

A wrapper that consumes `write-changelog` output must match the marker block (the fenced code block), **not** the human-readable prose above it. The prose is for the user; the marker is for the wrapper. Matching the prose produces false positives.

All markers use the same shape:

````
```
[CHANGELOG-MARKER] <kind>
key: value
key: value
```
````

The wrapper pattern is a regex over the fenced block, e.g.:

```
\[CHANGELOG-MARKER\] empty-range
```

followed by a parse of the `key: value` lines.

## Markers

### `empty-range` — D017

Emitted in Step 2 when the retrieved commit list is empty.

Prose above the marker (for the user):

> The commit range is empty — no changelog to generate.

Marker block:

````
```
[CHANGELOG-MARKER] empty-range
prior: <prior>
target: <target>
```
````

Wrapper behaviour: translate to non-zero exit code. The CI run is a failure; the changelog is not produced.

### `defaulted` — D001

Emitted in Step 4 when the ask-questions skill is unavailable or the user declines, and the section title defaults to `Global`.

The marker is **inline on the section header**, not in a fenced block, so a linter or release pipeline does not break on it:

```
## Global (defaulted)
```

Wrapper behaviour: do not exit non-zero. The default is a soft signal — surface the assumption in the changelog itself, but the run is a success. Linters and release pipelines must allow the `(defaulted)` suffix on the section header without failing.

### `overwrite-refused` — D003 (open follow-up)

Emitted in Step 6 when the user refuses to overwrite an existing destination. In interactive mode, the final markdown is output to the conversation and the user is offered a one-line "say `write to <path>`" prompt; no marker is required because a human is in the loop.

In autonomous (non-interactive) mode, the behaviour is not yet defined. This entry is the placeholder; the marker shape and the wrapper contract will be filled in by a follow-up branch that resolves D003's open follow-up. The deterministic default being weighed is `<destination>.new.<ext>` (e.g., `CHANGELOG.md.new.md`) so a CI pipeline never drops a changelog silently.

## Future markers

Add new marker kinds to this file rather than scattering them across `SKILL.md`. Each marker entry must include:

- The decision that introduced it (`Dxxx`).
- The prose above the marker (for the user).
- The marker block (for the wrapper).
- The wrapper behaviour (exit code, soft warning, etc.).
- A note on whether linters and release pipelines must accept or reject the marker.
