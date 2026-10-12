# 01 · The network itself, drawn from the real weights after training: dark background, neon edges, glow by layering
source("R/00_net.R")
run <- train(train_df, val_df, epochs = 60); saveRDS(run, "plots/run.rds")
net <- run$net
nodes <- rbind(data.frame(layer = 1, id = 1:2,  y = c(5.5, 11.5), lab = c("x1", "x2"), size = 9),
               data.frame(layer = 2, id = 1:16, y = 1:16,         lab = "",            size = 6.5),
               data.frame(layer = 3, id = 1,    y = 8.5,          lab = "p",           size = 10))
e1 <- expand.grid(i = 1:2, j = 1:16) |> mutate(w = net$W1[cbind(i, j)], x = 1, xend = 2, y = nodes$y[nodes$layer == 1][i], yend = j)
e2 <- data.frame(j = 1:16, w = as.vector(net$W2), x = 2, xend = 3, y = 1:16, yend = 8.5)
edges <- bind_rows(e1, e2) |> mutate(sign = ifelse(w > 0, "positive weight", "negative weight"), a = abs(w) / max(abs(w)))
act <- forward(net, as.matrix(train_df[, 1:2]))$H |> abs() |> colMeans()        # how active each hidden neuron is on average
nodes$act <- c(1, 1, act / max(act), 1)
bg <- "#0B1026"
net_plot <- ggplot() +
  geom_segment(data = edges, aes(x, y, xend = xend, yend = yend, colour = sign, linewidth = a * 7, alpha = a * 0.25), lineend = "round") +
  geom_segment(data = edges, aes(x, y, xend = xend, yend = yend, colour = sign, linewidth = a * 2.2, alpha = 0.4 + a * 0.6), lineend = "round") +
  geom_point(data = nodes, aes(layer, y, size = size * 2.2, alpha = act), colour = "#F5C400") +
  geom_point(data = nodes, aes(layer, y, size = size), colour = "#FFF6B0") +
  geom_point(data = nodes, aes(layer, y, size = size * 0.45), colour = "#F5C400") +
  geom_text(data = nodes, aes(layer, y, label = lab), family = "Fira Sans", size = 3.6, fontface = "bold", colour = bg, nudge_y = 0) +
  scale_colour_manual(values = c(`positive weight` = "#FF2D95", `negative weight` = "#1BE7FF")) +
  scale_linewidth_identity() + scale_alpha_identity() + scale_size_identity() +
  scale_x_continuous(breaks = 1:3, labels = c("input\n2 features", "hidden layer\n16 neurons", "output\nP(class B)"), limits = c(0.6, 3.4)) +
  scale_y_continuous(limits = c(0, 17)) +
  labs(x = NULL, y = NULL, caption = "48 weights + 17 biases = 65 numbers the network can change · line width = weight size · glow = average activity") +
  guides(colour = guide_legend(override.aes = list(linewidth = 2.5, alpha = 1))) +
  theme_void(base_family = "Fira Sans") +
  theme(plot.background = element_rect(fill = bg, colour = NA), panel.background = element_rect(fill = bg, colour = NA),
        legend.position = "top", legend.title = element_blank(), legend.text = element_text(colour = "white", size = 11),
        axis.text.x = element_text(colour = "white", face = "bold", size = 11, margin = margin(t = 6)),
        plot.caption = element_text(colour = "#9AA3C4", size = 8.5, hjust = 0.5, margin = margin(t = 8)),
        plot.margin = margin(8, 10, 8, 10))
save_plot(net_plot, "plots/network.png", width = 6.4, height = 4.2)
