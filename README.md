# Skills

Portable coding-agent skills for engineering, architecture, media, writing, and agent workflows.

[![skills.sh](https://skills.sh/b/iurysza/agent-skills)](https://skills.sh/iurysza/agent-skills)

## Install

```bash
npx skills@latest add iurysza/agent-skills
# or
gh skill install iurysza/agent-skills --all --agent universal --scope user
```

Install one skill by name:

```bash
npx skills@latest add iurysza/agent-skills --skill better-ui
# or
gh skill install iurysza/agent-skills better-ui --agent universal --scope user
```

Replace `better-ui` with any skill name listed below. Installs follow `main`; there are no versioned releases.

## Always-latest fan-out

This repository is the source of truth for the shared catalog. When `skills/` changes on `main`, [`.github/workflows/sync-skills.yml`](.github/workflows/sync-skills.yml) overlays each catalog skill into enabled consumer repos at **`.agents/skills/<skill-name>/SKILL.md`** and opens or updates a PR.

Cursor Cloud Agents discover project skills from `.agents/skills/` (and `.cursor/skills/`; `.claude/skills/` and `.codex/skills/` exist for other runtimes). Fan-out uses `.agents/skills/` so those agents load the catalog from the repo checkout. The copy is **always latest `main` HEAD**. This path has **no lockfile, no SHA pin, and no semver release**.

Pin-based consumers (for example a Docker image that bakes `agent-skills.lock`) keep their own flow and are not rewritten by this workflow.

Local skill directories whose names are not in this catalog are left in place, so a repo can keep project-only skills next to the overlay.

Consumer CI tip: exclude `.agents/**` from test, lint, and format globs (vitest/jest/bun test, biome/eslint/oxlint, prettier). The sync skips `*.{test,spec}.*` and similar test-only files, but skill scripts can still trip consumer tooling if those trees are included.

### Consumers

Enabled repos are listed in [`consumers.yml`](consumers.yml). That file is the editable manifest. Agent-worked Iury repos with `AGENTS.md` (and recent agent/release workflows) are included unless they are this catalog, a folded predecessor, or a pin-based/SHA-cached tree that must not be overwritten.

| Repo | Notes |
| --- | --- |
| [`termscope`](https://github.com/iurysza/termscope) | `AGENTS.md`, release-please |
| [`herdr-tab-smart-rename`](https://github.com/iurysza/herdr-tab-smart-rename) | `AGENTS.md`, release-please |
| [`herdr-mosaic`](https://github.com/iurysza/herdr-mosaic) | `AGENTS.md`, release-please |
| [`herdr-pane-layouts`](https://github.com/iurysza/herdr-pane-layouts) | `AGENTS.md` |
| [`module-graph`](https://github.com/iurysza/module-graph) | `AGENTS.md`, release-please |
| [`clockwork`](https://github.com/iurysza/clockwork) | Overlay into `.agents/skills/`; repo-root `skills/clockwork` stays the product skill that `clockwork setup` embeds |
| [`tab-declutter`](https://github.com/iurysza/tab-declutter) | `AGENTS.md` |
| [`android-use`](https://github.com/iurysza/android-use) | `AGENTS.md` |
| [`ultra`](https://github.com/iurysza/ultra) | `AGENTS.md` |
| [`visual-artifact-renderer`](https://github.com/iurysza/visual-artifact-renderer) | Overlay keeps local `impeccable` / `shadcn` |
| [`pi-extensions`](https://github.com/iurysza/pi-extensions) | Overlay at repo root; package-local skills stay put |
| [`plannotator`](https://github.com/iurysza/plannotator) | Overlay keeps local `.agents/skills` entries |

`agent-skills` itself is the source, not a consumer. There is no public `iurysza/herdr` repo (plugins are `herdr-*`). `iurysza/agents` and `flue-pi-agent` are not in this public tree; do not point this overlay at a SHA-cached `agents/skills` tree or a lockfile bake.

### Add a consumer

1. Confirm the repo is actively agent-worked (`AGENTS.md` or agent workflows) and should receive the shared catalog.
2. Append an enabled `- repo: owner/name` entry in `consumers.yml`. Default path is `.agents/skills`.
3. Merge to `main`. The next sync (or `workflow_dispatch`) opens a PR in that repo.

To stop syncing, delete the entry or set `enabled: false`.

### Secrets

`GITHUB_TOKEN` cannot open pull requests in other repositories. Add a repository secret on **iurysza/agent-skills** named **`SKILLS_SYNC_TOKEN`**:

- Fine-grained PAT: Contents (read and write) and Pull requests (read and write) on every enabled consumer, plus metadata read
- or a classic PAT with `repo`
- or a GitHub App installation token with the same permissions

Without that secret, the sync workflow fails with an explicit error. `workflow_dispatch` with `dry_run=true` plans PRs without pushing and does not need the token for public consumers.

### Dry-run

```bash
./scripts/sync-skills.sh fanout --dry-run
./scripts/sync-skills.sh vendor --dest /tmp/skills-preview/.agents/skills --dry-run
./scripts/sync-skills-test.sh
```

Reusable overlay from another workflow (still always-latest, still no pin):

```yaml
- uses: iurysza/agent-skills/.github/actions/vendor-skills@main
  with:
    dest: .agents/skills
```

`npx skills` and `gh skill install` are unchanged; they still follow `main` as documented above.

## Category metadata

Every skill sets one `metadata.category`: `writing-style`, `planning-architecture`, `development`, `review-verification`, `visual-media`, `browser-automation`, or `agent-workspace`. Category-aware launchers can group skills and match category names during search.

## Included skills

### Development workflows

| Skill | Invocation | Description |
| --- | --- | --- |
| [`architecture-knowledge-base`](skills/architecture-knowledge-base/SKILL.md) | model-invoked | Create source-backed architecture docs shaped around the codebase and its readers. |
| [`brainstorming`](skills/brainstorming/SKILL.md) | model-invoked | Explore and approve a design direction before implementation. |
| [`coding-standards`](skills/coding-standards/SKILL.md) | model-invoked | Language-neutral correct-by-construction engineering standards. |
| [`decision-room`](skills/decision-room/SKILL.md) | model-invoked | Compare competing arguments through topic-specific voices and test what survives. |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | model-invoked | Maintain domain language, diagrams, and durable decisions under `ai-artifacts/`. |
| [`goal`](skills/goal/SKILL.md) | user-invoked | Execute an approved goal package. |
| [`setup-goal`](skills/setup-goal/SKILL.md) | model-invoked | Extract intent and produce an approved execution package. |
| [`skill-cleaner`](skills/skill-cleaner/SKILL.md) | model-invoked | Audit skill roots, duplicates, usage, and prompt cost. |
| [`tech-spec`](skills/tech-spec/SKILL.md) | user-invoked | Produce a typed call-stack architecture handoff. |
| [`tool-install`](skills/tool-install/SKILL.md) | model-invoked | Safely install or update tools. |
| [`type-breakdown`](skills/type-breakdown/SKILL.md) | user-invoked | Trace a code path through its types, effects, and errors. |

### Design

| Skill | Invocation | Description |
| --- | --- | --- |
| [`better-ui`](skills/better-ui/SKILL.md) | model-invoked | Polish interface surfaces, motion, icons, and micro-interactions. |

### Writing

| Skill | Invocation | Description |
| --- | --- | --- |
| [`bro`](skills/bro/SKILL.md) | user-invoked | Restate the previous response plainly and concisely. |
| [`deslopify`](skills/deslopify/SKILL.md) | model-invoked | Remove generic AI mannerisms while preserving voice. |
| [`readback`](skills/readback/SKILL.md) | model-invoked | Restate the user's intended outcome and constraints before work begins. |
| [`rephrase`](skills/rephrase/SKILL.md) | user-invoked | Tighten rough text while preserving sentiment and voice. |
| [`strunk-writing-quality`](skills/strunk-writing-quality/SKILL.md) | model-invoked | Edit prose for clarity and concision. |
| [`technical-writing`](skills/technical-writing/SKILL.md) | model-invoked | Apply layered standards to technical documentation and engineering prose. |

### Media

| Skill | Invocation | Description |
| --- | --- | --- |
| [`audio-transcribe`](skills/audio-transcribe/SKILL.md) | model-invoked | Transcribe local audio with Gemini. |
| [`chatgpt-imagegen`](skills/chatgpt-imagegen/SKILL.md) | model-invoked | Generate and edit images with OpenAI. |
| [`gemini-tts`](skills/gemini-tts/SKILL.md) | model-invoked | Turn text and Markdown into spoken MP3 audio. |

## Check

```bash
./scripts/check.sh
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md).
