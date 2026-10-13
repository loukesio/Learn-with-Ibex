# 05 · Exploring move 1: ask who is near whom. Cosine similarity between 16 variants' vectors, and the nearest neighbours of V50M
source("R/00_data.R"); library(tidyr)
cosm <- function(M) { n <- M / sqrt(rowSums(M^2)); n %*% t(n) }
S <- cosm(X)
nn <- sort(S["V50M", ], decreasing = TRUE)[2:6]
cat("nearest to V50M:", paste(names(nn), sprintf("(%.2f)", nn), collapse = ", "), "\n")
pick <- c("V50M", "V50A", "V50L", "L75P", "T69A", "G67R", "I104S", "I104T", "I104V", "E81K", "V142I", "T139M", "A117S", "G26S", "H110R", "Y134C")
pick <- pick[pick %in% rownames(X)]
d <- as.data.frame(as.table(S[pick, pick])); names(d) <- c("a", "b", "sim")
d$a <- factor(d$a, levels = pick); d$b <- factor(d$b, levels = rev(pick))
labs_of <- setNames(as.character(lab), vec$variant)
nb_plot <- ggplot(d, aes(a, b, fill = sim)) + geom_tile(colour = "white", linewidth = 0.4) +
  scale_fill_gradient(low = "white", high = ibex$pink, limits = c(0.75, 1), oob = scales::squish, name = "cosine\nsimilarity") +
  coord_fixed() + labs(x = NULL, y = NULL, caption = "same residue = near-identical vectors · label colour: pink pathogenic, teal benign") +
  theme_seq() + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = rel(0.8), colour = cols[labs_of[pick]]),
                      axis.text.y = element_text(size = rel(0.8), colour = cols[labs_of[rev(pick)]]), panel.grid = element_blank(), axis.line.x = element_blank(), axis.ticks = element_blank(),
                      legend.position = "right", legend.title = element_text(size = rel(0.8)), plot.margin = margin(2, 2, 2, 2))
save_plot(nb_plot, "plots/neighbours.png", width = 6.4, height = 3.6)
