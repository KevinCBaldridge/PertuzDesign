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
see each outerr file for resfile contents
////////////////////////////////////////////////////////////////////////

"
} &>./`date +%Y-%m-%d@%H:%M:%S`.PtzCMSeqonlyBackrub.ctllog


{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HAa.resfile.txt 

/usr/bin/time -p ibrun -n 48 -o 0 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_HAa_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HAa_n100.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////

"
cat PtzShotgun.HAb.resfile.txt 

/usr/bin/time -p ibrun -n 48 -o 48 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HAb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_HAb_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HAb_n100.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HHa.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 96 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HHa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_HHa_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HHa_n100.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HHb.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 144 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HHb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_HHb_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HHb_n100.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LAa.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 192 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_LAa_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LAa_n100.outerr &
{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LAb.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 240 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_LAb_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LAb_n100.outerr &
{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LH.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 288 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LH.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 100 \
	-nstruct 400 \
	-suffix _CM_LH_n100 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LH_n100.outerr &


wait


{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HAa.resfile.txt 

/usr/bin/time -p ibrun -n 48 -o 0 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_HAa_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HAa_n1000.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////

"
cat PtzShotgun.HAb.resfile.txt 

/usr/bin/time -p ibrun -n 48 -o 48 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HAb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_HAb_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HAb_n1000.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HHa.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 96 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HHa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_HHa_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HHa_n1000.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.HHb.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 144 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.HHb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_HHb_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.HHb_n1000.outerr &

{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LAa.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 192 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAa.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_LAa_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LAa_n1000.outerr &
{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LAb.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 240 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LAb.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_LAb_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LAb_n1000.outerr &
{
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
resfile contents:
////////////////////////////////////////////////////////////////////////
"
cat PtzShotgun.LH.resfile.txt 


/usr/bin/time -p ibrun -n 48 -o 288 $TACC_ROSETTA_BIN/coupled_moves*release \
	-l PDBlist.txt \
	-flip_HNQ \
	-resfile PtzShotgun.LH.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-coupled_moves::ntrials 1000 \
	-nstruct 400 \
	-suffix _CM_LH_n1000 \
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
} &> ./`date +%Y-%m-%d@%H:%M:%S`.PtzCM.LH_n1000.outerr &


wait


