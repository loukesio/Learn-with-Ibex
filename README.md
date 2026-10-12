<div align="center">

# Learn with Ibex

**Bioinformatics explained in comics and carousels. No jargon, no prior knowledge needed.**

<img src="nextflow-pipeline-factory/episodes/ep1/ep1-01-cover.jpg" width="420" alt="The Pipeline Factory, Episode 1">

</div>

---

## The Pipeline Factory: Nextflow for everyone

Nextflow runs data-analysis pipelines. This series explains it as a **factory**: stations do the work,
conveyor belts carry boxes of samples between them, and a manager makes sure every sample goes through every step.

Swipe through an episode below, or download the PDF.

| | Episode | What you will learn | |
|:-:|---|---|:-:|
| <img src="nextflow-pipeline-factory/episodes/ep1/ep1-01-cover.jpg" width="140"> | **Ep 1 · The factory** | What Nextflow is, and what each file in the project folder does | [Slides](nextflow-pipeline-factory/episodes/ep1) · [PDF](nextflow-pipeline-factory/episodes/ep1.pdf) |
| <img src="nextflow-pipeline-factory/episodes/ep2/ep2-01-cover.jpg" width="140"> | **Ep 2 · The box** | What a sample looks like inside Nextflow: `val`, `path` and `tuple` | [Slides](nextflow-pipeline-factory/episodes/ep2) · [PDF](nextflow-pipeline-factory/episodes/ep2.pdf) |
| <img src="nextflow-pipeline-factory/episodes/ep3/ep3-01-cover.jpg" width="140"> | **Ep 3 · The belts** | How data moves: normal belts, shelves and `.collect()` | [Slides](nextflow-pipeline-factory/episodes/ep3) · [PDF](nextflow-pipeline-factory/episodes/ep3.pdf) |

*More episodes coming: the control room (`nextflow.config`), the toolbox (`bin/`), and run & resume.*

### The factory at a glance

| In the factory | In Nextflow |
|---|---|
| Blueprint | `main.nf`: which steps run, in what order |
| Control room | `nextflow.config`: laptop or cluster, how much memory |
| Toolbox | `bin/`: your own Bash and R scripts |
| Raw materials | `data/`: your read files |
| Station | a **process**: one step that does one job |
| Conveyor belt | a **channel**: carries data between steps |
| Labelled box | one **sample**: its name plus its two read files |
| Shelf | a **value channel**: shared by every step, never used up |

---

## How a neural network learns

Is this DNA variant disease-causing? Four facts in, one probability out. Weights (as a video), forward pass, loss and backprop, learning rate, epochs (as a video), overfitting and early stopping, evaluation on unseen data.
The network is 70 lines of base R with no packages, in [`neural-network-learns/R/00_net.R`](neural-network-learns/R/00_net.R); every figure comes from that run.

<p align="center">
  <img src="neural-network-learns/slides/slide-01.png" width="200">
  <img src="neural-network-learns/slides/slide-02.png" width="200">
  <img src="neural-network-learns/slides/slide-07.png" width="200">
</p>

---

## Protein language models

ESM-2, ESMFold, pLDDT, AlphaFold 2 vs ESMFold on the same sequence, PyMOL in five lines, and ESM3 / AlphaFold 3.
Every structure is a real prediction or crystal structure rendered with open-source PyMOL; scripts, inputs and renders in [`protein-language-models/`](protein-language-models).

<p align="center">
  <img src="protein-language-models/slides/slide-01.png" width="200">
  <img src="protein-language-models/slides/slide-04.png" width="200">
  <img src="protein-language-models/slides/slide-05.png" width="200">
</p>

---

## Getting into nf-core (nf-core, part 2)

How a pipeline is proposed, reviewed, transferred and released inside nf-core, in seven steps, with screenshots of the real pages:
a proposal issue, the approval bot, a first-release pull request, a release with its DOI. Slides and sources in [`nf-core-getting-in/`](nf-core-getting-in).

<p align="center">
  <img src="nf-core-getting-in/slides/slide-01.png" width="200">
  <img src="nf-core-getting-in/slides/slide-03.png" width="200">
  <img src="nf-core-getting-in/slides/slide-08.png" width="200">
</p>

---

## From scripts to a pipeline (nf-core, part 1)

