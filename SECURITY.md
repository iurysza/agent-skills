# Security policy

## Supported versions

Only the latest tagged release and current default branch receive security fixes during private preview.

## Reporting

During private preview, use a GitHub Security Advisory or contact the maintainer through an existing private channel for prompt-injection risks, unsafe commands, credential exposure, path traversal, or bundled-script vulnerabilities. Private vulnerability reporting will be enabled when the repository becomes public. Do not open an issue containing exploit details or secrets.

## Installer boundary

The Vercel `skills` CLI installs files but does not execute bundled scripts. Installing a skill still gives its instructions influence over an agent that may have broad permissions. Review `SKILL.md`, `scripts/`, and declared requirements before use.

Bundled scripts must:

- avoid interactive prompts
- expose `--help`
- use safe defaults and bounded output
- keep structured data on stdout and diagnostics on stderr when practical
- never read or print credentials unless that is the explicit, documented purpose
- never install system dependencies without explicit user approval
