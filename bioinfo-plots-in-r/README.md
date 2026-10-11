# Bioinformatics plots in R · Instagram carousel

8 square slides (1080×1080) teaching six R packages: ggvolc, ggsynteny, ggraph, ggtree, ggiraph, patchwork.
Every plot is real R output; the slides are a static HTML page screenshotted with headless Chrome.

```
R/            one script per plot + theme_ibex.R (shared look)
plots/        rendered PNGs (6×4.2 in, 300 dpi) + pca_interactive.html
carousel/     slides.html (?s=N shows one slide), fonts/, logo, shoot.sh
output/       slide-01..08.png (1080×1080) + caption.txt
```

## Rebuild

```bash
Rscript R/render_all.R      # plots/*.png
carousel/shoot.sh           # output/slide-0N.png (1080×1080)
```

Needs R with ggvolc, ggsynteny, ggraph, tidygraph, igraph, ggtree, ape, ggiraph, patchwork, ragg,
and the IBM Plex Mono font installed system-wide. Anton / Archivo / Plex Mono for the slides are in `carousel/fonts/`.

## Data

| Slide | Data |
|---|---|
| ggvolc | `ggvolc::all_genes`, 4,857 yeast genes (DESeq2 output), labels: top 2 up + top 2 down |
| ggsynteny | `ggsynteny::rice_sorghum`, 100 blocks, 12 rice vs 10 sorghum chromosomes. Slide 3 shows the circular layout (`R/02b_synteny_circular.R`) with two rings computed from the block table: genes per 2 Mb window and log block score. Needs ggsynteny ≥ 0.5.0 (GitHub). The linear version is used in the patchwork slide. |
| ggraph | simulated scale-free network (`igraph::sample_pa`, 40 nodes, seed 7); hubs = top 4 by degree |
| ggtree | hand-written Newick for 8 Caprinae species (illustrative topology; node labels are illustrative bootstrap values) |
| ggiraph | simulated expression (24 samples, 500 genes, 150 responsive) then a real `prcomp` PCA |
| patchwork | the three plots above |

The design reference is `../design_handoff_bioinfo_carousel/`. Copy changes vs. that design: the ggvolc and
ggsynteny code uses the packages' real signatures, the synteny slide shows rice vs sorghum (the bundled data)
instead of ibex vs sheep, and the ggiraph tooltip is drawn inside the plot.
