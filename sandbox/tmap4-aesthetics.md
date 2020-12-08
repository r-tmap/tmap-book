---
title: "tmap4: aesthetics"
author: Jakub Nowosad
date: 2020-11-30
output: 
  html_document: 
    toc: yes
    number_sections: yes
    keep_md: yes
---








```r
what_aes = function(layer_name){
  aes = filter(aes_df, layer == layer_name)
  aes_txt = glue_collapse(aes$aes_name, sep = ", ")
  glue("{aes_txt}")
}
what_other_aes = function(layer_name){
  aes = filter(other_data_aes_df, layer == layer_name)
  aes_txt = glue_collapse(aes$other_data_aes_name, sep = ", ")
  glue("{aes_txt}")
}
aes_df2 = tibble(layer = unique(aes_df$layer))
aes_df2$aes = purrr::map_chr(aes_df2$layer, what_aes)
aes_data_df2 = tibble(layer = unique(other_data_aes_df$layer))
aes_data_df2$other_aes = purrr::map_chr(aes_data_df2$layer, what_other_aes)

all_df = left_join(aes_df2, aes_data_df2)
```

```
## Joining, by = "layer"
```


# Layers and aesthetics list


Table: Map layers and their aesthetics that use data variables

|layer              |aes                                      |other_aes |
|:------------------|:----------------------------------------|:---------|
|tm_polygons()      |fill, color, stroke, linetype            |alpha     |
|tm_symbols()       |fill, color, size, shape, stroke         |alpha     |
|tm_fill()          |fill                                     |alpha     |
|tm_bubbles()       |fill, color, size, shape, stroke         |alpha     |
|tm_square()        |fill, color, size, shape, stroke         |alpha     |
|tm_lines()         |color, stroke, linetype                  |alpha     |
|tm_raster()        |color                                    |alpha     |
|tm_text()          |color, size, shape, text                 |alpha     |
|tm_borders()       |color, stroke, linetype                  |alpha     |
|tm_dots()          |color, size, shape                       |alpha     |
|tm_markers()       |color, size, shape, stroke               |alpha     |
|tm_iso()           |color?, size?, linetype?, text?, stroke? |alpha     |
|tm_rgb()/tm_rgba() |color                                    |alpha     |

# Questions/comments

1. Do we assume (similarly to ggplot2) that `alpha` relates to all aspects of visualization (e.g., fill and borders in `tm_polygons()`)?
