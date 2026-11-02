# Implementation

Produce an editable graphic. SVG, HTML, and CSS are the default because a news graphic is type plus marks, and both stay editable. Python is for a static figure when the brief asks for one. A chart library is a scale calculator, not the look of the piece.

Do not ship the library's demo theme: right-hand legend, tooltip as the only label, category colours, rounded bars, gradient area fills.

## HTML and SVG

The title and the source are HTML, so they can be read and selected. The plot is an SVG with real `<text>`, not outlined paths.

```html
<!-- Sample frame only. Replace the title with the claim the supplied data supports. -->
<figure class="gd">
  <p class="gd-kicker">Graphic detail</p>
  <h2 class="gd-title">Four of the five economies are back under 2% inflation</h2>
  <p class="gd-deck">Consumer prices, change on a year earlier, September 2024.</p>
  <svg class="gd-plot" viewBox="0 0 640 360" role="img" aria-labelledby="gd-title">
    <title id="gd-title">Four of the five economies are back under 2% inflation</title>
    <line class="gd-baseline" x1="120" y1="300" x2="600" y2="300" />
    <!-- marks, then labels. Text is last so it stays on top. -->
    <text class="gd-series" x="608" y="148">Japan</text>
  </svg>
  <p class="gd-note">Say what the scale does, and define the measure, in one or two sentences.</p>
  <p class="gd-source">Source: name the dataset and the vintage.</p>
</figure>
```

```css
.gd {
  max-width: 40rem;
  margin: 0;
  color: #121212;
  font-family: Georgia, "Iowan Old Style", Palatino, serif;
}
.gd-kicker,
.gd-deck,
.gd-note,
.gd-source,
.gd-plot text {
  font-family: system-ui, sans-serif;
  font-variant-numeric: tabular-nums;
}
.gd-kicker { margin: 0; font-size: 0.75rem; letter-spacing: 0; color: #6e6a64; }
.gd-title { margin: 0.25rem 0 0; font-size: 1.5rem; line-height: 1.2; font-weight: 600; }
.gd-deck { margin: 0.4rem 0 0.8rem; color: #4a4540; }
.gd-plot { width: 100%; height: auto; display: block; }
.gd-baseline { stroke: #121212; stroke-width: 1; }
.gd-note, .gd-source { margin: 0.6rem 0 0; font-size: 0.75rem; color: #6e6a64; }
.gd-series { font-size: 12px; fill: #E3120B; }
```

In the SVG:

- Set the viewBox and draw in that coordinate space. Let CSS size the figure.
- One `<g>` per series. Context series use `#8e8880`. The series in the title uses `#E3120B` or the project's single accent.
- Ticks are short lines and `<text>`. Four to six ticks are enough. Do not draw a box around the plot.
- Bars are `<rect>` from the baseline. The baseline is the zero line. Width encodes nothing.
- Lines are `<polyline>` or `<path>` with `fill="none"`. No marker on every vertex.
- Labels are `<text>` with `font-size` in px inside the viewBox so they scale with the plot. Do not convert them to paths.
- No `<filter>`, no drop shadow, no gradient on a bar. A `<linearGradient>` is acceptable only as a labeled sequential legend.
- `prefers-reduced-motion: reduce` disables any stroke animation. The static frame already contains the finding.

Check the SVG at a narrow width. Direct labels that collide become a small-multiple layout, not a smaller font jammed into the line.

## D3-style marks

Use D3, or any other scale helper, to compute positions. The rendered attributes should match the CSS above.

- `scaleLinear` for magnitude, with the domain starting at 0 for bars. For a broken line scale, set the domain from the data and draw the break mark yourself.
- `scaleBand` for categories, with `paddingInner` around 0.3.
- Override axis colour, font, and tick count. The default axis is too dark and too busy.
- Do not use `schemeCategory10` or any rainbow interpolator. One accent, one grey, and a semantic colour only when [palette.md](palette.md) allows it.
- Append labels as text at the data point. A hover tooltip may repeat the value. It may not be the only place the value exists.
- Skip enter animations on load. A transition is acceptable when the reader has changed a control and the title says what changed.

## React

A chart component takes the frame as props and renders children for the marks. Keep the frame outside the plotting library.

```jsx
export function Graphic({ kicker, title, deck, note, source, children }) {
  return (
    <figure className="gd">
      {kicker ? <p className="gd-kicker">{kicker}</p> : null}
      <h2 className="gd-title">{title}</h2>
      {deck ? <p className="gd-deck">{deck}</p> : null}
      {children}
      {note ? <p className="gd-note">{note}</p> : null}
      <p className="gd-source">{source}</p>
    </figure>
  );
}
```

If the project uses Recharts, Visx, or Nivo, turn the legend off, set the tooltip so it is not the only label, set bar radius to 0, and replace the default palette. Direct labels still have to be drawn. Prefer a small SVG component over a themed chart when the graphic is a single editorial chart.

## Matplotlib

Use this when the deliverable is a static file. Export SVG and finish colliding labels in the SVG if the layout needs it.

```python
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 11,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.edgecolor": "#121212",
    "axes.linewidth": 0.6,
    "axes.labelcolor": "#4a4540",
    "xtick.color": "#4a4540",
    "ytick.color": "#4a4540",
    "axes.grid": False,
    "figure.facecolor": "white",
    "axes.facecolor": "white",
    "savefig.facecolor": "white",
    "text.color": "#121212",
})

ACCENT = "#E3120B"
CONTEXT = "#8e8880"
```

- `barh` with the zero at the left spine. Sort before plotting.
- `ax.set_xlim(left=0)` for magnitudes. Do not call it for a line whose break you have marked.
- `ax.legend` stays off. Use `ax.text` at the last point, coloured with the series.
- Title in the figure, or as a suptitle, states the finding. `ax.set_title` is the wrong place for a topic label.
- `fig.savefig("chart.svg")`. Also write the source line under the axes with `fig.text`, because a chart image without a source is unfinished.
- ggplot in R is a reasonable sketching tool (it was Graphic Detail's in 2019). The same rules apply to theme, scales, and labels. The finished piece is still the edited SVG or the print layout, not the default ggplot theme.

## Plotly

Plotly's default template is a dashboard. Use it to explore. For anything a reader will see:

- `template="simple_white"`
- one accent and grey in `color_discrete_sequence` or an explicit color array
- `layout.showlegend = False` when labels are on the marks
- hover labels may exist; the static SVG must still carry the title, the labels, and the source
- `fig.write_image("chart.svg")` or export SVG from the browser, then apply the same critique as an hand-built SVG

If the export still looks like an interactive demo, redraw the graphic in SVG by hand.
