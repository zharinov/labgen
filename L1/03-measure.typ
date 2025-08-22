#import "../common.typ": *
#import "@preview/tblr:0.4.1": tblr
#import "@preview/zero:0.5.0": num, ztable
#import "@preview/pinit:0.2.2": *
#import "values.typ" as values

= Actividad 3

Se tomó un cilindro metálico y se realizaron 10 lecturas de altura ($h$) con calibre y 10 lecturas de diámetro ($D$) con palmer.

#v(1em)

#let tbl(data, header, footer) = {
  let cells = data

  set text(14pt)
  table(
    stroke: none,
    align: center,
    columns: (1fr, 1fr, 1fr),
    inset: (top: 10pt, bottom: 10pt),
    table.hline(stroke: 1pt),
    header,
    table.hline(stroke: 0.5pt),
  )

  v(5pt, weak: true)

  set text(12pt)
  ztable(
    stroke: none,
    columns: (1fr, 1fr, 1fr),
    align: center,
    format: ((digits: 2), (digits: 2), (digits: 4)),

    ..cells,

    table.cell(colspan: 3, inset: (y: 0pt, top: 5pt))[],
    table.hline(stroke: 0.5pt),
    table.cell(colspan: 3, inset: (y: 0pt, bottom: 5pt))[],

    footer,
  )
}

#{
  let h_data = values.height_table_data
  let d_data = values.diameter_table_data

  two-col(
    left: [
      ==== Altura, mm

      #tbl(
        h_data,
        table.header(
          [$h_i$],
          [$h_i - overline(h)$],
          [$(h_i - overline(h))^2$],
        ),
        table.footer(
          [#values.raw.height_mean],
          table.cell(colspan: 2)[_(valor más probable)_],
          table.cell(colspan: 3, inset: (y: 0pt, bottom: 5pt))[],
          table.hline(stroke: 1pt),
        ),
      )

      #v(10pt)
      #no-first-line-indent[
        #set text(12pt)
        #set par(spacing: 20pt)

        #align(center)[
          $overline(h) = #values.height_mean_mm$

          $e_h = sqrt((sum (d_i - overline(d))^2) / (n (n - 1))) = #values.height_standard_error$

          $A_c = #values.caliper_precision$ _(calibre)_

          $∆h = max(e_h, A_c) = #values.height_uncertainty_mm$
        ]

        #v(10pt)
        #align(center)[
          #box(stroke: 0.5pt, inset: 20pt, width: 100%)[
            #set align(center)
            $h = #values.height_result$
          ]
        ]
      ]
    ],
    right: [
      ==== Diámetro, mm

      #tbl(
        d_data,
        table.header(
          [$D_i$],
          [$D_i - overline(D)$],
          [$(D_i - overline(D))^2$],
        ),
        table.footer(
          [#values.raw.diameter_mean],
          table.cell(colspan: 2)[_(valor más probable)_],
          table.cell(colspan: 3, inset: (y: 0pt, bottom: 5pt))[],
          table.hline(stroke: 1pt),
        ),
      )

      #v(10pt)
      #no-first-line-indent[
        #set text(12pt)
        #set par(spacing: 20pt)

        #align(center)[
          #block[
            $overline(D) = #values.diameter_mean_mm$
          ]

          $e_D = sqrt((sum (D_i - overline(D))^2) / (n (n - 1))) = #values.diameter_standard_error$

          $A_p = #values.micrometer_precision$ _(palmer)_

          $∆D = max(e_D, A_p) = #values.diameter_uncertainty_mm$
        ]

        #v(10pt)
        #align(center)[
          #box(stroke: 0.5pt, inset: 20pt, width: 100%)[
            $D = #values.diameter_result$
          ]
        ]
      ]
    ],
  )
}
