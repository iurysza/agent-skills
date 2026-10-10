# Skills

Skills I use with coding agents for engineering, design, writing, and media. Every skill works on its own.

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

Use any skill name from the list below. Installs follow `main`. There are no versioned releases.

## Use in a repo

To install the whole catalog on a cloud box or CI runner, run:

```bash
curl -fsSL https://raw.githubusercontent.com/iurysza/agent-skills/main/scripts/bootstrap.sh | bash
```

It writes to `~/.agents/skills`, `~/.cursor/skills`, `~/.claude/skills` and `~/.codex/skills`. It does not write into the repo. Set `AGENT_SKILLS_REF` to pin a ref.

## Category metadata

Each skill sets one `metadata.category`, such as `development`, `visual-media` or `writing-style`. Launchers can use it to group skills.

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
| [`frontend-design`](skills/frontend-design/SKILL.md) | model-invoked | Give new or reworked UI a deliberate visual direction instead of a templated look. |

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
