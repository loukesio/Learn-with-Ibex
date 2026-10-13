# 01 · What an embedding looks like: the 1,280 numbers of residue 50 in wild-type TTR and in the V50M variant, as 32 x 40 tiles
source("R/00_data.R"); library(tidyr)
wt <- as.numeric(wt_res[wt_res$pos == 50, -1]); mut <- X["V50M", ]
tile <- function(v, name) data.frame(name = name, i = seq_along(v), row = (seq_along(v) - 1) %/% 40, col = (seq_along(v) - 1) %% 40, value = v)
d <- bind_rows(tile(wt, "wild type: V"), tile(mut, "variant: M"), tile(mut - wt, "difference"))
d$name <- factor(d$name, levels = unique(d$name)); lim <- quantile(abs(c(wt, mut)), 0.99)
vec_plot <- ggplot(d, aes(col, row, fill = value)) + geom_raster() + facet_wrap(~name, ncol = 3) +
  scale_fill_gradient2(low = ibex$teal, mid = "white", high = ibex$pink, limits = c(-lim, lim), oob = scales::squish, name = NULL) +
  coord_fixed(expand = FALSE) + scale_y_reverse() +
  labs(x = NULL, y = NULL, caption = sprintf("1,280 numbers each, laid out as 32 × 40 · cosine similarity %.2f", sum(wt*mut)/sqrt(sum(wt^2)*sum(mut^2)))) +
  theme_seq() + theme(axis.text = element_blank(), axis.ticks = element_blank(), panel.grid = element_blank(), axis.line.x = element_blank(),
                      legend.position = "right", legend.key.height = unit(0.8, "cm"), strip.text = element_text(face = "bold", size = rel(1)), plot.margin = margin(2, 4, 2, 4))
save_plot(vec_plot, "plots/vector.png", width = 6.4, height = 2.6)
