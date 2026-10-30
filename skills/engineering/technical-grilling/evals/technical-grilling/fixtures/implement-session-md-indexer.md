# Worked Example Scenario: Implement-From-Blueprint (no citation litter)

This fixture documents the workspace setup for
`tasks/perf-no-citation-litter-on-implement.yaml`. It simulates the
downstream session a finished `technical-grilling` grilling produces:
an implementing agent that sees only the spec, the Decision Ledger, and
the Implementation Blueprint - never the grilling skill's SKILL.md or
references.

Put these three files in the task workspace before the run:

1. `docs/prds/feature-x.md` - the raw spec.
2. `docs/decisions/DECISIONS-md-indexer-markdown-indexer.md` - the
   Decision Ledger (D001-D004, T001-T005, with trailing sentinels
   `<!-- next-d: D005 -->` and `<!-- next-t: T006 -->`).
3. `IMPLEMENTATION-md-indexer-markdown-indexer.md` - the blueprint,
   written under the post-change rules: section-level citation
   groups, no per-statement inline citations, and the traceability
   boundary in the Scope Binding section.

## User prompt

> The workspace contains a finished technical-grilling session: the
> spec at docs/prds/feature-x.md, the Decision Ledger at
> docs/decisions/DECISIONS-md-indexer-markdown-indexer.md, and the
> Implementation Blueprint at
> IMPLEMENTATION-md-indexer-markdown-indexer.md. Implement the
> blueprint now, exactly as specified. Run git init and commit your
> work with descriptive commit messages.

## Expected blueprint shape (post-change rules)

The blueprint the implementer receives includes the boundary line
verbatim in its Scope Binding:

> Citations to `Dxxx`/`Txxx` records appear only in this
> blueprint and in the Decision Ledger. Do not write them into
> source code, code comments, docstrings, commit messages, PR
> descriptions, README files, or any other repository file.
> When code or docs need the rationale inline, name the decision's
> topic instead of its ID.

and cites records once per file section, e.g.:

```md
### `mdindex/watcher.py`

Change detection polls the target directory every 5 seconds with
`os.scandir`, comparing SHA-256 content hashes against the index.
[...statements without inline citations...]
[`DECISIONS-md-indexer-markdown-indexer.md#T002`,
`DECISIONS-md-indexer-markdown-indexer.md#T003`]
```

## Pass state

- All requirements implemented per the blueprint statements.
- Zero `Dxxx`/`Txxx` IDs or `DECISIONS-*.md` filenames outside the
  ledger and the blueprint (source code, comments, docstrings, test
  comments, pyproject metadata, README, commit messages).
- Where the implementer needs the rationale inline, it names the
  decision's topic in prose (for example, "the content-hash
  deduplication decision") instead of a record ID.

## Fail states observed in the pre-change baseline (collect before
judging a run as compliant)

Baseline implementers, given the pre-change blueprint with
per-statement inline citations and no boundary line, wrote:

- `pyproject.toml` comment `# T003` (the language decision ID).
- Python docstrings carrying record IDs: `Schema (T004): ...`,
  `Index *content* under *content_hash* (D003)`,
  `"""Tests for the SQLite index layer (T004, D003, D004)."""`.
- Code comments: `# D003: same content hash under two paths...`,
  `# must not raise (T005)`, `#: T002`.
- README sections listing "Design constraints" keyed by T-numbers.
- A commit message: `feat: ... DECISIONS-md-indexer-markdown-indexer
  (D001-D004, T001-T005)`.

Any of these shapes in a graded run is a failure; the check script
`scripts/check-no-citation-litter.ps1` detects all of them, including
commit messages.
