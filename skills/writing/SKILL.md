---
name: writing
description: "Applies to any prose you write or edit: chat replies, PR and commit text, docs, reports, reviews, manager or stakeholder updates, escalations, approval requests. Plain English in GOV.UK style, no AI tells, four-part executive updates. Must always apply."
metadata:
  category: writing-style
---

# Writing

Write and edit prose in plain English, GOV.UK style: clear, concise, no AI tells. Follow all of it. Breaking a rule has to buy a compensating merit.

For a report, research write-up, guidance, documentation, announcement or summary, also read [references/report-style.md](references/report-style.md). When you brief an agent to write, tell it to follow this skill and that reference. For docs with a structure (tutorial, how-to, reference, explanation), also use `technical-writing`.

## Process

1. Scan for the patterns below. Mark repeated habits rather than banning isolated words.
2. Rewrite the smallest span that fixes each problem. Preserve meaning, facts, certainty, deliberate humor and intended tone.
3. Add voice (see below), or leave already-clean text alone.
4. Self-audit: "What makes this obviously AI generated?" Fix remaining tells and any repetition introduced while editing.

## Plain English

- Front-load. Conclusion first, then detail, then background. Do the same in each section, paragraph and sentence.
- One idea per sentence. Aim for 15 words, never over 25. If a sentence carries two ideas, split it into two sentences. Split what makes the reader backtrack.
- Active voice. Name the actor: "the compiler validates queries", not "queries are validated". Passive only when the receiver should be the subject or the actor is unknown or doesn't matter. No double passives. No weak existentials: "There were a great number of dead leaves lying on the ground" becomes "Dead leaves covered the ground."
- Cut needless words. "the question as to whether" becomes "whether", "owing to the fact that" becomes "because", "he is a man who" becomes "he", "the fact that he had not succeeded" becomes "his failure". Cut adverbs and intensifiers, or use a stronger verb: "significantly improves" becomes the measured delta, "very good" becomes "excellent".
- Positive form. "not honest" becomes "dishonest", "did not remember" becomes "forgot". Negation is fine for antithesis.
- Everyday words. "use", not "utilise" or "leverage"; "help", not "facilitate"; "about", not "in relation to"; "so", not "in order to"; "start", not "commence"; "enough", not "sufficient". "impact" is not a verb.
- Say what it does, not how it feels. "SQL you can read" and "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". If you can't restate a sentence as a concrete instruction, fact, or number, cut it. If it could appear unchanged in another project's docs, it says nothing about this one.
- Address the reader as "you", yourself or your organisation as "we", others as "they". Contractions are fine in chat and PR replies. In docs and reports write "cannot" and "do not".
- Numbers and dates: write "one", then numerals from 2 upwards (9, 25) and `%` (50%); `£` with no `.00` and spelled-out `million`/`billion` (`£75`, `£5 million`); ranges with `to` (`10 to 20`, `Monday to Friday`, `4 to 8 June`); dates as `4 June 2026` (no comma, no `th`); times with a dot (`10.30am to 11.45am`), `midday`, `midnight`.
- Commit messages: imperative subject (under 72 characters, no `#` heading) plus a short body of 2 or 3 active-voice sentences (under 55 words total, zero passive voice) naming who or what does each action.
- Open it up, don't dumb it down: keep every fact, nuance and number.

## Voice

Removing patterns is half the job. Sterile, voiceless writing is just as obvious. Have a view where the writing allows one: chat, explanations, newsletters. Guidance and reference state facts. Vary rhythm: short sentences, then fuller ones (still under 25 words). Acknowledge complexity ("impressive but also kind of unsettling" beats "impressive"). Use "I" when it fits. Let some mess in, because perfect structure looks machine-made. Be specific: not "this is concerning" but "there's something unsettling about agents churning away at 3am".

## AI tells

Cut the tells in Wikipedia's "Signs of AI writing": puffery and promotional language, name-dropping, vague attributions ("experts believe"), superficial -ing phrases, "serves as" for "is", "not just X but Y", rule of three, synonym cycling, false ranges, "despite challenges... continues to thrive", AI vocabulary (delve, tapestry, underscore, landscape, intricate), chatbot phrases ("Certainly!", "Found the smoking gun!"), sycophancy, cutoff disclaimers, filler, hedging, generic conclusions. State what happened, name the source, or delete.

