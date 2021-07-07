map_orange_world = function() {
  library(grid)
  if (file.exists("images/orange.png")) {
    World2 = World
    World2$geometry[World$iso_a3 == "USA"] = st_cast(World$geometry[World$iso_a3 == "USA"], "POLYGON")[6]
    ortho_crs = st_crs("+proj=ortho +lon_0=11 +lat_0=46")
    World_ortho = st_transform(World2, crs = ortho_crs)
    World_ortho = st_make_valid(World_ortho)
    World_ortho = st_cast(World_ortho, "MULTIPOLYGON")
    World_ortho = World_ortho[!st_is_empty(World_ortho), ]

    ortho_bbx = st_bbox(c(xmin = -6377165, ymin = -6373732, xmax = 6377165, ymax = 6377634), crs = ortho_crs)
    
    png("images/orange_world.png", width = 1213, height = 1213)
    
    orange = png::readPNG("images/orange.png") %>% 
      rasterGrob(interpolate=TRUE)
    
    grid.newpage()
    grid.draw(orange)
    vp = grid::viewport(width = .84, height = .84, x = .48)
    print(tm_shape(World_ortho, bbox = ortho_bbx) +
            # 	tm_borders("grey30", lwd = 2) +
            tm_polygons("red", border.col = "grey30", lwd = 4, alpha = .25) +
            tm_graticules(x = seq(-180, 150, by = 30), y = seq(-90, 90, by = 30),
                          labels.show = FALSE, lwd = 2) +
            tm_layout(frame = FALSE, bg.color = NA), vp = vp)
    dev.off()
  }
}



map_goode = function() {
  require(sf)
  require(tmap)
  data(World)
  crs_goode = "+proj=igh +towgs84=0,0,0"
  land = st_transform(World, crs_goode)

  # code from https://wilkelab.org/practicalgg/articles/goode.html
  lats <- c(
    90:-90, # right side down
    -90:0, 0:-90, # third cut bottom
    -90:0, 0:-90, # second cut bottom
    -90:0, 0:-90, # first cut bottom
    -90:90, # left side up
    90:0, 0:90, # cut top
    90 # close
  )
  longs <- c(
    rep(180, 181), # right side down
    rep(c(80.01, 79.99), each = 91), # third cut bottom
    rep(c(-19.99, -20.01), each = 91), # second cut bottom
    rep(c(-99.99, -100.01), each = 91), # first cut bottom
    rep(-180, 181), # left side up
    rep(c(-40.01, -39.99), each = 91), # cut top
    180 # close
  )

  bg <- list(cbind(longs, lats)) %>%
    st_polygon() %>%
    st_sfc(
      crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    ) %>%
    st_transform(crs = crs_goode)

  land = st_intersection(land, bg)

  #
  #   ## generate quasi-random sequence
  #   set.seed(123456789)
  #   hm <- randtoolbox::halton(72^2, dim=2) * 360 - 180
  #   hm = as.data.frame(hm[hm[,2] > -90 & hm[,2] < 90, ])
  #
  #   p = st_as_sf(hm, coords = c("V1", "V2"), crs = 4326)
  #
  #

  grat = sf::st_graticule(lon = seq(-180, 150, by = 30), lat = seq(-90, 90, by = 30)) %>%
    st_transform(crs = crs_goode) %>%
    st_intersection(bg)

  list(bg = bg, land = land, grat = grat)
}



map_4326 = function() {
  data(World, package = "tmap")
  land = sf::st_transform(World, 4326)
  grat = sf::st_graticule(lon = seq(-180, 180, by = 30), lat = seq(-90, 90, by = 30))
  bg = tmaptools::bb_earth()
  list(bg = bg, land = land, grat = grat)
}

map_3857 = function() {
  data(World, package = "tmap")
  bbx = sf::st_bbox(c(xmin=-180,ymin=-85, xmax=180, ymax=85), crs = 4326)
  land = World %>% 
    sf::st_transform(4326) %>% 
    st_crop(tmaptools::bb_earth(bbx = bbx)) %>% 
    sf::st_transform(3857)
  grat = sf::st_graticule(x = bbx, lon = seq(-180, 180, by = 30), lat = seq(-90, 90, by = 30))
  bg = tmaptools::bb_earth(projection = 3857, bbx = bbx)
  list(bg = bg, land = land, grat = grat)
}


