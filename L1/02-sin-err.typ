#import "@preview/tblr:0.4.1": *
#import "../common.typ": *
#import "values.typ" as values

= Actividad 2

Análisis del error relativo $ε_r = θ / sin(θ) - 1$ entre $θ$ (en radianes) y $sin(θ)$ para ángulos pequeños, evaluando la aproximación $sin(θ) approx θ$.

#set text(9pt)



#let tbl = {
  import "@preview/tblr:0.4.1": *

  tblr.with(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    align: center,
    stroke: none,

    hline(within: "header", y: 0, stroke: 1pt),
    hline(within: "header", y: end, position: bottom, stroke: 0.5pt),
    hline(y: end, position: bottom, stroke: 1pt),

    header-rows: 1,
    rows(
      within: "header",
      0,
      inset: (top: 10pt, bottom: 12pt, x: 0pt),
      hooks: x => text(13pt, x),
    ),
    rows(
      within: "body",
      span(0, end),
      inset: (y: 5pt, x: 0pt),
      hooks: x => text(
        11pt,
        x,
      ),
    ),
    rows(within: "body", 0, inset: (top: 10pt)),
    rows(within: "body", end, inset: (bottom: 10pt)),
    placement: top,
  )
}



#v(30pt)

#let headings = (
  [$θ°$],
  [$θ_"rad"$],
  [$sin(θ)$],
  [$ε_r$],
  [$ε_r%$],
)

#let left_data = values.theta_analysis.slice(0, 24).flatten()
#let right_data = values.theta_analysis.slice(24).flatten()

#two-col(
  left: [
    #tbl(
      ..headings,
      ..left_data,
    )
  ],
  right: [
    #tbl(
      ..headings,
      ..right_data,
    )
  ],
)
