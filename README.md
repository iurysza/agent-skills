# Skills

Portable coding-agent skills for engineering, architecture, media, writing, and agent workflows.

[![skills.sh](https://skills.sh/b/iurysza/agent-skills)](https://skills.sh/iurysza/agent-skills)

## Install

```bash
npx skills@latest add iurysza/agent-skills
# or
gh skill install iurysza/agent-skills --all --agent universal --scope user
```

Installs follow `main`; there are no versioned releases.

## Included skills

| Skill | Invocation | Description |
| --- | --- | --- |
| [`audio-transcribe`](skills/audio-transcribe/SKILL.md) | model-invoked | Transcribe local audio with Gemini. |
| [`brainstorming`](skills/brainstorming/SKILL.md) | model-invoked | Explore and approve a design direction before implementation. |
| [`bro`](skills/bro/SKILL.md) | user-invoked | Restate the previous response plainly and concisely. |
| [`chatgpt-imagegen`](skills/chatgpt-imagegen/SKILL.md) | model-invoked | Generate and edit images with OpenAI. |
| [`coding-standards`](skills/coding-standards/SKILL.md) | model-invoked | Language-neutral correct-by-construction engineering standards. |
| [`deslopify`](skills/deslopify/SKILL.md) | model-invoked | Remove generic AI mannerisms while preserving voice. |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | model-invoked | Maintain domain language, diagrams, and durable decisions under `ai-artifacts/`. |
| [`gemini-tts`](skills/gemini-tts/SKILL.md) | model-invoked | Turn text and Markdown into spoken MP3 audio. |
| [`goal`](skills/goal/SKILL.md) | user-invoked | Execute an approved goal package. |
| [`setup-goal`](skills/setup-goal/SKILL.md) | model-invoked | Extract intent and produce an approved execution package. |
| [`skill-cleaner`](skills/skill-cleaner/SKILL.md) | model-invoked | Audit skill roots, duplicates, usage, and prompt cost. |
| [`strunk-writing-quality`](skills/strunk-writing-quality/SKILL.md) | model-invoked | Edit prose for clarity and concision. |
| [`tech-spec`](skills/tech-spec/SKILL.md) | user-invoked | Produce a typed call-stack architecture handoff. |
| [`tool-install`](skills/tool-install/SKILL.md) | model-invoked | Safely install or update tools. |

## Synced from Matt Pocock

The TDD skill is copied from [mattpocock/skills](https://github.com/mattpocock/skills) so the collection remains self-contained. Do not edit it by hand; re-sync instead.

| Skill | Invocation | Description |
| --- | --- | --- |
| [`tdd`](skills/tdd/SKILL.md) | model-invoked | Vertical red-green test-driven development. |

Re-sync from upstream `main`:

```bash
./scripts/sync-matt-skills.sh
```

Sync a specific branch, tag, or commit:

```bash
MATT_SKILLS_REF=<sha-or-ref> ./scripts/sync-matt-skills.sh
```

## Check

```bash
./scripts/check.sh
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md).
