process MODBAM2BED {
    label 'process_high'

    conda "epi2melabs::modbam2bed"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'ghcr.io/dhslab/docker-longread:latest' :
        'ghcr.io/dhslab/docker-longread:latest' }"

    input:
        tuple val(meta), path (haplotagged_bam)
        tuple val(meta), path (haplotagged_bam_index)
        path (reference_fasta)

    output:
        tuple val(meta), path ("*.bed")    , emit: bam
        path  ("versions.yml")             , emit: versions

    script:
    """
    /opt/conda/envs/modbam2bed/bin/modbam2bed \\
    -e \\
    --cpg \\
    --aggregate \\
    --mod_base 5mC \\
    -t ${task.cpus} \\
    -p ${meta.sample} \\
    $reference_fasta \\
    $haplotagged_bam \\
    > ${meta.sample}.cpg.stranded.bed

    /opt/conda/envs/modbam2bed/bin/modbam2bed \\
    -e \\
    --cpg \\
    --aggregate \\
    --mod_base 5mC \\
    --haplotype=1 \\
    -t ${task.cpus} \\
    -p ${meta.sample}_hap1 \\
    $reference_fasta \\
    $haplotagged_bam \\
    > ${meta.sample}.hap1.cpg.stranded.bed

    /opt/conda/envs/modbam2bed/bin/modbam2bed \\
    -e \\
    --cpg \\
    --aggregate \\
    --mod_base 5mC \\
    --haplotype=2 \\
    -t ${task.cpus} \\
    -p ${meta.sample}_hap2 \\
    $reference_fasta \\
    $haplotagged_bam \\
    > ${meta.sample}.hap2.cpg.stranded.bed

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modbam2bed: \$(/opt/conda/envs/modbam2bed/bin/modbam2bed --version)
    END_VERSIONS
    """

    stub:
    """
    cp /Users/mohamedmahgoub/Documents/Lab/dev/wgsnano/test/nf-core-wgsnano/test_data/stubs/modbam2bed/${meta.sample}*.bed .

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        modbam2bed: \$(/opt/conda/envs/modbam2bed/bin/modbam2bed --version)
    END_VERSIONS
    """


}
