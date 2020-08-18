nr = 5
nc = 4

n = nr * nc

m = matrix(1:n, nrow = nr, ncol = nc)

x = seq(0, 1, length.out = nc + 1)[1:nc]
y = seq(0, 1, length.out = nr + 1)[1:nr]

g = as.data.frame(expand.grid(x1 = x, y1 = y))
g$x2 = g$x1 + 1/nc
g$y2 = g$y1 + 1/nr

xs = as.vector(rbind(g$x1, g$x2, g$x2, g$x1))
ys = as.vector(rbind(g$y1, g$y1, g$y2, g$y2))


grid.polygon(x = xs, y = ys, id = rep(1:n, each = 4), gp = gpar(fill = rainbow(n)[m]))

tf = function(x, y, w = .75, h = .33) {
  x2 = x * w + y * (1 - w)
  y2 = y * h
  list(x = x2, y = y2)
}

xy = tf(xs, ys)

grid.polygon(x = xy$x, y = xy$y, id = rep(1:n, each = 4), gp = gpar(fill = rainbow(n)[m]))
