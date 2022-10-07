#!/bin/bash
cp -rnL $WP/data/2020-04-23_PyIgClassifyDB/database/ $SCRATCH
export ROSETTA3_DB=$SCRATCH/database

while read line
do
line2=${line##*/}
if [ ! -f "$line2" ]; then
echo "copying $line to `pwd`"
cp $line .
fi
done <PDBlist.txt


{
echo "ROSETTA3_DB="${ROSETTA3_DB}
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
PDBlist contents:
////////////////////////////////////////////////////////////////////////

"
cat PDBlist.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
common_flags_trials1-9.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat common_flags_trials1-9.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Lib1.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat Lib1.resfile.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Lib2.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat Lib2.resfile.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Lib3.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat Lib3.resfile.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Lib4.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat Lib4.resfile.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Lib5.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat Lib5.resfile.txt

} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY.ctllog


{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib1.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_Lib1_100tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib1_100trials.outerr

{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib2.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_Lib2_100tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib2_100trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib3.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_Lib3_100tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib3_100trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib4.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_Lib4_100tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib4_100trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib5.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_Lib5_100tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib5_100trials.outerr



{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib1.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_Lib1_1000tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib1_1000trials.outerr

{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib2.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_Lib2_1000tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib2_1000trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib3.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_Lib3_1000tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib3_1000trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib4.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_Lib4_1000tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib4_1000trials.outerr
{
/usr/bin/time -p ibrun  $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile Lib5.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_Lib5_1000tr \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.CM_S310SAFY_lib5_1000trials.outerr


