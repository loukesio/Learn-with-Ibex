# 04 · ollamar — talk to local models through Ollama, no API key
# install.packages("ollamar")
library(ollamar)

models <- list_models()                       # what is installed on this laptop
reply  <- generate("phi3:mini", "Give the reverse complement of ATGGCCTAA. Reply with the sequence only.",
                   output = "text")
truth  <- as.character(Biostrings::reverseComplement(Biostrings::DNAString("ATGGCCTAA")))

out <- c("> list_models()", sprintf("  %-18s %s", models$name, models$size),
         "", "> generate(\"phi3:mini\", \"Reverse complement of ATGGCCTAA?\")",
         paste0("  ", strwrap(trimws(sub("(##|\n).*$", " …", gsub("[ \t]+", " ", reply))), 56)),
         "", "> reverseComplement(DNAString(\"ATGGCCTAA\"))  # Biostrings", paste0("  ", truth),
         if (grepl(truth, toupper(reply))) "  ✔ the model got it right" else "  ✘ the model got it wrong: always verify")
writeLines(out, "outputs/ollamar.txt"); cat(out, sep = "\n")
