# Spatial data in R {#geodata}
<!-- # Geographic data in R {#geodata} -->
<!-- to discuss -->

\index{spatial data}

## Introduction

Vector and raster data models are two basic models used to represent spatial data.
These spatial data models are closely related to map making, with each model having its own pros and cons. 
<!-- - few introduction sections -->
<!-- - mention GDAL, PROJ, and GEOS -->
<!-- - references to the next sections -->
<!-- - maybe also mention some data sources -->
This chapter describes the vector (section \@ref(vector-data)) and raster (section \@ref(raster-data)) models, and also their implementations in R in the form of the **sf** (section \@ref(the-sf-package)) and **stars** (section \@ref(the-stars-package)) packages.
Next, it focuses on the map projections (\@ref(crs)).
This section gives a background on why do we need map projections and how to translate spatial data from an ellipsoid into a flat surface or computer screen.
It also explains basic terms and gives an overview of map projections.
<!-- - maybe also references to some books (either here or in the next section or both) -->
<!-- geocompr, spatial data science, some crs book? -->
<!-- explain that often there is a need to prepare spatial data before mapping -->

## Vector data

\index{vector data model}

<!-- - one/two intro sentences -->
<!-- - including r packages used for vector representation -->
R has several packages aimed to represent spatial vector data.
Recently, the **terra** package has been released containing a new vector data representation.
For more than a decade, the **sp** package <!--REF--> was a standard of vector data representation in R.
However, now this package is in the maintenance mode only, and its successor, **sf** is recommended.
The **tmap** package has been using **sf** since version 2.0.
In the two next sections, we introduce vector data model (section \@ref(vector-data-model)) and show how the **sf** package works with spatial data (section \@ref(the-sf-package)).

### Vector data model

...

\index{vector data model}
\index{spatial geometries}
\index{spatial attributes}
The vector data model consists of two main elements: geometries and attributes.

The role of geometry is to describe the location and shape of spatial objects.
There are three basic types of geometries: points, lines, and polygons.
All of them are build using the same main idea of coordinates.

A point is represented by a pair of coordinates, usually described as X and Y.
It allows for locating this point in some space.
<!-- short CRS intro -->
X and Y could be unitless, in degrees, or in some measure units, such as meters.
<!-- maybe ref to CRS section here -->
Points can represent features on different scales, from a GPS position, location of a bench in a park, to a city on a small scale map.
They are also used to express abstract features, such as locations of map labels.
Properties of points<!--,such as ...--> can be expressed on maps by different point sizes, colors, or shapes<!--(markers/images) -->.

A line extends the idea of a point.
It consists of several points (with coordinates)<!--vertex--> that are arranged in some order.
Consecutive points are connected by straight lines.
Therefore, a straight spatial line consists of two points (two pairs of coordinates), while complex spatial lines could be created based on a large number of points.<!--to rewrite-->
It gives the illusion that the line is curved. 
Lines are used to representing linear features, such as roads, rivers, boundaries, footpaths, etc. 
In this case, we can express line features' attributes using either lines' color or their widths.
<!-- ways to adjust lines aesthetics: colors, lwd (line width) -->
<!-- in theory lty could be also used - but it is not implemented in tmap -->

A polygon is again a set of ordered points connected by straight lines. 
Its only difference from the line is that the first and the last point in a polygon has the same coordinates, and thus close the object.
<!-- examples of polygons -->
The polygon representation is used to represent shapes and locations of different objects, from a lake or a patch of vegetation, through a building or a city block, to some administrative units. 
Polygons also have one unique feature - they could have holes. 
A polygon hole represents an area inside of the polygon but does not belong to it.
For example, a lake with an island can be depicted as a polygon with a hole.
The values of polygons' attributes can be represented by the areas (fill) colors.

The second part of the vector data model relates to attributes. 
Attributes are usually stored as a table describing the properties of the data.
In this table, each column depicts some property, such as an identification number, a name of a feature, or a value of some characteristic.
Each row, on the other hand, relates to a single geometry. 







<img src="02-geodata_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

\index{simple feature}
The above ideas could be implemented in many ways. <!--...-->
Currently, the Simple Feature Access seems to be the most widely used standard <!--architecture-->
<!-- REF -->
<!-- http://portal.opengeospatial.org/files/?artifact_id=25355 -->
In it, a feature is every object or concept that have spatial location or extent. 
Simple feature standard makes a clear distinction between single- and multi-element features.
We can have a POINT feature and a MULTIPOINT feature, and similarly LINESTRING and MULTILINESTRING, and POLYGON and MULTIPOLYGON.
The main difference between single element features (such as POINT or POLYGON) and multi-element features (such as MULTIPOINT or MULTIPOLYGON) can be clearly seen in attribute tables. 
For example, six points stored as POINT features will have six separate rows, while six points stored as just one MULTIPOINT feature will have one row.
<!-- redundancy -->
<!-- Example -->
The simple feature standard also describes a number of additional geometry types, including Curve, Surface, or Triangle.
Finally, GeometryCollection exists that contain all of the possible geometry types.

