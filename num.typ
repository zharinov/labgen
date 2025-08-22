#import "@preview/zero:0.5.0": num

#let round-dec(decimal-digits) = (
  mode: "places",
  precision: decimal-digits,
  pad: true,
  direction: "nearest",
)

#let round-sig(significant-digits) = (
  mode: "uncertainty",
  precision: significant-digits,
  pad: true,
  direction: "nearest",
)

#let num = num.with(round: round-dec(2))

#let (
  mm,
  mm_2,
  mm_3,
  cm,
  cm_2,
  cm_3,
) = {
  let unit(u) = (x, ..args) => box[#num(x, ..args) #u]

  (
    unit([mm]),
    unit([mm²]),
    unit([mm³]),
    unit([cm]),
    unit([cm²]),
    unit([cm³]),
  )
}
