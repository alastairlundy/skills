# Ticket Publishing Rules

## Host-CLI Detection

1. Detect the project's git host:
   a. Parse `git remote -v` to extract the hostname.
   b. If the hostname is ambiguous (e.g., self-hosted with custom domain), check for host-specific config files (`.github/`, `.gitlab-ci.yml`, `.gitea/`).
   c. If detection fails, ask the user which host the project uses. The options to present are: GitHub Issues, GitLab Issues, Gitea, Codeberg Issues, or a hosted Forgejo Instance. Use the `ask_question` tool to present these options if available (Collaborative mode) or present them as a list (Self-Contained mode).
2. Load `references/host-cli-detection.md` for the CLI support-model tags and the Installation flow. The Installation section is the source of truth for how missing CLIs are handled and overrides any per-mode branch in this file.
3. Look up the expected CLI for the detected host using the loaded reference.
4. Verify the CLI is installed by checking if it is available in `PATH`. If not found, follow the no-auto-install flow defined in the loaded reference — in both Collaborative and Self-Contained modes. The agent shall not install host CLIs under any circumstance; the user is responsible for installing the CLI on their own machine and the agent shall point the user to the canonical install page URL.

## Render-time substitution

The `Blocked by` field in each ticket is stored as target-agnostic ticket IDs using the `TKxxx` prefix (e.g., `TK001`, `TK002`). The `TKxxx` prefix avoids collision with Decision Ledger record IDs (`Dxxx` for functional decisions, `Txxx` for technical decisions). At publish time, substitute these IDs with the appropriate format:

- **Issue tracker targets**: Replace target-agnostic IDs with issue numbers (e.g., `TK001` becomes `#42`).
- **Local markdown targets**: Replace target-agnostic IDs with file basenames (e.g., `TK001` becomes `001-authentication`).

The substitution runs once at publish, not during ticket generation.

## Issue tracker target

1. Publish tickets in dependency order - blockers first, then dependents. This ensures blocking ticket issue numbers exist before they are referenced in "Blocked by" fields.
2. For each ticket, create an issue using the host CLI. Fill in the "Blocked by" field with real issue numbers of previously published blocking tickets (substituted from target-agnostic IDs).
3. Do NOT close or modify any parent issue.

## Local markdown target

1. **Resolve the tickets directory** - scan the repo for an existing convention in this priority order: `tickets/`, then `docs/tickets/`, then `.tickets/`. Use the first match found. If none match, default to `tickets/` at the repo root. Record the resolved path as `<tickets-dir>` for the remaining sub-steps.
2. Create the `<tickets-dir>` directory at its resolved location if it does not exist.
3. Determine directory structure based on ticket count:
   - **Fewer than 8 tickets** - flat structure. All files in `<tickets-dir>`.
   - **8 or more tickets** - structured subdirectories. Default to domain concept unless the user has signalled a different strategy ("group by feature area", "topological layers", etc.) in the conversation, the spec, or in plain English at this step.
4. Name files with zero-padded sequential numbers - `001-authentication.md`, `002-user-profiles.md`.
5. If using structured directories, place files in the group subdirectory - e.g., `<tickets-dir>/authentication/001-login-endpoint.md`.
6. Write each ticket as a markdown file with YAML frontmatter matching the ticket template. The summary's `Output location` line shall include the resolved grouping strategy so the user can verify.

## Parent-issue rule

Do NOT close or modify any parent issue when publishing tickets.
