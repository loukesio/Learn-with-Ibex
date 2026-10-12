# Shared look for the "How a neural network learns" carousel: light, scientific, Fira Sans.
library(ggplot2)

ibex <- list(black = "#111111", grey = "#9A9A9A", light = "#E6E6E6",
             yellow = "#F5C400", pink = "#E8197F", teal = "#1A8C8F", blu = "#2E7DBE",
             peppermint = "#A8CF6A", rosa = "#F2C9D8", ice = "#BFD4DC")

theme_seq <- function(base_size = 15) {
  theme_minimal(base_size = base_size, base_family = "Fira Sans") +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = "#ECECEC", linewidth = 0.4),
      axis.line.x = element_line(colour = "#111111", linewidth = 0.5),
      axis.ticks.x = element_line(colour = "#111111", linewidth = 0.5),
      axis.text  = element_text(colour = "#333333"),
      axis.title = element_text(colour = "#111111", face = "bold"),
      plot.caption = element_text(colour = "#666666", hjust = 0, size = rel(0.8), family = "Fira Sans"),
      legend.position = "top", legend.title = element_blank(),
      legend.text = element_text(size = rel(0.9)),
      plot.background = element_rect(fill = "white", colour = NA)
    )
}

save_plot <- function(p, file, width = 6.4, height = 4.2, dpi = 300) {
  ggsave(file, p, width = width, height = height, dpi = dpi, bg = "white", device = ragg::agg_png)
  invisible(file)
}
