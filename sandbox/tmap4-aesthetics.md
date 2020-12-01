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



# Layers and aesthetics list


Table: Map layers and their aesthetics that use data variables

|layer              |aes                                 |
|:------------------|:-----------------------------------|
|tm_polygons()      |fill, color, stroke, linetype       |
|tm_symbols()       |fill, color, size, shape, stroke    |
|tm_fill()          |fill                                |
|tm_bubbles()       |fill, color, size, shape, stroke    |
|tm_square()        |fill, color, size, shape, stroke    |
|tm_lines()         |color, stroke, linetype             |
|tm_raster()        |color                               |
|tm_text()          |color, size, shape, text            |
|tm_borders()       |color, stroke, linetype             |
|tm_dots()          |color, size, shape                  |
|tm_markers()       |color, size, shape, stroke          |
|tm_iso()           |color, size, linetype, text, stroke |
|tm_rgb()/tm_rgba() |color                               |

# Questions/comments

1. Should I also list other aesthetics (e.g. alpha, colorNA, text family, text fontface, text angle)
2. Should we distinguish between data-based aesthetics (e.g., color or size) and single value aesthetics (e.g., colorNA, text family)?
3. What to do with alpha? 
Is it in the first or the second group?
4. `tm_raster()`/`tm_rgb()`/`tm_rgba()` - should it use `"color"` or `"fill"`?
5. `tm_dots()` - should it have aesthetics like `shape` and `color`?
6. I have tried to separate some meanings. 
For example, `tm_symbols()` - `"size"` relates to the symbol size, and `"stroke"` relates to the border/line width.
What do you think about it?
7. What to do with `tm_iso()`? `"color"` there could relate to the text color or line color... 
(It is the only corner case, I was able to find).
8. Also, maybe we can learn something useful from https://ggplot2-book.org/internals.html.
