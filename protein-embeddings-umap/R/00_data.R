# Shared data: ESM2-650M embeddings of transthyretin (UniProt P02766) missense variants, from the paper's repository
# (Lomoio et al., Bioinformatics Advances 2026, github.com/UgoLomoio/esm2_umap, MIT). One 1,280-number vector per variant: the
# representation of the mutated residue from the final layer ('representations' array, token = UniProt position). Note: the
# paper's code loads the 'embeddings' array instead, which is the average over all residues. Labels: ClinVar via EBI, as in the paper.
source("R/theme_seq.R"); library(dplyr)
# per variant: the 1,280 numbers of the MUTATED residue (final layer), exactly as the paper's text describes;
# dist_to_wt = Euclidean distance between that vector and the wild-type vector of the same residue
vec <- read.csv("data/ttr_residue_vectors.csv", check.names = FALSE)
X   <- as.matrix(vec[, -(1:5)]); rownames(X) <- vec$variant
lab <- factor(vec$label, levels = c("Benign", "Likely benign", "Likely pathogenic", "Pathogenic"))
wt_res <- read.csv("data/ttr_wt_residue_vectors.csv", check.names = FALSE)
cols <- c(Benign = ibex$teal, `Likely benign` = "#8FD0C8", `Likely pathogenic` = "#F39BC8", Pathogenic = ibex$pink)
pt <- function(p) p + scale_colour_manual(values = cols, drop = FALSE) +
  theme_seq() + theme(panel.grid = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), legend.position = "top") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 3)))
