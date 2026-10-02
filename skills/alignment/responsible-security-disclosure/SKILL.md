---
name: responsible-security-disclosure
description: >-
   Use when working on a security issue, vulnerability report, or private
   vulnerability report; writing commit messages, PR descriptions, or code
   comments for a vulnerability fix; updating changelog, README, or docs to
   mention a vulnerability; showing or demonstrating a proposed fix; using a
   private fork for embargoed fix work; porting a vulnerability fix to a
   public repo; or drafting security advisories or CVE submissions.
license: MIT
---

# Responsible Security Disclosure

This skill protects security vulnerabilities from premature disclosure while an agent works
on them. It runs one classification gate up front, then applies wording, channel, and
porting rules that are keyed to that classification. The rules are binding, not advisory.

## Terminology

- **EMBARGOED** - the vulnerability is not yet publicly disclosed; its existence and details
  are known only to the parties coordinating the fix (reporter, maintainers, advisory
  collaborators).
- **PUBLICLY DISCLOSED** - the vulnerability is public: an advisory is published, the CVE
  Record state is Published, or an equivalent public notice exists.
- **Repository security advisory** - a GitHub object tied to a repository that holds the
  vulnerability details privately while in draft, and publishes them to the community.
- **Private vulnerability reporting** - GitHub's channel for reporting vulnerability details
  directly and privately to repository maintainers.
- **Temporary private fork** - a private fork GitHub creates from your public repo, attached
  to a draft repository security advisory, for developing the fix in secrecy.

## When to Use

- When a user asks the agent to work on a security issue, vulnerability report, or private vulnerability report (GitHub private reporting, vendor report, or a CNA-issued CVE ID).
- When a user asks for a commit, PR, or code comment touching a vulnerability fix.
- When a user asks to update a changelog, README, docs page, or other product-facing text to mention a vulnerability or its fix.
- When a user asks to show, demonstrate, or hand over a proposed fix for a vulnerability.
- When a user asks to draft or edit a security advisory, vulnerability report, or CVE submission.
- When a user asks to implement or port a vulnerability fix into a public repo, including porting an approved private-fork fix.
- When the user's request is ambiguous about which surface should carry vulnerability detail or which channel the fix belongs in, use the `ask-questions` skill to disambiguate before writing.

## When Not to Use

