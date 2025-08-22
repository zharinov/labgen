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
