## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] **References Loaded**: All reference files were
      loaded and read in full before the first user question. If
      any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] **TDP round discipline**: Were TDPs grouped into
      dependency-ordered rounds of at most 3 unblocked items before
      resolution? Did each round emit the full 1-turn wrapper (round
      header, frontier statement, context blocks, options tables,
      recommendations) in a single agent turn?
- [ ] **1-turn wrapper per round**: Did every round - including
      foundation items, TDP branches, and any re-ask or follow-up  - 
      emit the full 1-turn wrapper in a single agent turn: round
      header, frontier statement, 5-row context block (Goal, Prior
      decisions, Scope, Spec section), conflict callout (if any),
      options table, recommendation. Up to 3 unblocked branches may
      appear in a single round. No Socratic elicitation question was
      emitted. See
      `references/locked-question-format.md`.
- [ ] **Context block (5-row)**: Every code-impl per-decision context
      block was emitted as the 5-row markdown table (header + 4 data
      rows: Goal, Prior decisions, Scope, Spec section) in that order,
      each element exactly one sentence, with ledger citations. The
      context block was not replaced with a free-form prose summary,
      a 'current state' investigation, a code reading, a domain-glossary
      recap, or any other kind of analysis.
      See `references/locked-question-format.md` for the template and
      the citation format.
- [ ] **Spec section required**: Every code-impl per-decision context
      block included the Spec section row as a single sentence naming
      the spec file path and the specific section or functional
      requirement the branch addresses, with an inline citation such
      as `specs/feature-x.md §3.2`. The Spec section row is required,
      not optional, and the citation format is fixed.
      See `references/locked-question-format.md`.
- [ ] **Decision Ledger Located**: Was the existing Decision
      Ledger located, read end-to-end, and its path confirmed with
      the user before the first question?
- [ ] **Foundation Complete**: Were Language, Framework,
      Dependencies, Structure, Sub-projects, and Project Type all
      resolved?
- [ ] **TDP Extraction**: Were all non-deferred technical gaps in
      the spec identified and resolved?
- [ ] **Minimum sweep**: Was the decision surface walked per
      `references/coverage-sweep.md` before TDP rounds were planned -
      every spec section/functional requirement (or named goal area)
      and every implementation-ambiguity taxonomy category mapped to
      a planned branch or an explicit out-of-scope entry?
- [ ] **Record echo**: Was every appended record's `Normalized
      Requirement` and `Constraints` echoed verbatim to the user in
      the same turn (`references/recording-decisions.md`)?
- [ ] **Composite answers decomposed**: Were unpinned sub-decisions
      of composite picks surfaced as follow-up branches, or their
      unpinned sub-parts enumerated in the record's `Constraints`?
- [ ] **Deferred defaults**: Does every DEFERRED record's
      `Constraints` cite the user's explicit deferral (verbatim) and
      carry the failed round's recommended option as
      the fallback default (`references/decision-ledger.md`), and does the
      blueprint mark where that default is applied?
- [ ] **No Abbreviations**: Did the agent avoid using the
      abbreviation "TDP" in all user-facing communication?
- [ ] **Ledger Recording**: Was a `Txxx` record appended to the
      Decision Ledger after every resolved Phase 2 decision
      (foundation establishment, spec-driven technical extraction,
      and interface & model branches), each with a fresh `Txxx` ID
      and a `Cites:` line
      naming the `Dxxx`/`Txxx` records the answer respects?
- [ ] **Optionality Handled**: Was the user asked about
      Interfaces, and given the "Collaborative ticket" warning if
      they declined? Did a decline append the `Txxx` DECLINED record
      with the recommended path forward (`references/interface-and-model-branch.md`)?
- [ ] **Interface Logic**: If Interfaces were resolved, were
      separation of concerns and the source of truth determined
      before signatures?
- [ ] **Visible Checklist**: If Interfaces were resolved, was a
      single-line running checklist emitted after each type
      introduction in Phase 3?
- [ ] **Alignment Check**: Was a final pass performed to ensure
      the technical "how" supports the functional "what"?
- [ ] **Goal-aligned reasoning**: Does every recommendation's
      `Reasoning` field explicitly tie to the session-level goal
      (the current goal record) using phrasing like "aligns
      with your goal of X" or "serves your goal of X"? Citing
      ledger records without naming the user's goal is insufficient  - 
      the goal must be surfaced explicitly. See
      `references/recommendation-format.md` Goal-alignment
      rule.
- [ ] **Ledger Coverage**: Does every blueprint body statement
      that satisfies a functional requirement inline-cite a
      `Dxxx`/`Txxx` record using `filename#<Dxxx|Txxx>` format,
      and does the blueprint list every cited
      record in a `## Ledger Reference` / `Decision Ledger:` section?
- [ ] **Scope Binding**: Does the blueprint explicitly
      link to the Decision Ledger, and warn
      against cross-spec application?
- [ ] **Residual inventory**: Was the close-out prompt accompanied by
      the residual inventory table from
      `references/coverage-sweep.md`, with every surface item mapped
      to Resolved / Deferred / Out of scope?
- [ ] **Deferrals section**: Did the blueprint carry a `## Deferrals
      and Defaults` section listing every DEFERRED record, its
      fallback default, and every DECLINED branch, sourced from the
      residual inventory (`references/output-selection.md`)?