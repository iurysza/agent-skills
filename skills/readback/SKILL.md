---
name: readback
description: Restate the user's intention to verify alignment.
---

# Readback

State what you believe the user wants accomplished.

A readback is not a plan. It describes **what the user has asked and his intention**.

## Process

1. Inspect the relevant code and context.
2. Infer the user's intended outcome.
3. Preserve important constraints, conditions, and negative requirements.
4. Surface assumptions or unresolved decisions.
5. Give the readback.
6. Stop and wait for correction or approval.

## Domain Language + Plain-English Gloss

Use established **terms of art** when they accurately describe the user's intent, but immediately gloss them in plain English.

Prefer:

> Use a **vertical slice** — build one small part of the feature end-to-end so it can actually be tested.

Over either:

> Use a vertical slice.

or:

> Build one small part through every layer of the system...

The goal is to preserve useful domain language without requiring the user to already know it.

Do not introduce jargon just to sound technical. Use it when it gives the idea a useful name.

## Rules

- Do not turn the readback into an implementation plan.
- Do not silently resolve meaningful ambiguity.
- Preserve conditions closely enough that their meaning cannot be lost.
- Treat negative requirements as first-class constraints.
- Use domain language when useful, followed by a plain-English gloss.
- If the user corrects the readback, update it before proceeding.
- For trivial, unambiguous changes, skip the full readback.

## Principle

Make sure your response sounds like one human talking to another.
Remove jargon, ceremony, repetition, and unnecessary structure. Preserve the meaning and any important caveats.
