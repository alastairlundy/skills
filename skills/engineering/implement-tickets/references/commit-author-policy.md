# Commit Author Policy

This file is a **copy-from aid**. The user may copy any row verbatim into
their reply, or supply their own. The `implement-tickets` skill does not
propose a default value, does not invent a handle, and does not auto-fill
from host CLI metadata.

**The agent must never replace `TODO` cells. Only the user may populate this table.**

## Canonical bot identities

| Host platform | Host CLI | Canonical name | Canonical email |
|---|---|---|---|
| opencode | `opencode` | TODO | TODO |
| Anthropic Claude Code | `claude` | TODO | TODO |
| OpenAI Codex | `codex` | TODO | TODO |
| GitHub Copilot | `copilot` | TODO | TODO |
| Kilo | `kilo` | TODO | TODO |

## How the skill uses this file

The skill loads this reference at sub-step 6 of Step 1 in `SKILL.md`, then
asks the user for the AI name and email. The user may:

- copy any row's `Canonical name` and `Canonical email` verbatim,
- edit one of the rows and use the edited values, or
- supply a completely new identity.

The recorded values are passed to `git -c user.name=... -c user.email=...`
at commit time. The shell's persistent `git config` is never mutated.

## Attribution

Derived from internal `implement-tickets` design notes; no upstream
source.
