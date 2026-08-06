#!/usr/bin/env bun
import { existsSync, mkdirSync, rmSync } from "fs";
import { basename, dirname, extname, join, resolve } from "path";
import { parseArgs } from "util";

const DEFAULT_CHUNK_MINUTES = 20;
const SUPPORTED_FORMATS = [".mp3", ".wav", ".m4a", ".ogg", ".flac", ".webm"];
const MODEL_NAME =
  process.env.GEMINI_TRANSCRIBE_MODEL ||
  process.env.GEMINI_FLASH_DEFAULT ||
  "gemini-3.1-flash-lite-preview";

interface AudioChunk {
  path: string;
  offsetSeconds: number;
  durationSeconds: number;
}

interface TranscribeOptions {
  chunkMinutes: number;
  keep: boolean;
  outputPath: string;
}

async function run(
  command: string[],
): Promise<{ stdout: string; stderr: string; exitCode: number }> {
  const process = Bun.spawn(command, { stdout: "pipe", stderr: "pipe" });
  const stdout = await new Response(process.stdout).text();
  const stderr = await new Response(process.stderr).text();
  return {
    stdout: stdout.trim(),
    stderr: stderr.trim(),
    exitCode: await process.exited,
  };
}

async function getDuration(filePath: string): Promise<number> {
  const result = await run([
    "ffprobe",
    "-i",
    filePath,
    "-show_entries",
    "format=duration",
    "-v",
    "quiet",
    "-of",
    "csv=p=0",
  ]);
  const duration = Number.parseFloat(result.stdout);
  if (result.exitCode !== 0 || !Number.isFinite(duration)) {
    throw new Error(`ffprobe could not read ${filePath}: ${result.stderr}`);
  }
  return duration;
}

function resolveApiKey(): string {
  const candidates = [
    process.env.GEMINI_API_KEY,
    process.env.GOOGLE_API_KEY,
    process.env.OPENCODE_GOOGLE_API_KEY,
  ];
  const key = candidates.find((value) => value?.trim())?.trim();
  if (!key) {
    throw new Error(
      "No Gemini API key configured. Set GEMINI_API_KEY or GOOGLE_API_KEY.",
    );
  }
  return key;
}

async function normalizeAudio(inputPath: string, outputPath: string): Promise<void> {
  console.log(`Normalizing ${basename(inputPath)} for upload...`);
  const result = await run([
    "ffmpeg",
    "-y",
    "-i",
    inputPath,
    "-vn",
    "-ac",
    "1",
    "-ar",
    "16000",
    "-b:a",
    "48k",
    outputPath,
  ]);
  if (result.exitCode !== 0) {
    throw new Error(`ffmpeg normalization failed: ${result.stderr}`);
  }
}

async function splitAudio(
  normalizedPath: string,
  workDir: string,
  duration: number,
  chunkMinutes: number,
): Promise<AudioChunk[]> {
  const chunkSeconds = chunkMinutes * 60;
  const count = Math.ceil(duration / chunkSeconds);
  if (count <= 1) {
    return [{ path: normalizedPath, offsetSeconds: 0, durationSeconds: duration }];
  }

  console.log(`Splitting into ${count} chunks of at most ${chunkMinutes} minutes...`);
  const chunks: AudioChunk[] = [];
  for (let index = 0; index < count; index += 1) {
    const offsetSeconds = index * chunkSeconds;
    const chunkPath = join(workDir, `chunk-${String(index + 1).padStart(3, "0")}.mp3`);
    const result = await run([
      "ffmpeg",
      "-y",
      "-i",
      normalizedPath,
      "-ss",
      String(offsetSeconds),
      "-t",
      String(chunkSeconds),
      "-c",
      "copy",
      chunkPath,
    ]);
    if (result.exitCode !== 0) {
      throw new Error(`ffmpeg failed to create chunk ${index + 1}: ${result.stderr}`);
    }
    chunks.push({
      path: chunkPath,
      offsetSeconds,
      durationSeconds: Math.min(chunkSeconds, duration - offsetSeconds),
    });
  }
  return chunks;
}

function formatTimestamp(totalSeconds: number): string {
  const seconds = Math.floor(totalSeconds % 60);
  const minutes = Math.floor(totalSeconds / 60) % 60;
  const hours = Math.floor(totalSeconds / 3600);
  return hours > 0
    ? `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
    : `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
}

function parseTimestamp(timestamp: string): number | undefined {
  const parts = timestamp.split(":").map(Number);
  if (parts.some((part) => !Number.isInteger(part)) || parts.at(-1)! >= 60) {
    return undefined;
  }
  if (parts.length === 2) return parts[0] * 60 + parts[1];
  if (parts.length === 3 && parts[1] < 60) {
    return parts[0] * 3600 + parts[1] * 60 + parts[2];
  }
  return undefined;
}

class TimestampValidationError extends Error {}

