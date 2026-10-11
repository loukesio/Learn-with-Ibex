# 03 · blastar — fetch from NCBI, align, build a tree (github.com/loukesio/blastar)
# remotes::install_github("loukesio/blastar")
source("R/theme_seq.R")
library(blastar); library(Biostrings); library(dplyr)

# three PAH (phenylalanine hydroxylase) mRNAs shipped with the msa package; blastar can also
# fetch them straight from NCBI with fetch_metadata(accessions)
pah <- readDNAStringSet(system.file("examples", "exampleDNA.fasta", package = "msa"))
seqs <- data.frame(accession = sub("PAH_", "", names(pah)), sequence = as.character(pah))

res <- align_sequences(seqs, method = "pairwise", pairwise_type = "local", seq_indices = c(1, 2))  # human vs mouse, Smith–Waterman
res$pid                                                                                          # 87.7 % identity

p <- strsplit(as.character(pwalign::alignedPattern(res$alignment)), "")[[1]]
s <- strsplit(as.character(pwalign::alignedSubject(res$alignment)), "")[[1]]
win <- 50
ident <- data.frame(pos = seq_along(p), match = p == s) |>
  mutate(identity = 100 * stats::filter(match, rep(1 / win, win), sides = 2)) |>
  filter(!is.na(identity))

id_plot <- ggplot(ident, aes(pos, identity)) +
  geom_hline(yintercept = res$pid, colour = ibex$grey, linetype = "dashed") +
  geom_area(fill = ibex$blu, alpha = 0.15) +
  geom_line(colour = ibex$blu, linewidth = 0.8) +
  annotate("label", x = max(ident$pos), y = res$pid, label = sprintf("overall %.1f%%", res$pid), hjust = 1, vjust = 1.3,
           family = "Fira Sans", colour = "#444444", fill = "white", label.size = 0, size = 3.6) +
  scale_y_continuous(limits = c(65, 100)) +
  labs(x = "position in the local alignment (bp)", y = "identity (%)",
       caption = sprintf("human vs mouse PAH · Smith–Waterman · %d bp window", win)) +
  theme_seq()

save_plot(id_plot, "plots/blastar.png")
