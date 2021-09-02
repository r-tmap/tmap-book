# Save maps {#save}

Maps created programmatically can serve several purposes, from exploratory, through visualizations of the processing steps, to being the final outputs of a given project.
Therefore, often we want just to see our map on the screen, but sometimes we also want to save our map results to an external file.
**tmap** objects can be directly saved to output files with `tmap_save()`^[Standard R approach of saving graphic files by opening a graphic device, e.g., `png()`, plotting the data, and then closing the device with `dev.off()` also works.].

The `tmap_save()` function allows to save our map in three groups of file formats, (a) raster graphics (section \@ref(raster-graphic-formats)), (b) vector graphics (section \@ref(vector-graphic-formats)), and (c) interactive ones (section \@ref(interactive-format)).
Additionally, chapter \@ref(animations) shows how to save map animations with the use of the `tmap_animation()` function.

For the examples in this section, we will use a simple map of the Easter Island polygon with the island name superimposed (not shown), stored in the `tm` object.


```r
library(tmap)
library(sf)
ei_borders = read_sf("data/easter_island/ei_border.gpkg")
tm = tm_shape(ei_borders) +
  tm_polygons() +
  tm_text("name", fontface = "italic")
tm
```

## Raster graphic formats

Raster graphics are non-spatial relatives of spatial rasters.
The digital images are composed of many pixels - squares filled with specific colors.
Main raster graphic file formats include PNG, JPEG, BMP, and TIFF.
<!-- jn: should we describe each in one sentence? -->
One of the major parameters of the raster graphic images is DPI (*Dots Per Inch*, in this context, a more proper name probably should be PPI, *Pixels Per Inch*) - is a number of pixels per inch of the output image.
For example, if the width and height of our image are 10 inches, then DPI of 300 would mean that our final image would have 3000 by 3000 pixels, and DPI of 72 would result in an image of 720 by 720 pixels.
Therefore, an image with the same width and height, but larger value of DPI would occupy more space of the hard drive, but also have better quality.

Saving **tmap** objects to a file can be done with the `tmap_save()`.
It usually accepts two arguments^[In fact, one argument is enough - if you just provide a **tmap** object, then it will be saved to a `tmap01` file with some default format.] - the first one, `tm`, is our map object, and the second one, `filename`, is the path to the created file.


```r
tmap_save(tm, "my_map.png")
#> Map saved to /home/runner/work/tmap-book/tmap-book/my_map.png
#> Resolution: 2492 by 1769 pixels
#> Size: 8.31 by 5.9 inches (300 dpi)
```

By default, DPI is set to 300, and the image width and height is automatically adjusted based on the map aspect ratio.
These parameters can be, however, changed with the `dpi`, `width`, and `height` arguments^[You can even specify just one of `width` or `height`, and the value of the second one will be calculated using the formula `asp = width / height`.].


```r
tmap_save(tm, "my_map.png", width = 1000, height = 750, dpi = 300)
#> Map saved to /home/runner/work/tmap-book/tmap-book/my_map.png
#> Resolution: 1000 by 750 pixels
#> Size: 3.33 by 2.5 inches (300 dpi)
```

The units of `width` or `height` depend on the value you set. 
They are pixels (`"px"`) when the value is greater than 50, and inches (`"in"`) otherwise.
Units can also be changed with the `units` argument.

This function also has several additional arguments, including `outer.margins`, `scale` and `asp`.
All of them override the arguments' values set in `tm_layout()` (chapter \@ref(layout)).
Additionally, when set to `0`, the' asp' argument has a side effect: it moves the map frame to the edges of the output image.

By default, **tmap** uses graphic devices^[Short discussion about graphic devices can be found in section \@ref(fonts-tmap).] incorporated in R.
However, it is also possible to use other, external devices with the `device` argument.


```r
tmap_save(tm, "my_map.png", device = ragg::agg_png)
```

For example, the `ragg::agg_png` device is usually faster and has better support for non-standard fonts than the regular `grDevices::png`.



## Vector graphic formats

Vector graphics are quite distant relatives of spatial vectors, with vector graphics consisting of sets of coordinates.
Contrary to spatial vectors, however, their coordinates can be connected not only by straight lines (section \@ref(vector-data-model)), but also using curves.
This makes it possible to create polygons, circles, ellipses, and others.
They also allow storing of text and other objects.
Common vector graphic file formats are SVG, EPS, PDF.

To save a map to a vector graphic format, we still can use `tmap_save()` but either with a proper extension or by using the `device` argument, for example `device = svglite::svglite`.


```r
tmap_save(tm, "my_map.svg")
#> Map saved to /home/runner/work/tmap-book/tmap-book/my_map.svg
#> Size: 8.31 by 5.9 inches
```



While a level of zoom does not impact vector graphics' quality, the `width`, `height`, and `scale` arguments still can impact the output file.
For example, a vector graphic file saved with a narrower width value will have thicker lines and larger fonts compared to the one with a larger width value.
You can check this effect by saving the `tm` object with `width = 1` and then with `width = 10`.

Compared to raster graphics, vector graphics are not suitable for storing complex images or maps, and they are less supported by web browsers comparing to rasters.
They, however, has also many advantages.
For example, they can be zoomed in and out without any decrease in quality.
Vector graphics can also be easily edited in dedicated software (e.g., Inkscape or Adobe Illustrator), which allows to change the style of map elements and move them using a computer mouse outside of the R environment.
This approach can be useful, for example, when you want to quickly adjust the position of map elements (e.g., labels) or collaborate with a graphic designer.
Note, however, that this process is not fully reproducible.

## Interactive format

`tmap` map objects can not only be viewed in the interactive mode (section \@ref(map-modes)) but also saved as HTML files by adding the `.html` extension to the output file name.


```r
tmap_save(tm, "my_map.html")
#> Interactive map saved to /home/runner/work/tmap-book/tmap-book/my_map.html
```

The `tmap_save()` function also has several additional arguments reserved for the interactive format, including `selfcontained` and `in.iframe`.
The `selfcontained` argument with `TRUE` by default saves our map together with additional resources (e.g., JavaScript libraries) into one HTML file. 
Otherwise, additional resources will be saved in an adjacent directory.
The `in.iframe` argument (`FALSE` by default) allows saving an interactive map as an iframe - when `TRUE` it creates two HTML files - a small HTML file with the iframe container and a large one with the actual map.
<!-- when `in.iframe = TRUE` is useful?? -->
<!-- arguments passed on to device functions or to saveWidget or saveWidgetframe -->


