# 06 · patchwork — compose Figure 1 with | and /
# install.packages("patchwork")
source("R/theme_ibex.R")
library(patchwork)

# re-use the plots from the earlier scripts
exists("volcano") || source("R/01_volcano.R")
exists("network") || source("R/03_network.R")
exists("synteny") || source("R/02_synteny.R")

figure1 <- (volcano | network) / synteny +
  plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(family = "IBM Plex Mono", face = "bold", size = 20))

save_plot(figure1, "plots/patchwork.png", width = 8, height = 8.8)