<!-- JN: maybe too much information-->
<!-- simple features standard also defines possible topological rules -->







<!-- additional dimensions: -->
<!-- - more than two coordinates (XYZM) -->
<!-- - multiobjects -->
<!-- - additional geometries -->

<!-- - what is the vector data model (point coordinates) -->
<!-- - examples -->
<!-- - what's the simple features standard -->
<!-- - main geometry types -->
<!-- - relation between geometries and attributes -->

\index{spatial file formats}
There are a couple hundreds of file formats that can store spatial vector data.
One of the simplest ways to store spatial data is in the form of a text file (`.csv`) or as a spreadsheet (`.xls` or `.xlsx`). 
While it makes storing point data simple, with two columns representing coordinates, it is not easy to store more complex objects in this way.
Text files are also not suitable for storing information about the coordinate reference system used.
<!--ref to the CRS section??-->
Historically, the shapefile format (`.shp`) developed by the ESRI company gained a lot of interest and become the most widely supported spatial vector file format. 
Despite its popularity, this format has a number of shortcomings, including the need to store several files, attribute names limited to ten characters, the ability to store up to 255 attributes and files up to 2GB, and many more.
A fairly recent file format, OGC GeoPackage (`.gpkg`), was developed as an alternative. 
It is a single file database free from the limitation of the shapefile format.
Other popular spatial vector file formats include GeoJSON (`.geojson`), GPX (`.gpx`), and KML (`.kml`). 
<!-- FlatGeobuf?? -->
<!-- - advantages/disadvantages -->
<!-- - example figure (similar to the one in geocompr, but made with tmap) -->

### The sf package

\index{sf}
\index{sf (package)|see {sf}}

The **sf** package implements ideas behind the Simple Feature standard.
Its main class, `sf`, has the form of an extended data frame, where each row is a spatial feature.
<!-- - how the sf objects are organized -->
In it, attributes of the vector data are stored as columns. 
It also has one additional column, most often named `geom` or `geometry`^[However, any other names are also possible.].
This column contains geometries in a form of well-known text (WKT), storing all of the coordinates.

<!-- - how to read sf objects from files -->
The **sf** package can read all of the spatial data formats mentioned in the previous section using the `read_sf()` function^[It is also possible to read spatial vector data using the `st_read()` function, which differs from `read_sf()` by having different default arguments.].
<!--improve example-->

```r
# replace this data with some new tmap dataset
library(sf)
file_path = system.file("shapes/world.gpkg", package = "spData")
x = read_sf(file_path)
```
<!-- explain example -->

The new object, `x`, has a `sf` class. 
It has 177 features (rows or geometries) and 10 fields (columns with attributes). 
There is also an 11th column, `geom`, that stores geometries of each feature.
Objects of class `sf` also display a header containing spatial metadata.
It includes geometry type, dimension (`XY`, `XYZ`, `XYM`, `XYZM`), bounding box (`bbox`), and information about the used Coordinate Reference System (`CRS`).


```r
x
#> Simple feature collection with 177 features and 10 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: -180 ymin: -90 xmax: 180 ymax: 83.6
#> geographic CRS: WGS 84
#> [90m# A tibble: 177 x 11[39m
#>    iso_a2 name_long continent region_un subregion type 
#>    [3m[90m<chr>[39m[23m  [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m
#> [90m 1[39m FJ     Fiji      Oceania   Oceania   Melanesia Sove…
#> [90m 2[39m TZ     Tanzania  Africa    Africa    Eastern … Sove…
#> [90m 3[39m EH     Western … Africa    Africa    Northern… Inde…
#> [90m 4[39m CA     Canada    North Am… Americas  Northern… Sove…
#> [90m 5[39m US     United S… North Am… Americas  Northern… Coun…
#> [90m 6[39m KZ     Kazakhst… Asia      Asia      Central … Sove…
#> [90m 7[39m UZ     Uzbekist… Asia      Asia      Central … Sove…
#> [90m 8[39m PG     Papua Ne… Oceania   Oceania   Melanesia Sove…
#> [90m 9[39m ID     Indonesia Asia      Asia      South-Ea… Sove…
#> [90m10[39m AR     Argentina South Am… Americas  South Am… Sove…
#> [90m# … with 167 more rows, and 5 more variables:[39m
#> [90m#   area_km2 [3m[90m<dbl>[90m[23m, pop [3m[90m<dbl>[90m[23m, lifeExp [3m[90m<dbl>[90m[23m,[39m
#> [90m#   gdpPercap [3m[90m<dbl>[90m[23m, geom [3m[90m<MULTIPOLYGON [°]>[90m[23m[39m
```

