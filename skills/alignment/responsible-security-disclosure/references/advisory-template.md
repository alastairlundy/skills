# Advisory Template

Structure and dilution checklist for draft security advisories. The advisory is the
disclosure vehicle: exploit-relevant detail concentrates here, in private channels, while
public artifacts stay vague. Write the advisory only into private channels (GitHub draft
repository security advisory, vendor security contact, CNA form) — never public issues, PRs,
or doc pages.

## Structure

```md
# <Title>

## Description
<The nature of the vulnerability: class, component, preconditions. Neutral mechanism
phrasing — no exploit path in the title or first paragraph.>

## Impact
<What an attacker could achieve, realistic scope.>

## Affected versions
<Version ranges known to be affected, e.g. "1.0.0 – 1.2.3".>

## Patched versions
<Versions containing the fix, e.g. "1.2.4". Enter the fix version into the draft advisory
before publication so dependabot-style tooling offers a safe upgrade at disclosure time.>

## Proof of concept
<A minimal actionable proof, marked for maintainer validation. The full working PoC is
stored privately alongside the advisory — never pasted into chat, docs, or public artifacts.>

## Credit
<Reporter and maintainer acknowledgments, per coordinated-disclosure convention. Always
credit the reporter when crediting the discovery.>

## Remediation
<Planned patch timing, coordinated release date.>
```

## Dilution checklist (all must pass)

Run the check by reading the draft as an attacker would. If any item fails, reduce the draft:
trim the PoC to the minimum that proves the issue to a maintainer; generalize exact
reproducer inputs to parameter ranges; keep step-by-step exploitation out of the narrative.

- [ ] A defender (maintainer) reading this draft can validate the issue and prepare the fix.
- [ ] A bad actor reading this draft cannot weaponize the vulnerability before a patched
      version is obtainable.
- [ ] The PoC is a working proof, not an exploit toolkit; no weaponization automation.
- [ ] Exact reproducer inputs are generalized to parameter ranges where a range proves the
      point equally well.
- [ ] No step-by-step exploitation narrative exists outside the PoC's minimum proof.
- [ ] The text does not enable exploitation before a patched version is obtainable.
