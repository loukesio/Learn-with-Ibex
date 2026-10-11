# 04 · ggtree — an annotated phylogeny
# BiocManager::install("ggtree"); install.packages("ape")
source("R/theme_ibex.R")
library(ape); library(ggtree)

# Caprinae relationships (illustrative topology, node labels = bootstrap support)
tr <- read.tree(text = "((((Capra_ibex:1,Capra_sibirica:1)98:1.2,Capra_nubiana:2.2)100:1,(Capra_hircus:2.4,Capra_falconeri:2.4)91:1.8)87:2,((Ovis_aries:2,Ovis_ammon:2)99:3.2,Hemitragus_jemlahicus:5.2)76:1);")
tr$tip.label <- gsub("_", " ", tr$tip.label)

ibex_clade <- MRCA(tr, c("Capra ibex", "Capra nubiana"))
cat("ibex clade node:", ibex_clade, "\n")

tree <- ggtree(tr, size = 1.2, colour = ibex$black) +
  geom_hilight(node = ibex_clade, fill = ibex$pink, alpha = 0.25, extend = 4) +
  geom_tiplab(fontface = "bold.italic", family = "IBM Plex Mono", size = 4.6, offset = 0.15) +
  geom_point2(aes(subset = !isTip & label != ""), shape = 21, fill = ibex$black, size = 7) +
  geom_text2(aes(subset = !isTip & label != "", label = label), colour = "white",
             family = "IBM Plex Mono", fontface = "bold", size = 2.6) +
  labs(caption = "node labels = bootstrap support") +
  xlim(0, 10.5) +
  theme_tree() +
  theme(plot.caption = element_text(family = "IBM Plex Mono", face = "bold", hjust = 0, size = 11),
        plot.background = element_rect(fill = "white", colour = NA))

save_plot(tree, "plots/tree.png", width = 6, height = 4)
