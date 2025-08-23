#import "../common.typ": *
#import "./values.typ"

#set par(first-line-indent: 0pt)

= Objetivos

- Medir longitudes con mayor precisión que una regla de lectura directa
- Conocer y utilizar calibre (vernier) y palmer (micrómetro)
- Expresar una medición como valor acotado
- Aplicar teoría de propagación de errores

= Introducción teórica

Una escala de lectura directa limita la precisión a aproximadamente #values.mm[0.5]. Para mejorar, se emplean instrumentos de doble escala.

*Calibre (vernier)*

Apreciación definida por:

$ A = r / N $

#no-first-line-indent([
  donde $r$ es la menor división de la regla fija y $N$ el número de divisiones del nonius. La lectura se obtiene mediante:
])

$ L = x r + A y $

*Palmer (micrómetro)*

Con paso $r$ y tambor con $N$ divisiones, la fracción es:

$ r / N $

La lectura es análoga a la del calibre.

En el procesamiento de datos, el valor más probable se toma como el promedio aritmético y el error absoluto se estima como:

$ e_"abs" = sqrt((sum (h_i - overline(h))^2) / (n (n - 1))) $

El error de apreciación se toma como la apreciación del instrumento (resolución). El error reportado es el mayor entre ambos. El valor acotado se informa como:

$ h = overline(h) plus.minus e $

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