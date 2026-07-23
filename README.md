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
| [`bro`](skills/bro/SKILL.md) | user-invoked | Restate the previous response plainly and concisely. |
| [`chatgpt-imagegen`](skills/chatgpt-imagegen/SKILL.md) | model-invoked | Generate and edit images with OpenAI. |
| [`coding-standards`](skills/coding-standards/SKILL.md) | model-invoked | Correct-by-construction TypeScript engineering standards. |
| [`deslopify`](skills/deslopify/SKILL.md) | model-invoked | Remove generic AI mannerisms while preserving voice. |
| [`gemini-tts`](skills/gemini-tts/SKILL.md) | model-invoked | Turn text and Markdown into spoken MP3 audio. |
| [`skill-cleaner`](skills/skill-cleaner/SKILL.md) | model-invoked | Audit skill roots, duplicates, usage, and prompt cost. |
| [`strunk-writing-quality`](skills/strunk-writing-quality/SKILL.md) | model-invoked | Edit prose for clarity and concision. |
| [`tech-spec`](skills/tech-spec/SKILL.md) | user-invoked | Produce a typed call-stack architecture handoff. |
| [`tool-install`](skills/tool-install/SKILL.md) | model-invoked | Safely install or update tools. |

## Synced from Matt Pocock

These skills are copied from [mattpocock/skills](https://github.com/mattpocock/skills) so the collection remains self-contained. Do not edit them by hand; re-sync instead.

| Skill | Invocation | Description |
| --- | --- | --- |
| [`grilling`](skills/grilling/SKILL.md) | model-invoked | Relentless one-question-at-a-time interview loop. |
| [`grill-me`](skills/grill-me/SKILL.md) | user-invoked | Start a grilling session. |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | model-invoked | Maintain project language and durable architectural decisions. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | user-invoked | Grill while maintaining the glossary and ADRs. |
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
