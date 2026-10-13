# 06 · Exploring move 2: colour the map by something you already know. Here: where in the protein the variant sits
source("R/00_data.R")
d <- readRDS("plots/umap.rds"); d$pos <- vec$pos[match(d$variant, vec$variant)]
keep <- d$U1 < 20
pos_plot <- ggplot(d[keep, ], aes(U1, U2, colour = pos)) + geom_point(size = 2.6, alpha = 0.95) +
  scale_colour_gradientn(colours = c(ibex$teal, "#F5C400", ibex$pink), name = "residue") +
  labs(x = "UMAP 1", y = "UMAP 2", caption = "same map, coloured by residue number: little islands are neighbours in the sequence") +
  theme_seq() + theme(panel.grid = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), legend.position = "right")
save_plot(pos_plot, "plots/position.png", width = 6.4, height = 3.8)
# how much of the layout is position? correlation between UMAP coordinates and residue number
cat(sprintf("cor(U1, pos) = %.2f, cor(U2, pos) = %.2f\n", cor(d$U1[keep], d$pos[keep]), cor(d$U2[keep], d$pos[keep])))
