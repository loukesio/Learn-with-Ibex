# 05 · The simplest score: how far did the mutated residue's vector move away from its wild-type self?
source("R/00_data.R")
d <- data.frame(dist = vec$dist_to_wt, label = lab, variant = vec$variant)
dd <- d[d$label %in% c("Benign", "Pathogenic"), ]
auc <- { pos <- dd$dist[dd$label == "Pathogenic"]; neg <- dd$dist[dd$label == "Benign"]; mean(outer(pos, neg, ">") + 0.5 * outer(pos, neg, "==")) }
dist_plot <- ggplot(d, aes(dist, label, colour = label)) +
  geom_jitter(height = 0.18, width = 0, size = 2.4, alpha = 0.85) +
  geom_text(data = d[d$variant == "V50M", ], aes(label = "V50M"), nudge_y = 0.42, family = "Fira Sans", size = 3.2, fontface = "bold") +
  scale_colour_manual(values = cols, guide = "none") +
  labs(x = "distance from wild type, same residue", y = NULL,
       caption = sprintf("benign vs pathogenic: ROC-AUC %.2f, a coin flip", auc)) +
  theme_seq() + theme(panel.grid.major.y = element_blank())
save_plot(dist_plot, "plots/distance.png", width = 6.4, height = 3.4)
cat(sprintf("AUC %.3f\n", auc))
