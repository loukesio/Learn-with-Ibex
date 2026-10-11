# Run from genomic-ranges/:  Rscript R/render_all.R
for (f in c("01_granges", "02_plyranges", "03_rtracklayer", "04_genomicfeatures", "05_regioner", "06_plotgardener")) {
  cat("==", f, "\n"); source(file.path("R", paste0(f, ".R")))
}
