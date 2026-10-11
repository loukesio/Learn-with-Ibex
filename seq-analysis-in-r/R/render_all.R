# Run from seq-analysis/:  Rscript R/render_all.R
for (f in c("01_biostrings", "02_msa", "03_blastar", "04_granges", "05_alignments", "06_gviz")) {
  cat("==", f, "\n"); source(file.path("R", paste0(f, ".R")))
}
