# 01 · ggvolc — volcano plot of a DESeq2 result table
# install.packages("ggvolc")  (CRAN)  ·  github.com/loukesio/ggvolc
source("R/theme_ibex.R")
library(ggvolc)

data(all_genes)   # 4,857 yeast genes, DESeq2 results() output

volcano <- ggvolc(all_genes,
                  fc = 1, p_value = 0.05,          # thresholds
                  label_top = 2, label_dir = "each", # 2 up + 2 down labelled
                  add_seg = TRUE,                  # dashed threshold lines
                  up_reg_color  = ibex$yellow,
                  down_reg_color = ibex$black,
                  not_sig_color = ibex$grey) +
  labs(x = "log2 fold change", y = "-log10 padj") +
  theme_ibex()

save_plot(volcano, "plots/volcano.png")

# smaller version for the patchwork slide (no axis titles)
volcano_mini <- volcano + labs(x = NULL, y = NULL) + theme(axis.text = element_blank(), axis.ticks = element_blank())
save_plot(volcano_mini, "plots/volcano_mini.png", width = 4.6, height = 3.2)
