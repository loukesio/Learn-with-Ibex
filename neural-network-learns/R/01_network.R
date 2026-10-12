# 01 · The network itself, drawn from the real weights after training, plus one drawing per epoch for the video slide
source("R/00_net.R"); source("R/net_draw.R")
run <- train(train_df, val_df, epochs = 60); saveRDS(run, "plots/run.rds")
X <- standardise(train_df)
save_plot(draw_net(run$net, X), "plots/network.png", width = 9.6, height = 3.6)
dir.create("frames/net", showWarnings = FALSE, recursive = TRUE)
for (e in 0:60) save_plot(draw_net(run$snaps[[e + 1]], X, epoch = e), sprintf("frames/net/n%03d.png", e), width = 9.6, height = 3.6, dpi = 200)
