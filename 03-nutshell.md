# **tmap** in a nutshell {#nutshell}

<!-- intro -->
<!-- exploration vs communication -->

## Spatial data

<!-- data intro -->

```r
library(tmap)
library(sf)
library(stars)
ei_elev = read_stars("data/easter_island/ei_elev.tif")
ei_borders = read_sf("data/easter_island/ei_border.gpkg")
ei_roads = read_sf("data/easter_island/ei_roads.gpkg")
ei_points = read_sf("data/easter_island/ei_points.gpkg")
volcanos = subset(ei_points, type == "volcano")
```


## Quick maps

<!-- customization vs quick map -->
<!-- exploration vs communication -->



```r
qtm(volcanos)
```

<img src="03-nutshell_files/figure-html/unnamed-chunk-3-1.png" width="672" style="display: block; margin: auto;" />


```r
qtm(volcanos, symbols.shape = 24, symbols.size = "elevation", title = "Volcanos")
```

<img src="03-nutshell_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

## Regular maps

<!-- mention tmap elements -->

<!-- reproduce the above plot -->

```r
tm_shape(volcanos) +
  tm_symbols(shape = 24, size = "elevation") +
  tm_layout(title = "Volcanos")
```


<!-- add a complete map code -->
<!-- - Layered approach (grammar of graphics) -->
<!-- explain line by line -->
<!-- ref to other parts of the book -->


```r
my_map = tm_shape(ei_elev) +
  tm_graticules() +
  tm_raster(style = "cont", title = "Elevation (m asl)",
            palette = "-RdYlGn", midpoint = NA) +
  tm_shape(ei_borders) + 
  tm_borders() +
  tm_shape(ei_roads) + 
  tm_lines(lwd = "strokelwd", legend.lwd.show = FALSE) +
  tm_shape(volcanos) +
  tm_symbols(shape = 24, size = "elevation",
             title.size = "Volcanos (m asl)") +
  tm_add_legend(type = "line", title = "Roads", col = "black") +
  tm_compass(position = c("right", "top")) +
  tm_scale_bar() +
  tm_layout(main.title = "Easter Island",
            bg.color = "lightblue")
```


```r
my_map
```

<img src="03-nutshell_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

<!-- refs  -->


## Map modes

<!-- static maps, default -->
<!-- interactive maps -->

```r
tmap_mode("view")
#> tmap mode set to interactive viewing
```


```r
my_map
```


```r
tmap_mode("plot")
#> tmap mode set to plotting
```


```r
my_map
```

## Small multiples {#sm-section}

## Animations {#ani-section}
