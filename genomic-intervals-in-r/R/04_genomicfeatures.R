# 04 · GenomicFeatures — promoters, exons, introns from a TxDb, then "where do the peaks land?"
source("R/00_data.R")

introns21 <- setdiff(reduce(tx21), exons21)                          # transcript body minus exons
where <- case_when(                                                  # first match wins
  countOverlaps(peaks, prom21)   > 0 ~ "promoter",
  countOverlaps(peaks, exons21)  > 0 ~ "exon",
  countOverlaps(peaks, introns21) > 0 ~ "intron",
  TRUE ~ "intergenic")
L <- 48129895
bp <- c(promoter = sum(width(prom21)), exon = sum(width(setdiff(exons21, prom21))),
        intron = sum(width(setdiff(introns21, union(prom21, exons21)))))
bp["intergenic"] <- L - sum(bp)

ann <- data.frame(where = names(bp),
                  peaks = as.numeric(table(factor(where, levels = names(bp)))) / length(peaks),
                  chr21 = bp / L) |>
  tidyr::pivot_longer(-where, names_to = "what", values_to = "frac") |>
  mutate(where = factor(where, levels = names(bp)),
         what = factor(what, levels = c("peaks", "chr21"), labels = c("CTCF peaks", "share of chr21")))

gf_plot <- ggplot(ann, aes(x = where, y = frac, fill = what)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.62) +
  geom_text(aes(label = scales::percent(frac, accuracy = 1)), position = position_dodge(width = 0.7), vjust = -0.4,
            family = "Fira Sans", size = 3.4) +
  scale_fill_manual(values = c(ibex$pink, ibex$light)) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.12))) +
  labs(x = NULL, y = NULL, caption = sprintf("%d CTCF peaks · promoter = 2 kb up, 200 bp down of a TSS · hg19", length(peaks))) +
  theme_seq() + theme(panel.grid.major.x = element_blank(), axis.line.x = element_blank(), axis.ticks.x = element_blank())

save_plot(gf_plot, "plots/genomicfeatures.png", width = 6.4, height = 3.8)
print(ann)
