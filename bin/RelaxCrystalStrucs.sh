#!/bin/bash

#enable command logging to trace what I've been doing fully and establish appropriate bracketing to catch everything in the log
set -x 
export REMORA_PERIOD=120
{
##################################
#need to make the PDBlist.start.txt thing by truncating her2 for 1n8z and getting it through pyigclassify etc
##################################
echo "kcb:score the two incoming crystal structures 1S78 and 1N8Z that have truncated HER2"
remora   ibrun $TACC_ROSETTA_BIN/score_jd2.*release \
	-l PDBlist.start.txt \
	-out:no_nstruct_label \
	-suffix _init \
	-out:pdb

ls *_init.pdb >PDBlist.txt

#relax the starting structures that have been mutated
echo "kcb:executing relax for Fab-DII complexes of DIV-Tsz and DII-Ptz"
remora  ibrun $TACC_ROSETTA_BIN/relax*release \
	@pareto_optimal_flags.txt \
	-l PDBlist.txt \
	-suffix rlx \
	-nstruct 10 



mv PDBlist.txt PDBlist.rlxin.txt

bestPtz=$(cat scorerlx.sc |sed 's/"coord.*tot/"tot/'|tr ':' '        ' | tr ',' '    '|sort -h -k4|grep Ptz|cut -f2 |head -n 1)
bestTsz=$(cat scorerlx.sc |sed 's/"coord.*tot/"tot/'|tr ':' '        ' | tr ',' '    '|sort -h -k4|grep Tsz|cut -f2 |head -n 1)

Ptz1=${bestPtz#\"}
Ptz2=${Ptz1%\"}
Ptz3="./"${Ptz2}".pdb.gz"
echo $Ptz3 >PDBlist.txt
Tsz1=${bestTsz#\"}
Tsz2=${Tsz1%\"}
Tsz3="./"${Tsz2}".pdb.gz"
echo $Tsz3 >>PDBlist.txt

echo "relax is done now, inspect and move on to design stages with best(lowest) total score for Ptz and Tsz"
cat PDBlist.txt 

} &>./`date +%Y-%m-%d@%H:%M:%S`.Relax.outerr 


