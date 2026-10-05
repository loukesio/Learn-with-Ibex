#!/usr/bin/env Rscript
# Plain R script. Args: samplesheet, then one Salmon output folder per sample.
suppressPackageStartupMessages({ library(tximport); library(DESeq2); library(ggplot2) })

args  <- commandArgs(trailingOnly = TRUE)
meta  <- read.csv(args[1])                     # sample,condition
dirs  <- args[-1]
files <- setNames(file.path(dirs, "quant.sf"), basename(dirs))
meta  <- meta[match(names(files), meta$sample), ]

txi <- tximport(files, type = "salmon", txOut = TRUE)
dds <- DESeqDataSetFromTximport(txi, colData = meta, design = ~ condition)
dds <- DESeq(dds)
res <- as.data.frame(results(dds))
write.csv(res, "deseq2_results.csv")

res$sig <- !is.na(res$padj) & res$padj < 0.05
p <- ggplot(res, aes(log2FoldChange, -log10(pvalue), colour = sig)) +
  geom_point(alpha = 0.6) + theme_minimal()
ggsave("volcano.png", p, width = 6, height = 5)
