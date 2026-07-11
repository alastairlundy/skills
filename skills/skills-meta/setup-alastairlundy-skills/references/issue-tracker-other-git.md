# Issue tracker: <host name>

Issues and PRDs for this repo live as issues on <host name>. <!-- The user specified this host during setup; replace <host name> with the actual host, e.g. "Sourcehut", "Bitbucket Server", etc. -->

## Conventions

<!-- No standard CLI exists for this host. Use the host's REST API or web interface. -->
<!-- Fill in the concrete commands/endpoints based on the host's API documentation. The skeleton below covers the five canonical operations. -->

- **Create an issue**: <API endpoint or CLI command to create an issue>
- **Read an issue**: <API endpoint or CLI command to read an issue and its comments>
- **List issues**: <API endpoint or CLI command to list open issues with label filters>
- **Comment on an issue**: <API endpoint or CLI command to add a comment>
- **Apply / remove labels**: <API endpoint or CLI command to add/remove labels>
- **Close**: <API endpoint or CLI command to close an issue>

Infer the project/owner/repo from `git remote -v`.

<!-- PR-as-issue-surface: insert one of the following lines into this section, or omit entirely -->
<!-- If user answered yes:  "- **Pull requests as issue surface**: PRs in this repo are treated as an issue surface. Skills that publish to the issue tracker may open a PR instead of (or in addition to) an issue." -->
<!-- If user answered no or skipped: no line needed — this is the default. -->

## When a skill says "publish to the issue tracker"

Create an issue on <host name>.

## When a skill says "fetch the relevant ticket"

<Describe how to fetch the issue and its comments for this host.>
