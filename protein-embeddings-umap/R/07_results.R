# 07 · What the paper found (amyloidosis, Table 4): ROC-AUC per strategy, next to the classic predictors
source("R/00_data.R")
d <- data.frame(method = c("ESM2 + ML", "ESM2 + UMAP distance", "REVEL", "CADD", "VESM 3B", "AlphaMissense", "ESM2 + UMAP + ML"),
                auc = c(0.7924, 0.7398, 0.7273, 0.7073, 0.6712, 0.6436, 0.5875),
                ours = c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE))
d$method <- factor(d$method, levels = rev(d$method))
res_plot <- ggplot(d, aes(auc, method, fill = ours)) + geom_col(width = 0.7) +
  geom_text(aes(label = sprintf("%.2f", auc)), hjust = -0.15, family = "Fira Sans", size = 3.4) +
  scale_fill_manual(values = c(`TRUE` = ibex$pink, `FALSE` = ibex$ice), labels = c("published predictors", "this paper"), name = NULL) +
  scale_x_continuous(limits = c(0, 0.95), expand = c(0, 0)) +
  labs(x = "ROC-AUC on held-out variants", y = NULL,
       caption = "Lomoio et al. 2026, Table 4, amyloidosis") +
  theme_seq() + theme(panel.grid.major.y = element_blank(), legend.position = "top")
save_plot(res_plot, "plots/results.png", width = 6.4, height = 3.4)
