#!/usr/bin/env nextflow

ch_hel = Channel.of('Bonjour', 'Ciao', 'Hello', 'Hola')

process sayHello {
  input: 
    val x
	path index
  output:
    stdout
  script:
    """
    echo '$x world!'
    wc $index
    """
}

workflow {
  sayHello(ch_hel, params.genome_index) | view
}
