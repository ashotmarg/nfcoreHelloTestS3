#!/usr/bin/env nextflow

ch_hel = Channel.of('Bonjour', 'Ciao', 'Hello', 'Hola')

process sayHello {
  input: 
    val x
	path index
  output:
    stdout
  script:
  def args = task.ext.args ?: ''

    """
    echo '$args $x world!'
    wc $index
    """
}

process SAMTOOLS_VIEW_REGIONS {
    label 'process_low'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.21--h96c455f_1' :
        'quay.io/biocontainers/samtools:1.21--h96c455f_1' }"

    input:
    val x
 
    output:
    path  "versions.yml",                                           emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    //new_sample_name = sample_name + "_" + pos.gene
   
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """

}



workflow {
  sayHello(ch_hel, params.genome_index) | view
  SAMTOOLS_VIEW_REGIONS(ch_hel) | view
}
