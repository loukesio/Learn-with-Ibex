# 02b · ggsynteny — circular synteny with annotation tracks
# ggsynteny >= 0.5.0:  remotes::install_github("loukesio/ggsynteny")
source("R/theme_ibex.R")
library(ggsynteny); library(dplyr)

data(rice_sorghum)
species <- c("Rice", "Sorghum")
ribbons <- rep(c(ibex$pink, ibex$yellow, ibex$teal, ibex$blu, ibex$peppermint, ibex$black), 2)

# 1. the circle: chromosome arcs + syntenic ribbons (labels switched off, we draw our own further out)
circ <- plot_circular_synteny(rice_sorghum, species,
                              ribbon_fill = "source_chr", ribbon_palette = ribbons, ribbon_alpha = 0.6,
                              chr_palette = ibex$black, chr_color = "white",
                              label_size = 0, species_label_size = 0)

# 2. the same angular layout the plot used (sector angles per chromosome)
chrs <- rice_sorghum$chromosomes
lay  <- ggsynteny:::.circ_layout(data.frame(group_name = chrs$species, sector_name = chrs$chr, start = 0, end = chrs$size),
                                 species, gap = 1, group_gap = 10, start_angle = 90, clockwise = TRUE)
theta <- function(sp, chr, pos) {           # genomic position (Mb) -> angle
  r <- lay[lay$group_name == sp & lay$sector_name == chr, ]
  r$theta_start + (r$theta_end - r$theta_start) * pmin(pos, r$end) / r$end
}
ring <- function(sp, chr, from, to, inner, outer, id, fill)
  cbind(ggsynteny:::.circ_ring(theta(sp, chr, from), theta(sp, chr, to), inner, outer), id = id, fill = fill)

# both sides of every block, as one long table
b <- rice_sorghum$blocks
sides <- bind_rows(
  transmute(b, sp = species1, chr = chr1, from = start1, to = end1, n_genes, score),
  transmute(b, sp = species2, chr = chr2, from = start2, to = end2, n_genes, score))

# 3. track A (outer ring): genes in synteny blocks per 2 Mb window, drawn as bars
bins <- chrs |> rowwise() |>
  reframe(sp = species, chr = chr, from = seq(0, size, by = 2), to = pmin(from + 2, size)) |>
  filter(to > from)
density <- bins |> rowwise() |>
  mutate(genes = sum({ s <- sides[sides$sp == sp & sides$chr == chr, ]
                       ov <- pmax(0, pmin(to, s$to) - pmax(from, s$from)); s$n_genes * ov / (s$to - s$from) })) |>
  ungroup() |> mutate(h = genes / max(genes))
track_a <- bind_rows(lapply(seq_len(nrow(density)), function(i) with(density[i, ],
  ring(sp, chr, from, to, 1.04, 1.04 + 0.14 * h, paste0("a", i), ibex$pink))))

# 4. track B (middle ring): block score, as a heat strip
shade <- colorRamp(c(ibex$ice, ibex$teal, ibex$black))
sides$col <- rgb(shade((log10(sides$score) - min(log10(sides$score))) / diff(range(log10(sides$score)))), maxColorValue = 255)
track_b <- bind_rows(lapply(seq_len(nrow(sides)), function(i) with(sides[i, ],
  ring(sp, chr, from, to, 1.21, 1.27, paste0("b", i), col))))
guides_b <- bind_rows(lapply(seq_len(nrow(lay)), function(i) with(lay[i, ],
  cbind(ggsynteny:::.circ_ring(theta_start, theta_end, 1.21, 1.27), id = paste0("g", i), fill = "#EEEEEE"))))

# 5. labels further out, and a key on the right
chr_lab <- ggsynteny:::.circ_labels((lay$theta_start + lay$theta_end) / 2, 1.34, lay$sector_name)
sp_lab  <- ggsynteny:::.circ_group_labels(lay, radius = 1.47)
key <- data.frame(y = c(1.05, 0.70, 0.35, 0.00, -0.50),
                  label = c("outer ring\ngenes per 2 Mb", "middle ring\nblock score (log)",
                            "inner ring\nchromosomes", "ribbons\nsynteny blocks,\ncolour = rice chr", "100 blocks\nrice vs sorghum"),
                  col = c(ibex$pink, ibex$teal, ibex$black, ibex$blu, ibex$black))

synteny_circular <- circ +
  geom_polygon(data = guides_b, aes(x, y, group = id, fill = fill), inherit.aes = FALSE) +
  geom_polygon(data = track_b,  aes(x, y, group = id, fill = fill), inherit.aes = FALSE) +
  geom_polygon(data = track_a,  aes(x, y, group = id, fill = fill), inherit.aes = FALSE) +
  geom_text(data = chr_lab, aes(x, y, label = label, angle = text_angle), family = "IBM Plex Mono", fontface = "bold", size = 3.2, inherit.aes = FALSE) +
  geom_text(data = sp_lab,  aes(x, y, label = label, angle = text_angle), family = "IBM Plex Mono", fontface = "bold.italic", size = 5, inherit.aes = FALSE) +
  geom_point(data = key, aes(x = 1.75, y = y + 0.02), colour = key$col, size = 5, inherit.aes = FALSE) +
  geom_text(data = key, aes(x = 1.86, y = y, label = label), family = "IBM Plex Mono", fontface = "bold", size = 3.4, hjust = 0, vjust = 0.8, lineheight = 0.95, inherit.aes = FALSE) +
  coord_equal(xlim = c(-1.55, 3.0), ylim = c(-1.55, 1.55), expand = FALSE, clip = "off") +
  theme(plot.margin = margin(4, 4, 4, 4))

save_plot(synteny_circular, "plots/synteny_circular.png", width = 7.2, height = 4.9)

# circle only (the carousel slide carries the key as text)
synteny_circle <- synteny_circular +
  coord_equal(xlim = c(-1.55, 1.55), ylim = c(-1.55, 1.55), expand = FALSE, clip = "off")
synteny_circle$layers <- synteny_circle$layers[!sapply(synteny_circle$layers, function(l) identical(l$data, key))]
synteny_circle <- synteny_circle +   # bigger labels: the circle is shown at ~500 px
  geom_text(data = chr_lab, aes(x, y, label = label, angle = text_angle), family = "IBM Plex Mono", fontface = "bold", size = 5, inherit.aes = FALSE) +
  geom_text(data = sp_lab,  aes(x, y, label = label, angle = text_angle), family = "IBM Plex Mono", fontface = "bold.italic", size = 7.5, inherit.aes = FALSE)
synteny_circle$layers <- synteny_circle$layers[!sapply(synteny_circle$layers, function(l) identical(l$data, chr_lab) && l$aes_params$size == 3.2 || identical(l$data, sp_lab) && l$aes_params$size == 5)]
save_plot(synteny_circle, "plots/synteny_circle.png", width = 5, height = 5)
