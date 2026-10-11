# Shared data for the "Genomic intervals in R" carousel.
# Peaks: IMR-90 CTCF ChIP-seq, ENCODE ENCFF453XKM (optimal IDR thresholded peaks, hg19), chr21 only.
# Genes: TxDb.Hsapiens.UCSC.hg19.knownGene.   Signal tracks: plotgardenerData (IMR-90, chr21:28.0-30.3 Mb).
suppressPackageStartupMessages({
  library(GenomicRanges); library(rtracklayer); library(TxDb.Hsapiens.UCSC.hg19.knownGene); library(dplyr)
})
source("R/theme_seq.R")

narrow_cols <- c(signalValue = "numeric", pValue = "numeric", qValue = "numeric", peak = "integer")
peaks <- import("data/IMR90_CTCF_chr21.narrowPeak", format = "BED", extraCols = narrow_cols)   # 480 CTCF peaks
peaks$name <- sprintf("ctcf_%03d", seq_along(peaks))

txdb    <- TxDb.Hsapiens.UCSC.hg19.knownGene
chr21   <- GRanges("chr21", IRanges(1, 48129895))                 # hg19 length
seqlevels(chr21) <- "chr21"; seqlengths(chr21) <- 48129895
tx21    <- subsetByOverlaps(transcripts(txdb), chr21)
genes21 <- subsetByOverlaps(suppressMessages(genes(txdb)), chr21)
prom21  <- reduce(promoters(tx21, upstream = 2000, downstream = 200))   # one promoter per TSS cluster
exons21 <- reduce(subsetByOverlaps(exons(txdb), chr21))
