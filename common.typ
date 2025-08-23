#import "@preview/zero:0.5.0": set-num, set-round

// Load global configuration
#let load-config() = {
  toml("config.toml")
}

// Helper function to merge global config with lab-specific overrides
#let merge-config(lab-config: (:)) = {
  let global-config = load-config()

  (
    year: lab-config.at(
      "year",
      default: global-config
        .at("course", default: (:))
        .at("year", default: datetime.today().year()),
    ),
    members: lab-config.at("members", default: global-config.at(
      "members",
      default: (),
    )),
    week: lab-config.at(
      "week",
      default: global-config
        .at("schedule", default: (:))
        .at("week", default: ""),
    ),
    day: lab-config.at(
      "day",
      default: global-config
        .at("schedule", default: (:))
        .at("day", default: ""),
    ),
    schedule: lab-config.at(
      "schedule",
      default: global-config
        .at("schedule", default: (:))
        .at("time", default: ""),
    ),
    lab_title: lab-config.at("lab_title", default: ""),
  )
}

#let indent = 20pt

#let tpl(
  body,
  year: datetime.today().year(),
  lab_title: "",
  members: (),
  week: "",
  day: "",
  schedule: "",
) = {
  set page(margin: (x: 3cm, y: 4cm))

  set text(
    font: "Libertinus Serif",
    lang: "es",
    size: 14pt,
    kerning: true,
    overhang: true,
  )

  set par(
    justify: true,
    first-line-indent: (amount: indent, all: true),
  )

  show math.equation: set text(font: "Euler Math")
  set math.equation(numbering: "(1)")
  set-num(decimal-separator: ",", tight: true)
  set-round(mode: "places", precision: none, pad: true, direction: "nearest")

  show heading: it => [
    #v(2em, weak: true)
    #set align(center)
    #set text(weight: "regular")
    #smallcaps(it)
    #v(1em)
  ]

  place(top + center, scope: "parent", float: true, [
    #align(center, image("logo.svg", width: 75%))
    #v(60pt)
    #align(center, [
      #text(38pt, tracking: 0.1em)[
        #smallcaps()[Física i]
      ]
      #text(30pt, tracking: 0.05em, top-edge: 0pt)[
        (#year)
      ]
    ])
    #v(60pt)
    #align(center, [
      #text(20pt, tracking: 0.05em, top-edge: 0pt)[
        #lab_title
      ]
    ])
  ])

  place(bottom + left, scope: "parent", float: true, [
    #align(left, [
      #set text(12pt)
      #set par(first-line-indent: 0pt)

      #table(
        columns: 2,
        stroke: none,
        align: (right + top, left + top),
        column-gutter: 1em,
        row-gutter: 1em,

        smallcaps[#text(tracking: 0.05em)[Integrantes]],
        [
          #grid(
            columns: 3,
            align: (left, left, right),
            column-gutter: (1em, 1em),
            row-gutter: 0.5em,
            inset: (y: 2pt, right: 3pt),
            ..for member in members {
              (
                smallcaps[#member.lastname],
                member.firstname,
                str(member.student_id),
              )
            }
          )
        ],

        smallcaps[#text(tracking: 0.05em)[Semana]], week,

        smallcaps[#text(tracking: 0.05em)[Día]], day,

        smallcaps[#text(tracking: 0.05em)[Horario]], schedule,
      )
    ])
  ])

  pagebreak()

  set page(numbering: "1")
  counter(page).update(1)

  body
}

#let no-page-break(body) = {
  block(breakable: false)[#body]
}

#let no-first-line-indent(body) = {
  set par(first-line-indent: 0pt)
  body
}

#let two-col(left: content, right: content) = {
  pad(left: indent, right: indent, grid(
    columns: (1fr, indent, 1fr),
    left, [], right,
  ))
}
