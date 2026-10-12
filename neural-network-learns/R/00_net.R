# A tiny neural network in base R: 4 inputs -> 8 hidden (tanh) -> 1 output (sigmoid), binary cross-entropy, mini-batch gradient descent.
# The task: is a DNA variant disease-causing? Four features per variant, one probability out. No packages, so every number on the
# slides comes from code you can read in a minute. The variants are simulated with a rule that mimics real genetics (rare + conserved
# + damaging = pathogenic), so the labels are known and the network has to rediscover the rule.
source("R/theme_seq.R")
library(dplyr)

FEATURES <- c(af = "allele frequency", cons = "conservation", impact = "protein impact", splice = "splice distance")

make_variants <- function(n = 200, seed = 1) {
  set.seed(seed)
  af     <- 10^runif(n, -5, -0.3)                      # how common the variant is in the population: 0.00001 … 0.5
  cons   <- runif(n)                                   # how conserved the position is across species: 0 … 1
  impact <- runif(n)                                   # predicted damage to the protein: 0 … 1
  splice <- 10^runif(n, 0, 3)                          # distance to the nearest splice site, 1 … 1000 bp
  score  <- 2.2 * cons * impact * 4 - 1.2 * (log10(af) + 3) - 0.8 * (log10(splice) - 1) + rnorm(n, 0, 0.6)
  data.frame(af = af, cons = cons, impact = impact, splice = splice, y = as.integer(score + 0.5 > 1.2))
}
standardise <- function(df, ref = df) {                 # the network sees scaled numbers: log for the two skewed features
  cbind(af = (log10(df$af) - mean(log10(ref$af))) / sd(log10(ref$af)),
        cons = (df$cons - mean(ref$cons)) / sd(ref$cons),
        impact = (df$impact - mean(ref$impact)) / sd(ref$impact),
        splice = (log10(df$splice) - mean(log10(ref$splice))) / sd(log10(ref$splice)))
}

init_net <- function(hidden = 8, seed = 42) {
  set.seed(seed)
  list(W1 = matrix(rnorm(4 * hidden, 0, 0.5), 4, hidden), b1 = rep(0, hidden),
       W2 = matrix(rnorm(hidden, 0, 0.5), hidden, 1),      b2 = 0)
}
sigmoid <- function(z) 1 / (1 + exp(-z))
forward <- function(net, X) { H <- tanh(sweep(X %*% net$W1, 2, net$b1, "+")); list(H = H, p = as.vector(sigmoid(H %*% net$W2 + net$b2))) }
bce <- function(p, y) -mean(y * log(p + 1e-9) + (1 - y) * log(1 - p + 1e-9))
backward <- function(net, X, y, fw) {
  n <- nrow(X); dz2 <- matrix(fw$p - y, n, 1) / n
  dH <- dz2 %*% t(net$W2) * (1 - fw$H^2)
  list(W1 = t(X) %*% dH, b1 = colSums(dH), W2 = t(fw$H) %*% dz2, b2 = sum(dz2))
}
train <- function(train_df, val_df, hidden = 8, lr = 0.5, epochs = 60, batch = 20, seed = 42) {
  net <- init_net(hidden, seed); Xtr <- standardise(train_df); ytr <- train_df$y; Xva <- standardise(val_df, train_df); yva <- val_df$y
  hist <- data.frame(); snaps <- list()
  for (e in 0:epochs) {
    if (e > 0) { idx <- sample(nrow(Xtr))
      for (b in split(idx, ceiling(seq_along(idx) / batch))) { fw <- forward(net, Xtr[b, , drop = FALSE]); g <- backward(net, Xtr[b, , drop = FALSE], ytr[b], fw)
        for (k in names(net)) net[[k]] <- net[[k]] - lr * g[[k]] } }
    ptr <- forward(net, Xtr)$p; pva <- forward(net, Xva)$p
    hist <- rbind(hist, data.frame(epoch = e, train_loss = bce(ptr, ytr), val_loss = bce(pva, yva), train_acc = mean((ptr > 0.5) == ytr), val_acc = mean((pva > 0.5) == yva)))
    snaps[[e + 1]] <- net
  }
  list(net = net, hist = hist, snaps = snaps)
}

# 2-D view for the plots: allele frequency across, conservation up; protein impact and splice distance held at their medians
grid_probs <- function(net, ref, n = 120) {
  g <- expand.grid(af = 10^seq(-5, -0.3, length.out = n), cons = seq(0, 1, length.out = n))
  g$impact <- median(ref$impact); g$splice <- median(ref$splice)
  g$p <- forward(net, standardise(g, ref))$p; g
}
boundary_plot <- function(net, df, ref = df, title = NULL, subtitle = NULL) {
  g <- grid_probs(net, ref)
  ggplot() +
    geom_raster(data = g, aes(af, cons, fill = p), interpolate = TRUE) +
    geom_contour(data = g, aes(af, cons, z = p), breaks = 0.5, colour = ibex$black, linewidth = 0.8) +
    geom_point(data = df, aes(af, cons, colour = factor(y)), size = 1.8, stroke = 0.5, shape = 21, fill = "white") +
    scale_fill_gradient2(low = ibex$teal, mid = "white", high = ibex$pink, midpoint = 0.5, limits = c(0, 1), guide = "none") +
    scale_colour_manual(values = c(`0` = ibex$teal, `1` = ibex$pink), labels = c("benign", "pathogenic")) +
    scale_x_log10(breaks = c(1e-5, 1e-3, 1e-1), labels = c("0.001%", "0.1%", "10%")) +
    coord_cartesian(expand = FALSE) +
    labs(x = "allele frequency (how common)", y = "conservation", title = title, subtitle = subtitle,
         caption = "impact and splice distance held at their medians · pink = says pathogenic") +
    theme_seq() + theme(panel.grid = element_blank(), legend.position = "top",
                        plot.title = element_text(face = "bold", size = rel(1)), plot.subtitle = element_text(colour = "#555555", size = rel(0.85)))
}

train_df <- make_variants(200, seed = 1); val_df <- make_variants(100, seed = 2); test_df <- make_variants(100, seed = 3)