The `x` object has MULTIPOLYGON geometry type, where each feature (row) can consist of one or more polygons.
Each polygon's vertices are represented by a pair of values (`dimension: XY`).
Bounding box allows to quickly understand the spatial extension of the input data. 
<!--...--> 
Finally, it has geographic CRS named WGS 84.
You can learn more about Coordinate Reference Systems in section \@ref(crs).

<!-- ref to CRS section -->

Spatial vector data of class `sf` can be also obtained using some of other R data packages.
<!-- add REFs--> 
For example, **rnaturalearth** allows to download world map data, **osmdata** imports OpenStreetMap data as `sf` objects, and **tigris** loads TIGER/Line data.
<!-- add reference to geocompr -->
<!-- add reference to https://cran.r-project.org/web/views/Spatial.html (after my updates) -->

The **tmap** package accepts spatial vector data objects from both **sf** and **sp** packages.
In case of having vector objects in a different representation, they should be converted into `sf` objects first, before making maps.
The **sf** package has the `st_as_sf()` function that translates objects of many classes, including `Spatial` (from the **sp** package), `ppp`, `psp`, and `lpp` (from the **spatstat** package), to the objects of class `sf`.
The `st_as_sf()` function also allows to turn data frames into `sf` objects - the user need to provide the input data frame, names of columns with coordinates, and additionally definition of the CRS of the data.
For example `my_sf = st_as_sf(my_df, coords = c("Xcolumn", "Ycolumn"), crs = 4326)`.

<!-- - where to find info on how to operate on sf objects -->
<!-- - https://geocompr.github.io/ -->
<!-- - vector simplification? -->

## Raster data

\index{raster data model}

<!-- - one/two intro sentences -->
<!-- - including r packages used for raster representation -->
<!-- packages REFs -->
Several R packages can be used to represent spatial raster data, including **raster** and its successor **terra**. 
The **raster** package was used as a backbone of raster data visualization until **tmap** version 3.0.
In the two next sections, we present raster data model (section \@ref(raster-data-model))
and introduce the **stars** package (section \@ref(the-stars-package)).

### Raster data model

\index{raster data model}
<!-- - raster data model (grid) -->
The raster data model represents the world using a continuous grid of cells<!--pixels-->.
<!-- - contionous and categorical rasters -->
<!-- Each cell has an associated value  -->

\@ref(fig:raster-intro)


```
#> To access larger datasets in this package,
#> install the spDataLarge package with:
#> `install.packages('spDataLarge',
#> repos='https://nowosad.github.io/drat/',
#> type='source')`
#> Loading required package: abind
```

<div class="figure" style="text-align: center">
<img src="02-geodata_files/figure-html/raster-intro-1.png" alt="Basic representation of the raster data model: (1) Cell IDs, (2) Cell values, and (3) A raster map" width="672" />
<p class="caption">(\#fig:raster-intro)Basic representation of the raster data model: (1) Cell IDs, (2) Cell values, and (3) A raster map</p>
</div>



\@ref(fig:grid-types)

<div class="figure" style="text-align: center">
<img src="02-geodata_files/figure-html/grid-types-1.png" alt="Main types of raster data grids: (1) Regular, (2) Rotated, (3) Sheared, (4) Rectilinear, and (5) Curvilinear" width="672" />
<p class="caption">(\#fig:grid-types)Main types of raster data grids: (1) Regular, (2) Rotated, (3) Sheared, (4) Rectilinear, and (5) Curvilinear</p>
</div>

<!-- - examples -->
<!-- - single layer rasters vs multilayer rasters -->
<!-- - storing bands vs attributes (either here or in the next section) (data cubes) -->
<!-- - rbg rasters -->
<!-- - regular, rotated, sheared, rectilinear and curvilinear rasters -->
<!-- - raster file formats -->

### The stars package

\index{stars}
\index{stars (package)|see {stars}}

<!-- - how the stars objects are organized -->
<!-- - how to read stars objects from files -->
<!-- - including reading chunks, changing resolution, and selecting bands -->
<!-- - where to find info on how to operate on stars objects -->
<!-- - https://r-spatial.github.io/stars/index.html -->
<!-- - advice: sometimes/often it is better to prepare spatial object before the mapping, than trying to over-customize the map -->
<!-- data cubes!! -->
<!-- - stars proxy -->


## CRS-tmp 
<!-- mtennekes part -->
<!-- + how to transform CRSs -->
