# Palette, type, and strokes

The working values below are for this skill. They are not The Economist's chart specification. Publish a different hex only when a linked source in [references.md](references.md) gives it, and say which source.

## Working palette

Use these unless the project already has editorial tokens. One accent on the marks that carry the sentence. Everything else is ink, paper, or a quiet context series.

| Role | Hex | Use |
| --- | --- | --- |
| Paper | `#ffffff` | Page and plot. A warm paper `#f7f5f0` is fine when the surrounding page is warm. Do not use a cream SaaS backdrop as decoration. |
| Ink | `#121212` | Headline and labels on the data. The Economist's 2020 election design sheet names Beijing `#121212` as a near-black. It is a brand sheet, not proof of the chart text colour. |
| Secondary ink | `#4a4540` | Deck, annotations, axis text. |
| Meta | `#6e6a64` | Source line, tick labels, footnotes. |
| Rule | `#d9d4cc` | Axis baseline and the rare gridline. |
| Context series | `#8e8880` | Series that are present so the accent has something to stand against. |
| Accent | `#E3120B` | Optional Economist brand nod. One series, one annotation, or the latest point. Not every bar. |

`#E3120B` (RGB 227, 18, 11) is Economist red on the public [2020 US election design sheet](https://cdn.design-system.economist.com/documents/US2020election.pdf). Helen Atkinson's 2020 note on Instagram charts uses a different red, `#EC111A`, as the highlight, with quieter blues behind it. Do not "correct" one into the other. If the piece is not wearing the brand, pick one semantic accent and keep red out of it, so red is not both "the point" and "bad".

## What the public notes actually say about colour

Elizabeth Lees ([Economist Education, 27 February 2024](https://education.economist.com/blog/interviews/tips-for-visualising-data-like-the-economist)):

- The pair she describes is a dark blue and a light blue, chosen for contrast. She does not publish hex values.
- About six colours is the practical ceiling. Past that, colour only the series that carries the point and let the rest recede.
- Political parties keep the colours readers already associate with them.
- Highlight with the accent, a tint, or bold type. A new hue is the wrong tool for emphasis inside one group.

Atkinson ([Charting new territory, 31 January 2020](https://medium.economist.com/charting-new-territory-7f5afb293270)):

- For Instagram, the template highlight is red `#EC111A`, and blues are secondary.
- Party colours, and map colours that already mean something, override the template.
- She treats that template as a default you may leave, not as a law.

The election sheet also names Chicago `#2E3C85`. That is an election identity colour. It is not Lees's chart blue. Do not invent official chart-blue hexes to fill the gap.

John Burn-Murdoch's public craft talk, as reported by GIJN: one colour that pops in a field of grey directs attention. A rainbow directs it nowhere. His phrase for the aim is to minimise distraction and maximise contrast.

## Semantic colour

Use a conventional colour when the convention is the reader's, not yours:

- A party, a national flag used as a locator, a sequential scheme the domain already uses.
- Up and down only when the subject is a signed change and the audience expects that encoding. Do not paint "bad" red on an Economist-red graphic. Move the judgment into the title.

Choropleths get one sequential ramp, light for the low end on a light page, dark for the high end. State min, max, and unit on the ramp. Missing data is a hatch or a neutral swatch outside the ramp, never the colour of zero.

Diverging ramps are for data with a true midpoint (change, balance, anomaly). The midpoint is labeled. The two ends are not a rainbow.

## Type

Do not require Economist or FT proprietary faces (Econ Sans, Milo, Financier). Use what the page already uses. If nothing is set:

- Headline: `Georgia, "Iowan Old Style", "Palatino Linotype", Palatino, serif`
- Labels, ticks, source: `system-ui, sans-serif` or the page's text face
- Figures: `font-variant-numeric: tabular-nums`

Hierarchy, from large to small: headline, deck, annotation, axis and source. Annotations are smaller than the title and larger than the source. Sentence case. One kicker is enough ("Graphic detail", or the section the piece belongs to). Do not put a tracked all-caps eyebrow on every chart.

Axis text is horizontal. Rotate a label only when the category names are long, and then prefer horizontal bars so the names stay horizontal.

## Strokes and fills

- Accent line: 1.75px. Context line: 1px. Both `stroke-linejoin: round` and `stroke-linecap: round`.
- Bars: flat fill, no stroke. Gap between bars is about a third of the bar thickness. Corner radius is 0. A 1px radius is the most a bar may have.
- Baseline: 1px, colour `#121212` or the meta ink. Other gridlines: 0 or one horizontal rule at a labeled tick, in the rule colour.
- Points: only when the observation is the object (a poll, an event). A dense time series has no default markers. The latest point may be a filled accent dot with its value beside it.
- Annotation rules: 1px, the accent or the meta ink, ending on the mark. No arrowheads unless the endpoint would be ambiguous. No glows.
- Fills are flat. A sequential ramp is a scale, not a gradient washed behind the chart.

## Highlight without a new hue

Lees's three tools, in order:

1. Bold the label of the row or point the sentence is about.
2. Tint that mark with the accent and leave its neighbours in the context grey.
3. A short note at the mark, in the accent, saying what the reader should see.