export function correctChunkTimestamps(
  text: string,
  offsetSeconds: number,
  chunkSeconds: number,
  previousTimestamp?: number,
): { text: string; timestamps: number[] } {
  const timestamps: number[] = [];
  let lastTimestamp = previousTimestamp;
  const minimum = offsetSeconds - 5;
  const maximum = offsetSeconds + chunkSeconds + 5;
  const correctedText = text.replace(
    /\[((?:\d{2}:)?\d{2}:\d{2})\]/g,
    (_match, timestamp: string) => {
      const relativeSeconds = parseTimestamp(timestamp);
      if (relativeSeconds === undefined) {
        throw new TimestampValidationError(`invalid timestamp [${timestamp}]`);
      }

      const offsetTimestamp = offsetSeconds + relativeSeconds;
      const correctedSeconds =
        lastTimestamp === offsetTimestamp ? offsetTimestamp + 1 : offsetTimestamp;
      if (correctedSeconds < minimum || correctedSeconds > maximum) {
        throw new TimestampValidationError(
          `timestamp [${timestamp}] corrected to [${formatTimestamp(correctedSeconds)}] outside [${minimum}s, ${maximum}s]`,
        );
      }
      if (lastTimestamp !== undefined && correctedSeconds <= lastTimestamp) {
        throw new TimestampValidationError(
          `timestamp [${timestamp}] corrected to [${formatTimestamp(correctedSeconds)}] is not later than [${formatTimestamp(lastTimestamp)}]`,
        );
      }

      timestamps.push(correctedSeconds);
      lastTimestamp = correctedSeconds;
      return `[${formatTimestamp(correctedSeconds)}]`;
    },
  );
  return { text: correctedText, timestamps };
}

function formatDuration(totalSeconds: number): string {
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = Math.floor(totalSeconds % 60);
  if (hours > 0) return `${hours}h ${minutes}m ${seconds}s`;
  if (minutes > 0) return `${minutes}m ${seconds}s`;
  return `${seconds}s`;
}

export function safeProviderError(error: unknown): string {
  if (!error || typeof error !== "object") return "ProviderError";
  const value = error as Record<string, unknown>;
  const constructor = (error as { constructor?: { name?: string } }).constructor;
  const name = constructor?.name?.match(/^[A-Za-z][A-Za-z0-9_]{0,63}$/)?.[0] ?? "ProviderError";
  const details = [name];
  if (typeof value.status === "number") details.push(`status=${value.status}`);
  if (typeof value.statusCode === "number") details.push(`status=${value.statusCode}`);
  if (
    typeof value.code === "string" &&
    /^[A-Za-z0-9_.-]{1,64}$/.test(value.code)
  ) {
    details.push(`code=${value.code}`);
  }
  return details.join(" ");
}

async function transcribeChunk(
  client: any,
  chunk: AudioChunk,
  index: number,
  total: number,
  previousTimestamp?: number,
): Promise<{ text: string; timestamps: number[] }> {
  console.log(`Transcribing chunk ${index + 1}/${total}...`);
  const audioData = await Bun.file(chunk.path).arrayBuffer();
  const base64Audio = Buffer.from(audioData).toString("base64");

  for (let attempt = 1; attempt <= 3; attempt += 1) {
    let response: any;
    try {
      response = await client.models.generateContent({
        model: MODEL_NAME,
        contents: [
          {
            role: "user",
            parts: [
              { inlineData: { mimeType: "audio/mp3", data: base64Audio } },
              {
                text: `Transcribe this audio accurately with speaker labels and timestamps.

Timestamps must be relative to the start of this audio chunk. Start near 00:00 and do not add any full-recording offset.

Rules:
1. Use consistent speaker names only when the audio provides enough evidence. Otherwise use Speaker 1, Speaker 2, and so on.
2. Put each speaker turn on its own line as: [MM:SS] Speaker: speech. Use [HH:MM:SS] only if the chunk reaches one hour.
3. Preserve meaningful false starts and filler words.
4. Mark relevant non-speech sounds such as [laughs], [sighs], or [inaudible].
5. Mark overlapping speech when it affects comprehension.
6. Output only the transcript, with no introduction or summary.`,
              },
            ],
          },
        ],
      });
    } catch (error) {
      throw new Error(
        `Gemini request failed for chunk ${index + 1}: ${safeProviderError(error)}`,
      );
    }

    const parts = response.candidates?.[0]?.content?.parts ?? [];
    const text = parts
      .map((part: { text?: string }) => part.text ?? "")
      .join("")
      .trim();
    if (!text) throw new Error(`Gemini returned no transcript for chunk ${index + 1}`);

    try {
      return correctChunkTimestamps(
        text,
        chunk.offsetSeconds,
        chunk.durationSeconds,
        previousTimestamp,
      );
    } catch (error) {
      if (!(error instanceof TimestampValidationError)) throw error;
      if (attempt === 3) {
        throw new Error(
          `Timestamp validation failed for chunk ${index + 1} after 3 attempts: ${error.message}`,
        );
      }
      console.warn(
        `Timestamp validation failed for chunk ${index + 1} (attempt ${attempt}/3): ${error.message}; retrying...`,
      );
    }
  }

  throw new Error(`Timestamp validation failed for chunk ${index + 1}`);
}

