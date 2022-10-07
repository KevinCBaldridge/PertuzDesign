#!/bin/bash
#note that here you need environmental variables set for the 
#$WORK pertEngr directory ($WPertEngr) and same for home $HPertEngr or uncomment the line below
#	export WPertEngr=$WORK/Pertuzumab-Engineering/
#	export HPertEngr=$HOME/Pertuzumab-Engineering/

#enable command logging to trace what I've been doing fully and establish appropriate bracketing to catch everything in the log
set -x 
{

#first, let's go ahead and clean up the file, put only the B,E,F chains out, where res 174-265 from chain B goes in one file and E/F go into another
#commented these out as they have been done in previous attempts or manually in the case of the DIIonly pdbfile
#   awk '/^ATOM/{if (substr($0,22,1)=="B") print $0}' <$WPertEngr/data/2020-03-27_startingS310FstrucGen/1S78.pdb >$WPertEngr/data/2020-03-27_startingS310FstrucGen/DII_1S78.pdb
#   awk '/^ATOM/{if (substr($0,22,1)=="F"||substr($0,22,1)=="E") print $0}' <$WPertEngr/data/2020-03-27_startingS310FstrucGen/1S78.pdb >$WPertEngr/data/2020-03-28_tryDIIonly/Fab_1S78.pdb
#scoring function on starting structures, saving the rosetta built PDB
   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-28_tryDIIonly/DII.pdb \
	-out:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:pdb \
	-ignore_unrecognized_res -overwrite

   ibrun $TACC_ROSETTA_BIN/score_jd2.*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/data/2020-03-28_tryDIIonly/Fab_1S78.pdb \
	-out:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:pdb \
	-ignore_unrecognized_res 

#relax the starting structures that have been passed through rosetta score_jd above
   ibrun $TACC_ROSETTA_BIN/relax*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s DII_0001.pdb \
	-in:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:pdb \
	-relax:constrain_relax_to_start_coords \
	-relax:coord_constrain_sidechains \
	-relax:ramp_constraints false \
	-ex1 -ex2 -use_input_sc -flip_HNQ -no_optH false \
	-use_input_sc \
	-ignore_unrecognized_res 

   ibrun $TACC_ROSETTA_BIN/relax*release -database $TACC_ROSETTA_DATABASE \
	-in:file:s $WPertEngr/results/2020-03-29_tryDIIonly/Fab_1S78_0001.pdb \
	-in:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:path $WPertEngr/results/2020-03-29_tryDIIonly \
	-out:pdb \
	-relax:constrain_relax_to_start_coords \
	-relax:coord_constrain_sidechains \
	-relax:ramp_constraints false \
	-ex1 -ex2 -use_input_sc -flip_HNQ -no_optH false \
	-use_input_sc \
	-ignore_unrecognized_res 

} 1>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.1S78-prepForMutDIIonly.log \
2>>$HPertEngr/doc/cmdlogs/`date +%Y-%m-%d@%H:%M:%S`.1S78-prepForMutDIIonly.log
