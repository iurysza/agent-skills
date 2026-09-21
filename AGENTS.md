# Agent instructions

Canonical source for Iury Souza's shareable Agent Skills. Fan-out is always-latest `main` HEAD; there are no versioned releases.

## Map

| Path | Role |
| --- | --- |
| `skills/<name>/SKILL.md` | Catalog skills. Frontmatter `name` matches the directory. |
| `scripts/check.sh` | Default closed loop. |
| `scripts/sync-skills.sh` | Overlay `skills/` into a dest, or fan out to consumers. |
| `consumers.yml` | Enabled overlay targets. Default dest `.agents/skills`. |
| `.github/workflows/ci.yml` | PR/`main` CI. |
| `.github/workflows/sync-skills.yml` | Fan-out when `skills/` or `consumers.yml` change on `main`. |
| `ai-artifacts/_index.md` | How the catalog works. Keep current; grow design notes under `ai-artifacts/`. |
| `README.md` | Install, consumers, fan-out. |
| `CONTRIBUTING.md` | Add a skill or consumer. |
| `THIRD_PARTY_NOTICES.md`, `LICENSE` | Attribution. |

This repo's skills live under `skills/`, not `.agents/skills/` or `.cursor/skills/`. Those paths are consumer discovery locations.

## Rules

- Keep skills under `skills/<name>/SKILL.md`. Match frontmatter `name` to the directory.
- Use only Agent Skills specification fields.
- Use relative paths. Never commit personal state, secrets, caches, virtual environments, generated media, or `node_modules`.
- Keep bundled scripts self-contained; real CLIs belong in their own repositories.
- Preserve upstream attribution in `THIRD_PARTY_NOTICES.md` and the root `LICENSE`.
- How-the-catalog-works docs belong in `ai-artifacts/` and must stay current.
- `main` is a rolling catalog. Do not create version tags or GitHub releases.

## Closed loop

```bash
./scripts/check.sh
```

`scripts/validate.sh`, `scripts/compat-test.sh`, and `scripts/smoke-test.sh` exec that same script. Run it before committing.

CI (`.github/workflows/ci.yml`):

```bash
./scripts/validate.sh
gh skill publish --dry-run
./scripts/compat-test.sh
./scripts/smoke-test.sh
```

plus a Node 18 job for `skills/skill-cleaner/scripts/skill-cleaner.mjs`.

Fan-out (`.github/workflows/sync-skills.yml`) after catalog changes on `main`. Local:

```bash
./scripts/sync-skills-test.sh
./scripts/sync-skills.sh fanout --dry-run
```

## Git commits

Never include Cursor (or any Cursor agent/bot) as git author, committer, or in a Co-authored-by / similar trailer.
