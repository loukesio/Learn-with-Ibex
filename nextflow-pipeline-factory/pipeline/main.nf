#!/usr/bin/env nextflow
// main.nf = the BLUEPRINT: which stations exist, and in what order boxes travel between them.
// In Nextflow a station is called a "process". A conveyor belt is called a "channel".

// FASTQC station: checks the quality of each sample's reads.
process FASTQC {
    tag "$sample_id"
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)   // one box: the sample name + its two read files

    output:
    path "*_fastqc.{zip,html}"          // quality reports

    script:
    """
    fastqc -t ${task.cpus} ${reads}
    """
}

// SALMON_INDEX station: builds the lookup map of genes, once, from the gene sequences.
process SALMON_INDEX {
    input:
    path transcriptome                  // the gene sequences file

    output:
    path "salmon_index"                 // the finished gene map

    script:
    """
    salmon index -t ${transcriptome} -i salmon_index
    """
}

// QUANT station: for one sample, counts which gene each read belongs to.
// It calls our own script from the toolbox (bin/run_salmon.sh).
process QUANT {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)   // one box from the belt
    path index                          // the gene map, taken from the shelf

    output:
    path "${sample_id}"                 // a folder of gene counts for this sample

    script:
    """
    run_salmon.sh ${sample_id} ${index} ${reads[0]} ${reads[1]} ${task.cpus}
    """
}

// DESEQ2 station: compares the groups (e.g. healthy vs sick) using ALL samples at once.
// It calls our own R script from the toolbox (bin/deseq2.R).
process DESEQ2 {
    publishDir "${params.outdir}/deseq2", mode: 'copy'

    input:
    path quant_dirs                     // the whole tray: every sample's counts
    path samplesheet                    // which sample belongs to which group

    output:
    path "deseq2_results.csv"
    path "volcano.png"

    script:
    """
    deseq2.R ${samplesheet} ${quant_dirs}
    """
}

workflow {
    // This belt carries one box per sample: its name and its two read files,
    // e.g. ["S1", [S1_R1.fastq.gz, S1_R2.fastq.gz]]. If no file matches the pattern, Nextflow stops.
    reads_ch = channel.fromFilePairs(params.reads, checkIfExists: true)

    // The same belt feeds two stations: every box goes to FASTQC and to QUANT.
    FASTQC(reads_ch)

    // This holds the gene map. SALMON_INDEX gets one plain file (not a belt), so it runs once
    // and its map goes on a SHELF (a "value channel"): every sample can use it again and again.
    index_ch = SALMON_INDEX(file(params.transcriptome))

    // This belt carries one folder of gene counts per sample, in the order samples finish.
    counts_ch = QUANT(reads_ch, index_ch)

    // .collect() waits for every box and puts them all on one tray, so DESEQ2 runs once.
    DESEQ2(counts_ch.collect(), file(params.samplesheet))
}
