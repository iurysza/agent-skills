---
name: gemini-tts
description: Generates spoken MP3 audio from text or Markdown with Gemini TTS. Use for narration, accessibility, voice previews, or reading documents aloud.
compatibility: Requires Python 3.10+, google-genai 1.65+, ffmpeg, and a Gemini API key. Optional playback needs afplay, ffplay, or mpv.
---

# Gemini TTS

Generate an MP3 from inline text or a UTF-8 text/Markdown file with the bundled script.

## Setup

Resolve paths relative to this `SKILL.md`; do not assume a particular install directory.

```bash
python3 -m pip install -r <skill-directory>/requirements.txt
export GEMINI_API_KEY='...'
```

`GOOGLE_API_KEY` and `OPENCODE_GOOGLE_API_KEY` are accepted as fallbacks. Set `GEMINI_TTS_MODEL` to override the default model.

## Before generation

Confirm or infer:

- source text or file
- output path
- voice or template
- desired delivery notes and speed
- whether playback is wanted

For long input, report the chunk count before making paid API calls. Ask for confirmation when the request is unexpectedly large or the user has not clearly approved generation.

## Discover voices and templates

```bash
python3 <skill-directory>/scripts/generate_tts.py --list-voices
python3 <skill-directory>/scripts/generate_tts.py --list-templates
python3 <skill-directory>/scripts/generate_tts.py --show-template mystery-narrator
```

Bundled templates include `mystery-narrator`, `newscaster`, `whisper`, `empathetic`, `deadpan`, `promo-hype`, and `podcast-newsletter`.

## Generate audio

From text:

```bash
python3 <skill-directory>/scripts/generate_tts.py \
  --text 'Read this clearly and naturally.' \
  --voice Orus \
  --output ./narration.mp3
```

From a file and template:

```bash
python3 <skill-directory>/scripts/generate_tts.py \
  --file ./article.md \
  --template podcast-newsletter \
  --output ./article.mp3 \
  --play
```

Customize delivery when needed:

```bash
python3 <skill-directory>/scripts/generate_tts.py \
  --file ./script.txt \
  --voice Kore \
  --profile 'Calm technical narrator' \
  --scene 'A quiet recording booth' \
  --notes 'Clear diction, measured pace, neutral accent' \
  --speed 1.1 \
  --output ./script.mp3
```

Explicit CLI flags override template values. Templates override the hard defaults (`Orus`, speed `1.0`).

## Reliability controls

- `--max-workers N`: concurrent chunk requests; default `1`
- `--requests-per-minute N`: request throttle; default `8`; `0` disables it
- `--allow-partial`: write an MP3 despite failed chunks; avoid unless the user accepts missing audio

Environment equivalents are `GEMINI_TTS_MAX_WORKERS` and `GEMINI_TTS_RPM`.

## Verification

After generation:

1. Confirm the command exited successfully.
2. Confirm the MP3 exists and is non-empty.
3. Report the exact output path.
4. If playback was requested, report when no supported player is installed.

Never print API keys or include them in command examples, logs, or output files.
