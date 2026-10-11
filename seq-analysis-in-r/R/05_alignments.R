# 05 · GenomicAlignments — reads from a BAM, coverage in one call
# BiocManager::install(c("GenomicAlignments", "Rsamtools"))
source("R/theme_seq.R")
library(GenomicAlignments); library(Rsamtools); library(dplyr); library(patchwork)

bam <- system.file("extdata", "ex1.bam", package = "Rsamtools")   # 3,271 reads, 2 contigs
ga  <- readGAlignments(bam)
cov <- coverage(ga)$seq1                                           # per-base depth, Rle

region <- 1:500
cov_df <- data.frame(pos = region, depth = as.numeric(cov[region]))
reads <- as.data.frame(ga[seqnames(ga) == "seq1" & start(ga) < 500]) |>
  arrange(start) |> mutate(row = disjointBins(IRanges(start - 2, end + 2))) |> filter(row <= 18)

p_cov <- ggplot(cov_df, aes(pos, depth)) +
  geom_area(fill = ibex$teal, alpha = 0.9) +
  labs(y = "depth", x = NULL, caption = NULL) + theme_seq() +
  theme(axis.text.x = element_blank(), axis.line.x = element_blank(), axis.ticks.x = element_blank())
p_reads <- ggplot(reads) +
  geom_segment(aes(x = start, xend = end, y = row, yend = row, colour = strand), linewidth = 1.6, lineend = "butt") +
  scale_colour_manual(values = c(`+` = ibex$pink, `-` = ibex$blu), labels = c("+ strand", "− strand")) +
  scale_y_reverse() +
  labs(x = "position on seq1 (bp)", y = "reads", caption = sprintf("%d aligned reads · coverage(ga)", length(ga))) +
  theme_seq() + theme(axis.text.y = element_blank(), panel.grid.major.y = element_blank())

aln_plot <- (p_cov / p_reads) + plot_layout(heights = c(1, 1.5), guides = "collect") & coord_cartesian(xlim = c(1, 500)) & theme(legend.position = "top")
save_plot(aln_plot, "plots/alignments.png", width = 6.4, height = 4.4)
