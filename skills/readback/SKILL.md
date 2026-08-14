---
name: readback
description: Restate the user's intention to verify alignment.
---

## Definition

A readback is the repetition of an instruction, request, or piece of information received from the user, stated back by the coding agent or assistant. It says what the user asked or what they meant to say so both sides can confirm the same understanding.

## Purpose

- Confirm that the agent correctly received and understood the user's instruction or intent.
- Allow the user to verify accuracy and correct any misunderstanding.
- Prevent errors caused by acting on a mistaken interpretation.

## Process

1. Inspect the relevant context.
2. Infer the user's intended outcome or meaning.
3. Preserve important constraints and conditions.
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
- Use domain language when useful, followed by a plain-English gloss.
- If the user corrects the readback, update it before proceeding.

## Principle

Make sure your response sounds like one human talking to another.
Remove jargon, ceremony, repetition, and unnecessary structure. Preserve the meaning and any important caveats.
