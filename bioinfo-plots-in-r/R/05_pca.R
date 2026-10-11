# 05 · ggiraph — hover a sample in a PCA
# install.packages("ggiraph")
source("R/theme_ibex.R")
library(ggiraph)

# 24 samples, 2 conditions, 500 genes (simulated), then a real PCA
set.seed(11)
n <- 24; genes <- 500
condition <- rep(c("normoxia", "hypoxia"), each = n / 2)
expr <- matrix(rnorm(n * genes), n, genes)
expr[condition == "hypoxia", 1:150] <- expr[condition == "hypoxia", 1:150] + 1.8   # 150 responsive genes
pca <- prcomp(expr, scale. = TRUE)
var_pct <- round(100 * pca$sdev^2 / sum(pca$sdev^2))

samples <- data.frame(sample_id = sprintf("IBX_%02d", 1:n), condition,
                      PC1 = pca$x[, 1], PC2 = pca$x[, 2])
samples$tooltip <- sprintf("sample_id: %s\ncondition: %s\nPC1: %.1f · PC2: %.1f",
                           samples$sample_id, samples$condition, samples$PC1, samples$PC2)

p <- ggplot(samples, aes(PC1, PC2)) +
  geom_point_interactive(aes(fill = condition, tooltip = tooltip, data_id = sample_id),
                         shape = 21, size = 6, colour = ibex$black, stroke = 1.4) +
  scale_fill_manual(values = c(normoxia = "white", hypoxia = ibex$yellow)) +
  labs(x = sprintf("PC1 · %d%%", var_pct[1]), y = sprintf("PC2 · %d%%", var_pct[2])) +
  theme_ibex()

# interactive version (open in a browser, hover a point)
widget <- girafe(ggobj = p, width_svg = 6, height_svg = 4.2,
                 options = list(opts_hover(css = "stroke-width:3;"), opts_tooltip(css = "background:#111;color:#fff;font-family:'IBM Plex Mono';padding:8px 12px;")))
htmlwidgets::saveWidget(widget, "plots/pca_interactive.html", selfcontained = TRUE)

# static version for Instagram: one sample ringed, with its tooltip drawn on the plot
hl <- samples[samples$sample_id == "IBX_07", ]
print(hl[, 1:4])
pca_static <- p +
  geom_point(data = hl, shape = 1, size = 11, stroke = 1.3, colour = ibex$black) +
  geom_label(data = hl, aes(label = tooltip), family = "IBM Plex Mono", fontface = "bold",
             fill = ibex$black, colour = "white", size = 3.6, hjust = 0, vjust = 0,
             nudge_x = 1.5, nudge_y = 1.5, label.r = unit(0, "pt"), label.padding = unit(6, "pt"), lineheight = 1.1)

save_plot(pca_static, "plots/pca.png")