Seven commands that turn a folder of bash and Python scripts into a Nextflow pipeline on the nf-core template, after the GCB 2025 workshop by QBiC.
Every console panel is real nf-core tools output; the demo pipeline `ibexvcf` is in [`nf-core-scripts-to-pipeline/`](nf-core-scripts-to-pipeline).

<p align="center">
  <img src="nf-core-scripts-to-pipeline/slides/slide-01.png" width="200">
  <img src="nf-core-scripts-to-pipeline/slides/slide-03.png" width="200">
  <img src="nf-core-scripts-to-pipeline/slides/slide-07.png" width="200">
</p>

---

## Genomic intervals in R

Six packages that turn "where are my peaks?" into one line of code: GenomicRanges, plyranges, rtracklayer, GenomicFeatures, regioneR, plotgardener.
One dataset runs through every slide: IMR-90 CTCF peaks on chr21 (ENCODE) with hg19 gene models. Scripts and data in [`genomic-intervals-in-r/`](genomic-intervals-in-r).

<p align="center">
  <img src="genomic-intervals-in-r/slides/slide-01.png" width="200">
  <img src="genomic-intervals-in-r/slides/slide-03.png" width="200">
  <img src="genomic-intervals-in-r/slides/slide-07.png" width="200">
</p>

---

## AI in R, no Python

Six packages to chat, label, search and test with language models from R: ellmer, mall, ragnar, ollamar, btw, vitals.
Every output came from a local model through Ollama. Scripts and captured outputs in [`ai-in-r/`](ai-in-r).

<p align="center">
  <img src="ai-in-r/slides/slide-01.png" width="200">
  <img src="ai-in-r/slides/slide-02.png" width="200">
  <img src="ai-in-r/slides/slide-07.png" width="200">
</p>

---

## Sequence analysis in R

Six packages that take you from a FASTA file to a genome-browser view: Biostrings, blastar, msa, GenomicRanges, GenomicAlignments, Gviz.
Scripts and data notes in [`seq-analysis-in-r/`](seq-analysis-in-r).

<p align="center">
  <img src="seq-analysis-in-r/slides/slide-01.png" width="200">
  <img src="seq-analysis-in-r/slides/slide-04.png" width="200">
  <img src="seq-analysis-in-r/slides/slide-07.png" width="200">
</p>

---

## Bioinformatics plots in R

Six R packages that turn tables of genes into figures: ggvolc, ggsynteny, ggraph, ggtree, ggiraph, patchwork.
Every plot is real R output, and the scripts are in [`bioinfo-plots-in-r/`](bioinfo-plots-in-r).

<p align="center">
  <img src="bioinfo-plots-in-r/slides/slide-01.png" width="200">
  <img src="bioinfo-plots-in-r/slides/slide-02.png" width="200">
  <img src="bioinfo-plots-in-r/slides/slide-05.png" width="200">
</p>

[Slides and code](bioinfo-plots-in-r)

---

## The full comic

Prefer one long story? The original 12-page comic covers the same ideas in one go.

<p align="center">
  <img src="nextflow-pipeline-factory/comic/01-cover.jpg" width="240">
  <img src="nextflow-pipeline-factory/comic/05-channel-async.jpg" width="240">
  <img src="nextflow-pipeline-factory/comic/07-queue-vs-value.jpg" width="240">
</p>

[All pages](nextflow-pipeline-factory/comic) · [Download PDF](nextflow-pipeline-factory/comic/the-pipeline-factory.pdf)

---

## The real pipeline

Everything in the comics is real code. [`nextflow-pipeline-factory/pipeline/`](nextflow-pipeline-factory/pipeline) is a small RNA-seq pipeline:

```
FASTQC        checks read quality
SALMON_INDEX  builds a gene map
QUANT         counts reads per gene        (bin/run_salmon.sh)
DESEQ2        compares the groups          (bin/deseq2.R)
```

Put your files in `data/` (`S1_R1.fastq.gz`, `S1_R2.fastq.gz`, …, `transcripts.fa.gz`, `samples.csv`), then:

```bash
cd nextflow-pipeline-factory/pipeline
nextflow run main.nf -profile docker      # or: standard (conda), slurm (cluster)
nextflow run main.nf -profile docker -resume   # after a crash: only unfinished steps run again
```

---

<div align="center">

**Follow on GitHub for more: [github.com/loukesio](https://github.com/loukesio)**

</div>
