#!/bin/bash

#enable command logging to trace what I've been doing fully and establish appropriate bracketing to catch everything in the log
set -x 
{

#scoring function on starting structures, saving the rosetta built PDB
#note that the output PDB file will not have a 0001 added since this will basically be the start of things.
echo "executing score_jd2 for DII"
   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-28_tryDIIonly/DII.pdb \
	-out:path $WPertEngr/results/2020-03-31_benchmarkingRelax \
	-out:pdb -no_nstruct_label true \
	-suffix _N4-n256 \
	-ignore_unrecognized_res -overwrite

echo "executing score_jd2 for Fab"
   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-28_tryDIIonly/Fab_1S78.pdb \
	-out:path $WPertEngr/results/2020-03-31_benchmarkingRelax \
	-out:pdb -no_nstruct_label true \
	-suffix _N4-n256 \
	-ignore_unrecognized_res 

echo "executing score_jd2 for DII-Fab complex"
   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-31_benchmarkingRelax/DII-Fab.pdb \
	-out:path $WPertEngr/results/2020-03-31_benchmarkingRelax \
	-out:pdb -no_nstruct_label true \
	-suffix _N4-n256 \
	-ignore_unrecognized_res -mute core -mute basic

#build the PDB input file list for relax
#choosing to do it this way at this step, since maybe there is some optimization of run time by not reloading libraries?
cd $WPertEngr/data/data/2020-03-31_benchmarkingRelax/
ls *_N4-n256*pdb >PDBlist_N4-n256.txt


#relax the starting structures that have been passed through rosetta score_jd above
echo "executing relax for DII, Fab, and Fab-DII complex"
   ibrun $TACC_ROSETTA_BIN/relax*release -database $TACC_ROSETTA_DATABASE \
	@$HPertEngr/bin/flagfiles/pareto_optimal_flags.txt \
	-in:file:list PDBlist_N4-n256.txt \
	-in:path $WPertEngr/results/2020-03-31_benchmarkingRelax \
	-suffix _N4-n256 \
	-out:path $WPertEngr/results/2020-03-31_benchmarkingRelax 
	

} 1>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.benchmark_N64-n256.stdout \
2>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.benchmark_N64-n256.stderr

