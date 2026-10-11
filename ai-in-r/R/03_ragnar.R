# 03 · ragnar — retrieval-augmented generation over your own documents
# install.packages("ragnar")  ·  ollama pull nomic-embed-text
library(ragnar)

embed <- function(x) embed_ollama(x, model = "nomic-embed-text")
store <- ragnar_store_create("outputs/pipeline-factory.duckdb", embed = embed, overwrite = TRUE)

md     <- paste(readLines("../../Learn-with-Ibex/README.md"), collapse = "\n")   # "The Pipeline Factory": Nextflow as a factory
doc    <- MarkdownDocument(md, origin = "README.md")       # ragnar_read() does the same for PDFs, HTML, docx via Python
chunks <- markdown_chunk(doc, target_size = 400)
ragnar_store_insert(store, chunks)
ragnar_store_build_index(store)

hits <- ragnar_retrieve(store, "What is a value channel?", top_k = 2)
cat("columns:", paste(names(hits), collapse = ", "), "\n")
txt <- gsub("\\s+", " ", hits$text[1])
at  <- regexpr("value channel", txt, ignore.case = TRUE)          # show the passage around the answer
excerpt <- if (at > 0) substr(txt, max(1, at - 90), at + 110) else substr(txt, 1, 200)
lines <- strwrap(paste0("...", excerpt, "..."), 46)
out <- c("> markdown_chunk(doc, target_size = 400)", sprintf("  %d chunks embedded with nomic-embed-text", nrow(chunks)), "",
         "> ragnar_retrieve(store, \"What is a value channel?\", top_k = 2)",
         sprintf("  #1  cosine distance %.2f · README.md", unlist(hits$cosine_distance)[1]), paste0("  ", lines))
writeLines(out, "outputs/ragnar.txt"); cat(out, sep = "\n")
