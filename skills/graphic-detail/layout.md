# Layout

A graphic is a column of type and a plot, in that order. The plot is the largest object. The type tells the reader what the plot claims, then gets out of the way.

## Frame

```
kicker          Graphic detail
headline        the finding, one sentence
deck            scope, dates, the caveat
plot            marks, direct labels, one or two notes on the data
note            break in the scale, smoothing, definition
source          who measured it, and when
```

On screen, leave 16–24px between the deck and the plot, and 12–16px between the plot and the note. The plot does not touch the type. In print, align the block to the column. Do not bleed the plot into the headline.

The opening of the public [2020 print PDF](https://infographics.economist.com/2020/XmasTreat/AYearInGraphicDetail2020.pdf) shows this stack: a Graphic Detail kicker, a sentence-style headline, a source line, and ranked bars with the event written on the bar. That probability chart runs from 0 to 100 and labels the bands in words (very unlikely, unlikely, evens, likely, very likely) as well as in numbers. Treat it as one opening spread, not a survey of the file. Later pages were not reviewed.

## Column and grid

One column for a single chart. For a story page, a stack of full-width charts, or one main chart with a rail of small multiples that share its scale. Gutters are even. Panel edges line up with the headline's left edge.

Do not lay the piece out as a dashboard: no row of summary tiles, no identical cards, no floating legend panel, no toolbar.

Selby-Boothroyd's test for a print page was whether the visualisation held the page, at roughly two parts picture to one part text. A single thin line chart often fails that test. The remedy is another cut of the same data (a breakdown, a map, a distribution), not a larger title and not decoration.

## Annotation

- The title states the claim. The note on the plot points at the mark that makes the claim true: the peak, the crossing, the outlier, the latest point.
- Two notes are usually enough. A third has to earn its place by preventing a misread.
- Place the note so it does not cross the series. If the plot is crowded, move the note into the margin and run a 1px rule to the mark.
- Direct-label the series at the end of the line, in the line's colour. The label is left-aligned just past the last point, or just inside the plot if the margin is tight.
- End values and category names use tabular figures.
- Burn-Murdoch's reported reading order is a Z: title, then the axes, then the data. Write the axis titles as words ("Years", "Share of adults, %"), not as a unit floating alone, when the unit is easy to miss.

## Small multiples

- Same scale, including the zero, unless a panel is explicitly a different unit. If the scales differ, say so in that panel's title.
- Same order of categories, same colour for the same series, same stroke widths.
- The panel title is the category (the country, the year, the group). It sits above the panel, left-aligned.
- Sort panels by the value the headline is about, or by a geography the reader expects. Do not leave them in the order of the file.
- Draw the axis once, on the bottom row and the left column, when the panels align. Repeating every tick label in every panel is noise.
- Three to twelve panels is the usual range. Past that, the sentence is probably a ranking and wants bars.

## Maps

Use a map when "where" is the question. If the reader must compare magnitudes, draw bars and use the map as a locator, or do not draw the map.

- One sequential ramp. Label the low end, the high end, and the unit.
- Missing data has a swatch labeled "No data", outside the ramp.
- A choropleth of counts will praise large places. Map a rate, or say that you are mapping counts and pair it with a ranking.
- Name the projection when the shape or the area of regions does the arguing. An equal-area projection is the default for a choropleth of rates.
- Coastlines and borders are thinner and lighter than the data fill. No relief shading, no satellite texture.
- A locator inset is useful when the main map is a region. It is a small outline, not a second dataset.

## Sparklines

No axes except a zero rule when the sign matters. Label the latest value and, if the comparison is the point, the start value. The latest point takes the accent. A sparkline is a clause in a table, not a chart with a title of its own.

## Visual essays

Sequence the page as sub-questions. A typical order:

1. The result, in the form that makes the comparison obvious.
2. The cut that makes the result surprising (who, where, or when).
3. The distribution or the exceptions behind the average.
4. The caveat: what the measure leaves out, as its own small graphic or as the note.

Each step has its own finding-title. The page scrolls. Scroll may reveal the next sentence. A click, a tab, or a slider may not be the only place that sentence exists. Tse's 2016 rules: if the reader must do something other than scroll, the interaction has to show something the static frame cannot; assume a tooltip is never seen; interaction across viewports is expensive, so the static version comes first.

Cox's earlier interview liked sliders because they imply a beginning, middle, and end. Prefer the later rule. If a slider stays, the first frame still states the finding, and the slider changes a variable the title has named.

The piece should still make sense printed: the same order, the same titles, no hover.

## Source line

One line, then a second only if the method needs it.

```
Source: OECD, 2024. Share of adults 25–64. Prices are current, not constant.
```

Include:

- The publisher of the figures, not the chart author.
- The year or the vintage of the extract.
- The unit and the population, if the title did not already fix them.
- The adjustment that a careful reader would ask about.

A correction or a known gap goes here too, in the same voice, without apology.
