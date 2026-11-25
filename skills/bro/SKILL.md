---
name: bro
description: "Plain, concise human rewrites across three modes: restate your last response plainly (bro), turn a technical review into a short casual Slack or PR reply (reply-bro), or proofread and tighten supplied text (rephrase). Use only when the user asks."
metadata:
  category: writing-style
---

# Bro

Rewrite text so it sounds like one human talking to another. Pick the mode that matches the request. Use straight quotes, no em dashes, no bold lead-ins and no AI filler.

## Mode 1: Plain restatement (bro / explain simpler)

Restate the previous response like one human talking to another. Make it clearly shorter than the original, about two-thirds to three-quarters of its length or less, in one short plain paragraph with no headings, ceremony, filler or repetition. Translate technical jargon into everyday words instead of repeating buzzwords. Keep the core meaning and every important caveat.

## Mode 2: Slack or PR review reply (reply-bro / make a reply casual)

Turn a technical review reply into a short message that sounds like an engineer typed it quickly in Slack or a PR thread:

- Output only the message. No headings, bullets or commentary.
- Use 3 or 4 short sentences.
- Start with a positive acknowledgement, such as "Good shout."
- Keep only the main technical concern. Cut specification detail, repeated reasoning and formal language.
- Raise the concern as a question, not a rejection ("Would this fit here though?", "It looks like...").
- End by asking whether a simpler alternative works ("Maybe keeping `existing.attribute` is simpler?").
- Use plain, casual language. Do not sound certain, argumentative or formal.

Example source:
> That RFC is why we should not use `http.request.body.size` for queue payloads. It is defined for HTTP request bodies on web servers, and the spec requires HTTP method and route attributes alongside it. A background worker job has none of those. Additionally, computing the payload bucket in the dashboard would mean shipping and storing the raw byte count on every event. We should keep `job.payload.bucket`.

Example reply:
> Good shout. Would `http.request.body.size` fit here though? It looks like an HTTP server attribute, while we just need payload size on a background job. Computing it in the dashboard would also mean sending raw byte counts. Maybe keeping `job.payload.bucket` is simpler?

## Mode 3: Proofread and tighten (rephrase / fix rough or voice-transcribed text)

Proofread and tighten supplied voice-transcribed or rough text. Fix typos and grammar while keeping the original sentiment and the author's voice. Make the phrasing tighter with minimal changes. Output only the revised text unless asked to explain.
