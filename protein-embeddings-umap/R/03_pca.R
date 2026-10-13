# 03 · PCA: 1,280 dimensions -> 2, keeping the directions of largest spread
source("R/00_data.R")
p <- prcomp(X, center = TRUE, scale. = FALSE); ve <- summary(p)$importance[2, 1:2]
d <- data.frame(PC1 = p$x[, 1], PC2 = p$x[, 2], label = lab, variant = vec$variant)
pca_plot <- pt(ggplot(d, aes(PC1, PC2)) +
  geom_point(aes(colour = label), size = 2.4, alpha = 0.9)) +
  labs(x = sprintf("PC1 · %.0f%% of the variance", 100 * ve[1]), y = sprintf("PC2 · %.0f%%", 100 * ve[2]),
       caption = "a straight-line projection: honest distances, faint clusters") +
  theme(axis.title = element_text(size = rel(0.9)))
save_plot(pca_plot, "plots/pca.png", width = 6.4, height = 3.8)
saveRDS(d, "plots/pca.rds")
