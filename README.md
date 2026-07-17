# agent-skills

Portable Agent Skills by Iury Souza.

## Install

```bash
npx skills add iurysza/agent-skills --list
npx skills add iurysza/agent-skills --skill tool-install -g
npx skills add 'iurysza/agent-skills#v0.1.0' --skill tool-install -g
```

With GitHub CLI 2.94+:

```bash
gh skill install iurysza/agent-skills tool-install@v0.1.0 --agent universal --scope user
```

## Skills

- **tool-install** — safely install or upgrade tools
- **strunk-writing-quality** — edit prose for clarity and concision
- **skill-cleaner** — audit skill roots, duplicates, usage, and prompt cost

## Validate and publish

```bash
./scripts/validate.sh
./scripts/smoke-test.sh
gh skill publish --dry-run
gh skill publish --tag v0.2.0
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md) and [security policy](SECURITY.md).
