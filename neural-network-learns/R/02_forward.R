# 02 · Forward pass: the untrained network already answers, just badly
source("R/00_net.R"); run <- readRDS("plots/run.rds")
save_plot(boundary_plot(run$snaps[[1]], train_df) + theme(legend.position = "none"), "plots/forward.png", width = 6.4, height = 3.8)
