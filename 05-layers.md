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
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_polygons() </td>
   <td style="text-align:left;"> polygons (borders and fill) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_symbols() </td>
   <td style="text-align:left;"> symbols </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_lines() </td>
   <td style="text-align:left;"> lines </td>
   <td style="text-align:left;"> lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_raster() </td>
   <td style="text-align:left;"> raster </td>
   <td style="text-align:left;"> raster </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_text() </td>
   <td style="text-align:left;"> text </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr grouplength="8"><td colspan="3" style="border-bottom: 1px solid;"><strong>Derived functions</strong></td></tr>
<tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_borders() </td>
   <td style="text-align:left;"> polygons (borders) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_fill() </td>
   <td style="text-align:left;"> polygons (fill) </td>
   <td style="text-align:left;"> polygons </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_bubbles() </td>
   <td style="text-align:left;"> bubbles </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_dots() </td>
   <td style="text-align:left;"> dots </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_markers() </td>
   <td style="text-align:left;"> marker symbols </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_square() </td>
   <td style="text-align:left;"> squares </td>
   <td style="text-align:left;"> points, polygons, and lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_iso() </td>
   <td style="text-align:left;"> lines with text labels </td>
   <td style="text-align:left;"> lines </td>
  </tr>
  <tr>
   <td style="text-align:left;font-weight: bold;font-family: monospace; padding-left:  2em;" indentlevel="1"> tm_rgb()/tm_rgba() </td>
   <td style="text-align:left;"> raster (RGB image) </td>
   <td style="text-align:left;"> raster </td>
  </tr>
</tbody>
</table>

## Shapes and markers <!--JN: I am not sure where this section should go-->

## Color palettes <!--JN: I am not sure where this section should go-->

<!-- color as VISUAL VARIABLE! -->
<!-- "Color, along with position, size, shape, value, orientation, and texture is what Jacques Bertin calls a visual variable:" -->

<!-- As we discussed in ..., -->
<!-- We can express values of attributes in spatial data using colors, shapes, or sizes. -->
<!-- https://en.wikipedia.org/wiki/Color_scheme -->
Colors in R are created based either on the color name or its hexadecimal form.
R understands 657 built-in color names, such as `"red"`, `"lightblue"` or `"gray90"`, that are available using the `colors()` function.
<!-- demo("colors") -->
<!-- http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf -->
Hexadecimal form, on the other hand, can represent 16,777,216 unique colors.
It consists of six-digits prefixed by the `#` (hash) symbol, where red, green, and blue values are each represented by two characters.
In hexadecimal form, `00` is interpreted as `0.0` which means a lack of a particular color and `FF` means `1.0` and shows that the given color has maximal intensity.
For example, `#000000` represents black color, `#FFFFFF` white color, and `#00FF00` green color.
<!-- hex alpha?? -->

<!-- what is a color palette intro -->
Using a single color we are able to draw points, lines, polygon borders, or their areas.
In that scenario, all of the elements will have the same color. 
However, often we want to represent different values in our data using different colors. 
This is a role for color palettes.
A color palette is a set of colors used to distinguish the values of variables on maps.

Color palettes in R are usually stored as a vector of either color names or hexadecimal representations.
For example, `c("red", "green", "blue")` or `c("#66C2A5", "#FC8D62", "#8DA0CB")`.
It allows every one of us to create our own color palettes. 
However, the decision on how to decide which colors to use is not straightforward, and usually requires thinking about several aspects.

Firstly, what kind of variable we want to show? 
<!-- a next sentence is a simplification, as always -->
Is it a <!--qualitative-->categorical variable where each value represents a <!--orderless-->group or a <!--quantitative-->numerical variable in which values have order?
<!-- http://colorspace.r-forge.r-project.org/articles/palette_visualization.html -->
The variable type impacts how it should be presented on the map.
For categorical variables, each color usually should receive the same perceptual weight, which is done by using colors with the same brightness<!--luminance-->, but different hue<!--type of color-->.
On the other hand, for numerical variables, we should easily understand which colors represent lower and which represent higher values.
This is done by manipulating colorfulness<!--chroma,saturation--> and brightness<!--luminance-->.
For example, low values could be presented by a blue color with low colorfulness and high brightness, and with growing values, colorfulness increases and brightness decreases. 

<!-- color perception-->
Next consideration is related to how people <!--(reader/viewers)--> perceive some colors.
Usually, we want them to be able to preliminary understand which values the colors represent without looking at the legend -- colors should be intuitive.
For example, in the case of categorical variables representing land use, we usually want to use some type of blue color for rivers, green for trees, and white for ice.
This idea also extends to numerical variables, where we should think about the association between colors and cultural values.
The blue color is usually connected to cold temperature, while the red color is hot or can represent danger or something not good.
However, we need to be aware that the connection between colors and cultural values varied between cultures.
<!-- http://uxblog.idvsolutions.com/2013/07/language-and-color.html -->

<!-- color blindness -->
Another thing to consider is to use a color palette that is accessible for people with color vision deficiency (color blindness).
<!-- https://en.wikipedia.org/wiki/Color_blindness -->
There are several types of color blindness, with the red-green color blindness (*deuteranomaly*) being the most common.
It is estimated that about XX of the world population is color blind.
<!-- look for stats/references.. -->

<!-- bw -->
<!-- backgroud -->
<!-- therefore, there is a lot of existing color palettes, and many of them are grounded in science -->

<!-- https://developer.r-project.org/Blog/public/2019/11/21/a-new-palette-for-r/index.html -->
There are three main types of color palettes (Figure \@ref(fig:palette-types)):

- Categorical (also known as Qualitative) - used for presenting categorical information, for example, categories or groups. 
Every color in this type of palettes should receive the same perceptual weight, and the order of colors is meaningless.
<!-- examples -->
- Sequential - used for presenting continuous variables, in which order matters.
Colors in this palette type changes from low to high (or vice versa), which is usually underlined by luminance differences (light-dark contrasts).
<!-- examples -->
- Diverging - used for presenting continuous variables, but where colors diverge from a central neutral value to two extremes.
Therefore, in sense, they consist of two sequential palettes that meet in the midpoint value.
<!-- examples -->



<!-- idea: add two examples to each (e.g., monochrome and part-spectral to sequential) -->
<!-- idea: add spectral schemes -->
<div class="figure" style="text-align: center">
<img src="05-layers_files/figure-html/palette-types-1.png" alt="Examples of three main types of color palettes: categorical, sequential, and diverging" width="672" />
<p class="caption">(\#fig:palette-types)Examples of three main types of color palettes: categorical, sequential, and diverging</p>
</div>
<!-- idea: add bivariate/trivariate schemes (if/when implemented in tmap) -->

<!-- add some notes about more complex approaches (e.g. cividis) -->

<!-- black and white (also in contrast to the three main palettes types)-->
<!-- color blindness -->
<!-- palette properties -->
<!-- anti-rainbow -->
<!-- limitation of the number of colors -->
<!-- interpolation between colors -->
<!-- relation in the background oclor and other colors -->

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
<!-- add some references about colors theory, color blindness, etc. -->

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
