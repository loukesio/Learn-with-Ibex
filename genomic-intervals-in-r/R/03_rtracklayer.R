# 03 · rtracklayer — files in, GRanges out: a narrowPeak (BED), a bigWig; and export() back to BED
source("R/00_data.R")
suppressPackageStartupMessages(library(plotgardenerData))
data(IMR90_ChIP_CTCF_signal)                                   # bedGraph-like data.frame, chr21:28.0–30.3 Mb

signal <- with(IMR90_ChIP_CTCF_signal, GRanges(as.character(chrom), IRanges(start, end), score = score,
                                               seqinfo = Seqinfo("chr21", 48129895)))   # bigWig needs chromosome lengths
export(signal, "data/IMR90_CTCF_chr21.bw")                    # write a bigWig ...
export(peaks,  "data/IMR90_CTCF_chr21_peaks.bed")              # ... and the peaks as plain BED

window <- GRanges("chr21", IRanges(28.15e6, 28.35e6))          # ADAMTS1 / ADAMTS5
sig_w  <- import("data/IMR90_CTCF_chr21.bw", which = window)   # read back only that window
pk_w   <- import("data/IMR90_CTCF_chr21_peaks.bed", which = window)

sig_df <- as.data.frame(sig_w)
rt_plot <- ggplot() +
  geom_segment(data = sig_df, aes(x = (start + end) / 2, xend = (start + end) / 2, y = 0, yend = score), colour = ibex$blu, linewidth = 0.25) +
  geom_rect(data = as.data.frame(pk_w), aes(xmin = start, xmax = end, ymin = -7, ymax = -2), fill = ibex$pink, colour = ibex$pink, linewidth = 0.5) +
  annotate("text", x = start(window), y = -4.5, label = "peaks.bed", hjust = 0, family = "Fira Sans", size = 3.2, colour = ibex$pink) +
  annotate("text", x = start(window), y = max(sig_df$score) * 0.92, label = "signal.bw", hjust = 0, family = "Fira Sans", size = 3.2, colour = ibex$blu) +
  scale_x_continuous(labels = function(x) sprintf("%.2f Mb", x / 1e6), expand = expansion(mult = 0.01)) +
  labs(x = "chr21 (hg19)", y = "CTCF signal",
       caption = sprintf("import(bw, which = window) → %s ranges · import(bed) → %d peaks", format(length(sig_w), big.mark = ","), length(pk_w))) +
  theme_seq() + theme(panel.grid.major.x = element_blank())

save_plot(rt_plot, "plots/rtracklayer.png", width = 6.4, height = 3.8)
cat(length(sig_w), "signal ranges,", length(pk_w), "peaks in window\n")