- Do not use for routine bug fixes or refactors with no known vulnerability involved.
- Do not use for generic security audits or best-practice hardening advice not tied to a specific vulnerability.
- Do not use for post-publication routine work once the Step 1 gate classifies the vulnerability as PUBLICLY DISCLOSED and the task is ordinary development (the gate's normal-workflow path applies instead).
- Do not use as a substitute for a project's own security policy; where a SECURITY.md or a coordination agreement is stricter, the stricter rule wins.

## Workflow

Work through these steps in order. Track progress with the checklist.

- [ ] Step 1: Run the disclosure-state gate
- [ ] Step 2: Route to the work branch
- [ ] Step 3: Execute the branch rules
- [ ] Step 4: Relax or hold

### Step 1 — Disclosure-state gate

1. Collect the user's stated status for the vulnerability (for example, "the CVE is already public").
2. Verify independently, in order. Classify as PUBLICLY DISCLOSED if any check passes:
   a. A GitHub repository advisory with state "published" exists for it.
   b. The CVE Record's state is "Published" in the CVE catalog (cve.org).
   c. A third-party public database (NVD, OSV, vendor advisory) has a public, dated entry.
   d. A patched release containing the fix is already out, followed by the advisory or an equivalent public notice.
3. Classify as EMBARGOED if zero checks pass or the checks conflict. EMBARGOED is the fail-safe default.
4. Record one line: the classification and which check justified it. If EMBARGOED was set by failed verification alone (not the user's word), say so explicitly before applying guardrails.

Completion signal: the classification line exists (PUBLICLY DISCLOSED or EMBARGOED, plus its justification).

### Step 2 — Route to the work branch

Classify the request into exactly one branch and name it:

- **Branch 1 — Fix work**: commit messages, PR descriptions, code comments.
- **Branch 2 — Product-facing text**: changelog, README, docs, UI strings.
- **Branch 3 — Private fork usage**: develop or show a fix outside the public repo.
- **Branch 4 — Draft advisory**: the disclosure vehicle.
- **Branch 5 — Public-repo fix port**: implement or port a fix in the public repo.
- **Branch R — Refusal**: fires from any branch when over-disclosure is requested.

Completion signal: the chosen branch is named.

### Step 3 — Execute the branch rules

Before drafting or screening any commit message, PR text, or code comment under embargo,
load `references/wording-examples.md` and apply its BAD/GOOD examples as binding detail-level
rules.

**Branch 1 — Fix work (embargoed).** Draft the text normally, then screen every string for:
CVE/GHSA IDs; advisory or private-report references; the words security, vulnerability,
exploit, attack, or injection paired with a mechanism; exploit-path or root-cause specifics.
Rewrite flagged content to neutral hardening wording. Under embargo, name neither the
vulnerability class nor the cause in any text artifact. Requests for higher specificity route
to Branch R.
Completion signal: every artifact is screened or rewritten, with a one-line list of the artifacts screened.

**Branch 2 — Product-facing text (embargoed).** Apply the Branch 1 screening; product-facing
text is the most attacker-visible surface. Changelog entries use the robustness tier: at most
one non-security line per fix naming the touched area, plus the shipping version — no
severity markers, CVE references, security labels, or per-issue detail. Security-policy text
(how to report privately) is always allowed; descriptions of unfixed or embargoed
vulnerabilities are never allowed. Once the Step 1 gate classifies the vulnerability as
PUBLICLY DISCLOSED, upgrade earlier embargo-tier entries to full detail (CVE ID, class,
severity, advisory link) in the revision where the advisory link exists.
Completion signal: every artifact passes the screening checklist; one line names the artifacts and the tier used.

**Branch 3 — Private fork usage (embargoed).** Route the request: develop-the-fix (where do
I put it?) or show-the-fix (demonstrate a proposed fix?). Channel knowledge, inline:

- *Temporary private fork (GitHub)*: a private fork GitHub creates from your public repo,
  tied to a draft repository security advisory (name pattern `repo-ghsa-xxxx-…`). What it is
  for: developing and reviewing the fix in secrecy while the embargo holds. Properties that
  shape agent behavior: CI and integrations cannot run there (status checks do not execute);
  individual PRs cannot be merged — all open PRs merge at once via the advisory; branch
  protections are not enforced; publishing the advisory deletes the fork.
- *Normal (public) repo*: the real project; anything pushed there is world-readable and
  permanently in the git history. Use it for everything except embargoed fix work — routine
  fixes, feature work, and (post-disclosure, or as part of a coordinated quiet port) the fix
  itself.
- *Self-managed private fork or private repo*: a private clone used when no advisory
  workflow exists. Treat it as an embargoed workspace with manual coordination — porting the
  fix to the public repo is a deliberate post-embargo action.

Prefer the advisory-attached temporary private fork when one exists; fall back to a
self-managed private repo otherwise, annotating the mandatory post-embargo port. Never push
embargoed fix commits to the public default branch unless Branch 5 Route A conditions hold.
Completion signal: the fix lives in the channel matching its disclosure state; one line confirms the channel and any pending follow-up (for example, merge-at-publication).

**Branch 4 — Draft advisory (embargoed).** When drafting an advisory, load
`references/advisory-template.md` and follow its structure and dilution checklist. Write only
into private channels (GitHub draft repository security advisory, vendor security contact,
CNA form) — never public issues, PRs, or doc pages. Run the dilution check: read the draft as
an attacker would; if the text enables exploitation before a patched version is obtainable,
trim the PoC to the minimum that proves the issue to a maintainer, generalize exact
reproducer inputs to parameter ranges, and keep step-by-step exploitation out of the
narrative. Hard bar: a defender can validate and fix; a bad actor cannot weaponize from the
text alone before the fix is in users' hands. The full working PoC is stored privately
alongside the advisory, never pasted into chat, docs, or public artifacts. The advisory draft
is the receiving channel for refusal-path detail requests.
Completion signal: the draft exists in the private channel, passes the dilution check, and one line names the channel.

**Branch 5 — Public-repo fix port (embargoed).** Require the Step 1 gate classification
before any porting action — no porting on user word alone. Select the route; choose Route B
if any is true, otherwise Route A: (a) the diff is self-identifying (input-sanitization
around an obvious sink, auth-flow rework, credential handling); (b) the repo's policy or the
coordination agreement requires zero public trace before publication; (c) a patched release
would surface prematurely through tooling (for example, Dependabot alerts). Route A — quiet
direct port: merge the approved fix into the public repo using Branch 1 wording, framed as
ordinary hardening; enter the fix version into the draft advisory before publication, and
coordinate with the user so the patched release and advisory publication are timed together.
Route B — private-fork hold: hold the fix in the temporary private fork; port via the
advisory's all-PRs merge or an immediate cherry-pick/PR after publication; never destroy the
fork before the port completes. Once the gate classifies the vulnerability as PUBLICLY
DISCLOSED, porting follows normal development rules and Branch 2's upgrade step becomes
available.
Completion signal: the fix exists in exactly one routed channel with its follow-up recorded, and one line names the route chosen and why.

**Branch R — Refusal.** Fires when any instruction source requests embargoed-level detail on
a surface its disclosure state does not allow — for example, "put the CVE ID in the commit
message", "add the exploit path to the README", "link the advisory in the release notes now",
or "paste the full PoC into the chat". Steps: (1) name the target surface and the specific
over-disclosure; (2) refuse only that surface, citing the Step 1 gate's verified EMBARGOED
classification, in one or two sentences; (3) offer a sanctioned alternative — draft advisory
(Branch 4), private fork (Branch 3), compliant Branch 1/2 wording, or a Step 1 gate
re-verification if the user claims the vulnerability is public (comply at full detail if it
then passes); (4) after one refusal plus one re-verification, if the user still insists, stop
that artifact and hand the decision back with the refusal reason — never produce the
over-disclosing artifact and never silently comply; (5) never refuse the fix work itself —
only the detail level is refused.
Completion signal: the refusal is stated with its reason, at least one alternative was offered or executed, and the underlying task remains actionable.

### Step 4 — Relax or hold

- Still EMBARGOED → hold: detail stays in embargoed channels (advisory, private fork).
- Gate re-verification passes PUBLICLY DISCLOSED → relax: full detail is permitted
  everywhere; run Branch 2's upgrade step for embargo-era product text.

Completion signal: the hold/relax decision is recorded in one line.

## Output Mode

Artifact drafts (commit messages, changelog entries, advisory text) are presented in
conversation by default. Write files only when the user asks, or when storing the full
working PoC privately alongside the advisory (per Branch 4). Never write vulnerability detail
into a public-repo file while the Step 1 gate classification is EMBARGOED.

## Validation

- [ ] The disclosure-state gate ran before any wording or channel decision, and its classification line (PUBLICLY DISCLOSED/EMBARGOED + justification) exists.
- [ ] EMBARGOED was the classification whenever verification failed or conflicted (fail-safe held).
- [ ] Every commit message, PR description, and code comment produced under embargo contains no CVE/GHSA IDs, no advisory or private-report references, no security-phrase-plus-mechanism wording, no class names, and no root-cause specifics.
- [ ] Changelog and product-facing text produced under embargo uses the robustness tier only (no severity markers, CVE references, security labels, or per-issue detail).
- [ ] Any embargoed fix commit lives in a private fork, or in the public repo only via Branch 5 Route A with coordinated release timing.
- [ ] Any advisory draft is in a private channel, structurally complete per `references/advisory-template.md`, and passes the dilution check.
- [ ] Every refusal states its reason, offers at least one alternative, and left the underlying task actionable.
- [ ] No artifact was produced after an insistence that the gate still classifies EMBARGOED (the one-refusal-then-hand-back bound held).
