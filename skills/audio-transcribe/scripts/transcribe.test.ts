import { describe, expect, test } from "bun:test";
import {
  extractWordAnnotations,
  formatStructuredTranscript,
  formatTimestamp,
} from "./transcribe.ts";

describe("formatTimestamp", () => {
  test("uses hours after the first hour", () => {
    expect(formatTimestamp(65)).toBe("01:05");
    expect(formatTimestamp(3665)).toBe("01:01:05");
  });
});

describe("extractWordAnnotations", () => {
  test("ignores non-word annotations", () => {
    expect(
      extractWordAnnotations({
        steps: [
          {
            content: [
              {
                annotations: [
                  { type: "citation", text: "ignored" },
                  { type: "word_info", text: "Hello", start_offset: "0.5s" },
                ],
              },
            ],
          },
        ],
      }),
    ).toEqual([{ type: "word_info", text: "Hello", start_offset: "0.5s" }]);
  });
});

describe("formatStructuredTranscript", () => {
  test("groups contiguous words by speaker and applies the chunk offset", () => {
    expect(
      formatStructuredTranscript(
        [
          { type: "word_info", speaker: "spk:1", start_offset: "0.5s", text: "Hello" },
          { type: "word_info", speaker: "spk:1", start_offset: "0.8s", text: "," },
          { type: "word_info", speaker: "spk:1", start_offset: "0.9s", text: "there" },
          { type: "word_info", speaker: "spk:2", start_offset: "2.0s", text: "Hi" },
          { type: "word_info", speaker: "spk:2", start_offset: "2.2s", text: "!" },
        ],
        60,
      ),
    ).toBe("[01:00] Speaker 1: Hello, there\n\n[01:02] Speaker 2: Hi!");
  });

  test("fails when Gemini omits usable timestamp annotations", () => {
    expect(() => formatStructuredTranscript([{ type: "word_info", text: "Hello" }], 0)).toThrow(
      "Gemini returned no timestamped word annotations.",
    );
  });
});
