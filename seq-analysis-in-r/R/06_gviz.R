# 06 · Gviz — a genome-browser view from R: axis, genes, CpG islands, highlight
# BiocManager::install("Gviz")
source("R/theme_seq.R")
library(Gviz)
data(geneModels); data(cpgIslands)        # chr7:26.5–27.0 Mb, hg19

axis <- GenomeAxisTrack(fontfamily = "Fira Sans", col = "#111111", fontcolor = "#111111", cex = 1)
genes <- GeneRegionTrack(geneModels, genome = "hg19", chromosome = "chr7", name = "genes",
                         transcriptAnnotation = "symbol", collapseTranscripts = "meta", just.group = "above", shape = "box",
                         fill = ibex$black, col = NA, col.line = "#111111",
                         fontfamily = "Fira Sans", fontcolor.group = "#111111", fontsize.group = 15,
                         background.title = "white", col.title = "#111111", fontfamily.title = "Fira Sans", cex.title = 1)
cpg <- AnnotationTrack(cpgIslands, name = "CpG", fill = ibex$pink, col = NA,
                       background.title = "white", col.title = "#111111", fontfamily.title = "Fira Sans", cex.title = 1)
hl <- HighlightTrack(trackList = list(genes, cpg), start = 26.59e6, end = 26.66e6, chromosome = "chr7",
                     fill = ibex$rosa, col = NA, alpha = 0.35)

ragg::agg_png("plots/gviz.png", width = 6.4, height = 4.2, units = "in", res = 300, background = "white")
plotTracks(list(axis, hl), from = 26.55e6, to = 27.0e6, chromosome = "chr7",
           sizes = c(0.7, 1.6, 0.6), fontfamily = "Fira Sans", margin = 20, innerMargin = 8)
dev.off()
