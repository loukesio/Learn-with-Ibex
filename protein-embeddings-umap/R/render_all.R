for (f in c("01_vector", "02_residues", "03_pca", "04_umap", "05_neighbours", "06_position", "07_settings", "08_results")) { cat("==", f, "\n"); source(file.path("R", paste0(f, ".R"))) }
