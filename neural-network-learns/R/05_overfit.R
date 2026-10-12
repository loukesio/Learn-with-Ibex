# 05 · Overfitting and early stopping: a wide network on a small training set, trained far too long
source("R/00_net.R")
small <- make_variants(40, seed = 7); val <- make_variants(100, seed = 8)
r <- train(small, val, hidden = 32, lr = 0.05, epochs = 600, batch = 10, seed = 3)
h <- r$hist |> filter(epoch >= 1) |> tidyr::pivot_longer(c(train_loss, val_loss), names_to = "set", values_to = "loss")
best <- which.min(r$hist$val_loss) - 1
ov_plot <- ggplot(h, aes(epoch, loss, colour = set)) + geom_line(linewidth = 1.1) +
  geom_vline(xintercept = best, linetype = "22", colour = ibex$black) +
  annotate("text", x = best + 12, y = max(h$loss) * 0.95, label = sprintf("early stopping: keep the weights\nfrom epoch %d, the best validation loss", best), family = "Fira Sans", size = 3.2, hjust = 0, vjust = 1) +
  scale_colour_manual(values = c(train_loss = ibex$teal, val_loss = ibex$pink), labels = c("training loss", "validation loss")) +
  labs(x = "epoch", y = "loss", caption = "40 training variants, 32 neurons: the network memorises noise") + theme_seq()
save_plot(ov_plot, "plots/overfit.png", width = 6.4, height = 3.8)
saveRDS(list(best = best, hist = r$hist), "plots/overfit.rds")
