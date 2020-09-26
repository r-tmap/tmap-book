# aspect ratio 3/2
plot_palette_types = function(y) {
  library(grid)
  
  grid.newpage()
  
  pushViewport(viewport(width = unit(3/2, "snpc"), height = unit(1, "snpc")))
  #grid.rect()
  pushViewport(viewport(layout = grid.layout(
    nrow = 14,
    ncol = 2, 
    widths = c(8.5/10, 1.5/10), 
    heights = c(10, 10, 5, 10, 2.5, 10, 10, 5, 10, 2.5, 10, 10, 5, 10) / 100
  )))
  
  rows = c(2, 7, 12)
  text_rows = rows - 1
  
  for (i in 1:3) {
    # text
    pushViewport(viewport(layout.pos.col = 1, layout.pos.row = text_rows[i]))
    grid.text(names(y)[i], x = 0, just = "left")
    popViewport()
    
    # labels
    pushViewport(viewport(layout.pos.col = 2, layout.pos.row = rows[i]))
    grid.text(names(y[[i]])[[1]], gp = gpar(col = "grey10", fontsize = 8))
    popViewport()
    
    pushViewport(viewport(layout.pos.col = 2, layout.pos.row = rows[i] + 2))
    grid.text(names(y[[i]])[[2]], gp = gpar(col = "grey10", fontsize = 8))
    popViewport()
    
    # palettes
    pals = y[[i]]
    pushViewport(viewport(layout.pos.col = 1, layout.pos.row = rows[i]))
    grid.rect(x = seq(1/14, 13/14, by = 1/7), width = 1/7, gp = gpar(fill = pals[[1]]))
    popViewport()

    pushViewport(viewport(layout.pos.col = 1, layout.pos.row = rows[i] + 2))
    grid.rect(x = seq(1/14, 13/14, by = 1/7), width = 1/7, gp = gpar(fill = pals[[2]]))
    popViewport()
    
  }
  popViewport(2)
}