map_4326_cyl = function() {
  get_cylinder = function(co, lon_center) {
    co[,1] = co[,1] - lon_center
    xx = sin(co[,1]/180*pi) * 55
    xy = -cos(co[,1]/180*pi) * 55 * .35
    
    x2 = xx
    y2 = xy + co[,2]
    
    x2 = x2 * .5
    y2 = y2 * .5
    cbind(x2,y2)
  }
  
  lon_center = 11
  crp = st_sfc(st_polygon(list(rbind(c(lon_center - 90, -90),
                                     c(lon_center - 90, 90),
                                     c(lon_center + 90, 90),
                                     c(lon_center + 90, -90),
                                     c(lon_center - 90, -90)))), crs = 4326)
  

  World_cyl = World %>% 
    st_transform(crs = 4326) %>% 
    st_intersection(crp) %>% 
    st_cast("MULTIPOLYGON")

  # ugly manual edits:
  ant = World_cyl$geometry[World_cyl$name == "Antarctica"]
  ant[[1]][[4]][[1]] = rbind(ant[[1]][[4]][[1]][1:262,], cbind(seq(101,-79, length.out = 30), rep(-90, 30)), ant[[1]][[4]][[1]][265:307,]) # add intermediate points to make the bottom curve (otherwise it would be a straight line)
  World_cyl$geometry[World_cyl$name == "Antarctica"] = ant
  zaf = World_cyl$geometry[World_cyl$iso_a3 == "ZAF"]
  zaf[[1]][[1]] = zaf[[1]][[1]][1] # remove island of South-Africa, which caused problems.
  World_cyl$geometry[World_cyl$iso_a3 == "ZAF"] = zaf
  
  
  World_cyl$geometry = st_sfc(lapply(World_cyl$geometry, function(g) {
    st_multipolygon(lapply(g, function(gi) {
      gi[[1]] = get_cylinder(gi[[1]], lon_center = lon_center)
      gi
    }))
  }), crs = 4326)
  
  bg_front = tmaptools::bb_poly(c(-90,-90, 90,90))
  bg_back = tmaptools::bb_poly(c(-180,-90,180,90))
  st_crs(bg_front) = 4326
  st_crs(bg_back) = 4326
  
  bg_front[[1]][[1]] = get_cylinder(bg_front[[1]][[1]], lon_center = 0)
  bg_back[[1]][[1]] = get_cylinder(bg_back[[1]][[1]], lon_center = 0)
  
  grat = sf::st_graticule(x = sf::st_bbox(c(xmin = -90 + lon_center, ymin = -90, xmax = 90 + lon_center, ymax = 90), crs = 4326),  lon = seq(-60, 90, by = 30), lat = seq(-90, 90, by = 30))
  grat$geometry = st_sfc(lapply(grat$geometry, function(g) {
    st_linestring(get_cylinder(g, lon_center = lon_center))
  }), crs = 4326)
  
  list(bg_front = bg_front, bg_back = bg_back, land = World_cyl, grat = grat)
}


# function to check if polygons contain 4 points
sf_is_valid_4poly = function(x) {
  g <- sf::st_geometry(x)
  vapply(g, function(gi) {
    nrow(st_coordinates(gi)) == 5L
  }, FUN.VALUE = logical(1))
}

# function to create world surface
world_surface = function(datum = 4326, step = 2, nx = 360/step, ny = 180/step, projection = NULL, union = TRUE) {
  s = stars::st_as_stars(sf::st_bbox(c(xmin=-180,ymin=-90,xmax=180,ymax=90), crs = datum), nx = nx, ny = ny)
  s2 = sf::st_as_sf(s)
  s4 = if (!is.null(projection)) {
    s3 = sf::st_transform(s2, crs=projection)
    s3[sf_is_valid_4poly(s3), ]
  } else{
    s2
  }
  if (union) {
    sf::st_union(sf::st_buffer(s4, dist = 1e-03))
  } else {
    s4
  }
}

map_3035 = function() {
  data(World, package = "tmap")
  land = sf::st_transform(World, 3035)
  grat = sf::st_graticule(lon = seq(-180, 180, by = 30), lat = seq(-90, 90, by = 30)) %>% st_transform(3035)
  
  # background approximation using many graticules
  grat2 = sf::st_graticule(lon = seq(-180, 180, by = 1), lat = seq(-90, 90, by = 1)) %>% st_transform(3035)
  co = st_coordinates(grat2)
  xrange = range(co[,1])
  yrange = range(co[,2])
  xc = mean(xrange)
  yc = mean(yrange)
  xamp = xc - xrange[1]
  yamp = yc - yrange[1]
  
  x = sin(seq(0, 2*pi, length.out=361)) * xamp + xc
  y = cos(seq(0, 2*pi, length.out=361)) * yamp + yc
  x[361] = x[1]
  y[361] = y[1]
  bg = st_sfc(st_polygon(list(cbind(x, y))), crs = 3035)
  
  list(bg = bg, land = land, grat = grat)
}


