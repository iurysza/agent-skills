---
name: audio-transcribe
description: Transcribe local audio with Gemini, including speaker labels and timestamps. Use for podcasts, interviews, lectures, meetings, voice notes, or requests to convert MP3, WAV, M4A, OGG, FLAC, or WebM audio into Markdown.
license: MIT
compatibility: Requires Bun 1.1+, ffmpeg/ffprobe, network access, and a Gemini API key.
---

# Audio Transcription

The bundled CLI normalizes audio, splits long recordings, transcribes chunks with Gemini, and writes one Markdown transcript.

## Setup

Resolve paths relative to this `SKILL.md`; do not assume a global skill directory.

```bash
bun install --cwd <skill-directory>/scripts --no-save
export GEMINI_API_KEY='...'
```

`GOOGLE_API_KEY` and `OPENCODE_GOOGLE_API_KEY` are accepted as fallbacks. Set `GEMINI_TRANSCRIBE_MODEL` to override the default model.

## Before transcription

1. Confirm the input exists and is one of the supported formats.
2. Use `ffprobe` to inspect duration.
3. Agree on an output path when the user has not supplied one.
4. Warn before unexpectedly long or costly transcription.

Do not upload media without the user's explicit transcription request.

## Run

```bash
bun run <skill-directory>/scripts/transcribe.ts \
  ./interview.m4a \
  --output ./interview-transcript.md
```

Options:

- `--chunk-minutes N`: chunk duration; default `20`
- `--output PATH`: exact Markdown output path
- `--keep`: retain normalized audio and chunk files beside the transcript
- `--help`: show usage

Supported inputs: MP3, WAV, M4A, OGG, FLAC, and WebM.

## Output

The transcript contains source metadata, duration, model, chunk count, speaker-labelled turns, and timestamps. Chunk prompts receive their offset within the full recording so timestamps remain useful across long files.

Speaker identity inferred by a model can be wrong. Preserve generic labels when names are uncertain and do not present inferred identities as verified facts.

## Verification

After transcription:

1. Confirm the command succeeded.
2. Confirm the Markdown file exists and is non-empty.
3. Inspect the beginning, one middle section, and the end for missing chunks or malformed output.
4. Report the exact path and disclose any failed or partial processing.

The CLI does not write partial transcripts after an API failure. Temporary normalized audio is removed unless `--keep` is set.

Never print API keys or add private media and generated transcripts to the skill repository.
