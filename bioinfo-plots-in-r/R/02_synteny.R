# 02 · ggsynteny — macro-synteny ribbons between two genomes
# install.packages("ggsynteny")  ·  github.com/loukesio/ggsynteny
source("R/theme_ibex.R")
library(ggsynteny)

data(rice_sorghum)   # 100 collinear blocks, 12 rice chr vs 10 sorghum chr

ribbons <- rep(c(ibex$pink, ibex$yellow, ibex$teal, ibex$blu, ibex$peppermint, ibex$black), 2)  # 12 rice chr

synteny <- plot_synteny(rice_sorghum,
                        species_order = c("Rice", "Sorghum"),
                        ribbon_fill    = "source_chr",   # colour by rice chromosome
                        ribbon_palette = ribbons,
                        ribbon_alpha   = 0.6,
                        chr_palette    = ibex$black,
                        chr_color      = "white",
                        label_size = 4, species_label_size = 5) +
  theme(text = element_text(family = "IBM Plex Mono", face = "bold"),
        plot.margin = margin(0, 10, 0, 70))

save_plot(synteny, "plots/synteny.png", width = 6, height = 3.6)
save_plot(synteny, "plots/synteny_mini.png", width = 7, height = 2.9)
