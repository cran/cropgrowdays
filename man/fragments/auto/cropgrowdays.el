;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "cropgrowdays"
 (lambda ()
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (LaTeX-add-bibitems
    "yang1995"
    "anonGDD"
    "sparks2017"
    "sparks2021"
    "mcmaster1997"
    "baskerville1969"
    "pollen2019"
    "agroclim2020"))
 '(or :bibtex :latex))

