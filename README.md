# agent-skills

Portable [Agent Skills](https://agentskills.io) by Iury Souza.

## Install

```bash
# Vercel skills CLI
npx skills add iurysza/agent-skills
npx skills add iurysza/agent-skills --list
npx skills add iurysza/agent-skills --skill tool-install -g
npx skills add 'iurysza/agent-skills#v0.2.0' --skill tool-install -g

# GitHub CLI 2.96+
gh skill install iurysza/agent-skills tool-install@v0.2.0 --agent universal --scope user
```

`npx skills` requires Node.js 22.20+. Use `gh skill` without Node.js.
Update unpinned installs with `npx skills update` or `gh skill update`.

## Skills

- [**tool-install**](skills/tool-install/SKILL.md) — safely install or upgrade tools
- [**strunk-writing-quality**](skills/strunk-writing-quality/SKILL.md) — edit prose for clarity and concision
- [**skill-cleaner**](skills/skill-cleaner/SKILL.md) — audit skill roots, duplicates, usage, and prompt cost; Node.js 18+

## Validate and publish

```bash
./scripts/validate.sh
./scripts/smoke-test.sh
./scripts/compat-test.sh
gh skill publish --dry-run
gh skill publish --tag vX.Y.Z
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md) and [security policy](SECURITY.md).
