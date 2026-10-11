# Run from the bioinfo-plots/ folder:  Rscript R/render_all.R
for (f in c("01_volcano", "02_synteny", "03_network", "04_tree", "05_pca", "06_patchwork")) {
  cat("==", f, "\n"); source(file.path("R", paste0(f, ".R")))
}
