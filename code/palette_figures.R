# aspect ratio 3/2
plot_palette_types = function(y) {
  library(grid)
  
  grid.newpage()
  
  pushViewport(viewport(width = unit(3/2, "snpc"), height = unit(1, "snpc")))
  #grid.rect()
  pushViewport(viewport(layout = grid.layout(nrow = 11, ncol = 2, widths = c(3/10, 7/10), heights = c(10, 5, 10, 12.5, 10, 5, 10, 12.5, 10, 5, 10) / 100)))
  
  rows = c(1, 5, 9)
  
  for (i in 1:3) {
    # text
    pushViewport(viewport(layout.pos.col = 1, layout.pos.row = rows[i]))
    grid.text(names(y)[i])
    popViewport()
    
    # palettes
    pals = y[[i]]
    pushViewport(viewport(layout.pos.col = 2, layout.pos.row = rows[i]))
    grid.rect(x = seq(1/14, 13/14, by = 1/7), width = 1/7, gp = gpar(fill = pals[[1]]))
    popViewport()

    pushViewport(viewport(layout.pos.col = 2, layout.pos.row = rows[i] + 2))
    grid.rect(x = seq(1/14, 13/14, by = 1/7), width = 1/7, gp = gpar(fill = pals[[2]]))
    popViewport()
    
  }
  popViewport(2)
}
