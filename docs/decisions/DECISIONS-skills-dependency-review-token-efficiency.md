# Decision Ledger — skills / dependency-review-token-efficiency

Topic: improve the LLM token efficiency of the `dependency-review` skill by
triage of 10 opportunities surfaced from a session-log analysis.

### [D001] — strategy for applying the 10 opportunities

- **Resolved Answer**: "I want to triage the opportunities one at a time and decide how to approach each."
- **Normalized Requirement**: The session shall process each of the 10 token-efficiency opportunities as a separate branch (D002 through D011), with the user deciding per-opportunity whether to apply, modify, defer, or skip — rather than pre-committing to a global strategy.
- **Constraints**: None.

### [D002] — frontmatter trim

- **Resolved Answer**: "Apply as proposed."
- **Normalized Requirement**: The dependency-review skill's YAML `description:` field shall be trimmed to ~300 chars, covering only the canonical trigger conditions (review dependencies, generate a dependency report, scan for unmaintained packages, check for upgrade pressure, judge dependency health); the scope flag detail, the v1/v2/v3 deferred-features list, the out-of-scope list, and the "invoke ask-questions" instruction shall be moved into the body of SKILL.md.
- **Constraints**: None.

### [D003] — workflow refactor

- **Resolved Answer**: "Defer - I need more context and to examine that section more closely before making a decision on it."
- **Normalized Requirement**: The dependency-review skill's inline 7-step Workflow section (SKILL.md lines 38-97) shall remain unmodified in this session; the opportunity is held for re-examination by the user.
- **Constraints**: None.

### [D004] — validation checklist move

- **Resolved Answer**: "Option 2 makes sense"
- **Normalized Requirement**: The 13-bullet Validation checklist (currently SKILL.md lines 99-112) shall be moved to a new `references/validation-checklist.md`; SKILL.md shall retain the section header (renamed if appropriate) with a one-line load-trigger note "load `references/validation-checklist.md` before composing the report"; the workflow section (per D003 defer) shall not be modified.
- **Constraints**: The load-trigger note must be explicit and contain the file name so the agent cannot miss it.

### [D005] — Guide dead-section delete

- **Resolved Answer**: "Option 1 - Delete both"
- **Normalized Requirement**: The §Build Order and §Source of These Decisions sections (currently `references/dependency-review-guide.md` lines 224-237, ~14 lines) shall be deleted from the Guide; no replacement content is required.
- **Constraints**: None.

### [D006] — worked-examples move

- **Resolved Answer**: "Option 1 - Move to a new reference"
- **Normalized Requirement**: The ~25 lines of worked threshold examples (currently `references/dependency-review-guide.md` lines 116-122, 136-142, 158-162) shall be moved to a new `references/worked-examples.md`; the Guide shall contain an explicit "load on first report" trigger that includes the new file's name.
- **Constraints**: The load trigger must include the phrase "load on first report" and the file name so the agent cannot miss it.

### [D007] — Step 7 pointer collapse

- **Resolved Answer**: "Defer pending D003"
- **Normalized Requirement**: The opportunity to collapse Step 7's 5 pointer-bullets (SKILL.md lines 90-97) shall be held until D003 (workflow refactor) is resolved; SKILL.md lines 90-97 remain unmodified in this session, consistent with D003.
- **Constraints**: None.

### [D008] — preamble enumeration replace

- **Resolved Answer**: "Option 1 it is"
- **Normalized Requirement**: The ~50-word enumeration at SKILL.md line 12 shall be replaced with the two-sentence version: "Load `references/dependency-review-guide.md` before Step 1. The Guide is the source of truth; the Skill and the future CLI are consumers."
- **Constraints**: None.

### [D009] — workflow breadcrumb drop

- **Resolved Answer**: "Option 2"
- **Normalized Requirement**: The opportunity to drop the 6 breadcrumb pointers in Steps 1-6 (SKILL.md lines 44, 57, 67, 71, 82, 86) shall be held until D003 (workflow refactor) is resolved; SKILL.md lines 38-97 remain unmodified in this session, consistent with D003, D007, and D009 itself.
- **Constraints**: None.

### [D010] — v1/v2/v3 capability relocation

- **Resolved Answer**: "Let's move the v1/v2/v3 capability stuff to a sub-heading for the skill under a Roadmap heading in the README file and remove all v1/v2/v3 mentions from the skill."
- **Normalized Requirement**: A `README.md` file in the dependency-review skill directory (`C:\Users\alast\.agents\skills\dependency-review\`) shall be created (or edited, if one already exists) with a `Roadmap` top-level heading and a sub-heading for the `dependency-review` skill; the v1/v2/v3 capability content currently in SKILL.md "When Not to Use" (lines 30-32) and the canonical mention in `references/dependency-review-guide.md` §Deferred Features shall be moved into that sub-heading. All v1/v2/v3 mentions shall be removed from SKILL.md, the moved validation checklist (per D004) shall not include the v1-limits bullet, and the Guide §Deferred Features section shall be deleted.
- **Constraints**: The README is human-facing documentation, not loaded by the agent on skill activation; the Roadmap section shall be self-contained (no broken references to the skill body that no longer carries the v1/v2/v3 content).

### [D011] — Guide §Trigger delete

- **Resolved Answer**: "Option 1 - delete it from the reference."
- **Normalized Requirement**: The §Trigger section (currently `references/dependency-review-guide.md` lines 32-39, ~8 lines) shall be deleted from the Guide; no replacement content.
- **Constraints**: None.

### [D012] — supersede the v1/v2/v3 part of D002

- **Resolved Answer**: "Option 1 - D002 dealt with moving content out of the description. D010 deals with removing it altogether as unnecessary."
- **Normalized Requirement**: D010 supersedes the v1/v2/v3-related movement in D002; the v1/v2/v3 deferred-features list shall not be moved to the body of SKILL.md but to the README per D010. The other D002 moves (scope flag detail, out-of-scope list, "invoke ask-questions" instruction) still go to the body of SKILL.md.
- **Constraints**: Supersedes: D002 (specifically the v1/v2/v3-related movement clause). D002's frontmatter trim and the other content moves remain valid.

### [D013] — workflow refactor strategy (re-opens D003)

- **Resolved Answer**: "Option 2 — Apply the surgical trims as written (D007 + D009)."
- **Normalized Requirement**: The dependency-review skill's Workflow section (SKILL.md lines 38-97) shall be modified to (a) collapse Step 7's 5 pointer-bullets (currently lines 90-97) into a single statement referencing the Guide, and (b) drop the 6 breadcrumb pointers to the Guide in Steps 1-6 (currently lines 44, 57, 67, 71, 82, 86); the per-step sub-criteria and threshold statements shall remain in SKILL.md.
- **Constraints**: Supersedes: D003, D007, D009. The collapse and drop actions are the joint resolutions of D007 and D009; their deferral conditions (D003 resolution) are now met. D008's preamble ("Load `references/dependency-review-guide.md` before Step 1. The Guide is the source of truth; the Skill and the future CLI are consumers.") remains the load trigger for the Guide; the dropped breadcrumbs and collapsed bullets are not load triggers.
