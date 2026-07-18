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

The skill never installs host CLIs. The user is responsible for installing the CLI required by the chosen publishing target. This rule applies in both Collaborative and Self-Contained modes and is not overridable by either mode.

Rationale — host-CLI installation is a sensitive prerequisite that:

- Downloads and executes code from a third-party source (supply-chain risk).
- May require elevated privileges (e.g., `sudo`, package-manager installs, system PATH changes).
- Must be reviewed by the user before execution; the agent cannot verify the integrity of remote install payloads on the user's behalf, and Self-Contained mode is a workflow-shape signal, not a blanket authorization to run untrusted third-party installers.

Self-Contained mode governs the ticket workflow (whether the agent pauses for input during decomposition and publishing); it does not extend to prerequisite setup operations like tool installation.

### Flow when a required CLI is missing

1. The agent identifies the canonical install page for the selected CLI from this static, hand-maintained table. The agent shall not fetch, parse, scrape, or quote remote README content, release pages, or install scripts to derive an install command:

   | CLI | Canonical install page |
   | --- | --- |
   | `gh` | `https://github.com/cli/cli#installation` |
   | `glab` | `https://gitlab.com/profclems/glab#installation` |
   | `tea` | `https://gitea.com/gitea/tea#installation` |
   | `fj` | `https://codeberg.org/codeberg/forgejo-cli#installation` |

2. The agent tells the user which CLI is required and presents the canonical install page URL. The agent does not extract, paraphrase, or restate install commands from the page. The user reads the page in their own browser and runs the install command themselves.

3. After the user has installed the CLI, the agent re-verifies the CLI is on `PATH` and proceeds with the publishing workflow.

### What the agent shall not do

- Fetch remote READMEs, release pages, or install scripts to extract install commands.
- Run `curl | sh`, `iwr | iex`, `pip install`, `apt install`, `brew install`, `winget install`, `scoop install`, or any other install command for a host CLI, regardless of mode.
- Present an install command sourced from remote content to the user as if it were the agent's own recommendation. The agent points to a URL; the user reads and runs the command themselves.

Destructive-operation note: the tool/harness permission layer is a safety net but does not replace the no-auto-install rule — the agent does not run install commands at all, with or without a permission prompt.
