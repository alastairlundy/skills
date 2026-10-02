# Wording Examples (binding)

Binding BAD/GOOD detail-level examples for screening vulnerability-related text while the
disclosure-state gate classifies the vulnerability as EMBARGOED. Apply these as hard rules,
not suggestions. Under embargo, name neither the vulnerability class nor the cause in any
text artifact — only neutral hardening wording is allowed.

## Screening list

Flag every string (commit message, PR description, code comment) that contains:

- CVE IDs or GHSA IDs.
- References to a security advisory or a private vulnerability report, including issue
  numbers that resolve to one (`fixes #1234` where #1234 is the advisory or private report).
- The words security, vulnerability, exploit, attack, or injection paired with a mechanism.
- Exploit-path or root-cause specifics (which sink, which input, which auth bypass).
- "Fixes a security issue…" phrasing in any form.

## Commit messages

- BAD: `Fix CVE-2026-1234: path traversal in upload handler allows writing arbitrary files`
- GOOD: `Tighten path validation in the upload handler`

- BAD: `Security fix: sanitize user-controlled filename before file write`
- GOOD: `Harden filename handling in the storage service`

## PR descriptions

- BAD: `This PR fixes the reported vulnerability where untrusted input reaches the command
  runner, enabling arbitrary command execution. See the private report.`
- GOOD: `Tighten argument construction in the command runner. Adds validation tests.`

- BAD: `Fixes the buffer overflow reported privately last week (CVE pending).`
- GOOD: `Bound-check buffer lengths in the decoder and cover with regression tests.`

## Code comments

- BAD: `// GHSA-abcd-efgh: user-controlled input reaches exec() here — see advisory`
- GOOD: `// Validate and canonicalize input before constructing the command.`

- BAD: `// This check prevents the path traversal attack from the security report.`
- GOOD: `// Reject path segments that escape the base directory.`

- BAD: `// Do not remove this sanitization — it is the fix for the open vulnerability.`
- GOOD: `// Input must be sanitized before use in file system operations.`

## Changelog entries (robustness tier — the only tier allowed under embargo)

- BAD: `Security: fixed arbitrary file write vulnerability (CVE-2026-1234)`
- BAD: `Fixed a critical security vulnerability in the upload handler.`
- GOOD: `Improved file-handling robustness in uploads.`
- GOOD: `Tightened validation in the command runner.`

Post-disclosure upgrade (allowed only after the gate classifies the vulnerability as
PUBLICLY DISCLOSED):

- UPGRADED: `Security: fixed arbitrary file write in the upload handler (CVE-2026-1234).
  Affected: 1.0.0–1.2.3. Patched: 1.2.4. Advisory: GHSA-xxxx-xxxx-xxxx.`

## Detail-level rule of thumb

Under embargo, an outside reader of the artifact must not be able to tell that a security
vulnerability exists, which class it belongs to, or how to trigger it. If the wording
identifies any of the three, rewrite to the GOOD examples' level.
