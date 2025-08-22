#import "../common.typ": *
#import "@preview/tblr:0.4.1": *
#import "values.typ" as values

= Actividad 4

Cálculo del perímetro y área de un rectángulo de lados iguales al diámetro y altura del cilindro, y del volumen del cilindro, aplicando propagación de errores lineal y cuadrática.

== Teoría de propagación de errores

#no-first-line-indent([
  Para una función $f(x, y)$ con variables independientes $x ± Δ x$ y $y ± Δ y$:


  #align(center, grid(
    // stroke: 1pt,
    columns: (1fr, 1fr),
    inset: (x: 10pt, y: 10pt),
    align: (horizon + center, horizon + center),
    [
      $Δ f = abs((∂f)/(∂x)) Δ x + abs((∂f)/(∂y)) Δ y$
    ],
    [
      $Δ f = sqrt(((∂f)/(∂x) Δ x)^2 + ((∂f)/(∂y) Δ y)^2)$
    ],

    [
      _(propagación lineal)_
    ],
    [
      _(propagación cuadrática)_
    ],
  ))


  La propagación cuadrática es más precisa cuando los errores son aleatorios e independientes. Sean:

  $ A = abs((∂f)/(∂x)) Δ x >= 0 $

  $ B = abs((∂f)/(∂y)) Δ y >= 0 $

  $ Δ f_"lin" = A + B $

  $ Δ f_"cuad" = sqrt(A^2 + B^2) $

  Elevando al cuadrado:

  $ (A + B)^2 = A^2 + B^2 + 2A B ≥ A^2 + B^2 = (sqrt(A^2 + B^2))^2 $

  $ A + B ≥ sqrt(A^2 + B^2) $

  $ Δ f_"lin" ≥ Δ f_"cuad" $
])

#pagebreak()


#no-first-line-indent([

  == Perímetro del rectángulo

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
    #v(15pt)
    #box(stroke: 0.5pt, inset: 20pt)[
      #set align(right)

      $P_"lin" = #values.perimeter_linear_result$

      $P_"cuad" = #values.perimeter_quadratic_result$
    ]
    #v(15pt)
  ]

  == Área del rectángulo

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
    #v(15pt)
    #box(stroke: 0.5pt, inset: 20pt)[
      #set align(right)
      $A_"lin" = #values.area_linear_result_mm = #values.area_linear_result_cm$

      $A_"cuad" = #values.area_quadratic_result_mm = #values.area_quadratic_result_cm$
    ]
    #v(15pt)
  ]

  == Volumen del cilindro

  $
    V = π (D^2 h)/4 = #values.pi_value times (#values.diameter_mean)^2 times #values.height_mean / 4 = #values.volume_value
  $

  #align(
    center,
    [(donde $π = #values.pi_result$)],
  )

  #v(30pt)

  $
    (∂V)/(∂π) = (D^2 h)/4 = #values.volume_partial_pi
  $

  $
    (∂V)/(∂D) = (π D h)/2 = #values.volume_partial_d
  $

  $
    (∂V)/(∂h) = (π D^2)/4 = #values.volume_partial_h
  $

  #v(30pt)

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
