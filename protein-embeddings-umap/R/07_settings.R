# 07 · Exploring move 3: poke the knobs. Two seeds and two neighbourhood sizes of the same vectors
source("R/00_data.R"); library(uwot)
run <- function(name, nn, s) { set.seed(s); u <- umap(X, n_neighbors = nn, min_dist = 0.4, metric = "correlation", seed = s)
  far <- sqrt((u[, 1] - median(u[, 1]))^2 + (u[, 2] - median(u[, 2]))^2) > 10
  data.frame(panel = name, U1 = u[, 1], U2 = u[, 2], label = lab)[!far, ] }
runs <- bind_rows(run("seed 1", 8, 1), run("seed 2", 8, 2), run("3 neighbours", 3, 1), run("40 neighbours", 40, 1))
runs$panel <- factor(runs$panel, levels = unique(runs$panel))
set_plot <- pt(ggplot(runs, aes(U1, U2)) + geom_point(aes(colour = label), size = 1.6, alpha = 0.9) +
  facet_wrap(~panel, nrow = 1, scales = "free")) + theme(panel.spacing = unit(10, "pt"), strip.text = element_text(face = "bold", size = rel(0.85)), legend.position = "none") +
  labs(x = NULL, y = NULL, caption = "new seed: same groups, new shape · few neighbours: fragments · many: one blob")
save_plot(set_plot, "plots/settings.png", width = 6.4, height = 2.6)
