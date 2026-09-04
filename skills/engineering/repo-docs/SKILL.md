---
name: repo-docs
description: >-
  Maintains repository documentation consistency and reduces architectural drift. 
  Acts as the single source of truth for project documentation formats, providing 
  deterministic workflows for managing the project GLOSSARY.md, creating 
  sequential Architecture Decision Records (ADRs), and auditing general repo 
  documentation against the current codebase state.
license: MIT
---

# repo-docs

## When to Use
- When you need to add or update a term in `GLOSSARY.md`.
- When a technical decision is made that has long-term architectural impact and requires an ADR.
- When you identify that existing repository documentation (READMEs, guides) contradicts the current codebase implementation.
- When you are tasked with general cleanup of repository-level documentation to ensure it remains "useful and up to date."
- When you need to determine if a new technical term should be formalized in the project's ubiquitous language.

## When Not to Use
- For trivial typo fixes or cosmetic changes to documentation that do not affect technical meaning or project-wide consistency.
- When creating documentation for a specific feature within a codebase (use feature-specific docs or comments).
- For managing external documentation sites or wikis outside the git repository.

## Workflow

### Lane 1: GLOSSARY Maintenance
1. **Discovery**: Search for `GLOSSARY.md`. If found, load it; otherwise, mark the file for creation.
2. **Conflict Check**: Search the existing glossary (if present) for synonyms or contradictions of the proposed entry.
3. **Formatting**: 
   - Load `references/GLOSSARY-FORMAT.md`.
   - Draft the entry using the prescribed project format.
4. **Integration**: 
   - If `GLOSSARY.md` exists: Insert the entry maintaining strict alphabetical order.
   - If `GLOSSARY.md` does not exist: Create the file with a standard header and the new entry.
5. **Validation**: Verify that the result is a valid markdown file and the term does not introduce ambiguity.
   - *Completion Signal: File produced (`GLOSSARY.md` updated or created).*

### Lane 2: ADR Creation
1. **Warrant Check**: Evaluate if the decision is architectural (cross-cutting, long-term impact, or core dependency change).
2. **Analysis**: Load existing ADRs to check for contradictions or determine if this decision supersedes a prior ADR.
3. **Drafting**: 
   - Load `references/ADR-FORMAT.md`.
   - Create the ADR content using the prescribed project format.
4. **Filing**: 
   - Identify the ADR directory (default `docs/adr/`).
   - Determine the next sequential ID (e.g., `0005-decision-name.md`).
   - Write the file to the directory.
5. **Indexing**: Update the ADR index file (e.g., `docs/adr/INDEX.md`) if one exists.
6. **Validation**: Verify that the ADR follows project style and the sequential ID is correct.
   - *Completion Signal: File produced (new ADR file and updated index).*

### Lane 3: General Repo Docs Maintenance
1. **Audit**: Compare current documentation against the codebase to find contradictions or deprecated examples.
2. **Scope Definition**: Define the specific sections requiring updates to prevent unnecessary rewriting.
3. **Execution**: 
   - Perform targeted edits.
   - Update broken cross-references and links.
   - Verify new instructions against the current environment.
4. **Verification**: Review changes to ensure the "useful" bar is met (clear, concise, and actionable).
5. **Review Flag**: If the change is high-impact (e.g., onboarding guide), flag it for user review.
   - *Completion Signal: State change (edited files verified and high-impact changes flagged).*

## Validation
- [ ] **Formatting**: Do all new GLOSSARY and ADR entries follow the templates in `references/` exactly?
- [ ] **Consistency**: Does the new GLOSSARY entry avoid introducing synonyms or contradictions?
- [ ] **Ordering**: Is `GLOSSARY.md` still strictly alphabetical?
- [ ] **Sequentiality**: Does the new ADR have the correct sequential ID and a corresponding index entry?
- [ ] **Accuracy**: Does the updated general documentation accurately reflect the current codebase state?
