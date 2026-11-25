---
name: technical-writing
description: "Layered technical-writing standard: Diátaxis structure, Google developer style sentences, STE instruction rules, Global English syntax. Use for /skill:technical-writing or when writing or reviewing docs, RFCs, readmes, PR descriptions, or commit messages."
metadata:
  category: writing-style
---

# Technical writing

The goal is writing a tired engineer understands on the first read. Four layers get you there, one question each: what kind of document is this (Diátaxis), how do sentences address the reader (Google developer style), how much does each sentence carry (ASD-STE100), and can any sentence be read two ways (Global English). Apply all four.

For prose itself (plain words, active voice, voice, AI tells, grammar) follow the `writing` skill. This skill adds what docs need on top.

When a rule makes a sentence worse, fix the sentence another way or leave it alone. The rules serve the reader. A sentence that follows every rule and sounds like a machine wrote it has failed.

The codebase is the word list. Write the real symbol, file, flag, or command name, not a synonym or a description of it. A named pattern is fine when the doc says what it means the first time.

## Pick the mode first (Diátaxis)

One document, one mode. Does the content inform action or understanding, and does it serve learning or work?

- **Tutorial** (action, learning): you are the teacher. Open by saying what the learner will build, not what they will "learn". Every step produces a visible result and says what they should see. Explanation is one clause and a link. Write as "we", in commands.
- **How-to** (action, work): solves a problem a person has, not an operation the machine can perform. Assume competence. Action only: no background, no teaching. Allow forks: "If you want x, do y." Name it by the task: "How to calibrate the radar array".
- **Reference** (understanding, work): describe, and only describe. No instruction, persuasion or opinion. Dry, complete, sure. Mirror the structure of the thing described. Generate from code where possible.
- **Explanation** (understanding, learning): one bounded topic anchored on a why question. Give context: decisions, history, constraints, alternatives. Opinion is allowed here and nowhere else.

Don't mix modes. Split and link instead.

## Write sentences to the reader (Google developer style)

- Write instructions as commands. State facts plainly. Never "should be done".
- Put the condition before the instruction: "To delete the document, click Delete." Put the common case first, exceptions after.
- No "please" in instructions, and never "simply", "easy", or "quickly" in a procedure.
- Headings carry the point. A task heading is a bare verb phrase ("Create an instance"), a concept heading a noun phrase. One h1 per page, no skipped levels.
- Numbered lists for sequences, bullets for the rest. Introduce a list with a complete sentence. Keep items parallel.
- Code goes in code font, UI elements in bold. Say up front when a list is partial.

## Make statements load one at a time (ASD-STE100, about 80%)

- One instruction per sentence. One thought per sentence everywhere else.
- Split instructions longer than about 20 words and other sentences longer than about 25.
- Put the warning or condition before the step it guards: "If hot oil touches your skin, injuries can occur."
- Keep "the" and "a": "Remove the backup file", not "Remove backup file".
- One word, one meaning, one job: "start", not "start" here and "initiate" there.
- Write procedures as direct commands, never as narration and never in the passive.
- Avoid "-ing" words where you can.

## Leave no sentence open to two readings (Global English)

- Keep "only" and "not" next to the word they change: "fails only on growth".
- Break long noun strings: "the proto import budget check script" becomes "the script that checks the proto-import budget".
- Make every "it", "they", and "this" point at one obvious thing. Never use "this" or "which" for a whole clause.
- Don't drop verbs: "Phase 1 moves the converters and Phase 2 the runtime" leaves Phase 2 without one. Keep "that" and the article in a series ("the client and the host").
- Say which parts "and" or "or" joins when a sentence can group two ways.
- Make text in parentheses a full unit. No "(s)". No slashes: "a, b or both", not "a/b" or "and/or".
- Call each thing by one name, everywhere. A doc that says "the gate", "the ratchet", and "the budget check" for one thing teaches three things. Don't reword an unchanged sentence between edits.
- Skip idioms and colloquialisms.

## Voice and repo specifics

- Follow the `writing` skill for the prose of every doc this skill touches.
- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies to them. Keep a commit message to an imperative subject (under 72 characters, no `#` heading) plus 2 or 3 short active-voice sentences (under 55 words total, zero passive voice) naming who or what does each action.
- Product UI strings are not documentation. Use your product's copy guidelines for those.
- Indent code snippets with tabs. Write real paths and real symbols. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.
