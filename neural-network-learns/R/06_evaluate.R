# 06 · Evaluation: the test set is touched once, at the end
source("R/00_net.R")
run <- readRDS("plots/run.rds"); net <- run$net
p <- forward(net, as.matrix(test_df[, 1:2]))$p; pred <- as.integer(p > 0.5)
cm <- table(actual = factor(test_df$y, 0:1, c("A", "B")), predicted = factor(pred, 0:1, c("A", "B")))
acc <- mean(pred == test_df$y)
ev <- boundary_plot(net, test_df) + theme(legend.position = "none")
save_plot(ev, "plots/evaluate.png", width = 6.4, height = 3.8)
print(cm); cat(sprintf("test accuracy %.2f  train %.2f  val %.2f\n", acc, tail(run$hist$train_acc, 1), tail(run$hist$val_acc, 1)))
