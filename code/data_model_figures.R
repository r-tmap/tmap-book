

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

# nr = 5
# nc = 4
# 
# n = nr * nc
# 
# m = matrix(1:n, nrow = nr, ncol = nc)
# 

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




