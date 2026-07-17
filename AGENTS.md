# Agent instructions

This repository is the canonical source for Iury Souza's shareable Agent Skills.

## Rules

- Keep skills under `skills/<name>/SKILL.md`.
- Match frontmatter `name` to the parent directory.
- Use only Agent Skills specification fields.
- Keep `SKILL.md` concise; move detail to one-level-deep `references/` files.
- Use paths relative to the skill directory. Never add personal absolute paths.
- Do not commit secrets, generated artifacts, auth state, caches, virtual environments, or `node_modules`.
- Bundle only small self-contained scripts. Real CLIs belong in their own package or repository.
- Preserve upstream attribution and per-skill licenses.
- Do not copy a third-party skill merely to rebrand it. Contribute upstream or document the source.
- Run `./scripts/validate.sh` and `./scripts/smoke-test.sh` before committing.

## Releases

- `main` is rolling.
- Tags are immutable repository-wide SemVer releases.
- Keep the repository private until a reviewed tagged release is ready for public use.
