

tf = function(x, y, w = .75, h = .33) {
  x2 = x * w + y * (1 - w)
  y2 = y * h
  list(x = x2, y = y2)
}


drawLayer = function(m, x = 0, y = 0, w = .75, h = .33, cols, border = "grey10", internal = "grey50") {
  nr = nrow(m)
  nc = ncol(m)
  n = nr * nc
  
  mx = seq(0, 1, length.out = nc + 1)[1:nc]
  my = seq(0, 1, length.out = nr + 1)[1:nr]
  
  g = as.data.frame(expand.grid(x1 = mx, y1 = my))
  g$x2 = g$x1 + 1/nc
  g$y2 = g$y1 + 1/nr
  
  xs = as.vector(rbind(g$x1, g$x2, g$x2, g$x1))
  ys = as.vector(rbind(g$y1, g$y1, g$y2, g$y2))
  
  xy = tf(xs, ys)
  grid.polygon(x = xy$x + x, y = xy$y + y, id = rep(1:n, each = 4), gp = gpar(fill = cols[m], col = internal))
  
  xy2 = tf(c(0,1,1,0), c(0,0,1,1))
  grid.polygon(x = xy2$x + x, y = xy2$y + y, gp = gpar(fill = NA, col = border))
}


stackLayers = function(k, ystep = 0.05, ...) {
  for (y in seq(0, by = ystep, length.out = k)) {
    drawLayer(y = y, ...)
  }
}


cellplot = function(row, col, width = 1, height = 1, e) {
  pushViewport(viewport(layout.pos.row = row, layout.pos.col = col))
  pushViewport(viewport(width = width, height = height))
  e
  upViewport(2)
}


draw_data_cubes = function() {
  require(stars)
  require(grid)
  
  
  tif = system.file("tif/L7_ETMs.tif", package = "stars")
  sensorA = read_stars(tif)[, 1:8, 1:8, 1:3]
  sensorB = read_stars(tif)[, 11:18, 11:18, 1:3]
  
  sensorA[[1]] = (sensorA[[1]] - min(sensorA[[1]])) / (max(sensorA[[1]]) - min(sensorA[[1]]))
  mA = cut(sensorA[[1]], breaks = seq(0, 1, by = .1), right = FALSE, include.lowest = TRUE, labels = FALSE)
  
  sensorB[[1]] = (sensorB[[1]] - min(sensorB[[1]])) / (max(sensorB[[1]]) - min(sensorB[[1]]))
  mB = cut(sensorB[[1]], breaks = seq(0, 1, by = .1), right = FALSE, include.lowest = TRUE, labels = FALSE)
  
  cols = viridisLite::magma(10, begin = 0.3, end = 1)
  
  
  
  
  grid.newpage()
  pushViewport(viewport(width = unit(2, "snpc"), height = unit(1, "snpc"))) # to make sure aspect ratio is 2
  #grid.rect(gp = gpar(fill = "grey90")) # enable to see viewports
  
  pushViewport(viewport(width = 0.9, height = 0.8))
  #grid.rect(gp = gpar(fill = "grey80")) # enable to see viewports
  
  grid2x3 = viewport(layout = grid.layout(nrow = 2, ncol = 3))
  pushViewport(grid2x3)
  
  for (b in 1:3) {
    cellplot(1, b, 0.95, 0.9, e = {
      stackLayers(5, ystep = 0.1, m = mA[,,b], cols = cols)
    })
    cellplot(2, b, 0.95, 0.9, e = {
      stackLayers(5, ystep = 0.1, m = mB[,,b], cols = cols)
    })
  }
  
  upViewport(2)
  grid.text("Band 1", x = 0.2, y = 0.05)
  grid.text("Band 2", x = 0.5, y = 0.05)
  grid.text("Band 3", x = 0.8, y = 0.05)
  grid.text("Sensor B", x = 0.98, y = 0.7, rot = -90)
  grid.text("Sensor A", x = 0.98, y = 0.3, rot = -90)
  grid.text("time", x = 0.045, y = 0.61, rot = -90, gp=gpar(cex = .75))
  grid.text("latitude", x = 0.09, y = 0.77, rot = 42, gp=gpar(cex = .75))
  grid.text("longitude", x = 0.2, y = 0.83, gp=gpar(cex = .75))

  upViewport()
}




