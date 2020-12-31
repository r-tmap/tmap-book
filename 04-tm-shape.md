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
tm_shape(land) +
  tm_raster("elevation", palette = terrain.colors(8)) +
tm_shape(World) +
  tm_borders() +
tm_shape(metro_large) +
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
tm_shape(land) +
  tm_raster("elevation", palette = terrain.colors(8)) +
tm_shape(World) +
  tm_borders() +
tm_shape(metro_large, is.master = TRUE) +
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
tm_shape(land, projection = 8857) +
  tm_raster("elevation", palette = terrain.colors(8)) 
```

The second approach (`raster.warp = FALSE`) computes new coordinates for each raster cell keeping all of the original values and results in a curvilinear grid.
This calculation could deform the shapes of original grid cells, and usually curvilinear grids take a longer time to plot^[For more details of the first approach see `?stars::st_warp()` and of the second approach see `?stars::st_transform()`.].

Figure \@ref(fig:tm-map-proj):B shows an example of the second approach, which gave a better result in this case without any spurious lands.
However, creation of the B map takes about ten times longer than the A map.


```r
tm_shape(land, projection = 8857, raster.warp = FALSE) +
  tm_raster("elevation", palette = terrain.colors(8))
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
tm_shape(land, bbox = c(-15, 35, 45, 65)) +
  tm_raster("elevation", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox1-1.png" alt="Global elevation data limited to the extent of the specified minimum and maximum coordinates." width="672" />
<p class="caption">(\#fig:tbbox1)Global elevation data limited to the extent of the specified minimum and maximum coordinates.</p>
</div>

The second approach allows setting the map extent based on a search query.
In the code below, we limit the map extent to the area of `"Europe"` (Figure \@ref(fig:tbbox2)).
This approach uses the OpenStreetMap tool called Nominatim to automatically generate minimum and maximum coordinates in the x and y directions based on the provided query.


```r
tm_shape(land, bbox = "Europe") +
  tm_raster("elevation", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox2-1.png" alt="Global elevation data limited to the extent specified with the 'Europe' query." width="672" />
<p class="caption">(\#fig:tbbox2)Global elevation data limited to the extent specified with the 'Europe' query.</p>
</div>

In the last approach, the map extent is based on another existing spatial object.
Figure \@ref(fig:tbbox3) shows the elevation raster data (`land`) limited to the edge coordinates from `metro_large`. 


```r
tm_shape(land, bbox = metro_large) +
  tm_raster("elevation", palette = terrain.colors(8))
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/tbbox3-1.png" alt="Global elevation data limited to the extent of the other spatial object." width="672" />
<p class="caption">(\#fig:tbbox3)Global elevation data limited to the extent of the other spatial object.</p>
</div>

<!-- ?bb -->
<!-- explain some additional arguments of bb?? -->

## Data simplification


```r
tm_shape(World) +
  tm_polygons()
```


```r
tm_shape(World, simplify = 0.05) +
  tm_polygons()
```


```r
tm_shape(World, simplify = 0.05, keep.units = TRUE) +
  tm_polygons()
```


```r
tm_shape(World, simplify = 0.05, keep.units = TRUE, keep.subunits = TRUE) +
  tm_polygons()
```


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

<img src="04-tm-shape_files/figure-html/unnamed-chunk-9-1.png" width="672" style="display: block; margin: auto;" />


<!-- mention other arguments in ms_simplify -->


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
tm_shape(land) +
  tm_raster("elevation")
```

Raster downsampling can be also disabled with the `raster.downsample` argument of `tm_shape()` (Figure \@ref(fig:rasterdown):B).


```r
tm_shape(land, raster.downsample = FALSE) +
  tm_raster("elevation")
```

<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/rasterdown-1.png" alt="(A) A raster map with the decreased resolution, (B) a raster map in the original resolution." width="672" />
<p class="caption">(\#fig:rasterdown)(A) A raster map with the decreased resolution, (B) a raster map in the original resolution.</p>
</div>

Any **tmap** options can be reset (set to default) with `tmap_options_reset()` (Chapter \@ref(options)).


```r
tmap_options_reset()
```
