## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] **References Loaded**: All six `grilling` reference files were
      loaded and read in full before the first user question. If
      any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
- [ ] **Two-turn procedure**: Did every branch question — including
      foundation items, TDP branches, and any re-ask or follow-up —
      emit the full four-part locked question sequence across two
      separate agent turns: a context block + Socratic elicitation
      question turn, and a locked question line + options +
      recommendation turn? The agent did not skip the context block or
      Socratic elicitation question on a re-ask, and did not collapse
      the two turns into a single turn. See
      `../grilling/references/locked-question-format.md`.
- [ ] **Context block (parent 4-element)**: Every context block was
      emitted as the four-element bullet list (Goal, Prior decisions,
      Stakes, Scope) in that order, each element exactly one sentence,
      with ledger citations. The context block was not replaced with a
      free-form prose summary, a 'current state' investigation, a code
      reading, a domain-glossary recap, or any other kind of analysis.
      See `../grilling/references/locked-question-format.md` for the
      parent 4-element definition. Code-impl per-decision context
      blocks extend this with the 5th element (Spec section) per
      `references/locked-question-format.md`.
- [ ] **Context block (5th element, Spec section)**: Every code-impl
      per-decision context block included the 5th element ('Spec
      section') as a single sentence naming the spec file path and the
      specific section or functional requirement the branch addresses,
      with an inline citation such as `specs/feature-x.md §3.2`. The
      5th element is required, not optional, and the citation format
      is fixed. See `references/locked-question-format.md` for the
      5-element template and the citation format.
- [ ] **Atomic Questioning**: Did the agent ask exactly one
      question at a time, waiting for a response before
      proceeding?
- [ ] **Decision Ledger Located**: Was the existing Decision
      Ledger located, read end-to-end, and its path confirmed with
      the user before the first question?
- [ ] **Foundation Complete**: Were Language, Framework,
      Dependencies, Structure, Sub-projects, and Project Type all
      resolved?
- [ ] **TDP Extraction**: Were all non-deferred technical gaps in
      the spec identified and resolved?
- [ ] **No Abbreviations**: Did the agent avoid using the
      abbreviation "TDP" in all user-facing communication?
- [ ] **Ledger Recording**: Was a `Txxx` record appended to the
      Decision Ledger after every resolved decision in Steps 4, 5,
      and 6, each with a fresh `Txxx` ID and a `Cites:` line
      naming the `Dxxx`/`Txxx` records the answer respects?
- [ ] **Optionality Handled**: Was the user asked about
      Interfaces, and given the "Collaborative ticket" warning if
      they declined?
- [ ] **Interface Logic**: If Interfaces were resolved, were
      separation of concerns and the source of truth determined
      before signatures?
- [ ] **Visible Checklist**: If Interfaces were resolved, was a
      single-line running checklist emitted after each type
      introduction in Phase 3?
- [ ] **Output Choice**: Did the user choose between a Blueprint
      and PRD augmentation after seeing trade-offs?
- [ ] **Alignment Check**: Was a final pass performed to ensure
      the technical "how" supports the functional "what"?
- [ ] **Goal-aligned reasoning**: Does every recommendation's
      `Reasoning` field explicitly tie to the session-level goal
      (D001 or current goal record) using phrasing like "aligns
      with your goal of X" or "serves your goal of X"? Citing
      ledger records without naming the user's goal is insufficient —
      the goal must be surfaced explicitly. See
      `../grilling/references/recommendation-format.md` Goal-alignment
      rule.
- [ ] **Ledger Coverage**: Does every blueprint body statement
      that satisfies a functional requirement inline-cite a
      `Dxxx`/`Txxx` record using `filename#<Dxxx|Txxx>` format,
      and does the blueprint (or augmented PRD) list every cited
      record in a `## Ledger Reference` / `Decision Ledger:` section?
- [ ] **Scope Binding**: If the user chose Option A
      (Implementation Blueprint), does the blueprint explicitly
      link to the specific PRD, the Decision Ledger, and warn
      against cross-spec application? If the user chose Option B
      (PRD Augmentation), does the augmented spec include the
      Scope Binding notice and the `Decision Ledger:` pointer in
      the appended Technical Implementation section?
- [ ] **Pass/Fail Gate**: Has the Terminal Output block been
      emitted with the Decision Ledger path substituted into
      `<ledger-path>`? If no, the workflow is incomplete.
