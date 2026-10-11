# 02 · plyranges — dplyr verbs on GRanges: how far is each CTCF peak from the nearest TSS?
source("R/00_data.R")
suppressPackageStartupMessages(library(plyranges))

tss  <- tx21 |> anchor_5p() |> mutate(width = 1)                       # transcription start sites
near <- peaks |> add_nearest_distance(tss) |>                          # one new column: distance
  mutate(bin = cut(distance, c(-1, 1e3, 1e4, 1e5, Inf), labels = c("< 1 kb", "1–10 kb", "10–100 kb", "> 100 kb")))
counts <- near |> group_by(bin) |> summarise(n = n()) |> as.data.frame() |> mutate(pct = n / sum(n))

plyranges_plot <- ggplot(as.data.frame(near), aes(x = distance + 1)) +
  geom_histogram(bins = 40, fill = ibex$teal, colour = "white", linewidth = 0.3) +
  geom_vline(xintercept = 1e3, linetype = "22", colour = ibex$black) +
  annotate("text", x = 1e3, y = Inf, vjust = 1.4, hjust = 1.08, family = "Fira Sans", size = 3.6,
           label = sprintf("%d of %d peaks\nwithin 1 kb of a TSS", counts$n[1], sum(counts$n))) +
  scale_x_log10(breaks = c(1, 10, 100, 1e3, 1e4, 1e5, 1e6), labels = c("0", "10 bp", "100 bp", "1 kb", "10 kb", "100 kb", "1 Mb")) +
  labs(x = "distance to nearest TSS", y = "CTCF peaks",
       caption = sprintf("IMR-90 CTCF, chr21 · %.0f%% within 1 kb of a TSS, %.0f%% beyond 10 kb", 100 * counts$pct[1], 100 * sum(counts$pct[3:4]))) +
  theme_seq()

save_plot(plyranges_plot, "plots/plyranges.png", width = 6.4, height = 3.8)
print(counts)
