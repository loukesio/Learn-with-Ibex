# 01 · Biostrings — read a FASTA, slide a window, count letters
# BiocManager::install("Biostrings")
source("R/theme_seq.R")
library(Biostrings)

orfs <- readDNAStringSet(system.file("extdata", "someORF.fa", package = "Biostrings"))  # 7 yeast ORFs
efb1 <- orfs[[3]]                                             # YAL003W / EFB1, 2,987 bp
names(orfs)[3]

win <- 100
gc <- letterFrequencyInSlidingView(efb1, win, "GC", as.prob = TRUE)[, 1] * 100
gc_df <- data.frame(pos = seq_along(gc) + win / 2, gc = gc)
mean_gc <- 100 * letterFrequency(efb1, "GC", as.prob = TRUE)[[1]]
codons <- trinucleotideFrequency(efb1, step = 3)              # codon usage, in frame

gc_plot <- ggplot(gc_df, aes(pos, gc)) +
  geom_hline(yintercept = mean_gc, colour = ibex$grey, linetype = "dashed") +
  geom_line(colour = ibex$pink, linewidth = 0.8) +
  annotate("text", x = length(efb1), y = mean_gc, label = sprintf("mean %.0f%%", mean_gc), hjust = 1, vjust = -0.5,
           family = "Fira Sans", colour = "#666666", size = 3.6) +
  scale_x_continuous(labels = function(x) paste0(x / 1000, " kb"), expand = c(0.01, 0)) +
  labs(x = "position in EFB1 (YAL003W), S. cerevisiae", y = "GC content (%)",
       caption = sprintf("%d bp sliding window · %d codons", win, sum(codons))) +
  theme_seq()

save_plot(gc_plot, "plots/biostrings.png")
