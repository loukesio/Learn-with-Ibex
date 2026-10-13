for (f in c("01_vector", "02_residues", "03_pca", "04_umap", "05_distance", "06_seeds", "07_results")) { cat("==", f, "\n"); source(file.path("R", paste0(f, ".R"))) }
