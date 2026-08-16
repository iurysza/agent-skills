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
npx skills@latest add iurysza/agent-skills --skill tdd
# or
gh skill install iurysza/agent-skills tdd --agent universal --scope user
```

Replace `tdd` with any skill name listed below. Installs follow `main`; there are no versioned releases.

## Included skills

### Development workflows

| Skill | Invocation | Description |
| --- | --- | --- |
| [`brainstorming`](skills/brainstorming/SKILL.md) | model-invoked | Explore and approve a design direction before implementation. |
| [`coding-standards`](skills/coding-standards/SKILL.md) | model-invoked | Language-neutral correct-by-construction engineering standards. |
| [`docker-patterns`](skills/docker-patterns/SKILL.md) | model-invoked | Apply Docker and Compose patterns for development, security, and installer testing. |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | model-invoked | Maintain domain language, diagrams, and durable decisions under `ai-artifacts/`. |
| [`goal`](skills/goal/SKILL.md) | user-invoked | Execute an approved goal package. |
| [`readback`](skills/readback/SKILL.md) | model-invoked | Restate the user's intended outcome and constraints before work begins. |
| [`setup-goal`](skills/setup-goal/SKILL.md) | model-invoked | Extract intent and produce an approved execution package. |
| [`skill-cleaner`](skills/skill-cleaner/SKILL.md) | model-invoked | Audit skill roots, duplicates, usage, and prompt cost. |
| [`tdd`](skills/tdd/SKILL.md) | model-invoked | Vertical red-green test-driven development. |
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
| [`rephrase`](skills/rephrase/SKILL.md) | user-invoked | Tighten rough text while preserving sentiment and voice. |
| [`strunk-writing-quality`](skills/strunk-writing-quality/SKILL.md) | model-invoked | Edit prose for clarity and concision. |

### Media

| Skill | Invocation | Description |
| --- | --- | --- |
| [`audio-transcribe`](skills/audio-transcribe/SKILL.md) | model-invoked | Transcribe local audio with Gemini. |
| [`chatgpt-imagegen`](skills/chatgpt-imagegen/SKILL.md) | model-invoked | Generate and edit images with OpenAI. |
| [`gemini-tts`](skills/gemini-tts/SKILL.md) | model-invoked | Turn text and Markdown into spoken MP3 audio. |

## Upstream sync

`tdd` is copied from [mattpocock/skills](https://github.com/mattpocock/skills). Do not edit it by hand; re-sync instead.

```bash
# Upstream main
./scripts/sync-matt-skills.sh

# Specific branch, tag, or commit
MATT_SKILLS_REF=<sha-or-ref> ./scripts/sync-matt-skills.sh
```

## Check

```bash
./scripts/check.sh
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md).
