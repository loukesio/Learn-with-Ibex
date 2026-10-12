for (f in c("01_network", "02_forward", "03_loss", "04_learning_rate", "05_overfit", "06_evaluate", "07_video")) { cat("==", f, "\n"); source(file.path("R", paste0(f, ".R"))) }
