map_orange_world = function() {
  if (file.exists("images/orange.png")) {
    World2 = World
    World2$geometry[World$iso_a3 == "USA"] = st_cast(World$geometry[World$iso_a3 == "USA"], "POLYGON")[6]
    ortho_crs = st_crs("+proj=ortho +lon_0=11 +lat_0=46")
    World_ortho = st_transform(World2, crs = ortho_crs)
    World_ortho <- st_make_valid(World_ortho)
    
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
            tm_graticules(x = seq(-180, 150, by = 30), y = seq(-90, 90, by = 30), labels.show = FALSE, lwd = 2) +
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
  
  print("test123")
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
