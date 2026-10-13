# 06 · The catch: four random seeds, four maps of the same vectors
source("R/00_data.R"); library(uwot)
runs <- bind_rows(lapply(1:4, function(s) { set.seed(s); u <- umap(X, n_neighbors = 8, min_dist = 0.4, metric = "correlation", seed = s)
  data.frame(seed = sprintf("seed %d", s), U1 = u[, 1], U2 = u[, 2], label = lab, far = sqrt((u[, 1] - median(u[, 1]))^2 + (u[, 2] - median(u[, 2]))^2) > 10) }))
runs <- runs[!runs$far, ]                                   # the 5 residue-104 outliers are off every chart
seed_plot <- pt(ggplot(runs, aes(U1, U2)) + geom_point(aes(colour = label), size = 1.6, alpha = 0.9) +
  facet_wrap(~seed, nrow = 1, scales = "free")) +
  theme(panel.spacing = unit(10, "pt")) +
  labs(x = NULL, y = NULL, caption = "same data, same settings, different random start · residue-104 outliers off-chart") +
  theme(strip.text = element_text(face = "bold"), legend.position = "none")
save_plot(seed_plot, "plots/seeds.png", width = 6.4, height = 2.6)
