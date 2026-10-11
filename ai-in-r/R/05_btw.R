# 05 · btw — describe your R session for an LLM (no model call needed)
# install.packages("btw")
library(btw)

genes <- tibble::tibble(gene = c("GCR1", "AGA2", "HSP26"), log2fc = c(2.24, 3.83, -2.21), padj = c(2.2e-25, 6.7e-23, 1.1e-19))
ctx <- btw(genes, "@platform_info", clipboard = FALSE)   # markdown ready to paste into any chat
txt <- strsplit(as.character(ctx), "\n")[[1]]
out <- c("> btw(genes, \"@platform_info\")", txt[seq_len(min(18, length(txt)))], "  ...")
writeLines(out, "outputs/btw.txt"); cat(out, sep = "\n")
