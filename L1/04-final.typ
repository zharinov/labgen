#import "../common.typ": *
#import "@preview/tblr:0.4.1": *
#import "values.typ" as values

= Actividad 4

#no-first-line-indent([
  == Perímetro del rectángulo (hipotético)

  $
    P = 2(D + h) = 2(#values.diameter_mean + #values.height_mean) = #values.perimeter_value
  $

  $ (∂P)/(∂D) = 2, quad (∂P)/(∂h) = 2 $

  $
    Δ P_"lin" = 2 Δ D + 2 Δ h = 2(#values.diameter_uncertainty + #values.height_uncertainty) = #values.perimeter_linear_error
  $

  $
    Δ P_"cuad" = 2 sqrt((Δ D)^2 + (Δ h)^2) = 2 sqrt((#values.diameter_uncertainty)^2 + (#values.height_uncertainty)^2) = #values.perimeter_quadratic_error
  $

  #align(center)[
    #v(5pt)
    #box(stroke: 0.5pt, inset: 10pt)[
      #set align(right)

      $P_"lin" = #values.perimeter_linear_result$

      $P_"cuad" = #values.perimeter_quadratic_result$
    ]
    #v(5pt)
  ]
  
  #v(10pt)

  == Área del rectángulo (hipotético)

  $
    A = D times h = #values.diameter_mean times #values.height_mean = #values.area_value
  $

  $
    (∂A)/(∂D) = h = #values.height_mean_mm, quad (∂A)/(∂h) = D = #values.diameter_mean_mm
  $

  $
    Δ A_"lin" = h Δ D + D Δ h = #values.height_mean times #values.diameter_uncertainty + #values.diameter_mean times #values.height_uncertainty = #values.area_linear_error
  $

  $
    Δ A_"cuad" = sqrt((h Δ D)^2 + (D Δ h)^2) = sqrt((#values.height_mean times #values.diameter_uncertainty)^2 + (#values.diameter_mean times #values.height_uncertainty)^2) = #values.area_quadratic_error
  $

  #align(center)[
    #v(5pt)
    #box(stroke: 0.5pt, inset: 10pt)[
      #set align(right)
      $A_"lin" = #values.area_linear_result_mm = #values.area_linear_result_cm$

      $A_"cuad" = #values.area_quadratic_result_mm = #values.area_quadratic_result_cm$
    ]
    #v(5pt)
  ]

  == Volumen del cilindro

  $
    V = π (D^2 h)/4 = #values.pi_value times (#values.diameter_mean)^2 times #values.height_mean / 4 = #values.volume_value
  $

  #align(
    center,
    [(donde $π = #values.pi_result$)],
  )

  #v(15pt)

  $
    (∂V)/(∂π) = (D^2 h)/4 = #values.volume_partial_pi
  $

  $
    (∂V)/(∂D) = (π D h)/2 = #values.volume_partial_d
  $

  $
    (∂V)/(∂h) = (π D^2)/4 = #values.volume_partial_h
  $

  #v(15pt)

  $
    Δ V_"lin" = (D^2 h)/4 Δ π + (π D h)/2 Δ D + (π D^2)/4 Δ h = #values.volume_linear_error
  $

  $
    Δ V_"cuad" = sqrt(((D^2 h)/4 Δ π)^2 + ((π D h)/2 Δ D)^2 + ((π D^2)/4 Δ h)^2) = #values.volume_quadratic_error
  $

  #align(center)[
    #v(20pt)
    #box(stroke: 0.5pt, inset: 20pt)[
      #set align(right)
      $V_"lin" = #values.volume_linear_result_mm = #values.volume_linear_result_cm$

      $V_"cuad" = #values.volume_quadratic_result_mm = #values.volume_quadratic_result_cm$
    ]
    #v(20pt)
  ]
]);