map_eqdc = function() {
  crs = "+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=60 +lat_2=60 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs"
  data(World, package = "tmap")
  
  land = World %>% filter(iso_a3 != "ATA") %>% sf::st_transform(crs)
  bg = tmaptools::bb_earth(crs)
  
  grat = sf::st_graticule(lon = seq(-180, 180, by = 30), lat = seq(-90, 90, by = 30)) %>% st_transform(crs)
  list(bg = bg, land = land, grat = grat)
  
}


map_3857_cyl = function() {
  
  m3857 = map_3857()
  
  ymax = unname(st_bbox(m3857$bg)[4])
  
  get_cylinder = function(co, lon_center) {

    magnitude = 20037508/180*55
    
    co[,1] = co[,1] - lon_center
    xx = sin(co[,1]/20037508*pi) * magnitude
    xy = -cos(co[,1]/20037508*pi) * magnitude * .35
    
    x2 = xx
    y2 = xy + co[,2]
    
    x2 = x2 * .5
    y2 = y2 * .5
    cbind(x2,y2)
  }
  
  lon_center = 11/180*20037508
  crp = st_sfc(st_polygon(list(rbind(c(lon_center - 20037508/2, -20037508),
                                     c(lon_center - 20037508/2, 20037508),
                                     c(lon_center + 20037508/2, 20037508),
                                     c(lon_center + 20037508/2, -20037508),
                                     c(lon_center - 20037508/2, -20037508)))), crs = 3857)
  
  World_cyl = m3857$land %>% 
    st_intersection(crp) %>% 
    st_cast("MULTIPOLYGON")
  
  # ugly manual edits:
  ant = World_cyl$geometry[World_cyl$name == "Antarctica"]
  ant[[1]][[4]][[1]] = rbind(ant[[1]][[4]][[1]][1:262,], cbind(seq(11243268.38,-8794239.62, length.out = 30), rep(-20037508, 30)), ant[[1]][[4]][[1]][265:307,]) # add intermediate points to make the bottom curve (otherwise it would be a straight line)
  World_cyl$geometry[World_cyl$name == "Antarctica"] = ant
  # zaf = World_cyl$geometry[World_cyl$iso_a3 == "ZAF"]
  # zaf[[1]][[1]] = zaf[[1]][[1]][1] # remove island of South-Africa, which caused problems.
  # World_cyl$geometry[World_cyl$iso_a3 == "ZAF"] = zaf
  
  
  World_cyl$geometry = st_sfc(lapply(World_cyl$geometry, function(g) {
    st_multipolygon(lapply(g, function(gi) {
      gi[[1]] = get_cylinder(gi[[1]], lon_center = lon_center)
      gi
    }))
  }), crs = 3857)
  
  bg_front = tmaptools::bb_poly(c(-10018754,-ymax, 10018754,ymax), projection = 3857)
  bg_back = tmaptools::bb_poly(c(-20037508,-ymax,20037508,ymax), projection = 3857)
  
  bg_front[[1]][[1]] = get_cylinder(bg_front[[1]][[1]], lon_center = 0)
  bg_back[[1]][[1]] = get_cylinder(bg_back[[1]][[1]], lon_center = 0)
  
  grat = sf::st_graticule(x = sf::st_bbox(c(xmin = -10018754 + lon_center, ymin = -ymax, xmax = 10018754 + lon_center, ymax = ymax), crs = 3857),  crs = 3857, lon = seq(-60, 90, by = 30), lat = seq(-90, 90, by = 30))
  grat$geometry = st_sfc(lapply(grat$geometry, function(g) {
    st_linestring(get_cylinder(g, lon_center = lon_center))
  }), crs = 3857)
  
  list(bg_front = bg_front, bg_back = bg_back, land = World_cyl, grat = grat)
}


