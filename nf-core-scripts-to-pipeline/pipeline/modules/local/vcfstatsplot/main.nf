process VCFSTATSPLOT {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine in ['singularity', 'apptainer'] && !task.ext.singularity_pull_docker_container
?         'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/bf/bfda6deaed916f55f16c6a5aaab4d83e4b38c0032d0b2e0ff8c17ad8c0c2ebc0/data'
:         'community.wave.seqera.io/library/python_pandas_numpy_matplotlib-base_pruned:68960cccb50bd6cd' }"

    input:
    tuple val(meta), path(vcf)

    output:
    tuple val(meta), path("*.png"), emit: plots
    tuple val("${task.process}"), val('python'), eval("python3 --version | sed 's/Python //'"), topic: versions, emit: versions_python

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    single_vcf_stats.py \\
        --vcf $vcf \\
        --out $prefix \\
        $args
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}_per_chrom.png ${prefix}_refalt_type.png
    """
}
