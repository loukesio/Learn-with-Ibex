# From protein to point cloud · Instagram carousel

10 square slides (1080×1080): what an embedding is, PCA and UMAP, and four exploration moves (nearest neighbours, colour by a known variable, vary seed and n_neighbors, train a probe). Vectors from the paper
**Lomoio, Mazza, Veltri, Guzzi (2026) "Interpretable classification of missense variants using ESM2 embeddings and UMAP", Bioinformatics Advances, doi:10.1093/bioadv/vbag288**.
No model was run: the ESM2-650M vectors come from the authors' repository ([UgoLomoio/esm2_umap](https://github.com/UgoLomoio/esm2_umap), MIT), protein transthyretin (UniProt P02766).

```
data/         P02766_esm2_umap.csv (the authors' variant list, ClinVar label, 10-D UMAP), 
              ttr_residue_vectors.csv (mutated-residue vector per variant, 134 × 1,280), ttr_wt_residue_vectors.csv (wild type, 147 × 1,280),
R/            00_data.R + one script per figure (01 vector tiles, 02 per-residue shift, 03 PCA, 04 UMAP, 05 cosine neighbours, 06 colour by residue, 07 seeds and n_neighbors, 08 the paper's Table 4)
plots/        the seven figures · renders/ the PyMOL cover (pymol/ttr.pml)
slides/       slide-01..10.png + caption.txt
```

## What is plotted

| Slide | Figure | Source |
|---|---|---|
| 2 | residue 50 vector, wild type vs V50M, 32×40 tiles | `representations[50]` of the wt and V50M files |
| 3 | per-residue shift caused by V50M | Euclidean distance between the two 147×1,280 matrices, row by row |
| 4, 5 | PCA (`prcomp`) and UMAP (`uwot`, n_neighbors 8, min_dist 0.4, correlation, as in the paper) of the 134 mutated-residue vectors | `ttr_residue_vectors.csv` |
| 6 | cosine similarity between 16 variants' vectors; nearest neighbours of V50M are V50L 0.93, V50G 0.92, V50A 0.90 | `ttr_residue_vectors.csv` |
| 7 | the same UMAP coloured by residue number | same |
| 8 | the same UMAP: seed 1, seed 2, n_neighbors 3, n_neighbors 40 | same |
| 9 | ROC-AUC per method, amyloidosis, held-out variants | the paper's Table 4 |

Notes. The paper's text says the per-variant feature is the final-layer vector of the mutated residue; its code loads the file's `embeddings`
array, which is the mean over residues. The slides follow the text. The three I104 variants (I104S, I104N, I104T, all pathogenic) are far outliers in every UMAP; slides 5 and 7 zoom
past them and say so. Labels: Benign 6, Likely benign 4, Likely pathogenic 17, Pathogenic 107 (the authors' table). Rebuild: `Rscript R/render_all.R; carousel/shoot.sh`.
