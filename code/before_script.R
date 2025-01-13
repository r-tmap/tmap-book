library(methods)
library(webshot)

knitr::opts_chunk$set(
  background = "#FCFCFC", # code chunk color in latex
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE, #https://github.com/rstudio/bookdown/issues/15#issuecomment-591478143
  # fig.pos = "h", #"t"
  fig.path = "figures/",
  fig.align = "center",
  # fig.height = 7,
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold",
  out.width = "100%",
  dev.args = list(png = list(type = "cairo-png")),
  optipng = "-o1 -quiet",
  widgetframe_widgets_dir = "widgets",
  screenshot.opt = list(delay = 0.3)
)

knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)

if(!knitr:::is_html_output()){
  options("width" = 56)
  knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 56, indent = 2),
                        tidy = TRUE)
}

set.seed(2020-05-06)
options(digits = 3)

view_map = function(x, name){
  if (knitr::is_latex_output()){
    tf = tempfile(fileext = ".html")
    tmap_save(x, tf)
    webshot2::webshot(tf, file = paste0("widgets/", name, ".png"))
    knitr::include_graphics(paste0("widgets/", name, ".png"))
  } else {
    # widgetframe::frameWidget(tmap::tmap_leaflet(x))
    tmap::tmap_leaflet(x)
  }
}

# Sys.setenv(CHROMOTE_CHROME = "/usr/bin/vivaldi")
