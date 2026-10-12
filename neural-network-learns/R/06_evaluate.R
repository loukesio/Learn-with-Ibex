# 06 · Evaluation: the test set is touched once, at the end
source("R/00_net.R"); run <- readRDS("plots/run.rds"); net <- run$net
p <- forward(net, standardise(test_df, train_df))$p; pred <- as.integer(p > 0.5)
cm <- table(actual = factor(test_df$y, 0:1, c("benign", "pathogenic")), predicted = factor(pred, 0:1, c("benign", "pathogenic")))
save_plot(boundary_plot(net, test_df, ref = train_df) + theme(legend.position = "none"), "plots/evaluate.png", width = 6.4, height = 3.8)
print(cm); cat(sprintf("test accuracy %.2f (%d wrong)  train %.2f  val %.2f\n", mean(pred == test_df$y), sum(pred != test_df$y), tail(run$hist$train_acc, 1), tail(run$hist$val_acc, 1)))
