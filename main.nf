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

workflow {
  sayHello(ch_hel, params.genome_index) | view
}
