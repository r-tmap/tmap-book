--- 
title: "tmap: beautiful and effective maps in R"
author: "Martijn Tennekes, Jakub Nowosad"
date: "2020-05-17"
description: "This is a book in progress about the tmap package."
knit: bookdown::render_book
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: krantz
monofont: "Source Code Pro"
monofontoptions: "Scale=0.7"
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: mtennekes/tmap_book
url: ""
cover-image: ""
colorlinks: yes
graphics: yes
links-as-notes: true
---

# Prerequisites

This is a _sample_ book written in **Markdown**. You can use anything that Pandoc's Markdown supports, e.g., a math equation $a^2 + b^2 = c^2$.

The **bookdown** package can be installed from CRAN or Github:


```r
install.packages("bookdown")
# or the development version
# devtools::install_github("rstudio/bookdown")
```

Remember each Rmd file contains one and only one chapter, and a chapter is defined by the first-level heading `#`.

To compile this example to PDF, you need XeLaTeX. You are recommended to install TinyTeX (which includes XeLaTeX): <https://yihui.name/tinytex/>.


