# Contributing

## Add or change a skill

1. Put it under `skills/<kebab-case-name>/SKILL.md`.
2. Match the frontmatter name to the directory.
3. Describe what it does and when it should trigger.
4. Use relative paths for bundled files.
5. Record copied or adapted material in `THIRD_PARTY_NOTICES.md`.
6. Run `./scripts/check.sh`.

## Synced skills

Do not edit Matt Pocock's synced skills by hand. Update them with:

```bash
./scripts/sync-matt-skills.sh
```

Set `MATT_SKILLS_REF` to sync a specific branch, tag, or commit.

The repository tracks a rolling `main` branch and does not publish versioned releases.
