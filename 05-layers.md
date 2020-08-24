# Layers {#layers}



\@ref(tab:layers-table)

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:layers-table)Map layers.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Function </th>
   <th style="text-align:left;"> Element </th>
   <th style="text-align:left;"> Geometry </th>
  </tr>
 </thead>
<tbody>
  <tr grouplength="5"><td colspan="3" style="border-bottom: 1px solid;"><strong>Basic functions</strong></td></tr>
<tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_polygons() </td>
   <td style="text-align:left;"> polygons (borders and fill) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_symbols() </td>
   <td style="text-align:left;"> symbols </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_lines() </td>
   <td style="text-align:left;"> lines </td>
   <td style="text-align:left;"> lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_raster() </td>
   <td style="text-align:left;"> raster </td>
   <td style="text-align:left;"> raster </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_text() </td>
   <td style="text-align:left;"> text </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr grouplength="8"><td colspan="3" style="border-bottom: 1px solid;"><strong>Derived functions</strong></td></tr>
<tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_borders() </td>
   <td style="text-align:left;"> polygons (borders) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_fill() </td>
   <td style="text-align:left;"> polygons (fill) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_bubbles() </td>
   <td style="text-align:left;"> bubbles </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_dots() </td>
   <td style="text-align:left;"> dots </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_markers() </td>
   <td style="text-align:left;"> marker symbols </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_square() </td>
   <td style="text-align:left;"> squares </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_iso() </td>
   <td style="text-align:left;"> lines with text labels </td>
   <td style="text-align:left;"> lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left: 2em;" indentlevel="1"> tm_rgb()/tm_rgba() </td>
   <td style="text-align:left;"> raster (RGB image) </td>
   <td style="text-align:left;"> raster </td>
  </tr>
</tbody>
</table>

## Color palettes <!--JN: I am not sure where this section should go-->

<!-- what is a color palette intro -->

There are three main types of color palettes (Figure \@ref(fig:palette-types)):

- Categorical (also known as Qualitative) - they are used for presenting categorical information, for example, categories or groups. 
Every color in this type of palettes should receive the same perceptual weight, and the order of colors is meaningless.
<!-- examples -->
- Sequential - they are used for presenting continuous variables, in which order matters.
Colors in this palette type changes from low to high (or vice versa), which is usually underlined by luminance differences (light-dark contrasts).
<!-- examples -->
- Diverging - they are also used for presenting continuous variables, but where colors diverge from a central neutral value to two extremes.
Therefore, in sense, they consist of two sequential palettes that meet in the midpoint value.
<!-- examples -->

<!-- add some notes about more complex approaches (e.g. cividis) -->

 <!--    Sequential: For coding ordered/numeric information, i.e., where colors go from high to low (or vice versa). -->
 <!--    Diverging: Designed for coding numeric information around a central neutral value, i.e., where colors diverge from neutral to two extremes. -->


<div class="figure" style="text-align: center">
<img src="05-layers_files/figure-html/palette-types-1.png" alt="Examples of three main types of color palettes: categorical, sequential, and diverging" width="672" />
<p class="caption">(\#fig:palette-types)Examples of three main types of color palettes: categorical, sequential, and diverging</p>
</div>


<!-- three main types of color palettes -->
<!-- categorical -->
<!-- https://developer.r-project.org/Blog/public/2019/11/21/a-new-palette-for-r/index.html -->
<!-- sequential -->

<!-- diverging -->
<!-- mention midpoint -->

<!-- black and white (also in contrast to the three main palettes types)-->
<!-- color blindness -->
<!-- palette properties -->
<!-- anti-rainbow -->
<!-- limitation of the number of colors -->
<!-- interpolation between colors -->

<!-- three ways to set colors in tmap: -->
<!-- 1. vector of colors (names vs hex) -->
<!-- 2. palette functions (e.g. RColorBrewer, rcartocolor, grDevices::hcl.colors) -->
<!-- 3. build-in names in tmap <!-- tmaptools::palette_explorer() --> -->
<!-- <!-- including viridis --> -->
<!-- also the `n` argument -->
<!-- also the `-` sign -->
<!-- The type of palette from aes.palette is automatically determined, but can be overwritten: use "seq" for sequential, "div" for diverging, and "cat" for categorical. -->
<!-- alpha? -->

<!-- resources: -->
<!-- - colorspace -->
<!-- - Polychrome -->
<!-- - https://bookdown.org/hneth/ds4psy/D-2-apx-colors-essentials.html -->
<!-- - https://developer.r-project.org/Blog/public/2019/11/21/a-new-palette-for-r/index.html -->

## The color scale styles <!--JN: I am not sure where this section should go-->


```r
# replace this data with some new tmap dataset
library(sf)
#> Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 7.0.0
library(tmap)
file_path = system.file("shapes/world.gpkg", package = "spData")
world = read_sf(file_path)
world_moll = st_transform(world, crs = "+proj=moll")
```

<!-- one plot with five panels: one color/adjacent polygons/categorical/discrete/continuous? -->
<!-- or maybe start with one color/adjacent polygons -->
<!-- and next present three main types of color palettes -->
<!-- after that categorical/discrete/continuous?? -->


```r
tm_one = tm_shape(world_moll) +
  tm_polygons(col = "lightblue")
tm_uni = tm_shape(world_moll) +
  tm_polygons(col = "MAP_COLORS")
```


To see and compare examples of every color scale style from **tmap** visit https://geocompr.github.io/post/2019/tmap-color-scales/.