grid.arc = function(xc, yc, asp, r, direction = "bottom", gp = gpar()) {
  
  if (direction == "bottom") {
    a = seq(-pi, 0, length.out = 100)
  } else if (direction == "top") {
    a = seq(0, pi, length.out = 100)
  } else {
    a = seq(-pi, pi, length.out = 200)
  }
  
  is_poly = (length(yc) == 2)
  
  if (!is_poly) {
    x = xc + cos(a) * r
    y = yc + sin(a) * r / asp
    grid.lines(x, y, gp = gp)
  } else {
    x = c(xc + cos(a) * r, xc + cos(rev(a)) * r)
    y = c(yc[1] + sin(a) * r / asp, yc[2] + sin(a) * r / asp)
    grid.polygon(x, y, gp = gp)
  }
}

grid.cone = function(xc, yc, asp, r, direction = "bottom", gp = gpar()) {
  offset = 0.1
  if (direction == "bottom") {
    a = seq(-(1+offset)*pi, pi*offset, length.out = 100)
  } else if (direction == "top") {
    a = seq(pi*offset, pi*(1-offset), length.out = 100)
  } else {
    a = seq(-pi, pi, length.out = 200)
  }
  
  x = c(xc + cos(a) * r, xc)
  y = c(yc[1] + sin(a) * r / asp, yc[2])
  grid.polygon(x, y, gp = gp)
}



crs_types = function(col1 = "#DDDDDD", col2 = "#DDDDDD88",  col3 = "steelblue", textgp = gpar(col = "#777777", cex = 0.8)) {
  require(grid)
  
  grid.newpage()
  pushViewport(viewport(layout=grid.layout(1, 5, widths = c(.2, .2, .2, .2, .2))))
  pushViewport(viewport(layout.pos.col=1, layout.pos.row=1))
  crs_type_cylindrical(col1, col2, col3)
  grid.text("(a) Cylindrical", y = unit(1, "lines"), gp = textgp)
  upViewport()
  pushViewport(viewport(layout.pos.col=2, layout.pos.row=1))
  crs_type_conic(col1, col2, col3)
  grid.text("(b) Conic", y = unit(1, "lines"), gp = textgp)
  upViewport()
  pushViewport(viewport(layout.pos.col=3, layout.pos.row=1))
  crs_type_planar(col1, col2, col3)
  grid.text("(c) Planar", y = unit(1, "lines"), gp = textgp)
  upViewport()
  pushViewport(viewport(layout.pos.col=4, layout.pos.row=1))
  crs_type_interrupted(col1, col2, col3)
  grid.text("(d) Interrupted", y = unit(1, "lines"), gp = textgp)
  upViewport(2)

}


crs_type_cylindrical = function(col1, col2, col3) {
  vp = viewport(width = unit(1, "snpc"), height = unit(1, "snpc"))
  pushViewport(vp)
  
  dy = -.05
  
  grid.arc(0.5, dy + c(0.2, 0.8), 2.5, .26, "top", gp = gpar(fill = col1, lty = "longdash"))
  grid.circle(0.5, dy + 0.5, r = 0.25, gp = gpar(fill = col3))
  grid.arc(0.5, dy + 0.5, 2.5, .25, "bottom")
  grid.arc(0.5, dy + c(0.2, 0.8), 2.5, .26, "bottom", gp = gpar(fill = col2))
  grid.arc(0.5, dy + 0.8, 2.5, .26, "top", gp = gpar())
  upViewport()
}


crs_type_conic = function(col1, col2, col3) {
  vp = viewport(width = unit(1, "snpc"), height = unit(1, "snpc"))
  pushViewport(vp)
  
  dy = -.05
  grid.cone(0.5, dy + c(0.4, .95), 2.5, .4, "top", gp = gpar(fill = col1, lty = "longdash"))
  grid.circle(0.5, dy + 0.5, r = 0.25, gp = gpar(fill = col3))
  grid.arc(0.5, dy + 0.5, 2.5, .25, "bottom")
  grid.cone(0.5, dy + c(0.4, .95), 2.5, .4, "bottom", gp = gpar(fill = col2))
  upViewport()
}


crs_type_planar = function(col1, col2, col3) {
  vp = viewport(width = unit(1, "snpc"), height = unit(1, "snpc"))
  pushViewport(vp)
  
  dy = -.05
  
  grid.circle(0.5, dy + 0.5, r = 0.25, gp = gpar(fill = col3))
  grid.arc(0.5, dy + 0.5, 2.5, .25, "bottom")
  grid.arc(0.5, dy + c(0.72, 0.72), 2.5, .4, "both", gp = gpar(fill = col2))
  upViewport()
}

