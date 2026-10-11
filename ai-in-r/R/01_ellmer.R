# 01 · ellmer — chat with any LLM from R; here a local model through Ollama
# install.packages("ellmer")  ·  ollama pull phi3:mini
library(ellmer)

chat <- chat_ollama(model = "phi3:mini",
                    system_prompt = "You are a concise bioinformatics tutor. Answer in one short sentence.")
answer <- chat$chat("What does a volcano plot show?", echo = FALSE)

# structured output: ask for a typed object, get a list back
type_de <- type_object(up = type_array(type_string()), down = type_array(type_string()))
de <- chat$chat_structured("In the yeast experiment GCR1 and AGA2 went up, while OPI10 and HSP26 went down.", type = type_de)

first <- sub("^((?:[^.]*\\.){1}).*$", "\\1", answer, perl = TRUE)   # keep the first sentence for the slide
out <- c("> chat$chat(\"What does a volcano plot show?\")", strwrap(first, 48), "  ...", "",
         "> chat$chat_structured(\"...GCR1 and AGA2 went up, while", "    OPI10 and HSP26 went down.\", type = type_de)",
         paste0("$up   ", paste(de$up, collapse = " ")), paste0("$down ", paste(de$down, collapse = " ")))
writeLines(out, "outputs/ellmer.txt"); cat(out, sep = "\n")
