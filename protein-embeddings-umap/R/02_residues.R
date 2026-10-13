# 02 · Where the vector comes from: the model gives every residue its own 1,280 numbers; a variant changes the rows around it
source("R/00_data.R")
wt <- as.matrix(read.csv("data/ttr_residues_wt.csv", header = FALSE)); mu <- as.matrix(read.csv("data/ttr_residues_V50M.csv", header = FALSE))
seq <- paste(readLines("data/P02766.fasta")[-1], collapse = "")
shift <- sqrt(rowSums((mu - wt)^2))                              # how much each residue's vector moved when residue 50 changed
d <- data.frame(pos = seq_len(nrow(wt)), aa = strsplit(seq, "")[[1]], shift = shift)
res_plot <- ggplot(d, aes(pos, shift)) +
  geom_col(aes(fill = pos == 50), width = 0.8) +
  scale_fill_manual(values = c(`TRUE` = ibex$pink, `FALSE` = ibex$ice), guide = "none") +
  annotate("text", x = 50, y = max(shift), label = "residue 50: V → M", family = "Fira Sans", size = 3.4, hjust = -0.1, vjust = 0.5, colour = ibex$pink, fontface = "bold") +
  annotate("rect", xmin = 0.5, xmax = 20.5, ymin = 0, ymax = max(shift) * 0.08, fill = "#EEEEEE") +
  annotate("text", x = 10.5, y = max(shift) * 0.13, label = "signal peptide", family = "Fira Sans", size = 2.8, colour = "#888888") +
  labs(x = "residue (UniProt numbering, 147 aa)", y = "how far the residue's\nvector moved",
       caption = "the mutated residue moves most; the rest move a little") +
  theme_seq()
save_plot(res_plot, "plots/residues.png", width = 6.4, height = 3.4)
