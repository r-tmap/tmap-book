# Specifying spatial data {#tmshape}

In order to plot spatial data, at least two aspects need to be specified: the spatial data object itself, and the plotting method(s). 
We will cover the former in this chapter. 
The latter will be discussed in the next chapter.
<!--to improve later-->

## Shapes and layers

As described in Chapter \@ref(geodata), shape objects can be vector or raster data.
We recommend `sf` objects for vector data and `stars` objects for raster data^[However, **tmap** also accepts other spatial objects, e.g., of `sp` or `raster`` classes.].

In **tmap**, a shape object needs to be defined with the function `tm_shape()`.
When multiple shape objects are used, each has to be defined in a separate `tm_shape()` call.
This is illustrated in the following example (Figure \@ref(fig:tmshape1)).


```r
# replace this data with some new tmap dataset
library(tmap)
library(dplyr)
library(sf)
library(stars)
worldvector = read_sf("data/worldvector.gpkg")
worldcities = read_sf("data/worldcities.gpkg")
worldelevation = read_stars("data/worldelevation.tif")
```


```r
tm_shape(worldelevation) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8)) +
tm_shape(worldvector) +
  tm_borders() +
tm_shape(worldcities) +
  tm_dots() +
  tm_text("name")
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tmshape1-1.png" alt="A map representing three shapes (land, World, and metro_large) using four layers." width="672" />
<p class="caption">(\#fig:tmshape1)A map representing three shapes (land, World, and metro_large) using four layers.</p>
</div>

In this example, we use three shapes: `land` which is a `stars` object that contains an attribute called `"elevation"`, `World` which is an `sf` object with country borders, and `metro_large`, which is an `sf` object that contains metropolitan areas of at least 20 million inhabitants.

Each `tm_shape()` function call is succeeded by one or more layer functions.
In the example these are `tm_raster()`, `tm_borders()`, `tm_dots()` and `tm_text()`.
We will describe layer functions in detail in the next chapter.
For this chapter, it is sufficient to know that each layer function call defines how the spatial data specified with `tm_shape()` is plotted.

Shape objects can be used to plot multiple layers.
In the example, shape `metro_large` is used for two layers, `tm_dots()` and `tm_text()`.
We recommend to indent the code for the layer functions, in order to see which layers use which shape objects.
<!--to discuss-->

## Shapes hierarchy

The order of the `tm_shape()` functions' calls is crucial.
The first `tm_shape()`, known as the main shape, is not only shown below the following *shapes*, but also sets the projection and extent of the whole map.
In Figure \@ref(fig:tmshape1), the `land` object was used as the first *shape*, and thus the whole map has the projection and extent of this object.

However, we can quickly change the main *shape* with the `is.master` argument.
<!--change to is.main later-->
In the following example, we set the `metro_large` object as the main *shape*, which limits the output map to the point locations in `metro_large` (Figure \@ref(fig:tmshape2))^[We will show how to adjust margins and text locations later in the book].


```r
tm_shape(worldelevation) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8)) +
tm_shape(worldvector) +
  tm_borders() +
tm_shape(worldcities, is.master = TRUE) +
  tm_dots() +
  tm_text("name")
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tmshape2-1.png" alt="A map representing three shapes (land, World, and metro_large) using four layers." width="672" />
<p class="caption">(\#fig:tmshape2)A map representing three shapes (land, World, and metro_large) using four layers.</p>
</div>

<!-- should we mention inner.margins here or later?? -->

## Map projection
\index{map projection}

As we mentioned in the previous section, the created map uses the projection from the main *shape*.
However, we often want to create a map with a different projection to preserve specific property (Chapter \@ref(crs)).
We can do this in two ways.
The first way to use a different projection on a map is to reproject the main data before plotting, as shown in Section \@ref(crs-in-r).
The second way is to specify the map projection using the `projection` argument of `tm_shape()`.
This argument expects either some `crs` object or a CRS code.
In the next example, we set `projection` to `8857`.
This number represents EPSG 8857 of a projection called [Equal Earth](http://equal-earth.com/index.html) [@savric_equal_2019].
The Equal Earth projection is an equal-area pseudocylindrical projection for world maps similar to the non-equal-area Robinson projection (Figure \@ref(fig:crs-robin)).

Reprojections of vector data is usually straightforward because each spatial coordinate is reprojected individually. 
However, reprojecting of raster data is more complex and requires using one of two approaches.
The first approach (`raster.warp = TRUE`) applies raster warping, which is a name for two separate spatial operations: creation of a new regular raster object and computation of new pixel values through resampling (for more details read Chapter 6 of @lovelace2019geocomputation).
This is the default option in **tmap**, however, it has some limitations.

Figure \@ref(fig:tm-map-proj):A shows the world elevation raster reprojected to Equal Earth.
Some of you can quickly noticed that certain areas, such as parts of Antarctica, New Zealand, Alaska, and the Kamchatka Peninsula, are presented twice: with one version being largely distorted.
Another limitation of `raster.warp = TRUE` is the use of the nearest neighbor resampling only - while it can be a proper method to use for categorical rasters, it can have some unintended consequences for continuous rasters (such as the `"elevation"` data).


```r
tm_shape(worldelevation, projection = 8857) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8)) 
```

The second approach (`raster.warp = FALSE`) computes new coordinates for each raster cell keeping all of the original values and results in a curvilinear grid.
This calculation could deform the shapes of original grid cells, and usually curvilinear grids take a longer time to plot^[For more details of the first approach see `?stars::st_warp()` and of the second approach see `?stars::st_transform()`.].

Figure \@ref(fig:tm-map-proj):B shows an example of the second approach, which gave a better result in this case without any spurious lands.
However, creation of the B map takes about ten times longer than the A map.


```r
tm_shape(worldelevation, projection = 8857, raster.warp = FALSE) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tm-map-proj-1.png" alt="Two elevation maps in the Equal Earth projection: (A) created using raster.warp = TRUE, (B) created using raster.warp = FALSE." width="672" />
<p class="caption">(\#fig:tm-map-proj)Two elevation maps in the Equal Earth projection: (A) created using raster.warp = TRUE, (B) created using raster.warp = FALSE.</p>
</div>



<!-- add our recommendations -->
<!-- about reprojecting first vs later - why and how -->

## Map extent

Another important aspect of mapping, besides projection, is its extent - a portion of the area shown in a map.
<!--add info about the bounding box term-->
This is not an issue when the extent of our spatial data is the same as we want to show on a map.
However, what should we do when the spatial data contains a larger region than we want to present?

Again, we could take two routes.
The first one is to preprocess our data before mapping - this can be done with vector clipping (e.g., `st_intersection()`) and raster cropping (e.g., `st_crop()`).
We would recommend this approach if you plan to work on the smaller data in the other parts of the project.
The second route is to specify the map extent in **tmap**.

**tmap** allows specifying map extent using three approaches.
The first one is to specify minimum and maximum coordinates in the x and y directions that we want to represent.
This can be done with a numeric vector of four values in the order of minimum x, minimum y, maximum x, and maximum y, where all of the coordinates need to be specified in the input data units^[This can also be done with the object of class `st_bbox` or a 2 by 2 matrix.
In the following example, we limit our map extent to the rectangular area between x from -15 to 45 and y from 35 to 65 (Figure \@ref(fig:tbbox1)).
<!-- mention tm_grid? -->


```r
tm_shape(worldelevation, bbox = c(-15, 35, 45, 65)) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox1-1.png" alt="Global elevation data limited to the extent of the specified minimum and maximum coordinates." width="672" />
<p class="caption">(\#fig:tbbox1)Global elevation data limited to the extent of the specified minimum and maximum coordinates.</p>
</div>

The second approach allows setting the map extent based on a search query.
In the code below, we limit the map extent to the area of `"Europe"` (Figure \@ref(fig:tbbox2)).
This approach uses the OpenStreetMap tool called Nominatim to automatically generate minimum and maximum coordinates in the x and y directions based on the provided query.


```r
tm_shape(worldelevation, bbox = "Europe") +
  tm_raster("worldelevation.tif", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox2-1.png" alt="Global elevation data limited to the extent specified with the 'Europe' query." width="672" />
<p class="caption">(\#fig:tbbox2)Global elevation data limited to the extent specified with the 'Europe' query.</p>
</div>

In the last approach, the map extent is based on another existing spatial object.
Figure \@ref(fig:tbbox3) shows the elevation raster data (`land`) limited to the edge coordinates from `metro_large`. 


```r
tm_shape(worldelevation, bbox = worldcities) +
  tm_raster("worldelevation.tif", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox3-1.png" alt="Global elevation data limited to the extent of the other spatial object." width="672" />
<p class="caption">(\#fig:tbbox3)Global elevation data limited to the extent of the other spatial object.</p>
</div>

<!-- ?bb -->
<!-- explain some additional arguments of bb?? -->

## Data simplification

Geometries in spatial vector data consists of sets of coordinates (Section \@ref(vector-data-model)).
Spatial vector objects grow larger with more features to present and more details to show, and this also has an impact on time to render a map.
<!-- also to consider - the level of generalization -->
Figure \@ref(fig:vectordown):A shows a map of countries from the `World` object.


```r
tm_shape(worldvector) +
  tm_polygons()
```

This level of detail can be good for some maps, but sometimes the number of details can make reading the map harder.
To show a simplified (smoother) version of vector data, we can use the `simplify` argument of `tm_shape()`^[Vector data simplification requires the **rmapshaper** package to be installed.].
It expects a numeric value from 0 to 1 - a proportion of vertices in the data to retain.
In the example below, we set `simplify` to 0.05, which keeps 5% of vertices (Figure \@ref(fig:vectordown):B).


```r
tm_shape(worldvector, simplify = 0.05) +
  tm_polygons()
```

The process of simplification can also be more controlled.
By default, the underlining algorithm (called the Visvalingam method, learn more at https://bost.ocks.org/mike/simplify/), removes small features, such as islands in our case.
This could have far-reaching consequences - in the process of simplification, we can remove some countries!
To prevent the deletion of small features, we also need to set `keep.units` to `TRUE`.


```r
tm_shape(worldvector, simplify = 0.05, keep.units = TRUE) +
  tm_polygons()
```

Figure \@ref(fig:vectordown):C shows the result of such an operation.
Now, our map contains all of the countries from the original data, but in a simplified form.
`keep.units = TRUE`, however, does not keep all of the subfeatures.
In the case of one country consisting of many small polygons, only one is sure to be retained.
For example, look at New Zealand, which is now only represented by Te Waipounamu (the South Island).
To keep all of the spatial geometries (even the smallest of islands), we should also specify `keep.subunits` to `TRUE`.


```r
tm_shape(worldvector, simplify = 0.05, keep.units = TRUE, keep.subunits = TRUE) +
  tm_polygons()
```

Figure \@ref(fig:vectordown):D contains a simplified map, where each spatial geometry of the original map still exists, but in a less detailed form.


```
#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.

#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.

#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.

#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.

#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.

#> Warning: rmapshaper package is needed to simplify
#> the shape. Alternatively, st_simplify from the sf
#> package can be used. See the underlying function
#> tmaptools::simplify_shape for details.
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/vectordown-1.png" alt="A map of world's countries based on: (A) original data, (B) simplified data with 5% of vertices kept, (C) simplified data with 5% of vertices, and all features kept, (D) simplified data with 5% of vertices, all features, and all polygons kept." width="672" />
<p class="caption">(\#fig:vectordown)A map of world's countries based on: (A) original data, (B) simplified data with 5% of vertices kept, (C) simplified data with 5% of vertices, and all features kept, (D) simplified data with 5% of vertices, all features, and all polygons kept.</p>
</div>

All of the about vector simplification functions use the `ms_simplify()` from the **rmapshaper** package <!--add two citations: to mapshaper and rmapshaper-->.
Therefore, you can customize the data simplification even further using other arguments of `ms_simplify()` (except for the arguments `input`, `keep`, `keep_shapes`, and `explode`).


<!-- 2/resolution -->
Raster data is represented by a grid of cells (Section \@ref(raster-data-model)), and the number of cells impacts the time to render a map.
Rasters with hundreds of cells will be plotted quickly, while rasters with hundreds of millions or billions of cells will take a lot of time (and RAM) to be shown.
<!-- ... some info about screen resolution -->
Therefore, the **tmap** package downsamples large rasters by default to be below 10,000,000 cells in the plot mode and 1,000,000 cells in the view mode.
<!-- c(plot = 1e7, view = 1e6) -->
This values can be adjusted with the `max.raster` argument of `tmap_options()`, which expects a named vector with two elements - `plot` and `view`.
<!-- btw - downsampling cont vs cat -->
<!-- when and why -->
 (Figure \@ref(fig:rasterdown):A).


```r
tmap_options(max.raster = c(plot = 5000, view = 2000))
tm_shape(worldelevation) +
  tm_raster("worldelevation.tif")
```

Raster downsampling can be also disabled with the `raster.downsample` argument of `tm_shape()` (Figure \@ref(fig:rasterdown):B).


```r
tm_shape(worldelevation, raster.downsample = FALSE) +
  tm_raster("worldelevation.tif")
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/rasterdown-1.png" alt="(A) A raster map with the decreased resolution, (B) a raster map in the original resolution." width="672" />
<p class="caption">(\#fig:rasterdown)(A) A raster map with the decreased resolution, (B) a raster map in the original resolution.</p>
</div>

Any **tmap** options can be reset (set to default) with `tmap_options_reset()` (We explain `tmap_options()` in details in Chapter \@ref(options)).


```r
tmap_options_reset()
```

<!-- is there anything important about tm_shape arguments that still is missing for the above text?? -->
