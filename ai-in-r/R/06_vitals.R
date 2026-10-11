# 06 · vitals — evaluate an LLM on your own questions
# install.packages("vitals")
library(vitals); library(ellmer); library(tibble)
vitals_log_dir_set("outputs/vitals-logs")

qa <- tibble(
  input  = c("In DESeq2 output, what does padj stand for? Answer in three words.",
             "How many codons fit in a 300 bp open reading frame? Answer with a number.",
             "Which package fits a negative binomial model for RNA-seq: DESeq2 or ggplot2? Answer with the name.",
             "What base pairs with adenine in DNA? One word."),
  target = c("adjusted", "100", "DESeq2", "thymine"))

tsk <- Task$new(dataset = qa, name = "bio-qa",
                solver = generate(chat_ollama(model = "phi3:mini", system_prompt = "Answer as briefly as possible.")),
                scorer = detect_includes())
tsk$eval(view = FALSE)
res <- tsk$get_samples()
cat("columns:", paste(names(res), collapse = ", "), "\n")
short <- function(x, n) ifelse(nchar(x) > n, paste0(substr(x, 1, n - 1), "…"), x)
out <- c("> tsk$eval()   # solver phi3:mini · scorer detect_includes()",
         sprintf("  %-34s %-9s %s", "question", "target", "score"),
         sprintf("  %-34s %-9s %s", short(res$input, 34), res$target, as.character(res$score)),
         "", sprintf("  accuracy %.0f%%", 100 * mean(res$score == "C")))
writeLines(out, "outputs/vitals.txt"); cat(out, sep = "\n")
