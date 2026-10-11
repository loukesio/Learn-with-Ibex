# From scripts to a pipeline · Instagram carousel (nf-core, part 1)

9 square slides (1080×1080) that walk through turning a folder of bash and Python scripts into a Nextflow pipeline
on the nf-core template, following the GCB 2025 workshop by QBiC ([qbic-projects/gcb-2025-scripts-to-pipeline](https://github.com/qbic-projects/gcb-2025-scripts-to-pipeline), MIT).
Every console panel is real output; the commands were run on a throwaway pipeline called `ibexvcf`.

```
outputs/      trimmed console output per slide (tree_before, tree_after, install, create, modules, subworkflow, module, run, lint)
pipeline/     the ibexvcf pipeline as it was after step 7 (template files + the edits made on the slides)
logos/        nf-core logo (MIT, nf-core/logos)
slides/       slide-01..09.png
```


## Reproduce the pipeline

```bash
conda create -n nf-core nf-core nextflow && conda activate nf-core        # nf-core 4.1.0, Nextflow 26.04.7
nf-core pipelines create --name ibexvcf --description "Filter somatic VCFs and convert them to MAF" --author "Your Name"
cd ibexvcf && git checkout dev
nf-core modules install bcftools/view
nf-core modules install vcf2maf
nf-core subworkflows create vcf_filter_convert --author @you         # then edit subworkflows/local/vcf_filter_convert/main.nf
nf-core modules create vcfstatsplot --author @you --label process_single --meta --empty-template
cp single_vcf_stats.py bin/ && chmod +x bin/single_vcf_stats.py     # then edit modules/local/vcfstatsplot/{main.nf,environment.yml}
nf-core modules containers create vcfstatsplot                       # builds Docker + Singularity images on Seqera Wave from environment.yml
nextflow run . -profile test -stub --outdir results
nf-core pipelines lint
```

Edits made by hand (all in `pipeline/`): `assets/schema_input.json` and the samplesheet (sample, vcf, index instead of fastq),
the samplesheet parsing in `subworkflows/local/utils_nfcore_ibexvcf_pipeline/main.nf`, `conf/modules.config` (bcftools args),
`conf/test.config` (two small VCFs and a genome from nf-core/test-datasets), `workflows/ibexvcf.nf` (subworkflow + module instead of FastQC).

Notes: the test profile points at a samplesheet inside `assets/`; a real nf-core pipeline would put it in nf-core/test-datasets.
The stub run does not execute bcftools, vcf2maf or the Python script, it only checks the wiring; `-profile test,docker` runs them for real
(vcf2maf needs a reference FASTA that matches the VCF). The console panels drop two Nextflow warnings that are unrelated to the pipeline.
