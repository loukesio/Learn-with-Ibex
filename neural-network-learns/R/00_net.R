# A tiny neural network in base R: 2 inputs -> 16 hidden (tanh) -> 1 output (sigmoid), binary cross-entropy,
# mini-batch gradient descent. No packages, so every number on the slides comes from code you can read in a minute.
source("R/theme_seq.R")
library(dplyr)

make_moons <- function(n = 200, noise = 0.18, seed = 1) {        # the toy data set: two interleaving half-moons
  set.seed(seed); t <- runif(n, 0, pi); cls <- rep(0:1, length.out = n)
  x <- ifelse(cls == 0, cos(t), 1 - cos(t)) + rnorm(n, 0, noise)
  y <- ifelse(cls == 0, sin(t), 0.5 - sin(t)) + rnorm(n, 0, noise)
  data.frame(x1 = x, x2 = y, y = cls)
}

init_net <- function(hidden = 16, seed = 42) {
  set.seed(seed)
  list(W1 = matrix(rnorm(2 * hidden, 0, 0.5), 2, hidden), b1 = rep(0, hidden),
       W2 = matrix(rnorm(hidden, 0, 0.5), hidden, 1),      b2 = 0)
}
sigmoid <- function(z) 1 / (1 + exp(-z))

forward <- function(net, X) {                                    # forward pass: inputs -> hidden -> probability
  H <- tanh(sweep(X %*% net$W1, 2, net$b1, "+"))
  p <- sigmoid(H %*% net$W2 + net$b2)
  list(H = H, p = as.vector(p))
}
bce <- function(p, y) -mean(y * log(p + 1e-9) + (1 - y) * log(1 - p + 1e-9))   # the loss: how wrong, on average

backward <- function(net, X, y, fw) {                            # backpropagation: gradient of the loss for every weight
  n <- nrow(X); dz2 <- matrix(fw$p - y, n, 1) / n                # derivative of BCE+sigmoid is simply p - y
  gW2 <- t(fw$H) %*% dz2; gb2 <- sum(dz2)
  dH <- dz2 %*% t(net$W2) * (1 - fw$H^2)                        # through tanh
  list(W1 = t(X) %*% dH, b1 = colSums(dH), W2 = gW2, b2 = gb2)
}

train <- function(train_df, val_df, hidden = 16, lr = 0.5, epochs = 60, batch = 20, seed = 42) {
  net <- init_net(hidden, seed); Xtr <- as.matrix(train_df[, 1:2]); ytr <- train_df$y
  Xva <- as.matrix(val_df[, 1:2]); yva <- val_df$y
  hist <- data.frame(); snaps <- list()
  for (e in 0:epochs) {
    if (e > 0) {
      idx <- sample(nrow(Xtr))                                   # shuffle, then one pass over the data = one epoch
      for (b in split(idx, ceiling(seq_along(idx) / batch))) {    # one mini-batch = one weight update (an iteration)
        fw <- forward(net, Xtr[b, , drop = FALSE]); g <- backward(net, Xtr[b, , drop = FALSE], ytr[b], fw)
        for (k in names(net)) net[[k]] <- net[[k]] - lr * g[[k]]  # the learning rate scales every step
      }
    }
    ptr <- forward(net, Xtr)$p; pva <- forward(net, Xva)$p
    hist <- rbind(hist, data.frame(epoch = e, train_loss = bce(ptr, ytr), val_loss = bce(pva, yva),
                                   train_acc = mean((ptr > 0.5) == ytr), val_acc = mean((pva > 0.5) == yva)))
    snaps[[e + 1]] <- net
  }
  list(net = net, hist = hist, snaps = snaps)
}

grid_probs <- function(net, lim = c(-1.6, 2.6, -1.3, 1.8), n = 120) {   # probability surface for the decision boundary plots
  g <- expand.grid(x1 = seq(lim[1], lim[2], length.out = n), x2 = seq(lim[3], lim[4], length.out = n))
  g$p <- forward(net, as.matrix(g))$p; g
}

boundary_plot <- function(net, df, title = NULL, subtitle = NULL) {
  g <- grid_probs(net)
  ggplot() +
    geom_raster(data = g, aes(x1, x2, fill = p), interpolate = TRUE) +
    geom_contour(data = g, aes(x1, x2, z = p), breaks = 0.5, colour = ibex$black, linewidth = 0.8) +
    geom_point(data = df, aes(x1, x2, colour = factor(y)), size = 1.8, stroke = 0.4, shape = 21, fill = "white") +
    scale_fill_gradient2(low = ibex$teal, mid = "white", high = ibex$pink, midpoint = 0.5, limits = c(0, 1), guide = "none") +
    scale_colour_manual(values = c(`0` = ibex$teal, `1` = ibex$pink), labels = c("class A", "class B")) +
    coord_fixed(expand = FALSE) + labs(x = "feature 1", y = "feature 2", title = title, subtitle = subtitle) +
    theme_seq() + theme(panel.grid = element_blank(), legend.position = "top",
                        plot.title = element_text(face = "bold", size = rel(1)), plot.subtitle = element_text(colour = "#555555", size = rel(0.85)))
}

# shared data for every script: 200 training, 100 validation, 100 test points
train_df <- make_moons(200, seed = 1); val_df <- make_moons(100, seed = 2); test_df <- make_moons(100, seed = 3)
