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
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
PDBlist contents:
"
cat PDBlist.txt
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LAa.resfile.txt
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub.ctllog

{
/usr/bin/time -p ibrun -n 48 -o 0 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc0.6_bz0.6 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 0.6 \
	-coupled_moves::boltzmann_kt 0.6 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc0.6_bz0.6.outerr &

{
/usr/bin/time -p ibrun  -n 48 -o 48 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc1.2_bz1.2 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 1.2 \
	-coupled_moves::boltzmann_kt 1.2 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc1.2_bz1.2.outerr &

{
/usr/bin/time -p ibrun -n 48 -o 96 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc2.4_bz2.4 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc2.4_bz2.4.outerr &


{
/usr/bin/time -p ibrun -n 48 -o 144 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc1.2_bz0.6 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 1.2 \
	-coupled_moves::boltzmann_kt 0.6 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc1.2_bz0.6.outerr &




{
/usr/bin/time -p ibrun -n 48 -o 192 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc0.6_bz1.2 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 0.6 \
	-coupled_moves::boltzmann_kt 1.2 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc0.6_bz1.2.outerr &



{
/usr/bin/time -p ibrun -n 48 -o 240 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc2.4_bz1.2 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 2.4 \
	-coupled_moves::boltzmann_kt 1.2 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc2.4_bz1.2.outerr &



{
/usr/bin/time -p ibrun -n 48 -o 288 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 100 \
	-suffix _CM_mc1.2_bz2.4 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 1.2 \
	-coupled_moves::boltzmann_kt 2.4 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc1.2_bz2.4.outerr &

{
/usr/bin/time -p ibrun -n 48 -o 336 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 400 \
	-nstruct 100 \
	-suffix _CM_mc1_bz1_n400 \
	-ignore_unrecognized_res \
	-ignore_zero_occupancy false \
	-coupled_moves::mc_kt 1 \
	-coupled_moves::boltzmann_kt 1 \
	-coupled_moves::initial_repack false \
	-coupled_moves::fix_backbone false \
	-coupled_moves::bias_sampling true \
	-coupled_moves::bump_check true \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub_CM_mc1_bz1_n400.outerr &
wait




