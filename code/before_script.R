library(methods)

knitr::opts_chunk$set(
  background = "#FCFCFC", # code chunk color in latex
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  fig.pos = "h", #"t"
  fig.path = "figures/",
  fig.align = "center",
  fig.height = 7,
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold"#,out.width = "100%"
)

if(!knitr:::is_html_output()){
  options("width" = 56)
  knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 56, indent = 2),
                        tidy = TRUE)
}

set.seed(2020-05-06)
options(digits = 3)