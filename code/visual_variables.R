visual_variables = function() {
  library(tmap)
  library(grid)
  
  data(World, World_rivers, metro, land)
  
  # adds heading and trailing spaces to make legend labels wider
  make_wider = function(x, n = 5) paste0(paste(rep(" ", n), collapse = ""), x, paste(rep(" ", n), collapse = ""))
  
  categories = make_wider(LETTERS[1:5], 3)
  num_max = 10
  sizes_legend = seq(2,10, by = 2)
  tmap_label_size = 0.7
  tmap_data_size = 2
  tmap_data_lwd = 4
  label_size = 0.9
  cat_palette = "Dark2"
  
  
  World$x = runif(nrow(World), 0, num_max)
  World$y = rep(categories, length.out = nrow(World))
  
  World_rivers$x = runif(nrow(World_rivers), 0, num_max)
  World_rivers$y = rep(categories, length.out = nrow(World_rivers))
  
  metro$x = runif(nrow(metro), 0, num_max)
  metro$y = rep(categories, length.out = nrow(metro))
  
  tml = tm_layout(legend.only = TRUE, legend.text.size = tmap_label_size)
  lf = list(scientific = TRUE, format = "f")
  
  x11 = tm_shape(metro) + tm_dots(fill = "y",
                                  fill.scale = tm_scale(values = cat_palette,
                                                        label.format = lf),
                                  fill.legend = tm_legend(orientation = "landscape",
                                                          title = ""),
                                  size = tmap_data_size) + tml
  x12 = tm_shape(metro) + tm_dots(fill = "x",
                                  fill.scale = tm_scale(label.format = lf),
                                  fill.legend = tm_legend(orientation = "landscape",
                                                          title = ""),
                                  size = tmap_data_size) + tml
  
  x13 = tm_shape(metro) + tm_symbols(size = "x", 
                                     size.scale = tm_scale(label.format = lf),
                                     size.legend = tm_legend(orientation = "landscape",
                                                             title = "")) + tml
  
  x14 = tm_shape(metro) + tm_symbols(shape = "y",
                                     shape.scale = tm_scale(label.format = lf),
                                     shape.legend = tm_legend(orientation = "landscape",
                                                             title = ""),
                                     size = tmap_data_size) + tml
  
  x21 = tm_shape(World_rivers) + tm_lines(col = "y",
                                          col.scale = tm_scale(values = cat_palette,
                                                               label.format = lf),
                                          col.legend = tm_legend(orientation = "landscape",
                                                                title = ""),
                                          lwd = tmap_data_lwd) + tml

  x22 = tm_shape(World_rivers) + tm_lines(col = "x",
                                          col.scale = tm_scale(label.format = lf),
                                          col.legend = tm_legend(orientation = "landscape",
                                                                title = ""),
                                          lwd = tmap_data_lwd) + tml

  x23 = tm_shape(World_rivers) + tm_lines(lwd = "x",
                                          lwd.scale = tm_scale(label.format = lf,
                                                               values.scale = tmap_data_lwd * 1.5),
                                          lwd.legend = tm_legend(orientation = "landscape",
                                                                title = "")) + tml
  
  x31 = tm_shape(World) + tm_polygons(fill = "y",
                                      fill.scale = tm_scale(values = cat_palette,
                                                           label.format = lf),
                                      fill.legend = tm_legend(orientation = "landscape",
                                                              title = "")) + tml
  
  x32 = tm_shape(World) + tm_polygons(fill = "x",
                                      fill.scale = tm_scale(label.format = lf),
                                      fill.legend = tm_legend(orientation = "landscape",
                                                              title = "")) + tml
  
  cellplot = function(row, col, e) {
    pushViewport(viewport(layout.pos.row = row, layout.pos.col = col))
    e
    upViewport(1)
  }
  
  # tmap_options(component.autoscale = FALSE)
  
  grid.newpage()
  
  pushViewport(viewport(width = unit(2, "snpc"), height = unit(1, "snpc"))) # to make sure aspect ratio is 1.5
  #grid.rect(gp = gpar(fill = "grey90")) # enable to see viewports
  
  
  pushViewport(viewport(layout = grid.layout(nrow = 5, ncol = 4)))
  
  print(x11, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
  print(x12, vp = viewport(layout.pos.row = 3, layout.pos.col = 2))
  print(x13, vp = viewport(layout.pos.row = 4, layout.pos.col = 2))
  print(x14, vp = viewport(layout.pos.row = 5, layout.pos.col = 2))
  print(x21, vp = viewport(layout.pos.row = 2, layout.pos.col = 3))
  print(x22, vp = viewport(layout.pos.row = 3, layout.pos.col = 3))
  print(x23, vp = viewport(layout.pos.row = 4, layout.pos.col = 3))
  print(x31, vp = viewport(layout.pos.row = 2, layout.pos.col = 4))
  print(x32, vp = viewport(layout.pos.row = 3, layout.pos.col = 4))
  
  cellplot(2, 1, grid.text("Categorical colors", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  cellplot(3, 1, grid.text("Sequential colors", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  cellplot(4, 1, grid.text("Size", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  cellplot(5, 1, grid.text("Shape", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  
  cellplot(1, 2, grid.text("Symbols", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  cellplot(1, 3, grid.text("Lines", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  cellplot(1, 4, grid.text("Polygons", just = "left", x = 0.1, gp = gpar(cex = label_size)))
  
}
