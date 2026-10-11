# 04 · GenomicRanges — ranges, overlaps, and the one-liner that answers "which genes have a CpG island?"
# BiocManager::install(c("GenomicRanges", "Gviz"))   (Gviz only for its demo data)
source("R/theme_seq.R")
library(GenomicRanges); library(dplyr); library(ggrepel)
data(geneModels, package = "Gviz"); data(cpgIslands, package = "Gviz")   # chr7, hg19

genes <- geneModels |> group_by(gene, symbol, strand) |>
  summarise(start = min(start), end = max(end), .groups = "drop") |>
  with(GRanges("chr7", IRanges(start, end), strand = strand, symbol = symbol))

hits <- findOverlaps(cpgIslands, genes)                     # the core operation
cpg <- as.data.frame(cpgIslands) |> mutate(id = row_number(), overlaps = id %in% queryHits(hits))
gn  <- as.data.frame(genes) |> mutate(row = disjointBins(IRanges(start - 15000, end + 15000)), y = 1.6 + 0.45 * row)  # stack overlapping genes
pairs <- data.frame(cpg = queryHits(hits), gene = subjectHits(hits))

ranges_plot <- ggplot() +
  geom_segment(data = gn, aes(x = start, xend = end, y = y, yend = y), colour = ibex$black, linewidth = 5, lineend = "butt") +
  geom_text_repel(data = gn, aes(x = (start + end) / 2, y = y, label = symbol), direction = "x", nudge_y = 0.22, segment.colour = NA,
                  family = "Fira Sans", size = 3, fontface = "italic", min.segment.length = Inf) +
  geom_point(data = cpg, aes(x = (start + end) / 2, y = 1, colour = overlaps), size = 3) +
  scale_colour_manual(values = c(`TRUE` = ibex$pink, `FALSE` = ibex$grey), labels = c(`TRUE` = "inside a gene", `FALSE` = "intergenic")) +
  scale_y_continuous(breaks = c(1, 2.3), labels = c("CpG islands", "genes"), limits = c(0.6, 3.3)) +
  scale_x_continuous(labels = function(x) sprintf("%.2f Mb", x / 1e6)) +
  labs(x = "chr7 (hg19)", y = NULL,
       caption = sprintf("findOverlaps(): %d of %d CpG islands overlap %d genes", length(unique(pairs$cpg)), length(cpgIslands), length(unique(pairs$gene)))) +
  theme_seq() + theme(panel.grid.major.y = element_blank())

save_plot(ranges_plot, "plots/granges.png", width = 6.4, height = 3.6)
