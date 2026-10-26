---
name: graphic-detail
description: "Editorial chart craft in the manner of The Economist Graphic Detail, FT Visual Journalism, and NYT Graphics. Use when making or reviewing charts, maps, small multiples, annotated story graphics, or print-style visual essays, or when a graphic looks like a dashboard, chartjunk, or an unlabeled topic dump. Triggers on data viz, chart, map, graphic detail, small multiples, annotated chart, visual essay, Economist chart, FT chart."
metadata:
  category: visual-media
---

# Graphic detail

Build a newspaper graphic, not a dashboard. One finding, flat marks, labels on the data, a source line, and a page that can be read in a column. The Economist's Graphic Detail is the target. FT Visual Journalism and NYT Graphics are the peers for chart choice, annotation, and story sequence.

This is a craft brief, not those newsrooms' style guide. Public notes disagree on accent colour and on broken axes. Those conflicts are in [references.md](references.md). When a cited source contradicts a rule here, follow the source, name it, and drop the rule.

Do not invent numbers. A missing series stays missing. Placeholder marks are labeled as placeholders.

## Steps

1. **Name the question.** Write the sentence the picture must answer. "Unemployment" is a topic. "Unemployment is lower than in 2019 in four of the five countries" is a finding the chart can settle. Two findings means two graphics. Proceed with the finding the data supports. Ask only when the data can carry two different claims and the brief does not pick one.
2. **Choose the form.** Use the decision tree below. The longer menu is the [FT Visual Vocabulary](https://ft-interactive.github.io/visual-vocabulary/). A fancier form has to show something the plain form hides.
3. **Set palette, type, and placement.** [palette.md](palette.md) for colour, type, and strokes. [layout.md](layout.md) for the frame, multiples, maps, and visual essays.
4. **Draw an editable graphic.** SVG, HTML, and CSS are the default. [implement.md](implement.md) covers that stack, D3-style marks, React, and matplotlib or Plotly when a static export was actually requested.
5. **Critique it** against the checklist at the end. Deliver the graphic and a short critique: question, form, scale, accent, and what was cut.

## Principles

1. **The title is the finding.** A reader who sees only the headline should know what the picture claims. The deck carries the caveat the title cannot: the dates, the cutoff, the comparison group.
2. **Dense and calm.** Thin rules, muted neutrals, one accent used on the series or the annotation that is the sentence. Gridlines are lighter than the data and few. No shadow, no gradient fill, no fake depth.
3. **Label the marks.** Put the series name at the end of the line or beside the bar. A legend is a second lookup. Put the takeaway on the plot, next to the point it describes.
4. **Small multiples before spaghetti.** Shared scales, the same order in every panel, a quiet frame. The panel the sentence is about can take the accent or a heavier stroke. The others stay neutral.
5. **Scales that match the encoding.** Bars and columns encode by length, so they start at zero. Do not clip a bar to save space. A line may leave zero when the level is an index, or when a zero baseline would flatten a change that is the story. Mark that break, and leave air under the lowest point. Sarah Leo, citing Francis Gagnon, aims for at least a third of the plot left free under a non-zero line. Say "log scale" on the axis, and use one only when multiplicative change is the question.
6. **One panel, one baseline.** Series that do not share a unit or a baseline get two aligned panels. A double scale is a last resort. Do not tune the two ranges so the lines coincide. Leo's test: if the series hug, check whether the axes are showing comparable proportional change.
7. **Colour means a category or the one highlight.** A new hue reads as a new group. Emphasise a point inside a group with the accent, a heavier stroke, or bold type. Conventional colours win when the reader already knows them (political parties, a named map convention). One sequential ramp for a choropleth.
8. **The footer carries the method.** Source, date, unit, and the choice that would change the reading: current versus constant prices, the age cutoff, whether polls were smoothed. A smoothed line says it is smoothed.
9. **Print structure, including on screen.** Kicker, headline, deck, chart, note, source. Align to a column. Keep the margins even. On a Graphic Detail-style page the picture is the majority of the surface. Alex Selby-Boothroyd's year-one note aimed at about twice as much visualisation as text, and asked whether the piece "holds the page".
10. **A visual essay is a sequence of questions.** Each chart answers the next sub-question. The graphic stands on its own: a reader should get the point without the article (Amanda Cox). Anything the reader must see is on the default view, not in a tooltip or a click (Archie Tse).
11. **Decoration does not encode data.** A flag or a small locator can anchor a place. A scene, a 3D icon, or a gradient blob does not. If deleting it leaves the sentence intact, it was decoration.
12. **Show the pattern, and a few real cases.** An average is the wrong picture when the shape is the story. Annotate a handful of points so the pattern has examples. Cox's line on this is that the words should state the pattern or an expert's reading, and that distributions are more interesting than averages.

## Decision tree

Pick the relationship in the sentence, then the form.

| The sentence is about | Draw |
| --- | --- |
| How big, compared with others | Sorted horizontal bars, or columns for a few discrete periods. Length from zero. Value at the end of the bar. |
| Change over time | A line, labeled at its end. Zero if the level is the story. A marked break only for an index or a change that zero would hide. More than three or four crossing series: small multiples. |
| A ranking | Sorted bars. Alphabetical order is a lookup table, not a ranking. |
| Distance from a target, average, or forecast | Bars either side of that reference, or a line against a labeled reference rule. |
| A distribution | Histogram, strip, or quantiles. Put the average in the sentence beside the shape when the spread matters. |
| Parts of a whole | Labeled shares, or one stacked bar. A pie only for a single whole with two or three shares. |
| Whether two measures move together | A scatter, with a few points annotated. A trend line only if you can say what it is. |
| Place | A map when location is the subject. Otherwise a bar of places. One labeled sequential ramp. Missing data has its own swatch. |
| Movement between states | A flow or a slope. If the question is really "who is larger now", use a ranking. |
| Two units | Two panels that share time or category. A double scale only after that fails, with ranges that are not fitted to each other. |

Elizabeth Lees's public notes add two Economist forms. A bubble chart can show a huge range, and it still needs labels because area is hard to compare. A thermometer chart compares two categories (two groups, or two years) in a small space. Rosamund Pearce describes the thermometer as the form they used, instead of a column, when a numerical axis had to be broken. A broken bar or column still misleads: the rectangle's length is the value.

## Anti-patterns

| Mistake | Fix |
| --- | --- |
| Chartjunk, heavy grids, pictures inside bars, moiré | Flat marks, few 1px rules, no texture |
| Rainbow or jet scales | One sequential ramp, labeled with the unit |
| 3D bars, 3D pies, extrusions, isometric "depth" | Flat marks. Selby-Boothroyd's year-one note mentions 3D pies in a list of unused forms. That is not a licence |
| Dual axis tuned so two series agree | Two panels, or one shared scale |
| Truncated bar or column | Full length from zero. A break belongs on a line or a marked thermometer, and it is signed |
| Gradient fills, glass, neon-on-dark SaaS cards, soft drop shadows | Paper background, flat fills, one accent |
| KPI tiles, filter chrome, a grid of identical rounded cards | One question and an editorial frame |
| Six hues of spaghetti | Small multiples, or one accent and grey |
| Topic title, colour legend as the only key | Finding as the title, direct labels, annotation on the mark |
| The point hidden in hover, a tab, or a slider | The default view states the finding. Tse's 2016 rule beats Cox's earlier fondness for sliders |
| Decorative illustration, AI-slop scenes | Marks that encode data, plus the source line |
| Invented or smoothed data that is not labeled as such | The supplied values only. Smoothing is disclosed in the note |

## Critique

Answer these before handing the graphic over:

- Can a reader state the claim from the title alone?
- Does every colour encode a category or the single highlight?
- Do bars start at zero? If a line does not, is the break marked, and is there air under the line?
- Is the takeaway on the plot, next to the mark?
- Are the numbers the ones supplied, including gaps?
- What was cut (legend, second axis, extra series, gradient, icon)?
- Would it still read in one column, in black plus one spot colour?

Then check the disagreements in [references.md](references.md). If a linked source contradicts the graphic, change the graphic or cite the source you followed.

## References

Roles and links, with the conflicts and the pages that were not read: [references.md](references.md).

| Person | Use their public record for |
| --- | --- |
| [Matt McLean](https://mediadirectory.economist.com/people/matt-mclean/) | The Graphic Detail design role. No open craft essay of his is cited here. |
| [Sarah Leo](https://mediadirectory.economist.com/people/sarah-leo/) | [Mistakes, we've drawn a few](https://medium.economist.com/mistakes-weve-drawn-a-few-8cdd8a42d368): truncated bars, forced double scales, colour that implies a false category. |
| [Martín González Gómez](https://martingonzalez.net/) | Reported visual stories and detailed maps. His site is a portfolio, not a written style sheet. |
| [John Burn-Murdoch](https://gijn.org/stories/data-visualization-storytelling-tips-john-burn-murdoch/) | Narrative titles, direct labels, one point of contrast, annotation for a general reader. |
| [Alan Smith](https://www.ft.com/alan-smith) | [FT Visual Vocabulary](https://ft-interactive.github.io/visual-vocabulary/) and *How Charts Work*. The vocabulary is the open artifact. This skill does not claim the book was read. |
| [Caroline Nevitt](https://www.ft.com/caroline-nevitt) | Design lead for FT data and visual storytelling. No open craft note of hers is cited here. |
| [Amanda Cox](https://simplystatistics.org/posts/2012-06-01-interview-with-amanda-cox-graphics-editor-at-the-new/) | Annotation, standalone graphics, distributions over averages. [Lecture abstract](https://stat.osu.edu/events/wherry-lecture-amanda-cox). |
| [Archie Tse](https://github.com/archietse/malofiej-2016) | Default view, scroll, and a high bar for interaction. [2016 slides](https://github.com/archietse/malofiej-2016). |

Named Economist pages: [Graphic Detail](https://www.economist.com/graphic-detail), the [2020 chart round-up](https://www.economist.com/graphic-detail/2020/12/24/a-round-up-of-our-favourite-charts-of-2020), and the [2020 print PDF](https://infographics.economist.com/2020/XmasTreat/AYearInGraphicDetail2020.pdf). What was and was not readable is in [references.md](references.md).
