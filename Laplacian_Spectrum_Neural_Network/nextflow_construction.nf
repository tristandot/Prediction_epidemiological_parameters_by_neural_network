#!/usr/bin/env nextflow

// Files paths must be changed accordingly

params.forestFile = '/pasteur/homes/tdot/results/forests_IcyTree_Original.nwk'
data_forest = file(params.forestFile)

params.info = '/pasteur/homes/tdot/results/subpopulations_original.txt'
trees_info = file(params.info)

params.design = '/pasteur/homes/tdot/results/design_original.txt'
parameters_data = file(params.design)

params.result = 'results' /*Results Folder*/
result = file(params.result)
result.with{mkdirs()}

params.step = 100


process filter_forest {


    input:
    file subpopulation from trees_info
    file forest from data_forest
    file parameters from parameters_data

    output:
    file 'filtered_forests_IcyTree.nwk' into data_forest_1
    file 'filtered_design.txt' into parameters
    file 'indices.txt' into indices


    shell:
    '''
    awk '$5 == "200"' < !{subpopulation} | cut -f1 -d$'\t' > indices.txt
    head -n 1 !{parameters} > filtered_design.txt
    awk -F '\t' 'NR==FNR {id[$1]; next} $1 in id' indices.txt !{parameters} >> filtered_design.txt
    awk '{ print $1 + 1 }' indices.txt > numberfile.txt
    awk 'NR == FNR {nums[$1]; next} FNR in nums' numberfile.txt !{forest} > filtered_forests_IcyTree.nwk
    '''
}


process generate_csv_parameters {

    input:
    file parameters from parameters

    output:
    file 'csv_parameters.csv' into final_parameters

    script:
    """
    text_to_csv.R parameters $parameters > csv_parameters.csv
    """

}

final_parameters.subscribe{
it->it.copyTo(result.resolve(it.name))
}


process generate_trees {

	//publishDir 'results/trees', mode: 'copy'

	input:
	file forest from data_forest_1
    val step from params.step


	output:
	file 'arbre_*' into trees mode flatten

	script:
	"""
    i=0
    awk '/;/{if ((NR+("'$step'"-1)-i) == "'$step'") {i=NR+("'$step'"-1); close("arbre_"NR-"'$step'"".nwk") ; f="arbre_"NR".nwk"}} {print >> f} ' < $forest
	"""
}


treesid=trees.map{it -> [it.baseName.split(/[_\.]/)[1], it]}

process generate_eigenValues {
 
	input:
	set val(id), file(tree) from treesid
    val step from params.step


	output:
	file 'data.csv' into final_data

	script:
	"""
	spectreR.R tree $tree id $id step $step > data.csv
	"""

}


//In order to test other graph embeddings (provided by the GEM packaging: https://github.com/palash1992/GEM), work in progress
/*
process generate_eigenMaps {

    input:
    set val(id), file(tree) from treesid
    val step from params.step

    output:
    file 'data2.csv' into final_data2

    script:
    """
    generate_embeddings.py @tree $tree @id $id @step $step > data2.csv
    """

}


collected2=final_data2
.collectFile(newLine: true)
*/


collected=final_data
.collectFile(newLine: true)

process sortfile {
    input:
    file csv from collected

    output:
    file 'final_data.csv' into sorted

    script:
    """
    sort -n -k 2 -t '"' ${csv} > final_data.csv
    """
}


sorted.subscribe{
it->it.copyTo(result.resolve(it.name))
}


