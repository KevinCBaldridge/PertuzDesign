#!/bin/bash

#enable command logging to trace what I've been doing fully and establish appropriate bracketing to catch everything in the log
set -x 
export REMORA_PERIOD=120
bracketsstart=$SECONDS
{
echo "logging information: 

ROSETTA3_DB=$ROSETTA3_DB
"
echo "
 PDBlist.txt: 
"
cat PDBlist.txt
echo "
 flagfile contents: 
"
cat commonflagsKCB.txt
echo "
 cdr instruction file contents: 
"
echo "

filename:	$files 
"
cat seqonly.cdr

echo "
 resfile contents: 
"
cat PtzShotgun.LAa.resfile.txt
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub.ctllog
{
/usr/bin/time -p ibrun $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-outer_cycle_rounds 100 \
	-resfile PtzShotgun.LAa.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD \
	-nstruct 1000 



} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub.outerr 


