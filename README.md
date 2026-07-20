# agent-skills

Portable [Agent Skills](https://agentskills.io) by Iury Souza.

[![skills.sh](https://skills.sh/b/iurysza/agent-skills)](https://skills.sh/iurysza/agent-skills)

## Install

```bash
# Vercel skills CLI
npx skills add iurysza/agent-skills
npx skills add iurysza/agent-skills --list
npx skills add iurysza/agent-skills --skill tool-install -g
npx skills add 'iurysza/agent-skills#v0.2.0' --skill tool-install -g

# GitHub CLI 2.96+
gh skill install iurysza/agent-skills tool-install@v0.2.0 --agent universal --scope user
```

`npx skills` requires Node.js 22.20+. Use `gh skill` without Node.js.
Update unpinned installs with `npx skills update` or `gh skill update`.

## Skills

### Planning and architecture

- [**adr**](skills/adr/SKILL.md) — create and maintain concise Architecture Decision Records
- [**brainstorming**](skills/brainstorming/SKILL.md) — turn early ideas into approved designs before implementation

### Media

- [**audio-transcribe**](skills/audio-transcribe/SKILL.md) — transcribe local audio with Gemini; Bun 1.1+ and ffmpeg
- [**chatgpt-imagegen**](skills/chatgpt-imagegen/SKILL.md) — generate and edit images with OpenAI; Python 3.10+
- [**gemini-tts**](skills/gemini-tts/SKILL.md) — turn text and Markdown into spoken MP3 audio; Python 3.10+ and ffmpeg

### Tooling

- [**skill-cleaner**](skills/skill-cleaner/SKILL.md) — audit skill roots, duplicates, usage, and prompt cost; Node.js 18+
- [**tool-install**](skills/tool-install/SKILL.md) — safely install or upgrade tools

### Writing

- [**deslopify**](skills/deslopify/SKILL.md) — remove generic AI mannerisms while preserving the author's voice
- [**strunk-writing-quality**](skills/strunk-writing-quality/SKILL.md) — edit prose for clarity and concision

## Validate and publish

```bash
./scripts/validate.sh
./scripts/smoke-test.sh
./scripts/compat-test.sh
gh skill publish --dry-run
gh skill publish --tag vX.Y.Z
```

MIT licensed. See [third-party notices](THIRD_PARTY_NOTICES.md) and [security policy](SECURITY.md).
