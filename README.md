# agent-skills

Curated, portable Agent Skills by Iury Souza.

> Private hardening preview. The repository will become public after its first tagged release passes validation and install smoke tests.

## Install

List available skills:

```bash
npx skills add iurysouza/agent-skills --list
```

Install one globally:

```bash
npx skills add iurysouza/agent-skills --skill tool-install -g
```

Install a reproducible tagged release:

```bash
npx skills add 'iurysouza/agent-skills#v0.1.0' --skill tool-install -g
```

The default branch is the rolling channel. Version tags are immutable snapshots.

## Skills

| Skill | Purpose | Requirements |
| --- | --- | --- |
| [`tool-install`](skills/tool-install/SKILL.md) | Research, plan, approve, install, and verify tools safely | Web research and shell access; macOS-first |
| [`strunk-writing-quality`](skills/strunk-writing-quality/SKILL.md) | Edit prose for clarity, concision, structure, and plain English | None |
| [`skill-cleaner`](skills/skill-cleaner/SKILL.md) | Audit skill roots, duplicates, usage, and prompt-budget pressure | Node.js 22.6+ |

## Tool policy

`npx skills` copies or symlinks skill files. It does not execute dependency hooks.

- Small helpers belong in a skill's `scripts/` directory and must be self-contained, non-interactive, and documented with `--help`.
- Real CLIs belong in their own repository or package. Their installer may explicitly install both the CLI and matching skill.
- Third-party tools must use the official install source and declare requirements in `compatibility`.
- Skills never contain credentials, private state, personal absolute paths, generated output, vendored virtual environments, or `node_modules`.

## Versioning

The collection uses repository-wide semantic versioning:

- `main`: rolling updates
- `v0.x.y`: private preview releases
- `v1.0.0+`: stable releases

A breaking change to any published skill increments the repository major version. Per-skill versions are intentionally deferred until real demand appears.

## Validate

```bash
./scripts/validate.sh
./scripts/smoke-test.sh
```

Validation checks Agent Skills specification compliance, portable paths, accidental vendoring, secret leaks when Gitleaks is available, the bundled CLI, and Vercel CLI discovery.

## Promotion workflow

1. Develop and test a shareable skill here.
2. Validate locally and in CI.
3. Tag an immutable repository release.
4. Install the tagged skill into the private agent configuration repository.
5. Keep personal or machine-specific variants private; do not sync them back here.

## Security

Skills run with an agent's permissions. Review the skill and bundled scripts before installation. Report vulnerabilities privately as described in [`SECURITY.md`](SECURITY.md).

## License

Original work is MIT licensed. Third-party and adapted material is listed in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) and inside affected skill directories.
