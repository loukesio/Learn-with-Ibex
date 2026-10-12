# 02 · Forward pass: the untrained network already makes predictions, they are just bad
source("R/00_net.R")
run <- readRDS("plots/run.rds")
p0 <- boundary_plot(run$snaps[[1]], train_df) + theme(legend.position = "none")
save_plot(p0, "plots/forward.png", width = 6.4, height = 3.8)
