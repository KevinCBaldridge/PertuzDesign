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
cat PtzShotgun.LAa.RAbDnoNATRO.resfile.txt
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub.ctllog
{
/usr/bin/time -p ibrun -n 48 -o 0 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in5-KT2 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 5 \
	-outer_kt 2.0 \
	-inner_kt 2.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in5-KT2.outerr & 
{
/usr/bin/time -p ibrun -n 48 -o 48 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in5-KT1 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 5 \
	-outer_kt 1.0 \
	-inner_kt 1.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in5-KT1.outerr & 

{
/usr/bin/time -p ibrun -n 48 -o 96 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in3-KT2 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 3 \
	-outer_kt 2.0 \
	-inner_kt 2.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in3-KT2.outerr & 

{
/usr/bin/time -p ibrun -n 48 -o 144 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in3-KT1 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 3 \
	-outer_kt 1.0 \
	-inner_kt 1.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in3-KT1.outerr & 

{
/usr/bin/time -p ibrun -n 48 -o 192 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in1-KT1 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 1 \
	-outer_kt 1.0 \
	-inner_kt 1.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in1-KT1.outerr & 
{
/usr/bin/time -p ibrun -n 48 -o 240 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in1-KT1.5 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 1 \
	-outer_kt 1.5 \
	-inner_kt 1.5 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in1-KT1.5.outerr & 


{
/usr/bin/time -p ibrun -n 48 -o 288 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in1-KT2-seq5 \
	-seq_design_profile_samples 5 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 1 \
	-outer_kt 2.0 \
	-inner_kt 2.0 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in1-KT2-seq5.outerr & 

{
/usr/bin/time -p ibrun -n 48 -o 336 $TACC_ROSETTA_BIN/antibody_designer*release \
	@commonflagsKCB.txt \
	-l PDBlist.txt \
	-cdr_instructions seqonly.cdr \
	-random_start 0 \
	-resfile PtzShotgun.LAa.RAbDnoNATRO.resfile.txt \
	-extrachi_cutoff 0 \
	-suffix _RAbD_in1-KT1.5-seq5 \
	-seq_design_profile_samples 5 \
	-outer_cycle_rounds 100 \
	-inner_cycle_rounds 1 \
	-outer_kt 1 \
	-inner_kt 1 \
	-nstruct 100 
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzRabdSeqonlyBackrub_in1-KT1-seq5.outerr & 
wait
