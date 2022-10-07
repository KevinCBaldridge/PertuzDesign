#!/bin/bash
#note that here you need environmental variables set for the 
#$WORK pertEngr directory ($WPertEngr) and same for home $HPertEngr or uncomment the line below
#	export WPertEngr=$WORK/Pertuzumab-Engineering/
#	export HPertEngr=$HOME/Pertuzumab-Engineering/

#enable command logging to trace what I've been doing fully and establish appropriate bracketing to catch everything in the log
set -x 
{

#first, let's go ahead and clean up the file, put only the B,E,F chains out, where B goes in one file and E/F go into another
#	awk '/^ATOM/{if (substr($0,22,1)=="B") print $0}' <$WPertEngr/data/2020-03-27_startingS310FstrucGen/1S78.pdb >$WPertEngr/data/2020-03-27_startingS310FstrucGen/Bchain_1S78.pdb
#	awk '/^ATOM/{if (substr($0,22,1)=="F"||substr($0,22,1)=="E") print $0}' <$WPertEngr/data/2020-03-27_startingS310FstrucGen/1S78.pdb >$WPertEngr/data/2020-03-27_startingS310FstrucGen/EFchains_1S78.pdb
#scoring function on starting structures, saving the rosetta built PDB
   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-27_startingS310FstrucGen/Bchain_1S78.pdb \
	-out:pdb -out:file:scorefile $WPertEngr/results/2020-03-27_gettinstarted/Bchain_score.sc \
	-ignore_unrecognized_res

   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-27_startingS310FstrucGen/EFchains_1S78.pdb \
	-out:pdb -out:file:scorefile $WPertEngr/results/2020-03-27_gettinstarted/EFchain_score.sc \
	-ignore_unrecognized_res

#relax the starting structures that have been passed through rosetta score_jd above
   ibrun $TACC_ROSETTA_BIN/relax*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s Bchain_1S78_0001.pdb \
	-out:pdb -out:file:scorefile $WPertEngr/results/2020-03-27_gettinstarted/BChain_relax_score.sc \
	-relax:constrain_relax_to_start_coords \
	-relax:coord_constrain_sidechains \
	-relax:ramp_constraints false \
	-ex1 -ex2 -use_input_sc -flip_HNQ -no_optH false \
	-use_input_sc \
	-ignore_unrecognized_res

   ibrun $TACC_ROSETTA_BIN/relax*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s EFchains_1S78_0001.pdb \
	-out:pdb -out:file:scorefile $WPertEngr/results/2020-03-27_gettinstarted/EFChain_relax_score.sc \
	-relax:constrain_relax_to_start_coords \
	-relax:coord_constrain_sidechains \
	-relax:ramp_constraints false \
	-ex1 -ex2 -use_input_sc -flip_HNQ -no_optH false \
	-use_input_sc \
	-ignore_unrecognized_res

} 1>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.1S78-prepForMut.log \
2>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.1S78-prepForMut.log
