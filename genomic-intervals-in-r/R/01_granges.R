# 01 · GenomicRanges — the verbs: shift, resize, flank, reduce, gaps, disjoin on the same four ranges
source("R/00_data.R")

gr <- GRanges("chr21", IRanges(start = c(10, 25, 30, 55), width = c(10, 10, 12, 8)))
ops <- list(
  "gr"                               = gr,
  "shift(gr, 5)"                     = shift(gr, 5),
  'resize(gr, 20, fix = "center")'   = resize(gr, 20, fix = "center"),
  "flank(gr, 5)"                     = flank(gr, 5),
  "reduce(gr)"                       = reduce(gr),
  "disjoin(gr)"                      = disjoin(gr),
  "gaps(gr, start = 1, end = 70)"    = gaps(gr, start = 1, end = 70)
)
df <- bind_rows(lapply(names(ops), \(n) data.frame(op = n, start = start(ops[[n]]), end = end(ops[[n]]))), .id = NULL) |>
  mutate(op = factor(op, levels = rev(names(ops))), kind = ifelse(op == "gr", "input", "result"))

granges_plot <- ggplot(df) +
  geom_rect(aes(xmin = start - 0.5, xmax = end + 0.5, ymin = as.numeric(op) - 0.32, ymax = as.numeric(op) + 0.32, fill = kind),
            colour = "white", linewidth = 0.4) +
  scale_fill_manual(values = c(input = ibex$black, result = ibex$pink), guide = "none") +
  scale_y_continuous(breaks = seq_along(levels(df$op)), labels = levels(df$op), expand = expansion(add = 0.5)) +
  scale_x_continuous(breaks = seq(0, 70, 10), limits = c(0, 71), expand = c(0, 0)) +
  labs(x = "position (bp)", y = NULL, caption = "black: the four input ranges · pink: what each verb returns") +
  theme_seq(base_size = 14) +
  theme(axis.text.y = element_text(family = "Fira Mono", size = rel(0.95), hjust = 1, colour = ibex$black), panel.grid.major.y = element_blank())

save_plot(granges_plot, "plots/granges.png", width = 6.4, height = 3.8)
