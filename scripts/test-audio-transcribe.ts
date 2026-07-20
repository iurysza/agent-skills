#!/usr/bin/env bun
import { safeProviderError } from "../skills/audio-transcribe/scripts/transcribe.ts";

class ProviderFailure extends Error {
  status = 429;
  code = "resource_exhausted";
}

const privateText = "private transcript content";
const rendered = safeProviderError(
  new ProviderFailure(`provider echoed input: ${privateText}`),
);

if (rendered.includes(privateText)) {
  throw new Error("provider error summary leaked private content");
}
if (rendered !== "ProviderFailure status=429 code=resource_exhausted") {
  throw new Error(`unexpected provider error summary: ${rendered}`);
}

console.log("audio transcription boundary tests passed");
