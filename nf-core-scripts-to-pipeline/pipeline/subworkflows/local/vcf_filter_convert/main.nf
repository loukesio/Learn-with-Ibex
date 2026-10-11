//
// Filter a VCF to PASS variants, then convert it to MAF
//

include { BCFTOOLS_VIEW } from '../../../modules/nf-core/bcftools/view/main'
include { VCF2MAF       } from '../../../modules/nf-core/vcf2maf/main'

workflow VCF_FILTER_CONVERT {

    take:
    ch_vcf   // channel: [ val(meta), path(vcf), path(index) ]
    ch_fasta // channel: path(fasta)

    main:

    BCFTOOLS_VIEW ( ch_vcf, [], [], [] )          // was: filter.sh

    VCF2MAF ( BCFTOOLS_VIEW.out.vcf, ch_fasta, [] ) // was: convert.sh

    emit:
    vcf = BCFTOOLS_VIEW.out.vcf // channel: [ val(meta), path(vcf) ]
    maf = VCF2MAF.out.maf       // channel: [ val(meta), path(maf) ]
}
