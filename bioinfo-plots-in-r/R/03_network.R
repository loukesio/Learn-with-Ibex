# 03 · ggraph — a protein–protein interaction style network
# install.packages(c("igraph", "tidygraph", "ggraph"))
source("R/theme_ibex.R")
library(igraph); library(tidygraph); library(ggraph)

set.seed(7)
g <- sample_pa(40, power = 1.1, m = 2, directed = FALSE) |>   # scale-free: a few hubs
  as_tbl_graph() |>
  mutate(degree = centrality_degree(),
         hub    = degree >= sort(degree, decreasing = TRUE)[4])

set.seed(3)
network <- ggraph(g, layout = "fr") +
  geom_edge_link(colour = ibex$black, alpha = 0.45, edge_width = 0.6) +
  geom_node_point(aes(size = degree, fill = hub), shape = 21,
                  colour = ibex$black, stroke = 1.4) +
  scale_fill_manual(values = c(`FALSE` = "white", `TRUE` = ibex$pink)) +
  scale_size(range = c(3, 13)) +
  labs(caption = "node size = degree · pink = hub") +
  theme_ibex() + theme(axis.line = element_blank(), axis.text = element_blank(),
                       axis.ticks = element_blank(), axis.title = element_blank())

save_plot(network, "plots/network.png")
save_plot(network + labs(caption = NULL), "plots/network_mini.png", width = 4.6, height = 3.2)
