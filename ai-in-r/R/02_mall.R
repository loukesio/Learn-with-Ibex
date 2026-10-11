# 02 · mall — run an LLM over a data-frame column
# install.packages("mall")
library(mall); library(dplyr)
llm_use("ollama", "phi3:mini", seed = 100, .silent = TRUE)

genes <- tibble::tibble(
  gene = c("GCR1", "AGA2", "HSP26", "TFC3", "SSA1"),
  description = c("Transcriptional activator of genes involved in glycolysis",
                  "Adhesion subunit of a-agglutinin of mating type a cells",
                  "Small heat shock protein with chaperone activity",
                  "Subunit of RNA polymerase III transcription initiation factor",
                  "ATPase involved in protein folding and nuclear localisation"))  # SGD summaries

labelled <- genes |>
  llm_classify(description, c("transcription", "chaperone", "cell adhesion"), pred_name = "role")

truth <- c("transcription", "cell adhesion", "chaperone", "transcription", "chaperone")   # from the SGD summaries
mark  <- ifelse(labelled$role == truth, "✔", "✘")
out <- c("> genes |> llm_classify(description, roles)",
         sprintf("%-6s %-30s %-14s", "gene", "description", "role"),
         sprintf("%-6s %-30s %-14s %s", labelled$gene, paste0(substr(labelled$description, 1, 29), "…"), labelled$role, mark),
         "", sprintf("  %d of %d match the curated role", sum(mark == "✔"), length(mark)))
writeLines(out, "outputs/mall.txt"); cat(out, sep = "\n")
