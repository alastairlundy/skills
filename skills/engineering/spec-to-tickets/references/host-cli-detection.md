# Host CLI Detection

> Reusable reference. The content here was developed for `spec-to-tickets` but may be lifted into a separate publishing skill if a future need arises (copy-and-adapt, not extraction; this file remains the source of truth for spec-to-tickets).

`last-verified: 2026-06-22`

## CLI support model

| Host | CLI | Support model |
| --- | --- | --- |
| `github.com` | `gh` | official |
| `gitlab.com` or self-hosted GitLab | `glab` | official |
| `gitea.com` or Gitea instances | `tea` | official (Gitea's primary CLI) |
| `codeberg.org` or Forgejo instances | `fj` | community-maintained, not official (Codeberg/Forgejo community CLI) |

The `fj` entry is intentionally tagged as community-maintained and is not part of Gitea's official toolchain. The `tea` entry is the official CLI for Gitea.

## Installation

When the user has chosen a host CLI that is not installed, the skill does not auto-install. The flow is:

1. The agent locates the canonical source repository for the selected CLI:
   - `gh` — `cli/cli`
   - `glab` — `profclems/glab`
   - `tea` — `gitea/tea`
   - `fj` — `codeberg/forgejo-cli`
2. The agent searches the repository README for install instructions and pulls the install command for the current platform.
3. The agent presents the install instructions to the user, including the README-derived command.
4. The agent asks: "shall I run this?" — the LLM shall not run the install without an explicit `yes` to that prompt. There is no session-level authorization; every install is its own ask.
5. On `yes`, the agent runs the install. On any other response, the agent aborts the install path and asks the user how to proceed (install manually, switch target, or cancel).

Destructive-operation note: the tool/harness permission layer is a safety net but does not replace this explicit confirmation step — the agent asks before the tool call, not via the tool's permission prompt.
