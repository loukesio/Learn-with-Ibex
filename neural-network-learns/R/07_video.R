# 07 · Video slide: 2-D view of the predictions + loss curve, one frame per epoch
source("R/00_net.R"); library(patchwork)
run <- readRDS("plots/run.rds"); h <- run$hist; dir.create("frames", showWarnings = FALSE)
for (e in 0:60) {
  top <- boundary_plot(run$snaps[[e + 1]], train_df, title = sprintf("epoch %d", e)) + theme(legend.position = "none", plot.title = element_text(size = rel(1.6), face = "bold"), plot.caption = element_blank())
  bottom <- ggplot(h[h$epoch <= e, ], aes(epoch, train_loss)) + geom_line(colour = ibex$pink, linewidth = 1.3) + geom_point(data = h[h$epoch == e, ], colour = ibex$pink, size = 3.5) +
    scale_x_continuous(limits = c(0, 60)) + scale_y_continuous(limits = c(0, max(h$train_loss) * 1.05)) +
    labs(x = "epoch", y = "loss", title = sprintf("loss %.2f · accuracy %.0f%%", h$train_loss[e + 1], 100 * h$train_acc[e + 1])) + theme_seq() + theme(plot.title = element_text(face = "bold", size = rel(1)))
  frame <- (top / bottom) + plot_layout(heights = c(1.45, 1)) + plot_annotation(title = "one epoch = one pass over all 200 variants · 10 weight updates",
            theme = theme(plot.title = element_text(family = "Fira Sans", size = 13, colour = "#555555", hjust = 0.5), plot.background = element_rect(fill = "white", colour = NA)))
  ragg::agg_png(sprintf("frames/f%03d.png", e), width = 1080, height = 1080, res = 170, background = "white"); print(frame); dev.off()
}
