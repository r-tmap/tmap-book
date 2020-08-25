

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
  grid.polygon(x = xy$x + x, y = xy$y + y, id = rep(1:n, each = 4), gp = gpar(fill = cols[t(m[nr:1,])], col = internal))
  
  xy2 = tf(c(0,1,1,0), c(0,0,1,1))
  grid.polygon(x = xy2$x + x, y = xy2$y + y, gp = gpar(fill = NA, col = border))
}


stackLayers = function(k, ml, ystep = 0.05, ...) {
  ys = seq(0, by = ystep, length.out = k)

  for (i in 1:k) {
    y = ys[i]
    m = ml[[i]]
    drawLayer(y = y, m = m, ...)
  }
}


cellplot = function(row, col, width = 1, height = 1, e) {
  pushViewport(viewport(layout.pos.row = row, layout.pos.col = col))
  pushViewport(viewport(width = width, height = height))
  e
  upViewport(2)
}

logit = function(x, a = 1, b = 0.5) {
  1 / (1 + exp(-a * (x - b)))
}


draw_data_cubes = function() {
  require(stars)
  require(grid)
  
  
  tif = system.file("tif/L7_ETMs.tif", package = "stars")
  sensorA = read_stars(tif)[, 1:8, 1:8, 1:3]
  sensorB = read_stars(tif)[, 11:18, 11:18, 1:3]
  
  sensorA[[1]] = (sensorA[[1]] - min(sensorA[[1]])) / (max(sensorA[[1]]) - min(sensorA[[1]]))
  sensorB[[1]] = (sensorB[[1]] - min(sensorB[[1]])) / (max(sensorB[[1]]) - min(sensorB[[1]]))
  
  mA = sensorA[[1]]
  mB = sensorB[[1]]
  
  k = 5
  
  mlist = lapply(seq(0, 1, length.out = k), function(i) {
    m = logit(i, a = 7) * mA + (1 - logit(i, a = 7)) * mB
    cut(m, breaks = seq(0, 1, by = .1), right = FALSE, include.lowest = TRUE, labels = FALSE)
  })
  
  
  cols = viridisLite::magma(10, begin = 0.3, end = 1)
  
  grid.newpage()
  pushViewport(viewport(width = unit(4, "snpc"), height = unit(1, "snpc"))) # to make sure aspect ratio is 4
  #grid.rect(gp = gpar(fill = "grey90")) # enable to see viewports
  
  pushViewport(viewport(width = 0.9, height = 0.8))
  #grid.rect(gp = gpar(fill = "grey80")) # enable to see viewports
  
  grid1x3 = viewport(layout = grid.layout(nrow = 1, ncol = 3))
  pushViewport(grid1x3)
  
  for (b in 1:3) {
    mlb = lapply(mlist, function(m) {
      m[,,b]
    })
    cellplot(1, b, 0.95, 0.9, e = {
      stackLayers(5, ystep = 0.1, ml = mlb, cols = cols)
    })
  }
  
  upViewport(2)
  grid.text("Attribute 1", x = 0.2, y = 0.05)
  grid.text("Attribute 2", x = 0.5, y = 0.05)
  grid.text("Attribute 3", x = 0.8, y = 0.05)
  grid.text("time", x = 0.045, y = 0.3, rot = -90, gp=gpar(cex = .75))
  grid.text("latitude", x = 0.09, y = 0.62, rot = 41, gp=gpar(cex = .75))
  grid.text("longitude", x = 0.2, y = 0.75, gp=gpar(cex = .75))

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
  
  sf_pnts = st_sf(ID = 1:2, name = c("Broadleaf", "Conifer"), has = c("Leaves", "Needles"), evergreen = c(FALSE, TRUE), cols = cols[1:2],
                  geometry = st_sfc(st_multipoint(rbind(c(2, 7), c(6, 3.5), c(6, 8))),
                                    st_multipoint(rbind(c(9, 4), c(4, 2), c(11, 6), c(10, 7.5))), crs = 4326))
  
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
  
  
  sf_plg = st_sf(ID = 1:2, name = c("Country A", "Country B"), population = c(1000, 500), touristic = c(FALSE, TRUE), cols = cols[1:2],
                 geometry = st_sfc(st_multipolygon(list(list(rbind(c(1, 9),
                                                         c(6, 9),
                                                         c(5, 5),
                                                         c(3.5, 4.5),
                                                         c(1, 4.5),
                                                         c(1, 9))))),
                                   st_multipolygon(list(list(rbind(c(5, 5),
                                                         c(6,9),
                                                         c(9, 8.5),
                                                         c(8, 5.5),
                                                         c(5,5))),
                                                   list(rbind(c(10, 4.25),
                                                              c(11,5),
                                                              c(11.5, 3),
                                                              c(8, 2.75),
                                                              c(8, 3.5),
                                                              c(10, 4.25)))))), crs = 4326)
  
  sf_plg_pnts = sf_plg
  sf_plg_pnts$geometry = st_cast(sf_plg_pnts$geometry, "MULTIPOINT")
  
  grid.newpage()
  pushViewport(viewport(width = unit(1,"snpc"), height = unit(1,"snpc"))) # to make sure asp ratio is 1
  grid.rect(gp=gpar(fill="grey95", col = "grey30", lwd = scale))
  #pushViewport(viewport(layout = grid.layout(nrow = 7, ncol = 5, widths = c(0.05, 0.3, 0.05, 0.55, 0.05), heights = c(0.076, 0.232, 0.076, 0.232, 0.076, 0.232, 0.076))))
  pushViewport(viewport(layout = grid.layout(nrow = 10, ncol = 5, widths = c(0.05, 0.3, 0.05, 0.55, 0.05), heights = c(0.076, 0.174, 0.058, 0.076, 0.174, 0.058, 0.076, 0.174, 0.058, 0.076))))
  
  print({
    tm_shape(sf_pnts, bbox = c(0, 0, 12.931, 10)) +
      tm_dots(size = 0.2, col = "cols") +
      tm_text("ID", xmod = .5, ymod = .5) +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 2:3, layout.pos.col = 2))
  
  print({
    tm_shape(sf_lns, bbox = c(0, 0, 12.931, 10)) +
      tm_lines(lwd = 2, col = "cols") +
      tm_text("ID", xmod = .5, ymod = c(.5, 1, .5)) +
      tm_shape(sf_lns_pnts) + 
      tm_dots(size = 0.2, col = "cols") +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 5:6, layout.pos.col = 2))
  
  print({
    tm_shape(sf_plg, bbox = c(0, 0, 12.931, 10), point.per = "segment") +
      tm_polygons(lwd = 2, col = "cols", border.col = "grey30") +
      tm_text("ID", col = "white") +
      tm_shape(sf_plg_pnts) + 
      tm_dots(size = 0.2, col = "grey30") +
      tm_layout(scale = scale, inner.margins = 0, outer.margins = 0)
  }, vp = viewport(layout.pos.row = 8:9, layout.pos.col = 2))
  
  cellplot(2, 4, e = {
    draw_table(sf_pnts %>% st_drop_geometry() %>% select(ID, name, has, evergreen), col_rows = cols, scale = scale)
  })
  
  cellplot(5:6, 4, e = {
    draw_table(sf_lns %>% st_drop_geometry() %>% select(ID, name, lanes, cycling), col_rows = cols, scale = scale)
  })
  
  cellplot(8, 4, e = {
    draw_table(sf_plg %>% st_drop_geometry() %>% select(ID, name, population, touristic), col_rows = cols, scale = scale)
  })
  
  cellplot(1, 4, e = {
    grid.text("Example attributes for point data", y = .4, gp=gpar(cex = 1.25 * scale, col = "grey30"))
  })
  
  cellplot(4, 4, e = {
    grid.text("Example attributes for line data", y = .4, gp=gpar(cex = 1.25 * scale, col = "grey30"))
  })
  
  cellplot(7, 4, e = {
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
  library(dplyr)
  library(tidyr)
  
  data(NLD_prov)
  
  
  lu = read.csv("data/lan_use_ovw.tsv", sep = "\t", na.strings = ": ") %>% 
    rename(cat = 1) %>% 
    {suppressWarnings(separate(., cat, into = c("unit", "landuse", "geo")))} %>% 
    filter(geo %in% paste0("NL", c(11:13, 21:23, 31:34, 41,42)),
           unit == "PC",
           landuse %in% c("LUA", "LUB", "LUC", "LUD", "LUE", "LUF")) %>% 
    mutate(x1 = ifelse(is.na(X2009), ifelse(is.na(X2012), X2015, X2012), X2009)) %>% 
    mutate(x2 = ifelse(is.na(X2015), ifelse(is.na(X2012), X2009, X2012), X2015)) %>% 
    mutate(x1 = as.numeric(gsub("u", "", x1, fixed = TRUE)),
           x2 = as.numeric(gsub("u", "", x2, fixed = TRUE))) %>% 
    mutate(landuse2 =  case_when(landuse %in% "LUA" ~ "Crops",
                                 landuse %in% "LUB" ~ "Forest",
                                 landuse %in% "LUC" ~ "Water",
                                 TRUE ~ "Urban"),
           name = case_when(geo == "NL11" ~ "Groningen",
                            geo == "NL12" ~ "Friesland",
                            geo == "NL13" ~ "Drenthe",
                            geo == "NL21" ~ "Overijssel",
                            geo == "NL22" ~ "Gelderland",
                            geo == "NL23" ~ "Flevoland",
                            geo == "NL31" ~ "Utrecht",
                            geo == "NL32" ~ "Noord-Holland",
                            geo == "NL33" ~ "Zuid-Holland",
                            geo == "NL34" ~ "Zeeland",
                            geo == "NL41" ~ "Noord-Brabant",
                            geo == "NL42" ~ "Limburg")) %>% 
    group_by(name, landuse2) %>% 
    summarize(x1 = sum(x1),
              x2 = sum(x2))
  
  lu1 = lu %>% 
    pivot_wider(id = name, names_from = landuse2, values_from = x1) %>% 
    replace_na(list(Water = 0)) %>% 
    mutate(Urban = 100 - Crops - Forest - Water) %>% 
    arrange(match(name, NLD_prov$name)) %>% 
    ungroup() %>% 
    mutate(name = NULL) %>% 
    select(Urban, Crops, Forest, Water) %>% 
    as.matrix()
    
  lu2 = lu %>% 
    pivot_wider(id = name, names_from = landuse2, values_from = x2) %>% 
    replace_na(list(Water = 0)) %>% 
    mutate(Urban = 100 - Crops - Forest - Water) %>% 
    arrange(match(name, NLD_prov$name)) %>% 
    ungroup() %>% 
    mutate(name = NULL) %>% 
    select(Urban, Crops, Forest, Water) %>% 
    as.matrix()
  
  k = 8
  
  o = c(1, 3, 4, 2, 6, 5, 12, 8, 7, 11, 9, 10)
  brks = classInt::classIntervals(c(as.numeric(lu1), as.numeric(lu2)), style = "kmeans", n= 10)$brks
  
  
  mlist = lapply(seq(0, 1, length.out = k), function(i) {
    m = (1- logit(i, a = 7)) * lu1 + logit(i, a = 7) * lu2
    cut(m, breaks = brks, right = FALSE, include.lowest = TRUE, labels = FALSE)[o, ]
  })
  
  cols = viridisLite::magma(10, begin = 0.3, end = 1)
  
  
  grid.newpage()
  pushViewport(viewport(width = unit(1.65, "snpc"), height = unit(1, "snpc")))
  #grid.rect(gp = gpar(fill = "grey90"))
  pushViewport(viewport(width = .7, height = .66, y = .35, x = .55))
  #grid.rect()
  stackLayers(k = k, ml = mlist, cols = cols)
  upViewport()
  
  
  mapWidth = .3 * 1.1
  mapHeight = .5 * 1.1
  mapX = .15
  mapY = .72
  
  print({
    tm_shape(NLD_prov) +
      tm_polygons(col = "grey95") +
      tm_layout(inner.margins = 0, outer.margins = 0, frame = FALSE)
  }, vp = viewport(width = mapWidth, height = mapHeight, x = mapX, y = mapY))
  
  # calculate centroid of provinces in [0, 1] range (inside viewport)
  co = st_coordinates(st_centroid(NLD_prov))[o,1:2]
  bb = st_bbox(NLD_prov)
  cx = (co[,1] - bb[1]) / (bb[3] - bb[1])
  cy = (co[,2] - bb[2]) / (bb[4] - bb[2])
  
  # transform coordinates to outside viewport
  cx2 = cx * mapWidth + mapX - mapWidth/2
  cy2 = cy * mapHeight + mapY - mapHeight/2
  
  co2 = cbind(cx2, cy2)
  # grid.points(x = unit(cx2, "npc"), y = unit(cy2, "npc"))
  
  
  # grid.points(x = unit(c(.25, .42), "npc"), y = unit(c(.32, .5), "npc"))
  co3 = cbind(seq(.36, .2, length.out = 12),
              seq(.47, .26, length.out = 12))
  # grid.points(co3[,1], co3[,2])
  
  xall = as.vector(rbind(co2[,1], co3[,1]))
  yall = as.vector(rbind(co2[,2], co3[,2]))
  
  grid.polyline(x = xall, y = yall, id = rep(1:12, each = 2), gp = gpar(col = "grey30"))
  grid.text(c("urban", "crops", "forest", "water"), x = unit(seq(.42, .85, length.out = 4),"npc"), y = unit(.52,"npc"), gp = gpar(col = "grey30"))
  grid.text("year", x = unit(.95,"npc"), y = unit(.35,"npc"), gp = gpar(col = "grey30"))
}
