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

<!-- reference this bp - https://earthobservatory.nasa.gov/blogs/elegantfigures/2013/08/06/subtleties-of-color-part-2-of-6/ -->

<!-- color as VISUAL VARIABLE! -->
<!-- "Color, along with position, size, shape, value, orientation, and texture is what Jacques Bertin calls a visual variable:" -->
<!-- IDEA: one or more section per each visual variable (color/size/shape) -->
Colors, along with sizes and shapes, are the most often used to express values of attributes or their properties.
Proper use of colors draws the attention of viewers and has a positive impact on the clarity of the presented information. 
On the other hand, poor decisions about colors can lead to misinterpretation of the map.

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
It is estimated that up to about 8% of the male population and about 0.5% of the female population in some regions of the world is color blind [@birch_worldwide_2012;@sharpe_opsin_1999].
<!-- look for stats/references.. -->

<!-- backgroud -->
<!-- Simultaneous contrast. -->
The relation between the selected color palette and other map elements or the map background should be also taken into a consideration.
Using a bright or dark background color on a map has an impact on how people will perceive different color palettes.

<!-- The last thing to consider is related to the  -->
<!-- also related to what is the main goal - website, journal article? -->
<!-- bw -->
<!-- is it A4 or a postcard size?-->

<!-- should we add: (?) -->
<!-- aesthetic -->
<!-- similar to lines types, fonts, etc, positions -->
<!-- hard to grasp, hard to learn, look for good examples and be inspired -->

<!-- therefore, there is a lot of existing color palettes, and many of them are grounded in science -->
Gladly, a lot of work has been put on creating color palettes that are grounded in the research of perception and design.
Currently, [several dozens of R packages](https://github.com/EmilHvitfeldt/r-color-palettes
) contains hundreds of color palettes. 
The most popular among them are **RColorBrewer** [@R-RColorBrewer] and **viridis** [@R-viridis].
**RColorBrewer** builds upon a set of perceptually ordered color palettes [@harrower_colorbrewer_2003] and the associated website at https://colorbrewer2.org.
The website not only presents all of the available color palettes, but also allow to filter them based on their properties, such as being colorblind safe or print-friendly.
The **viridis** package has five color palettes are perceptually-uniform and suitable for people with color blindness.
Four palettes is this package ("viridis", "magma", "plasma", and "inferno") are derived from the work on the color palettes for [the matplotlib Python library](http://bids.github.io/colormap/).
The last one, "cividis", is based on the work of @nunez_optimizing_2018.


```r
RColorBrewer::brewer.pal(7, "RdBu")
#> [1] "#B2182B" "#EF8A62" "#FDDBC7" "#F7F7F7" "#D1E5F0"
#> [6] "#67A9CF" "#2166AC"
viridis::viridis(7)
#> [1] "#440154FF" "#443A83FF" "#31688EFF" "#21908CFF"
#> [5] "#35B779FF" "#8FD744FF" "#FDE725FF"
```

<!-- grDevices::hcl.colors  + links-->
<!-- grDevices::palette  + links-->

```r
grDevices::hcl.colors(7, "Oslo")
#> [1] "#FCFCFC" "#C2CEE8" "#86A2D3" "#3C79C0" "#275182"
#> [6] "#132B48" "#040404"
grDevices::palette.colors(7, "Okabe-Ito")
#>       black      orange     skyblue bluishgreen 
#>   "#000000"   "#E69F00"   "#56B4E9"   "#009E73" 
#>      yellow        blue  vermillion 
#>   "#F0E442"   "#0072B2"   "#D55E00"
```

<!-- https://developer.r-project.org/Blog/public/2019/11/21/a-new-palette-for-r/index.html -->
Generaly, color palettes can be divided into three main types (Figure \@ref(fig:palette-types)):

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

<!-- palette properties -->
<!-- anti-rainbow -->
<!-- https://eagereyes.org/basics/rainbow-color-map -->
<!-- limitation of the number of colors -->
<!-- interpolation between colors -->
<!-- relation in the background oclor and other colors -->
<!-- using two or more palettes (e.g. lines and points): -->
<!-- color palettes then should be complementary -->

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
<!-- https://earthobservatory.nasa.gov/blogs/elegantfigures/2013/09/10/subtleties-of-color-part-6-of-6/ -->

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
