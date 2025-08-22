#import "@preview/tblr:0.4.1"
#import "../common.typ": *
#import "values.typ" as values

= Actividad 1

Cálculo del error absoluto $Δ π$ entre el valor real de $π$ y aproximaciones obtenidas desde la calculadora ($π_c$), y del error relativo $ε_r = (Δ π) / overline(π)$ para diferentes aproximaciones de $π$ sin usar calculadora, donde $Δ π$ representa el error absoluto para cada aproximación.

#v(1em)

#let left_data = values.pi_absolute_errors.flatten()
#let right_data = values.pi_relative_errors.flatten()

#show figure.where(kind: table): set figure(numbering: "(a)")
#show figure.caption.where(kind: table): it => [
  #set text(10pt, style: "italic")
  #it.supplement
  #context it.counter.display(it.numbering):
  #it.body
]

#let tbl = {
  import "@preview/tblr:0.4.1": *

  tblr.with(
    stroke: none,

    hline(within: "header", y: 0, stroke: 1pt),
    hline(within: "header", y: end, position: bottom, stroke: 0.5pt),
    hline(y: end, position: bottom, stroke: 1pt),

    header-rows: 1,
    rows(
      within: "header",
      0,
      inset: (top: 10pt, bottom: 12pt),
      hooks: x => text(14pt, x),
    ),
    rows(within: "body", span(0, end), inset: (y: 5pt), hooks: x => text(
      12pt,
      x,
    )),
    rows(within: "body", 0, inset: (top: 10pt)),
    rows(within: "body", end, inset: (bottom: 10pt)),
    placement: top,
  )
}

#two-col(
  left: [
    #tbl(
      caption: [error absoluto],
      columns: (1fr, 1fr),
      [$overline(π)$],
      [$Delta π$],
      ..left_data,
    )
  ],
  right: [
    #tbl(
      caption: [error relativo],
      columns: (1fr, 1fr, 1fr),
      [$overline(π)$],
      [$Delta π$],
      [$ε_r = (Delta π)/(overline(π))$],
      ..right_data,
    )
  ],
)
