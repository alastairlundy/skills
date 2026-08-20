# Triage Rules

A finding is a BLOCKER if any hold:
1. The project cannot be installed/used as intended - build fails, no install path exists, or the manifest's distribution metadata is missing/empty (PackageId, name, description, version).
2. A legal gate for the intended distribution is missing - LICENSE for any public/OSS release; privacy/terms for app-store-distributed apps.
3. The README is missing, empty, or a default scaffold (e.g. a single "Hello World" line) - users cannot learn what the project is.
4. Automated tests exist but do not pass.

A finding is a SHOULD-HAVE if all hold:
1. It is conventional for the detected project type and ecosystem (CI configured, `.gitignore` present, repository URL in manifest, CHANGELOG entry, version explicitly chosen).
2. Its absence will cause real user friction within the first 5 minutes of evaluation (install steps unclear, no usage example, no minimum-viable test coverage for the core API/scenario).
3. It can be added in well under an hour and meaningfully improves credibility for a first release.

A finding is a NICE-TO-HAVE if all hold:
1. It is project-type-conditional and primarily cosmetic (logo/banner for UI apps, badges in README, contributing guide, code of conduct, extra tutorials, performance benchmarks).
2. Its absence does not block any reasonable user from installing, understanding, or using the project.
3. It can be reasonably deferred to a post-release update.

Out of scope: items that do not fit any bucket (e.g. personal scratch scripts "released" with no distribution intent) - the skill must ask the user to confirm intent in Step 1 before triaging, not fabricate findings to fill buckets.
