# Contributing

## Add or change a skill

1. Put it under `skills/<kebab-case-name>/SKILL.md`.
2. Match the frontmatter name to the directory.
3. Describe what it does and when it should trigger.
4. Use relative paths for bundled files.
5. Record copied or adapted material in `THIRD_PARTY_NOTICES.md`.
6. Run `./scripts/check.sh`.

The repository tracks a rolling `main` branch and does not publish versioned releases.

## Add a fan-out consumer

1. Confirm the repo should vendor this catalog for Cursor Cloud Agents (`.agents/skills/<name>/SKILL.md`).
2. Add `- repo: owner/name` under `consumers` in `consumers.yml`. Leave `enabled` unset (true). Set `enabled: false` and a `notes:` value when recording a repo that must not receive the overlay.
3. Do not add a lockfile or SHA pin. The sync overlays catalog skill directories and keeps local-only skill names.
4. Run `./scripts/sync-skills-test.sh` and `./scripts/check.sh`.

Consumer repos should exclude `.agents/**` from lint/test/format configs so vendored skill scripts do not fail CI. Sync already omits test-only files (`*.{test,spec}.*`, `test_*.py`, `*_test.py`, `*_test.go`).

Cross-repo PRs need the `SKILLS_SYNC_TOKEN` repository secret (see the README). This catalog is the source; do not add `agent-skills` as a consumer.