async function transcribe(inputPath: string, options: TranscribeOptions): Promise<void> {
  const absoluteInput = resolve(inputPath);
  const outputPath = resolve(options.outputPath);
  if (!existsSync(absoluteInput)) throw new Error(`File not found: ${absoluteInput}`);
  if (absoluteInput === outputPath) throw new Error("Output path must differ from input path.");

  const extension = extname(absoluteInput).toLowerCase();
  if (!SUPPORTED_FORMATS.includes(extension)) {
    throw new Error(`Unsupported format ${extension}. Supported: ${SUPPORTED_FORMATS.join(", ")}`);
  }

  const duration = await getDuration(absoluteInput);
  mkdirSync(dirname(outputPath), { recursive: true });
  const workDir = join(
    dirname(outputPath),
    `.audio-transcribe-work-${process.pid}-${Date.now()}`,
  );
  mkdirSync(workDir, { recursive: true });

  console.log(`Input: ${absoluteInput}`);
  console.log(`Duration: ${formatDuration(duration)}`);
  console.log(`Model: ${MODEL_NAME}`);

  try {
    const normalizedPath = join(workDir, "normalized.mp3");
    await normalizeAudio(absoluteInput, normalizedPath);
    const chunks = await splitAudio(
      normalizedPath,
      workDir,
      duration,
      options.chunkMinutes,
    );

    const { GoogleGenAI } = await import("@google/genai");
    const client = new GoogleGenAI({ apiKey: resolveApiKey() });
    const transcripts: string[] = [];
    let previousTimestamp: number | undefined;
    for (const [index, chunk] of chunks.entries()) {
      const transcript = await transcribeChunk(
        client,
        chunk,
        index,
        chunks.length,
        previousTimestamp,
      );
      transcripts.push(transcript.text);
      previousTimestamp = transcript.timestamps.at(-1) ?? previousTimestamp;
    }

    const output = `---
source: ${JSON.stringify(basename(absoluteInput))}
duration_seconds: ${Math.round(duration)}
chunks: ${chunks.length}
model: ${JSON.stringify(MODEL_NAME)}
transcribed: ${JSON.stringify(new Date().toISOString())}
---

# Transcript: ${basename(absoluteInput, extension)}

${transcripts.join("\n\n---\n\n")}
`;
    await Bun.write(outputPath, output);
    const outputFile = Bun.file(outputPath);
    if (!(await outputFile.exists()) || outputFile.size === 0) {
      throw new Error(`Transcript was not written: ${outputPath}`);
    }
    console.log(`Transcript saved: ${outputPath}`);
    if (options.keep) console.log(`Intermediate audio retained: ${workDir}`);
  } finally {
    if (!options.keep) rmSync(workDir, { recursive: true, force: true });
  }
}

async function main(): Promise<void> {
  const { values, positionals } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      "chunk-minutes": { type: "string", default: String(DEFAULT_CHUNK_MINUTES) },
      output: { type: "string" },
      keep: { type: "boolean", default: false },
      help: { type: "boolean", short: "h", default: false },
    },
    allowPositionals: true,
  });

  if (values.help || positionals.length === 0) {
    console.log(`Audio Transcription

Usage:
  bun run transcribe.ts <audio-file> [options]

Options:
  --chunk-minutes <n>  Chunk duration from 1 to 60 minutes (default: ${DEFAULT_CHUNK_MINUTES})
  --output <path>      Markdown output path (default: beside input)
  --keep               Keep normalized and chunk audio
  -h, --help           Show this help

Credentials:
  GEMINI_API_KEY (preferred), GOOGLE_API_KEY, or OPENCODE_GOOGLE_API_KEY

Model:
  GEMINI_TRANSCRIBE_MODEL (default: ${MODEL_NAME})

Supported formats: ${SUPPORTED_FORMATS.join(", ")}`);
    return;
  }

  const inputPath = positionals[0];
  const chunkMinutes = Number.parseInt(values["chunk-minutes"] as string, 10);
  if (!Number.isInteger(chunkMinutes) || chunkMinutes < 1 || chunkMinutes > 60) {
    throw new Error("--chunk-minutes must be an integer from 1 to 60.");
  }
  const inputExtension = extname(inputPath);
  const defaultOutput = join(
    dirname(inputPath),
    `${basename(inputPath, inputExtension)}.transcript.md`,
  );

  await transcribe(inputPath, {
    chunkMinutes,
    keep: values.keep as boolean,
    outputPath: (values.output as string | undefined) ?? defaultOutput,
  });
}

if (import.meta.main) {
  main().catch((error: Error) => {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  });
}
