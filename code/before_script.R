library(methods)
# knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)
knitr::opts_chunk$set(
  background = "#FCFCFC", # code chunk color in latex
  comment = "#>",
  collapse = TRUE,
  cache = TRUE, #https://github.com/rstudio/bookdown/issues/15#issuecomment-591478143
  fig.pos = "h", #"t"
  fig.path = "figures/",
  fig.align = "center",
  fig.height = 7,
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold",
  #,out.width = "100%"
  dev.args = list(png = list(type = "cairo-png")),
  optipng = "-o1 -quiet",
  widgetframe_widgets_dir = 'widgets'
)

if(!knitr:::is_html_output()){
  options("width" = 56)
  knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 56, indent = 2),
                        tidy = TRUE)
}

set.seed(2020-05-06)
options(digits = 3)