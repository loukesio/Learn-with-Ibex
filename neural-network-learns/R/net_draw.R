# Draw the network from a given weight set (used for the static figure and for one frame per epoch)
draw_net <- function(net, X, epoch = NULL, hidden_pos = NULL) {
  nh <- ncol(net$W1); bg <- "#0B1026"
  ys <- seq(1, 16, length.out = nh)                                   # hidden neurons spread over the full height
  nodes <- rbind(data.frame(layer = 1, y = c(5.5, 11.5), lab = c("x1", "x2"), size = 10),
                 data.frame(layer = 2, y = ys,             lab = "",           size = 5.2),
                 data.frame(layer = 3, y = 8.5,            lab = "p",          size = 11))
  e1 <- expand.grid(i = 1:2, j = 1:nh) |> mutate(w = net$W1[cbind(i, j)], x = 1, xend = 2, y = c(5.5, 11.5)[i], yend = ys[j])
  e2 <- data.frame(j = 1:nh, w = as.vector(net$W2), x = 2, xend = 3, y = ys, yend = 8.5)
  wmax <- 3.5                                                          # fixed scale so widths are comparable across epochs
  edges <- bind_rows(e1, e2) |> mutate(sign = ifelse(w > 0, "positive weight", "negative weight"), a = pmin(abs(w) / wmax, 1))
  act <- colMeans(abs(forward(net, X)$H)); nodes$act <- c(1, 1, pmin(act / 0.9, 1), 1)
  ggplot() +
    geom_segment(data = edges, aes(x, y, xend = xend, yend = yend, colour = sign, linewidth = 0.4 + a * 8, alpha = 0.05 + a * 0.2), lineend = "round") +
    geom_segment(data = edges, aes(x, y, xend = xend, yend = yend, colour = sign, linewidth = 0.3 + a * 2.8, alpha = 0.25 + a * 0.75), lineend = "round") +
    geom_point(data = nodes, aes(layer, y, size = size * ifelse(layer == 2, 1.9, 2.4), alpha = 0.15 + 0.5 * act), colour = "#F5C400") +
    geom_point(data = nodes, aes(layer, y, size = size), colour = "#FFF6B0") +
    geom_point(data = nodes, aes(layer, y, size = size * 0.45), colour = "#F5C400") +
    geom_text(data = nodes[nodes$lab != "", ], aes(layer, y, label = lab), family = "Fira Sans", size = 4.2, fontface = "bold", colour = bg) +
    scale_colour_manual(values = c(`positive weight` = "#FF2D95", `negative weight` = "#1BE7FF")) +
    scale_linewidth_identity() + scale_alpha_identity() + scale_size_identity() +
    scale_x_continuous(breaks = 1:3, labels = c("input\n2 features", sprintf("hidden layer\n%d neurons", nh), "output\nP(class B)"), limits = c(0.85, 3.15)) +
    scale_y_continuous(limits = c(0.2, 16.8)) +
    labs(x = NULL, y = NULL, title = NULL,
         caption = "48 weights + 17 biases = 65 numbers to change · line width = weight size · glow = neuron activity") +
    guides(colour = guide_legend(override.aes = list(linewidth = 2.5, alpha = 1))) +
    theme_void(base_family = "Fira Sans") +
    theme(plot.background = element_rect(fill = bg, colour = NA), panel.background = element_rect(fill = bg, colour = NA),
          legend.position = "top", legend.title = element_blank(), legend.text = element_text(colour = "white", size = 10), legend.margin = margin(0, 0, -6, 0),
          plot.title = element_text(colour = "#F5C400", face = "bold", size = 18, hjust = 0.02),
          axis.text.x = element_text(colour = "white", face = "bold", size = 10, margin = margin(t = 2)),
          plot.caption = element_text(colour = "#9AA3C4", size = 8, hjust = 0.5, margin = margin(t = 4)),
          plot.margin = margin(8, 10, 8, 10))
}
