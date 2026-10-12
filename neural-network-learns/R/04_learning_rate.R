# 04 · Learning rate: same network, same data, three step sizes
source("R/00_net.R")
runs <- bind_rows(lapply(c(0.02, 0.5, 5), function(lr) train(train_df, val_df, lr = lr, epochs = 60)$hist |> mutate(lr = lr)))
runs$lr <- factor(runs$lr, labels = c("0.02 crawls", "0.5 just right", "5 jumps around"))
lr_plot <- ggplot(runs, aes(epoch, train_loss, colour = lr)) + geom_line(linewidth = 1.1) +
  scale_colour_manual(values = c(ibex$blu, ibex$pink, ibex$yellow)) +
  labs(x = "epoch", y = "training loss", caption = "weights move by  learning rate × gradient  at every iteration") +
  theme_seq() + guides(colour = guide_legend(nrow = 1, title = "learning rate", title.position = "left")) + theme(legend.title = element_text(face = "bold"))
save_plot(lr_plot, "plots/learning_rate.png", width = 6.4, height = 3.8)
