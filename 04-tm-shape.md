# Specifying spatial data with `tm_shape` {#tmshape}


## Map projections (CRS) {#crs}

### How to put an orange peel flat on the table?

<!--probably best to move it to Chapter 2, I (Martijn) will do this when the draft is more or less finished.-->




We use maps so often in everyday life that most of us probably forget that a map is just a two-dimensional representation of a three-dimensional object, namely the earth.
For centuries, geographers and mathematicians wondered what the best way is to do this.
Let us wonder with them for a second.

The world is shown as an orange below, not just to stimulate your appetite for this subject, but also since an orange peel is a good analogy for a two-dimensional map.
A world map can be seen as an orange peel that is put flat on the table.
The question is how to do this.




<div class="figure" style="text-align: center">
<img src="images/orange_world.png" alt="How to peel an orange?" width="606" />
<p class="caption">(\#fig:orange)How to peel an orange?</p>
</div>

When we peel the orange, ideally we want to rip the peel near areas of the earth that are less interesting. 
What is interesting depends on the application; for applications where land mass is more important than wetlands, it is a good idea to make the rips in the oceans.
The (interrupted) Goode homolosine projection, which is shown below, embodies this idea. 
All continents and countries are preserved, except Antarctica and Greenland.


<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/crs-03-1.png" alt="The (interrupted) Goode homolosine projection" width="672" />
<p class="caption">(\#fig:crs-03)The (interrupted) Goode homolosine projection</p>
</div>

To make the analogy between the orange peel and the surface of the earth complete, we have to assign two fictitious properties to the orange peel, namely that it is stretchable and deformable.
These properties are needed in order to make a non-interrupted map, as we will see in the next sections.

A method to flatten down the earth, for which the Goode homolosine projection shown Figure \@ref(fig:crs-03) is an example, is called a *map projection*. Technically, it is also known as a *coordinate reference system* (*crs*), which specifies the corresponding coordinate system, as well as the transformations to other map projections.

### How to model the surface of the earth?

The orange and the earth have another thing in common; both are spheres, but not perfect ones.
The earth is metaphorically speaking a little fat: the circumference around the equator is 40,075 km whereas around the circumference that crosses both poles is 40,009 km.
<!--source: https://en.wikipedia.org/wiki/Earth_physical_characteristics_tables-->
Therefore, the earth can better be described as an ellipsoid.
The same applies to an orange; every orange is a little different, but probably very few oranges are perfect spheres.

Although the ellipsoid is a good mathematical model to describe the earth's surface, keep in mind that the surface of the earth is not smooth;
land mass usually lies on a higher altitude than sea level.
We could potentially map each point on the surface of the earth using a three-dimensional $(x, y, z)$ Cartesian coordinate system with the center of the mass of the Earth being the origin (0, 0, 0).
However, since this has many mathematical complications, the ellipsoid is often sufficient as a model of the surface of the earth.

This ellipsoid model and its translation to the Earth' surface is called a *(geodetic) datum*.
The most popular datum is WGS84, which has been introduced in 1984 as an international standard, and has been last revised in 2004.
There are many (slightly) different datums, which are often tailored for local applications.
For instance, NAD83, ETRS89, and GDA94 are slightly better models for North-America, Europe, and Australia respectively.
However, since WGS84 is a very good approximation of the earth as a whole, it has been widely adopted worldwide and is also used by the Global Positioning System (GPS).


When we have specified a datum, we are able to specify geographic locations with two familiar variables, namely *latitude* and *longitude*.
The latitude specifies the north-south position in degrees, where latitude = 0$^\circ$ is the equator.
The latitudes for the north and south pole are 90$^\circ$ and $-90^\circ$ respectively.
The longitude specifies the east-west position in degrees, where by convention, the longitude = 0$^\circ$ meridian crosses the Royal Observatory in Greenwich, UK.
The Longitude range is -180$^\circ$ to 180$^\circ$, and since this is a full circle, -180$^\circ$ and $^\circ$ specify the same longitude.

When we see the earth in its three-dimensional form, as in Figure \@ref(fig:orange), the latitude parallels are the horizontal lines around the earth, and the longitude meridians are the vertical lines around the earth. The set of longitude meridians and latitude parallels is also referred to as *graticule*.
In all the figures in this section, latitude parallels are shown as gray lines for $-60^\circ$, $-30^\circ$, $0^\circ$, $30^\circ$ and $60^\circ$, and longitude meridians from $-180^\circ$ to $180^\circ$ at every $30^\circ$.

Please keep in mind that only a latitude and longitude are not sufficient to specify a geographic location.
A datum is required.
When people exchange latitude longitude data, it is save to assume that they implicitly have used the WGS84 datum.
However, it is good practice to specify the datum explicitly.

### Platte Carrée and Web Mercator


Let's take a closer look at two widely used map projections, namely the plain latitude longitude coordinate system (using the WGS84 datum) and the Web Mercator projection, which is currently the de facto standard for interactive maps. 
These projections are indexed as EPSG4326 and EPSG3857 respectively.
EPSG is an institute that maintains a database of standard map projections.

<!--https://geographx.co.nz/map-projections/-->


<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/crs-04-1.png" alt="The WGS84 coordinate system (EPSG4326)" width="672" />
<p class="caption">(\#fig:crs-04)The WGS84 coordinate system (EPSG4326)</p>
</div>

When we fictitiously make little holes in the orange peel at both poles, and stretch these open so wide that they have the same width as the equator, we obtain the cylinder depicted in Figure \@ref(fig:crs-04) (left).
Note that the lontitude lines have become straight vertical lines.
When we unroll this cylinder, we obtain a map where the $x$ and $y$ coordinates are the longitude and latitude respectively. This CRS, which is known as EPSG4326, is shown in Figure \@ref(fig:crs-04) (right).


EPSG4326 is an *unprojected* CRS, since the longitude and latitude have not been transformed. With *projected* CRSs, the $x$ and $y$ coordinates refer to specific measurement units, usually meters.
The projected variant of this CRS is called the *Platte Carrée* (EPSG4087), and is exactly the same map as shown in Figure \@ref(fig:crs-04) (right), but with other $x$ and $y$ value ranges.

Observe since we stretched the poles open, the area near the poles have been stretched out as well.
More specifically, the closer the land is to one of the poles, the more it has been stretched out.
Since the stretching direction is only horizontally, the shapes of the areas have become wider.
A good example is Greenland, which is normally a 'tall' area (as can be seen in Figure \@ref(fig:orange)).

In order to fix these deformed areas, Gerardus Mercator, a Flemish geographer in the 16th century introduced a method to compensate for this by inflating the areas near the poles even more, but now only in a vertical direction.
This projection is called the Mercator projection.
For web applications, this projection has been slightly modified and renamed to the Web Mercator projection (EPSG3857).
The cylinder and plain map that uses this projection are shown in Figure \@ref(fig:crs-05).


<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/crs-05-1.png" alt="Web Mercator projection (EPSG3857)" width="672" />
<p class="caption">(\#fig:crs-05)Web Mercator projection (EPSG3857)</p>
</div>

Although the areas near the poles have been inflated quite a lot, especially Antarctica and Greenland, the shape of the areas is correct (which can be seen by comparing with Figure \@ref(fig:orange)).
The Mercator projection is very useful for navigational purposes, and has therefore been embraced by sailors ever since.
Also today, the Web Mercator is the de facto standard for interactive maps and navigation services.
However, for maps that show data the (Web) Mercator projection should be used with great caution, because the hugely inflated areas will influence how we perceive spatial data.
We will discuss this in the next section.

## Overview of map projections

<!-- https://en.wikipedia.org/wiki/List_of_map_projections
http://www.geog.uoregon.edu/shinker/geog311/Labs/lab02/properties.htm
-->




<div class="figure" style="text-align: center">
<img src="04-tm-shape_files/figure-html/crs-06-1.png" alt="Lambert azimuthal equal-area projection (EPSG3035)" width="672" />
<p class="caption">(\#fig:crs-06)Lambert azimuthal equal-area projection (EPSG3035)</p>
</div>


Map projections can be classified by whether the following map properties are preserved:

The standard set of comparison operators can be used in the `filter()` function, as illustrated in Table \@ref(tab:operators): 


Table: (\#tab:operators)Map projection properties.

|Name        |Preserved property  |
|:-----------|:-------------------|
|Conformal   |Local angle (shape) |
|Equal area  |Area                |
|Equidistant |Distance            |
|Azimuthal   |Direction           |


* *Conformal (true local angles/shapes)*: A map projection is called *conformal* when local angles are preserved, and therefore local shapes. 
The Mercator is an example.
* *Equal-area (true areas)*: A map projection is called *equal-area* if the areas are proportional to the true areas.
* *Equidistant (true distances)* A map projection is called *equidistant* if there is one point (usually the center) from which the distances to any other point in the map are preserved.
* *Azimuthal (true-direction)* A map projection is called *azimuthal* if the directions from one point (the center) to any other point are same as the true direction following the surface of the earth.


Take home message: plain latitude/longitude coordinates (EPSG 4326) and the Mercator projection (3857) are great for navigation, but less suitable for maps with data, especially world maps.

Take home message: before you start mapping, think about which projection is good for the area of interest and for the specific task at hand.
