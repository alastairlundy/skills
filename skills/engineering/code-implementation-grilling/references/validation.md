## Validation

After completing the workflow, verify each item against the session
transcript:

- [ ] **References Loaded**: All six `grilling` reference files were
      loaded and read in full before the first user question. If
      any reference file was missing or unreadable, the session
      aborted and the missing file was reported to the user.
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
      Decision Ledger after every resolved decision in Steps 3, 4,
      and 5, each with a fresh `Txxx` ID and a `Cites:` line
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
