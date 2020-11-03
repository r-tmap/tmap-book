visual_variables = function() {
  library(tmap)
  library(grid)
  
  data(World, rivers, metro, land)
  
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
  
  rivers$x = runif(nrow(rivers), 0, num_max)
  rivers$y = rep(categories, length.out = nrow(rivers))
  
  metro$x = runif(nrow(metro), 0, num_max)
  metro$y = rep(categories, length.out = nrow(metro))
  
  tml = tm_layout(legend.only = TRUE, legend.text.size = tmap_label_size)
  lf = list(scientific = TRUE, format = "f")
  
  x11 = tm_shape(metro) + tm_dots("y", size = tmap_data_size, palette = cat_palette, title = "", legend.is.portrait = FALSE, legend.format = lf) + tml
  x12 = tm_shape(metro) + tm_dots("x", size = tmap_data_size, style = "pretty", title = "", legend.is.portrait = FALSE, legend.format = lf) + tml
  
  x13 = tm_shape(metro) + tm_symbols(size = "x", scale = 1.5, sizes.legend = sizes_legend, sizes.legend.labels = make_wider(sizes_legend, 2),  title.size = "", legend.size.is.portrait = FALSE, legend.format = lf) + tml
  x14 = tm_shape(metro) + tm_symbols(shape = "y", size = tmap_data_size, title.shape = "", legend.shape.is.portrait = FALSE, legend.format = lf) + tml

  x21 = tm_shape(rivers) + tm_lines(col = "y", lwd = tmap_data_lwd, palette = cat_palette, title.col = "", legend.col.is.portrait = FALSE, legend.format = lf) + tml
  x22 = tm_shape(rivers) + tm_lines(col = "x", lwd = tmap_data_lwd, style = "pretty", title.col = "", legend.col.is.portrait = FALSE, legend.format = lf) + tml
  
  x23 = tm_shape(rivers) + tm_lines(lwd = "x", scale = tmap_data_lwd * 1.5, lwd.legend = sizes_legend, lwd.legend.labels = make_wider(sizes_legend, 2), title.lwd = "", legend.lwd.is.portrait = FALSE, legend.format = lf) + tml
  
  x31 = tm_shape(World) + tm_polygons("y", palette = cat_palette, title = "", legend.is.portrait = FALSE, legend.format = lf) + tml
  x32 = tm_shape(World) + tm_polygons("x", style = "pretty", title = "", legend.is.portrait = FALSE, legend.format = lf) + tml
  
  
  cellplot = function(row, col, e) {
    pushViewport(viewport(layout.pos.row = row, layout.pos.col = col))
    e
    upViewport(1)
  }
  
  
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