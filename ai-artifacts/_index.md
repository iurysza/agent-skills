# Catalog notes

How this repository works. Keep this current. Grow design notes here as they crystallize.

- Overview, install, consumers, fan-out: [README.md](../README.md)
- Skills: [skills/](../skills/) — each skill is `skills/<name>/SKILL.md`
- Checks: [scripts/check.sh](../scripts/check.sh) (`validate.sh`, `compat-test.sh`, and `smoke-test.sh` exec it)
- Fan-out manifest: [consumers.yml](../consumers.yml)
- Fan-out workflow: [.github/workflows/sync-skills.yml](../.github/workflows/sync-skills.yml)
- CI: [.github/workflows/ci.yml](../.github/workflows/ci.yml)
- Add a skill or consumer: [CONTRIBUTING.md](../CONTRIBUTING.md)

This repo is the catalog source. Consumers receive overlays at `.agents/skills/<name>/`. Do not add `agent-skills` as a consumer.
