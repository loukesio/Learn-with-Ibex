# 06 · plotgardener — a genome-browser figure laid out on a page: genes, two signals, peaks, loops
source("R/00_data.R")
suppressPackageStartupMessages({library(plotgardener); library(plotgardenerData); library(org.Hs.eg.db)})
data(IMR90_ChIP_CTCF_signal); data(IMR90_ChIP_H3K27ac_signal); data(IMR90_DNAloops_pairs)

p <- pgParams(chrom = "chr21", chromstart = 28.0e6, chromend = 30.3e6, assembly = "hg19",
              x = 0.9, width = 5.3, default.units = "inches", fontfamily = "Fira Sans")
peaks_df <- as.data.frame(peaks)[, c("seqnames", "start", "end")]; names(peaks_df)[1] <- "chrom"

ragg::agg_png("plots/plotgardener.png", width = 6.4, height = 3.8, units = "in", res = 300, background = "white")
pageCreate(width = 6.4, height = 3.8, default.units = "inches", showGuides = FALSE)
plotGenes(params = p, y = 0.2, height = 0.55, fontcolor = c(ibex$black, ibex$black), fill = c(ibex$black, "#777777"), fontsize = 7)
plotText(label = "genes", x = 0.8, y = 0.47, just = "right", fontsize = 8, fontfamily = "Fira Sans")
plotSignal(data = IMR90_ChIP_CTCF_signal, params = p, y = 0.9, height = 0.55, linecolor = ibex$blu, fill = ibex$blu, scale = TRUE, fontsize = 6)
plotText(label = "CTCF", x = 0.8, y = 1.17, just = "right", fontsize = 8, fontfamily = "Fira Sans")
plotRanges(data = peaks_df, params = p, y = 1.52, height = 0.18, fill = ibex$pink, collapse = TRUE, boxHeight = unit(0.12, "inches"))
plotText(label = "CTCF peaks", x = 0.8, y = 1.61, just = "right", fontsize = 8, fontfamily = "Fira Sans")
plotSignal(data = IMR90_ChIP_H3K27ac_signal, params = p, y = 1.8, height = 0.55, linecolor = ibex$teal, fill = ibex$teal, scale = TRUE, fontsize = 6)
plotText(label = "H3K27ac", x = 0.8, y = 2.07, just = "right", fontsize = 8, fontfamily = "Fira Sans")
plotPairsArches(data = IMR90_DNAloops_pairs, params = p, y = 2.42, height = 0.7, fill = ibex$yellow, linecolor = "#C9A000", alpha = 0.6, flip = FALSE)
plotText(label = "loops", x = 0.8, y = 2.77, just = "right", fontsize = 8, fontfamily = "Fira Sans")
plotGenomeLabel(params = p, y = 3.18, length = 5.3, scale = "Mb", fontsize = 8)
plotText(label = "IMR-90 · ENCODE peaks + plotgardenerData signal · hg19", x = 0.9, y = 3.6, just = "left", fontsize = 7, fontcolor = "#666666", fontfamily = "Fira Sans")
invisible(dev.off())
