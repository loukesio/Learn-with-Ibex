# Genomic intervals in R · Instagram carousel

8 square slides (1080×1080) teaching six packages: GenomicRanges, plyranges, rtracklayer, GenomicFeatures, regioneR, plotgardener.
Every plot is real R output from one dataset; the slides are a static HTML page screenshotted with headless Chrome.

```
R/            00_data.R (shared data) + one script per plot + theme_seq.R (light, Fira Sans)
data/         IMR90_CTCF_chr21.narrowPeak (ENCODE ENCFF453XKM, hg19, chr21 only); the bigWig/BED written by 03 are not committed
plots/        rendered PNGs (6.4×3.8 in, 300 dpi)
logos/        hex stickers (© their authors): GenomicRanges, IRanges, plyranges, Bioconductor (BiocStickers repo), plotgardener (PhanstielLab)
slides/       slide-01..08.png
```

## Rebuild

```bash
Rscript R/render_all.R      # plots/*.png (run from this folder)
```

## Data

One dataset runs through all six slides: IMR-90 CTCF ChIP-seq peaks on chr21 (ENCODE `ENCFF453XKM`, optimal IDR thresholded peaks, hg19; 480 peaks)
plus hg19 gene models from `TxDb.Hsapiens.UCSC.hg19.knownGene` and the IMR-90 CTCF / H3K27ac signal and loop data shipped with `plotgardenerData` (chr21:28.0–30.3 Mb).

| Slide | Package | What it shows |
|---|---|---|
| 2 | GenomicRanges | shift, resize, flank, reduce, disjoin, gaps on four toy ranges |
| 3 | plyranges | `add_nearest_distance()`: distance of each peak to the nearest TSS |
| 4 | rtracklayer | `export()` the signal as bigWig and the peaks as BED, `import(which = window)` the ADAMTS1 locus back |
| 5 | GenomicFeatures | peaks in promoter / exon / intron / intergenic vs. the share of chr21 each category covers |
| 6 | regioneR | `permTest()`: 1,000 random placements within assembled chr21 (p-arm gap and centromere excluded) |
| 7 | plotgardener | genes, CTCF signal, peaks, H3K27ac signal, loops and a genome label on one page |

Packages: Bioconductor 3.22 builds of GenomicRanges 1.62, plyranges 1.28, rtracklayer 1.70, GenomicFeatures 1.62, regioneR 1.40, plotgardener 1.14; `org.Hs.eg.db` for gene symbols.
rtracklayer, GenomicFeatures and regioneR have no hex sticker, so their slides carry the Bioconductor hex.
