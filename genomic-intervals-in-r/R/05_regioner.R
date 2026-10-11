# 05 · regioneR — is the CTCF–promoter overlap more than chance? Permutation test.
source("R/00_data.R")
suppressPackageStartupMessages(library(regioneR))

# hg19 chr21: the first 9.41 Mb and the centromere are unassembled gaps; peaks can never fall there, so neither should random regions
universe <- GRanges("chr21", IRanges(c(9411194, 14338129), c(11188129, 48129895)))   # UCSC gap table, hg19
set.seed(21)
pt <- permTest(A = peaks, B = prom21, ntimes = 1000, genome = universe,
               randomize.function = randomizeRegions, evaluate.function = numOverlaps, verbose = FALSE)
r <- pt$numOverlaps
perm <- data.frame(n = r$permuted)

regioner_plot <- ggplot(perm, aes(x = n)) +
  geom_histogram(binwidth = 1, fill = ibex$light, colour = "white", linewidth = 0.3) +
  geom_vline(xintercept = r$observed, colour = ibex$pink, linewidth = 1.1) +
  annotate("text", x = r$observed, y = Inf, vjust = 1.4, hjust = 1.1, family = "Fira Sans", size = 3.6, colour = ibex$pink,
           label = sprintf("observed: %d", r$observed)) +
  annotate("text", x = mean(perm$n), y = Inf, vjust = 1.4, hjust = 0.5, family = "Fira Sans", size = 3.6, colour = "#555555",
           label = sprintf("random: %.0f ± %.0f", mean(perm$n), sd(perm$n))) +
  labs(x = "CTCF peaks overlapping a promoter", y = "permutations",
       caption = sprintf("1,000 permutations within assembled chr21 · z = %.1f · p = %s", r$zscore, format.pval(r$pval, digits = 2))) +
  theme_seq()

save_plot(regioner_plot, "plots/regioner.png", width = 6.4, height = 3.8)
print(r[c("observed", "zscore", "pval")])
