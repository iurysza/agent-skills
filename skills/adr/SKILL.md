---
name: adr
description: Create and maintain concise Architecture Decision Records when a project makes a consequential technical choice, compares architectural options, changes an established pattern, or needs the rationale preserved for future contributors.
license: MIT
compatibility: Requires file read and write access to the project documentation tree.
---

# Architecture Decision Records

Record decisions whose rationale will matter after the current conversation ends.

## Use an ADR when

- several viable options have meaningful trade-offs
- a choice changes architecture, security, data ownership, deployment, or team conventions
- a project intentionally departs from an existing standard
- a previous decision is replaced or deprecated

Skip ADRs for routine implementation details, reversible experiments, and choices already dictated by project policy.

## Before writing

1. Read project instructions and existing architecture documentation.
2. Look for an established ADR directory, template, numbering scheme, and index.
3. Search existing ADRs for related or superseded decisions.
4. Gather only missing facts: context, options, decision, rationale, consequences, and status.

Follow the project's existing convention. If none exists, use `docs/decisions/`, filenames such as `ADR-0001-short-title.md`, and the bundled templates.

Never overwrite an existing ADR number. Determine the next number from the files already present.

## Workflow

1. State the decision in one sentence.
2. Explain the constraint or problem that forced the choice.
3. Compare the serious alternatives, including doing nothing when relevant.
4. Record why the selected option wins under the stated constraints.
5. List positive, negative, and follow-up consequences.
6. Link related ADRs, plans, issues, or source evidence.
7. Write the ADR using [references/adr-template.md](references/adr-template.md).
8. Create or update the index using [references/index-template.md](references/index-template.md).
9. Check that the ADR describes one decision and contains no invented rationale.

If the decision is not final, use `Proposed`. Do not label it `Accepted` merely because the agent recommends it.

## Statuses

- `Proposed`: under review
- `Accepted`: approved and current
- `Deprecated`: retained for history but discouraged
- `Superseded`: replaced by another ADR; link the replacement

Do not rewrite history when a decision changes. Add a new ADR, mark the old one superseded, and cross-link both records.

## Quality bar

A useful ADR is short enough to scan and complete enough to explain the trade-off:

- title names the decision, not the meeting or project
- context describes constraints rather than retelling the discussion
- alternatives are credible and treated fairly
- decision and rationale are explicit
- consequences include costs and operational follow-up
- status, date, and links are accurate
- index is updated in the same change

Report the ADR path, status, one-line decision, and any index or supersession changes when finished.
