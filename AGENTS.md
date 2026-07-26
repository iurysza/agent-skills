# Agent instructions

This repository is the canonical source for Iury Souza's shareable Agent Skills.

## Rules

- Keep skills under `skills/<name>/SKILL.md`.
- Match frontmatter `name` to the directory.
- Use only Agent Skills specification fields.
- Use relative paths and never commit personal state, secrets, caches, virtual environments, generated media, or `node_modules`.
- Keep bundled scripts self-contained; real CLIs belong in their own repositories.
- Preserve upstream attribution in `THIRD_PARTY_NOTICES.md` and the root `LICENSE`.
- Do not edit the synchronized `tdd` skill by hand. Run `scripts/sync-matt-skills.sh`.
- Run `./scripts/check.sh` before committing.

`main` is a rolling catalog. Do not create version tags or GitHub releases.
