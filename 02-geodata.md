# Spatial data in R {#geodata}
<!-- # Geographic data in R {#geodata} -->
<!-- to discuss -->

\index{spatial data}

## Introduction

Two basic models used to represent spatial data are vector and raster data model.
<!-- - few introduction sections -->
<!-- - mention GDAL, PROJ, and GEOS -->
<!-- - references to the next sections -->
<!-- - maybe also references to some books (either here or in the next section or both) -->
<!-- - maybe also mention some data sources -->

## Vector data

\index{vector data model}

<!-- - one/two intro sentences -->
<!-- - including r packages used for vector representation -->

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
Points can represents features on different scales, from a GPS position, location of a bench in a park, to a city in a small scale map.
They are also used to express abstract features, such as locations of map labels.
Properties of points<!--,such as ...--> can be expressed on maps by different point sizes, colors, or shapes<!--(markers/images) -->.

A line extends the idea of a point.
It consists of several points (with coordinates)<!--vertex--> that are arranged in some order.
Consecutive points are connected by straight lines.
Therefore, a straight spatial line consists of two points (two pairs of coordinates), while complex spatial lines could be created based on a large number of points.<!--to rewrite-->
It gives the illusion that the line is curved. 
Lines are used to represent linear features, such as roads, rivers, boundaries, footpaths, etc. 
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
Values of polygons' attributes can be represented by the areas (fill) colors.

The second part of the vector data model relates to attributes. 
Attributes are usually stored as a table describing properties of the data.
In this table, each column depicts some property, such as an identification number, a name of a feature, or a value of some characteristic.
Each row, on the other hand, relates to a single geometry. 







<img src="02-geodata_files/figure-html/unnamed-chunk-4-1.png" width="672" style="display: block; margin: auto;" />

<!-- several implementations of this data model -->
<!-- including simple feature -->
<!-- what is a feature -->
Simple feature standard makes a clear distinction between single- and multi-element features.
We can have a POINT feature and a MULTIPOINT feature, and similarly LINESTRING and MULTILINESTRING, and POLYGON and MULTIPOLYGON.
<!-- multielements -->
Attribute table clearly shows a main difference between single element features (such as POINT or POLYGON) and multi-element features (such as MULTIPOINT or MULTIPOLYGON).
For example, six points stored as POINT features will have six separate rows, while six points stored as just one MULTIPOINT feature will have one row.
<!-- redundancy -->
<!-- Example -->
<!-- additional geometries -->







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
<!-- - advantages/disadvantages -->
<!-- - example figure (similar to the one in geocompr, but made with tmap) -->

### The sf package

<!-- "Vector data provide a way to represent real world features" -->
<!-- - how the sf objects are organized -->
<!-- - how to read sf objects from files -->
<!-- - where to find info on how to operate on sf objects -->
<!-- - https://geocompr.github.io/ -->
<!-- - vector simplification? -->
<!-- - stars proxy -->

## Raster data

<!-- one/two intro sentences -->
<!-- including r packages used for raster representation -->

### Raster data model

<!-- - raster data model (grid) -->
<!-- - contionous and categorical rasters -->
<!-- - examples -->
<!-- - single layer rasters vs multilayer rasters -->
<!-- - storing bands vs attributes (either here or in the next section) (data cubes) -->
<!-- - rbg rasters -->
<!-- - regular, rotated, sheared, rectilinear and curvilinear rasters -->
<!-- - raster file formats -->

### The stars package

<!-- - how the stars objects are organized -->
<!-- - how to read stars objects from files -->
<!-- - including reading chunks, changing resolution, and selecting bands -->
<!-- - where to find info on how to operate on stars objects -->
<!-- - https://r-spatial.github.io/stars/index.html -->
<!-- - advice: sometimes/often it is better to prepare spatial object before the mapping, than trying to over-customize the map -->
<!-- - stars proxy -->


## CRS
<!-- mtennekes part -->
