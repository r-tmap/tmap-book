---
title: Ideas for tmap version 4
author: Jakub Nowosad
date: 2020-11-25
output: 
  html_document: 
    toc: yes
    number_sections: yes
---

# Colors

1. Use of `hcl.colors()` and `palette.colors()` from **grDevices** instead of any external packages
2. Update the **tmaptools** shiny app accordingly (also - make this app run in the backgroud R session)

# Annotations and text improvements

1. Improving labels (text) locations - see **ggrepel** (https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html) (also https://github.com/mtennekes/tmap/issues/337)
2. Adding a new layer type - annotations (see how it works in **ggplot2** - https://ggplot2.tidyverse.org/reference/annotate.html)
3. Fonts improvements, including rotating (see https://github.com/mtennekes/tmap/issues/389)

# Aesthetics

1. Make aesthetics extensible, but also more consistent (some ideas are already at https://github.com/mtennekes/tmap/issues/495#issuecomment-732189644)

# Legends

1. Unify legends API for inside and outside legends. 
Currently, there is a subset of settings for inside and a subset of settings for outside legends.
2. Improved specifying of horizontal and vertical legends.
Currently, horizontal legends are harder to customize (e.g., https://github.com/mtennekes/tmap/issues/350).
3. (Additionally) Allow for changing positions of many legends separately

# Attributes layers

1. Allow to move some attributes layers (e.g. scale bar or compass) outside of a map.

# Improve plots alignment

1. Allowing to convert **tmap** objects into `grob`s to make easier plot alignments and map insets (with **cowplot** or **gridExtra**).
More info at https://github.com/mtennekes/tmap/issues/338.

# Other

1. Revise default colors, sizes, etc.
1. Replace the `is.master` by `is.main`
1. Decide on the **tmap** hex logo
1. Bivariate/multivariate color palettes (https://github.com/mtennekes/tmap/issues/183)
1. Add possibility to fill polygons with pattern (https://github.com/mtennekes/tmap/issues/49)
1. Close GitHub issues that are not going to be fix/implemented in the foreseeable future (declutter issue tracker)
