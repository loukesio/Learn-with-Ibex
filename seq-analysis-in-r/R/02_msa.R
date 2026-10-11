# 02 · msa — multiple sequence alignment, drawn as a tile map
# BiocManager::install("msa")
source("R/theme_seq.R")
library(msa); library(Biostrings); library(dplyr); library(tidyr)

hb <- readAAStringSet(system.file("examples", "HemoglobinAA.fasta", package = "msa"))  # 17 alpha-globins
names(hb) <- sub("HBA1_", "", names(hb)) |> gsub(pattern = "_", replacement = " ")
aln <- msa(hb, method = "ClustalW")                                      # runs locally, < 1 s

mat <- as.matrix(unmasked(aln))
cons <- msaConsensusSequence(aln)
groups <- c(G = "small", A = "small", S = "small", T = "small", P = "small",
            C = "sulfur", M = "sulfur",
            D = "acidic", E = "acidic", N = "amide", Q = "amide",
            K = "basic", R = "basic", H = "basic",
            F = "aromatic", Y = "aromatic", W = "aromatic",
            V = "hydrophobic", L = "hydrophobic", I = "hydrophobic")
window <- 1:60
tiles <- as.data.frame(mat[, window]) |>
  mutate(species = rownames(mat)) |>
  pivot_longer(-species, names_to = "col", values_to = "aa") |>
  mutate(pos = rep(window, times = nrow(mat)), group = ifelse(aa == "-", "gap", groups[aa]),
         species = factor(species, levels = rev(rownames(mat))))

pal <- c(small = "#F5C400", sulfur = "#A8CF6A", acidic = "#E8197F", amide = "#F2C9D8",
         basic = "#2E7DBE", aromatic = "#1A8C8F", hydrophobic = "#BFD4DC", gap = "white")

msa_plot <- ggplot(tiles, aes(pos, species, fill = group)) +
  geom_tile(colour = "white", linewidth = 0.3) +
  geom_text(aes(label = aa), family = "Fira Sans", size = 2.3, colour = "#111111") +
  scale_fill_manual(values = pal, breaks = names(pal)[1:7]) +
  scale_x_continuous(expand = c(0, 0), breaks = seq(10, 60, 10)) +
  labs(x = "alignment column", y = NULL, caption = sprintf("ClustalW · %d sequences · columns 1–60 of %d", nrow(mat), ncol(mat))) +
  theme_seq() + theme(panel.grid = element_blank(), axis.text.y = element_text(size = 8, face = "italic"),
                      legend.key.size = unit(10, "pt"))

save_plot(msa_plot, "plots/msa.png", width = 6.4, height = 4.6)
