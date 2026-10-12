# The network drawing: 4 named inputs, 8 hidden neurons, 1 output. Dark background, clean rings, line width = weight size.
draw_net <- function(net, X, epoch = NULL) {
  nh <- ncol(net$W1); bg <- "#0B1026"
  yin <- rev(seq(2.5, 13.5, length.out = 4)); yh <- seq(1, 15, length.out = nh)   # allele frequency at the top
  nodes <- rbind(data.frame(layer = 1, y = yin, lab = c("allele\nfrequency", "conservation", "protein\nimpact", "splice\ndistance"), size = 7),
                 data.frame(layer = 2, y = yh,  lab = "", size = 5),
                 data.frame(layer = 3, y = 8,   lab = "", size = 9))
  e1 <- expand.grid(i = 1:4, j = 1:nh) |> mutate(w = net$W1[cbind(i, j)], x = 1, xend = 2, y = yin[i], yend = yh[j])
  e2 <- data.frame(j = 1:nh, w = as.vector(net$W2), x = 2, xend = 3, y = yh, yend = 8)
  edges <- bind_rows(e1, e2) |> mutate(sign = ifelse(w > 0, "positive weight (excites)", "negative weight (inhibits)"), a = pmin(abs(w) / 3, 1))
  act <- colMeans(abs(forward(net, X)$H)); hid <- data.frame(layer = 2, y = yh, act = pmin(act / 0.9, 1))
  ggplot() +
    geom_segment(data = edges, aes(x, y, xend = xend, yend = yend, colour = sign, linewidth = 0.25 + a * 2.6, alpha = 0.35 + a * 0.65), lineend = "round") +
    geom_point(data = hid, aes(layer, y, alpha = 0.12 + 0.35 * act), size = 9.5, colour = "#F5C400") +   # activity: a thin soft halo
    geom_point(data = nodes, aes(layer, y, size = size), colour = "white") +
    geom_point(data = nodes, aes(layer, y, size = size), shape = 21, colour = "#F5C400", stroke = 1.4, fill = NA) +
    geom_text(data = nodes[nodes$layer == 1, ], aes(0.86, y, label = lab), family = "Fira Sans", size = 3.3, fontface = "bold", colour = "white", hjust = 1, lineheight = 0.85) +
    annotate("text", x = 3.14, y = 8, label = "disease-causing?\nprobability 0 – 1", family = "Fira Sans", size = 3.3, fontface = "bold", colour = "white", hjust = 0, lineheight = 0.85) +
    scale_colour_manual(values = c(`positive weight (excites)` = "#FF2D95", `negative weight (inhibits)` = "#1BE7FF")) +
    scale_linewidth_identity() + scale_alpha_identity() + scale_size_identity() +
    scale_x_continuous(breaks = 1:3, labels = c("4 inputs", sprintf("%d hidden neurons", nh), "1 output"), limits = c(0.3, 3.75)) +
    scale_y_continuous(limits = c(0, 16)) +
    labs(x = NULL, y = NULL, title = if (is.null(epoch)) NULL else sprintf("epoch %d", epoch),
         caption = sprintf("%d weights + %d biases = %d numbers the network can change · line width = weight size", 4 * nh + nh, nh + 1, 5 * nh + nh + 1)) +
    guides(colour = guide_legend(override.aes = list(linewidth = 2.5, alpha = 1))) +
    theme_void(base_family = "Fira Sans") +
    theme(plot.background = element_rect(fill = bg, colour = NA), panel.background = element_rect(fill = bg, colour = NA),
          legend.position = "top", legend.title = element_blank(), legend.text = element_text(colour = "white", size = 10), legend.margin = margin(0, 0, -4, 0),
          plot.title = element_text(colour = "#F5C400", face = "bold", size = 16, hjust = 0.02),
          axis.text.x = element_text(colour = "#C9CFE6", face = "bold", size = 10, margin = margin(t = 2)),
          plot.caption = element_text(colour = "#9AA3C4", size = 8, hjust = 0.5, margin = margin(t = 4)),
          plot.margin = margin(6, 10, 6, 10))
}