- Cut magic adverbs ("quietly", "deeply", "fundamentally", "remarkably", "arguably"), countdowns ("Not X. Not Y. Just Z."), self-posed rhetorical Q&A ("The result? Devastating."), repeated sentence openings (anaphora), stacked one-word fragments, and disguised listicles ("The first... The second... The third...").
- Cut AI tone tropes: "Here's the kicker/thing/deal", "Think of it as...", "Imagine a world where...", "Let's break this down/unpack this", "The truth is simple", performative vulnerability ("This is not a rant; it's a diagnosis"), grandiose stakes, invented compound labels ("supervision paradox", "acceleration trap", "workload creep"), fractal section summaries, historical analogy stacks, dead repeated metaphors, and signposted conclusions ("In conclusion", "To sum up", "In summary").
- No em dashes. Use periods or commas. No en dash, spaced hyphen or parentheses standing in for one. Parentheses are fine otherwise.
- Colons are fine before a list or example, not as a mid-sentence connector. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" gains nothing from the colon. Rewrite so the point stands without comparison framing: "Describing when the scheduler should fire works best as plain English."
- Bold and italics only for a literal interface element ("select Save"). No bold lead-ins, no bold-label-and-colon bullets ("**Performance:** Performance improved..."), no bold proper nouns.
- Sentence case headings. No decorative emojis or unicode arrows (`→`; use `->` or words). Straight quotes.
- Abstract metaphor nouns read as technical but have a plainer concrete word: substrate, wedge, vector, locus, vantage, nexus, primitive (noun), harness (metaphor), surface ("API surface"), bedrock, scaffolding, modality, paradigm, gold-plating, ratchet, evacuate (for moving code), endgame, north star, flywheel, and the GOV.UK clichés (drive, unlock, deep dive, robust, key, ring-fence, hub, portal, ecosystem, going forward). "Substrate" becomes "base", "wedge in" becomes "add", "gold-plating" becomes "more than the job needs", "ratchet" becomes the mechanism's real name, "evacuate" becomes "move out". Pick the concrete word.

## Executive updates

For a status update, message to a manager or stakeholder, escalation, decision or approval request, or research summary the reader must act on, reorder and cut (add no new research) into four parts in order (skip step 1 when a report title or heading already gives the context, and open a report summary straight with the recommendation):

1. Context: one line reminding the reader of the question or problem on the table.
2. Assertion: your answer or recommendation and its reasons in 1 to 2 sentences, even when tentative ("my first take is"). For an escalation, state the problem and its impact.
3. Evidence: only the facts backing each reason (about one per reason), with numbers and source. Never invent a number; if one is missing, say so. If a reason has no fact, call it a hunch. Put uncertainty in one plain sentence after the evidence instead of hedging every line.
4. Next steps: what happens next, who does it and when, plus one specific ask (yes/no, a choice between named options, or a deadline). Never write "let me know your thoughts".

Cut the chronological story of what you did; mention method only if it changes trust. Scale to the channel (one sentence per part in Slack, short sections in a memo). The four parts are structure, not headings, unless the doc is long enough to need headings.

## Grammar and usage (The Elements of Style)

- Keep related words together: subject near verb, relative pronoun right after its antecedent, modifier next to the word it modifies ("found only two mistakes").
- Parallel form for co-ordinate ideas, including both...and and not only...but also. Emphatic words last.
- One paragraph per topic, topic sentence first. A one-sentence paragraph stands alone only as a transition.
- Parenthetic expressions take a pair of commas, never one. Restrictive clauses take no commas; non-restrictive clauses do.
- A comma before "and" or "but" joining independent clauses. No comma splices: use a period, also before "so", "therefore", "thus". No semicolons. No sentence fragments. A participial opener must refer to the grammatical subject.
- No serial comma: "red, white and blue". Singular possessive takes 's even after s (Charles's).
- Cut hackneyed words: "factor", "feature", "along these lines", "worth while".
- "while" means "during the time that". "literally" never supports exaggeration. "claim" and "state" are not "say". "due to" modifies a noun, not a verb. "less" for quantity, "fewer" for number. "compare to" points out likeness, "compare with" points out difference.
