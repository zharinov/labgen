#import "../common.typ": *

// Load lab-specific configuration
#let output-data = toml("output.toml")
#let config = merge-config(lab-config: (:))

#show: tpl.with(
  year: config.year,
  lab_title: [
    #smallcaps[
      #output-data.title

      #output-data.subtitle
    ]
  ],
  members: config.members,
  week: config.week,
  day: config.day,
  schedule: config.schedule,
)

#set math.equation(numbering: none)
#include "00-intro.typ"
#include "01-pi-err.typ"
#pagebreak()
#include "02-sin-err.typ"
#pagebreak()
#include "03-measure.typ"
#pagebreak()
#include "04-final.typ"
