# Shared look for every plot in the "Bioinformatics plots in R" carousel.
# Fonts: IBM Plex Mono (https://fonts.google.com/specimen/IBM+Plex+Mono)

library(ggplot2)

ibex <- list(
  black = "#111111", white = "#FFFFFF", grey = "#BBBBBB",
  yellow = "#F5C400", pink = "#E8197F", teal = "#1A8C8F", blu = "#2E7DBE",
  peppermint = "#A8CF6A", rosa = "#F2C9D8", ice = "#BFD4DC"
)

theme_ibex <- function(base_size = 16) {
  theme_minimal(base_size = base_size, base_family = "IBM Plex Mono") +
    theme(
      panel.grid = element_blank(),
      axis.line  = element_line(colour = "#111111", linewidth = 1.2),
      axis.ticks = element_line(colour = "#111111", linewidth = 1),
      axis.text  = element_text(colour = "#111111", face = "bold"),
      axis.title = element_text(colour = "#111111", face = "bold"),
      plot.caption = element_text(colour = "#111111", face = "bold", hjust = 0, size = rel(0.8)),
      legend.position = "none",
      plot.background = element_rect(fill = "white", colour = NA)
    )
}

# ggsave wrapper: ragg so the Plex Mono font is picked up on every OS.
save_plot <- function(p, file, width = 6, height = 4.2, dpi = 300) {
  ggsave(file, p, width = width, height = height, dpi = dpi, bg = "white",
         device = ragg::agg_png)
  invisible(file)
}
