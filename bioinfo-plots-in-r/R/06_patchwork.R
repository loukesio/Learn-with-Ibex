# 06 · patchwork — compose Figure 1 with | and /
# install.packages("patchwork")
source("R/theme_ibex.R")
library(patchwork)

# build the three panels (note: base R also has a dataset called `volcano`, so always source)
source("R/01_volcano.R"); source("R/03_network.R"); source("R/02b_synteny_circular.R")

figure1 <- ((volcano / network) | synteny_circle) +
  plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(family = "IBM Plex Mono", face = "bold", size = 20))

save_plot(figure1, "plots/patchwork.png", width = 10, height = 6.4)
