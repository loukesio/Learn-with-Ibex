# 04 · UMAP with the paper's settings: n_neighbors = 8, min_dist = 0.4, metric = correlation
source("R/00_data.R"); library(uwot)
set.seed(42)
u <- umap(X, n_neighbors = 8, min_dist = 0.4, metric = "correlation", n_components = 2, seed = 42)
d <- data.frame(U1 = u[, 1], U2 = u[, 2], label = lab, variant = vec$variant)
umap_plot <- pt(ggplot(d, aes(U1, U2)) +
  geom_point(aes(colour = label), size = 2.4, alpha = 0.9)) +
  coord_cartesian(xlim = range(d$U1[d$U1 < 20]) + c(-0.4, 0.4), ylim = range(d$U2[d$U1 < 20]) + c(-0.4, 0.4)) +
  labs(x = "UMAP 1", y = "UMAP 2", caption = "5 variants at residue 104 sit far off-chart · gaps between groups mean little")
save_plot(umap_plot, "plots/umap.png", width = 6.4, height = 3.8)
saveRDS(d, "plots/umap.rds")