draw_table = function(df, col_heading = "white", col_rows = "black", bg_heading = "grey40", bg_main = "white", borders = "grey40", scale = 1) {
  nrows = nrow(df) + 1
  ncols = ncol(df)
  col_rows = rep(col_rows, length.out = nrows - 1)
  
  pushViewport(viewport(layout = grid.layout(nrow = nrows, ncol = ncols)))
  
  for (i in 1:ncols) {
    cellplot(1, i, e = {
      grid.rect(gp=gpar(col = borders, lwd = scale, fill = bg_heading))
      grid.text(label = names(df)[i], gp = gpar(col = col_heading, cex = scale, lwd = scale, fontface = "bold"))
    })  
    for (j in 2:nrows) {
      cellplot(j, i, e = {
        grid.rect(gp=gpar(col = borders, lwd = scale, fill = bg_main))
        grid.text(label = df[j-1, i], gp = gpar(col = col_rows[j-1], cex = scale, lwd = scale))
      })
    }
  }
  upViewport()
}

draw_vector_data = function(scale = 1) {
  library(grid)
  library(sf)
  library(tmap)
  library(dplyr)
  
  cols = RColorBrewer::brewer.pal(3, "Dark2")
  
  sf_pnts = st_sf(ID = 1:3, name = c("City A", "City B", "City C"), population = c(400, 100, 800), beautiful = c(FALSE, TRUE, TRUE), cols = cols,
                  geometry = st_sfc(st_point(c(2, 7)),
                                    st_point(c(9, 5)),
                                    st_point(c(6, 3))), crs = 4326)
  
  sf_lns = st_sf(ID = 1:3, name = c("Road A", "Road B", "Road C"), lanes = c(4, 3, 2), cycling = c(FALSE, TRUE, TRUE), cols = cols,
                 geometry = st_sfc(st_linestring(rbind(c(3,8),
                                                       c(6,7),
                                                       c(8,6))),
                                   st_linestring(rbind(c(5,5),
                                                       c(9,4),
                                                       c(11.5,6))),
                                   st_linestring(rbind(c(1,3),
                                                       c(6,2),
                                                       c(10,1),
                                                       c(11,3)))), crs = 4326)
  sf_lns_pnts = sf_lns
  sf_lns_pnts$geometry = st_cast(sf_lns_pnts$geometry, "MULTIPOINT")
  
  
  sf_plg = st_sf(ID = 1:3, name = c("County A", "County B", "County C"), population = c(1000, 500, 900), beautiful = c(TRUE, TRUE, TRUE), cols = cols,
                 geometry = st_sfc(st_polygon(list(rbind(c(3,8),
                                                         c(4.5,9.5),
                                                         c(5,7),
                                                         c(4,6),
                                                         c(3,8)))),
                                   st_polygon(list(rbind(c(7,5),
                                                         c(9,4),
                                                         c(11.5,6),
                                                         c(9,9),
                                                         c(7,5)))),
                                   st_polygon(list(rbind(c(5,4),
                                                         c(6,2),
                                                         c(10,1),
                                                         c(11,3),
                                                         c(5,4))))), crs = 4326)
  
  sf_plg_pnts = sf_plg
  sf_plg_pnts$geometry = st_cast(sf_plg_pnts$geometry, "MULTIPOINT")
  
  grid.newpage()
  pushViewport(viewport(width = unit(1,"snpc"), height = unit(1,"snpc"))) # to make sure asp ratio is 1
  grid.rect(gp=gpar(fill="grey95", col = "grey30", lwd = scale))
  pushViewport(viewport(layout = grid.layout(nrow = 7, ncol = 5, widths = c(0.05, 0.3, 0.05, 0.55, 0.05), heights = c(0.076, 0.232, 0.076, 0.232, 0.076, 0.232, 0.076))))
  
  print({
    tm_shape(sf_pnts, bbox = c(0, 0, 12.931, 10)) +
      tm_dots(size = 0.2, col = "cols") +
      tm_text("ID", xmod = .5, ymod = .5) +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
  
  print({
    tm_shape(sf_lns, bbox = c(0, 0, 12.931, 10)) +
      tm_lines(lwd = 2, col = "cols") +
      tm_text("ID", xmod = .5, ymod = c(.5, 1, .5)) +
      tm_shape(sf_lns_pnts) + 
      tm_dots(size = 0.2, col = "cols") +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 4, layout.pos.col = 2))
  
  print({
    tm_shape(sf_plg, bbox = c(0, 0, 12.931, 10)) +
      tm_polygons(lwd = 2, col = "cols", border.col = "grey30") +
      tm_text("ID", col = "white") +
      tm_shape(sf_plg_pnts) + 
      tm_dots(size = 0.2, col = "grey30") +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 6, layout.pos.col = 2))
  
  cellplot(2, 4, e = {
    draw_table(sf_pnts %>% st_drop_geometry() %>% select(ID, name, population, beautiful), col_rows = cols, scale = scale)
  })
  
  cellplot(4, 4, e = {
    draw_table(sf_lns %>% st_drop_geometry() %>% select(ID, name, lanes, cycling), col_rows = cols, scale = scale)
  })
  
  cellplot(6, 4, e = {
    draw_table(sf_plg %>% st_drop_geometry() %>% select(ID, name, population, beautiful), col_rows = cols, scale = scale)
  })
  
  cellplot(1, 4, e = {
    grid.text("Example attributes for point data", y = .4, gp=gpar(cex = 1.25 * scale, col = "grey30"))
  })
  
  cellplot(3, 4, e = {
    grid.text("Example attributes for line data", y = .4, gp=gpar(cex = 1.25 * scale, col = "grey30"))
  })
  
  cellplot(5, 4, e = {
    grid.text("Example attributes for polygon data", y = .4, gp=gpar(cex = 1.25 * scale, col = "grey30"))
  })
  upViewport(2)
}


draw_vector_cubes = function() {
  # NOTE: data values do not correspond with reality, e.g. some provinces should have much higher values for "urban". Either we should use non-informative category labels like "A", "B", etc., or real land use data.
  
  library(grid)
  library(sf)
  library(stars)
  library(tmap)
  
  data(NLD_prov)
  
  tif = system.file("tif/L7_ETMs.tif", package = "stars")
  sensorA = read_stars(tif)[, 1:12, 1:5, 1]
  sensorA[[1]] = (sensorA[[1]] - min(sensorA[[1]])) / (max(sensorA[[1]]) - min(sensorA[[1]]))
  
  m = cut(sensorA[[1]], breaks = seq(0, 1, by = .1), right = FALSE, include.lowest = TRUE, labels = FALSE)[,,1]
  cols = viridisLite::magma(10, begin = 0.3, end = 1)
  
  
  grid.newpage()
  pushViewport(viewport(width = unit(1.5, "snpc"), height = unit(1, "snpc")))
  #grid.rect(gp = gpar(fill = "grey90"))
  pushViewport(viewport(width = .7, height = .6, y = .4, x = .6))
  #grid.rect()
  stackLayers(k = 8, m = m, cols = cols)
  upViewport()
  
  
  mapWidth = .3
  mapHeight = .5
  mapX = .2
  mapY = .7
  
  print({
    tm_shape(NLD_prov) +
      tm_polygons(col = "grey95") +
      tm_layout(inner.margins = 0, outer.margins = 0, frame = FALSE)
  }, vp = viewport(width = mapWidth, height = mapHeight, x = mapX, y = mapY))
  
  # calculate centroid of provinces in [0, 1] range (inside viewport)
  co = st_coordinates(st_centroid(NLD_prov))[,1:2]
  bb = st_bbox(NLD_prov)
  cx = (co[,1] - bb[1]) / (bb[3] - bb[1])
  cy = (co[,2] - bb[2]) / (bb[4] - bb[2])
  
  # transform coordinates to outside viewport
  cx2 = cx * mapWidth + mapX - mapWidth/2
  cy2 = cy * mapHeight + mapY - mapHeight/2
  
  co2 = cbind(cx2, cy2)
  # grid.points(x = unit(cx2, "npc"), y = unit(cy2, "npc"))
  
  
  # grid.points(x = unit(c(.25, .42), "npc"), y = unit(c(.32, .5), "npc"))
  co3 = cbind(seq(.41, .25, length.out = 12),
              seq(.5, .32, length.out = 12))
  # grid.points(co3[,1], co3[,2])
  
  xall = as.vector(rbind(co2[,1], co3[,1]))
  yall = as.vector(rbind(co2[,2], co3[,2]))
  
  grid.polyline(x = xall, y = yall, id = rep(1:12, each = 2), gp = gpar(col = "grey30"))
  grid.text(c("urban", "forest", "crops", "grass", "water"), x = unit(seq(.47, .90, length.out = 5),"npc"), y = unit(.55,"npc"), gp = gpar(col = "grey30"))
  
}

