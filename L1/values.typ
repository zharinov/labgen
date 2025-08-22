#import "../num.typ": *

#let raw = toml("output.toml")

// Pi error calculations
#let pi_absolute_errors = raw.pi_absolute_errors.map(entry => {
  let (round, absolute_error) = entry
  (
    num(raw.pi_value, digits: round, round: none),
    num(absolute_error, fixed: int(-round), round: round-dec(3)),
  )
})

#let pi_relative_errors = raw.pi_relative_errors.map(entry => {
  let (round, absolute_error, relative_error) = entry

  let formatted_delta_pi = if round < 6 {
    num(absolute_error, round: round-dec(round))
  } else {
    let i = -calc.log(absolute_error, base: 10)
    [$10^(#int(-round))$]
  }

  let formatted_epsilon = {
    let exponent = calc.floor(calc.log(calc.abs(relative_error), base: 10)) + 1
    num(
      relative_error,
      fixed: int(-round),
      round: round-dec(3),
    )
  }

  (
    num(raw.pi_value, digits: round, round: none),
    formatted_delta_pi,
    formatted_epsilon,
  )
})

// Theta analysis
#let theta_analysis = raw.theta_analysis.map(entry => {
  let (
    theta_degrees,
    theta_radians,
    sin_theta,
    relative_error,
    relative_error_percent,
  ) = entry
  (
    str(theta_degrees),
    num(theta_radians, round: round-dec(3)),
    num(sin_theta, round: round-dec(3)),
    num(relative_error, round: round-dec(4)),
    num(relative_error_percent),
  )
})

// Height measurements
#let height_mean = mm(raw.height_mean)
#let height_standard_error = mm(raw.height_standard_error, round: round-dec(3))
#let height_uncertainty = num(raw.height_uncertainty, round: (
  precision: 2,
  direction: "nearest",
))
#let height_result = mm(raw.height_result, round: round-sig(1))

// Diameter measurements
#let diameter_mean = mm(raw.diameter_mean)
#let diameter_standard_error = mm(
  raw.diameter_standard_error,
  round: round-dec(3),
)
#let diameter_uncertainty = num(raw.diameter_uncertainty)
#let diameter_result = mm(raw.diameter_result, round: round-sig(1))

// Instrument precision
#let caliper_precision = mm(raw.caliper_precision)
#let micrometer_precision = mm(raw.micrometer_precision)

// Measurement table data
#let height_table_data = (
  raw
    .height_data
    .map(((entry)) => {
      let (measured, deviation, deviation_squared) = entry
      ([#measured], [#deviation], [#deviation_squared])
    })
    .flatten()
)

#let diameter_table_data = (
  raw
    .diameter_data
    .map(((entry)) => {
      let (measured, deviation, deviation_squared) = entry
      ([#measured], [#deviation], [#deviation_squared])
    })
    .flatten()
)

// Pi value and uncertainty
#let pi_value = num(raw.pi_value, round: round-dec(3))
#let pi_uncertainty = num(raw.pi_uncertainty)
#let pi_result = num(raw.pi_result, round: round-sig(1))

// Calculation values for display
#let diameter_mean = num(raw.diameter_mean)
#let diameter_mean_mm = mm(raw.diameter_mean)
#let height_mean = num(raw.height_mean)
#let height_mean_mm = mm(raw.height_mean)
#let diameter_uncertainty = num(raw.diameter_uncertainty)
#let diameter_uncertainty_mm = mm(raw.diameter_uncertainty)
#let height_uncertainty = num(raw.height_uncertainty)
#let height_uncertainty_mm = mm(raw.height_uncertainty)

// Perimeter calculations
#let perimeter_value = mm(raw.perimeter_value)
#let perimeter_linear_error = mm(raw.perimeter_linear_error)
#let perimeter_quadratic_error = mm(raw.perimeter_quadratic_error)
#let perimeter_linear_result = mm(
  raw.perimeter_linear_result,
  round: round-sig(2),
)
#let perimeter_quadratic_result = mm(
  raw.perimeter_quadratic_result,
  round: round-sig(2),
)

// Area calculations
#let area_value = mm_2(raw.area_value)
#let area_linear_error = mm_2(raw.area_linear_error)
#let area_quadratic_error = mm_2(raw.area_quadratic_error)
#let area_linear_result_mm = mm_2(
  raw.area_linear_result_mm,
  round: round-sig(3),
)
#let area_quadratic_result_mm = mm_2(
  raw.area_quadratic_result_mm,
  round: round-sig(3),
)
#let area_linear_result_cm = cm_2(
  raw.area_linear_result_cm,
  round: round-sig(1),
)
#let area_quadratic_result_cm = cm_2(
  raw.area_quadratic_result_cm,
  round: round-sig(1),
)

// Volume calculations
#let volume_value = mm_3(raw.volume_value)
#let volume_linear_error = mm_3(raw.volume_linear_error)
#let volume_quadratic_error = mm_3(raw.volume_quadratic_error)
#let volume_linear_result_mm = mm_3(
  raw.volume_linear_result_mm,
  round: round-sig(4),
)
#let volume_quadratic_result_mm = mm_3(
  raw.volume_quadratic_result_mm,
  round: round-sig(4),
)
#let volume_linear_result_cm = cm_3(
  raw.volume_linear_result_cm,
  round: round-sig(1),
)
#let volume_quadratic_result_cm = cm_3(
  raw.volume_quadratic_result_cm,
  round: round-sig(1),
)

// Partial derivatives for volume calculations
#let volume_partial_pi = mm_3(raw.volume_partial_pi)
#let volume_partial_d = mm_2(raw.volume_partial_d)
#let volume_partial_h = mm_2(raw.volume_partial_h)