grid.faceTop = function(xc, yc, s, a, b, gp = gpar()) {
  grid.polygon(xc + c(-.5 * s - b,  -.5 * s + b, .5 * s + b, .5 * s - b, -.5 * s - b), yc + c(-a/2, a/2, a/2, -a/2, -a/2), gp = gp)
}
grid.faceSide = function(xc, yc, s, a, b, gp = gpar()) {
  grid.polygon(xc + c(-b, -b, b, b, -b), yc + c(-a/2-s/2, -a/2 + s/2, a/2 + s/2, a/2-s/2, -a/2-s/2), gp = gp)
}
grid.faceFront = function(xc, yc, s, gp = gpar()) {
  grid.polygon(xc + c(-s/2, -s/2, s/2, s/2, -s/2), yc + c(-s/2, s/2, s/2, -s/2, -s/2), gp = gp)
}

grid.arrow = function(x1, y1, x2, y2) {
  #grid.newpage()
  # vp = viewport(width = unit(1, "snpc"), height = unit(1, "snpc"))
  # pushViewport(vp)
  # grid.rect()
  # x1 = .5
  # y1 = .5
  # 
  # x2 = .25
  # y2 = .25
  
  xc = x1
  yc = y2
  
  a = seq(0, 0.5*pi, length.out = 20)
  
  x = xc + sin(a) * (x2 - x1)
  y = yc - cos(a) * (y2 - y1)

  grid.lines(x = x,
             y = y,
             gp = gpar(fill="black", lty = "longdash"),
             arrow = arrow(length = unit(0.05, "npc"), 
                           ends="last", type="closed"))
}


crs_type_interrupted = function(col1, col2, col3) {
  #grid.newpage()
  vp = viewport(width = unit(1, "snpc"), height = unit(1, "snpc"))
  pushViewport(vp)
  
  xc = 0.5
  yc = 0.5
  
  s = 0.5
  
  a = s/2.5
  b = s/3
  
  dy = -.05
  
  grid.faceTop(xc, dy + yc - s/2, s = s, a = a, b = b, gp = gpar(fill = col1))
  grid.faceTop(xc-s, dy + yc - s/2, s = s, a = a, b = b, gp = gpar(fill = col1))
  grid.faceTop(xc+s, dy + yc - s/2, s = s, a = a, b = b, gp = gpar(fill = col1))
  grid.faceTop(xc+2*s, dy + yc - s/2, s = s, a = a, b = b, gp = gpar(fill = col1))
  grid.faceTop(xc-b*2, dy + yc - s/2-a, s = s, a = a, b = b, gp = gpar(fill = col1))
  grid.faceTop(xc+b*2, dy + yc - s/2+a, s = s, a = a, b = b, gp = gpar(fill = col1))

  
  grid.faceSide(xc - s/2, dy + yc, s = s, a = a, b = b, gp = gpar(fill = col1, lty = "longdash"))
  grid.faceFront(xc + b, dy + yc + a/2, s = s, gp = gpar(fill = col1, lty = "longdash"))

  grid.arrow(xc - s/2, dy + yc + s/4, xc-s-s/4, dy + yc - s/2)
  #grid.arrow(xc + b, dy + yc + a/2 + s/4, xc+b*2.5, dy + yc - s/2+a+a/4)
  
  grid.circle(xc, dy + yc, r = s/2, gp = gpar(fill = col3))
  grid.arc(0.5, dy + 0.5, 2.5, .25, "bottom")
  
  grid.faceSide(xc + s/2, dy + yc, s = s, a = a, b = b, gp = gpar(fill = col2))
  grid.faceFront(xc - b, dy + yc - a/2, s = s, gp = gpar(fill = col2))

  
  grid.faceTop(xc, dy + yc + s/2, s = s, a = a, b = b, gp = gpar(fill = col2))
  

  
  grid.arrow(xc + s/2, dy + yc + s/4, xc+s+s/4, dy + yc - s/2)
  grid.arrow(xc - b, dy + yc - a/2 + s/4, xc-b*2.5, dy + yc - s/2-a-a/4)
  
  upViewport()
  
}














# qtm(World, projection = 3785)
# #	tm_graticules()
# 
# 
# data(World)
# World3 = st_transform(World, 3785)
# World3$scale = as.numeric(st_area(World)) / as.numeric(st_area(World3))
# 
# Wc = st_centroid(World3, of_largest_polygon = TRUE)$geometry
# World3$geometry = (World3$geometry - Wc) * World3$scale + Wc
# 
# st_crs(World3) = st_crs(3785)
# 
# 
# 	tm_shape(World3) +
# 	tm_polygons("darkorange") +
# tm_shape(World) +
# 		tm_borders(lwd = 2)
