# 03 · Loss: one number for "how wrong", here for the first 10 iterations of epoch 1 (batch by batch)
source("R/00_net.R")
set.seed(42); net <- init_net(); X <- as.matrix(train_df[, 1:2]); y <- train_df$y
idx <- sample(nrow(X)); steps <- data.frame()
for (k in 0:30) {
  if (k > 0) { b <- idx[((k - 1) %% 10) * 20 + 1:20]; fw <- forward(net, X[b, ]); g <- backward(net, X[b, ], y[b], fw)
               for (nm in names(net)) net[[nm]] <- net[[nm]] - 0.5 * g[[nm]] }
  steps <- rbind(steps, data.frame(iteration = k, loss = bce(forward(net, X)$p, y)))
}
loss_plot <- ggplot(steps, aes(iteration, loss)) +
  geom_vline(xintercept = c(10, 20, 30), linetype = "22", colour = "#BBBBBB") +
  annotate("text", x = c(5, 15, 25), y = max(steps$loss), label = c("epoch 1", "epoch 2", "epoch 3"), family = "Fira Sans", size = 3.4, colour = "#666666") +
  geom_line(colour = ibex$pink, linewidth = 1.1) + geom_point(colour = ibex$pink, size = 2) +
  labs(x = "iteration (one mini-batch of 20 points, one weight update)", y = "loss on all 200 points",
       caption = "binary cross-entropy: 0 would be perfect, 0.69 is a coin flip") + theme_seq()
save_plot(loss_plot, "plots/loss.png", width = 6.4, height = 3.8)
