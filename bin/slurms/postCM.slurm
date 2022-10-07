#!/bin/bash
#----------------------------------------------------
# Sample Slurm job script
#   for TACC Stampede2 KNL nodes
#
#   *** MPI Job on Normal Queue ***
# 
# Last revised: 20 Oct 2017
#
# Notes:
#
#   -- Launch this script by executing
#      "sbatch knl.mpi.slurm" on Stampede2 login node.
#
#   -- Use ibrun to launch MPI codes on TACC systems.
#      Do not use mpirun or mpiexec.
#
#   -- Max recommended MPI tasks per KNL node: 64-68
#      (start small, increase gradually).
#
#   -- If you're running out of memory, try running
#      fewer tasks per node to give each task more memory.
#
#----------------------------------------------------

#SBATCH -J PRsB1           # Job name
#SBATCH -o PRsB1.o%j       # Name of stdout output file
#SBATCH -e PRsB1.e%j       # Name of stderr error file
#SBATCH -p skx-normal          # Queue (partition) name
#SBATCH -N 8               # Total # of nodes 
#SBATCH -n 384              # Total # of mpi tasks
#SBATCH -t 02:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=baldridge.kevin@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Pertuzumab-Engineeri       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...
module load remora
module list
pwd
date +%Y-%m-%d_%H:%S:%M

# Launch MPI code... 

pwd
export WP=$WORK/PtzEng/
export SP=$SCRATCH/PtzEng/
cp -rnL $WP/data/2020-04-23_PyIgClassifyDB/database/ $SCRATCH
export ROSETTA3_DB=$SCRATCH/database
export LD_PRELOAD=/home1/apps/tacc-patches/python_cacher/myopen.so

#if [[ -a scorefilelist.txt ]] 
#then#
#	mv scorefilelist.txt scorefilelist.txt.`date +%N`
#fi

#ls *.sc >scorefilelist.txt
cp $WP/colKeys1.tsv . 
cp $WP/bin/python/postDesign.py .
cp $WP/bin/seqident.awk .
cp $WP/bin/postCMRAbD.sh .
/usr/bin/time -p postCMRAbD.sh ./scorefilelist.txt

cd $SP/results
zip -j 13July_allshotgun_R1_pdbsScores.zip 2020-07-13_allPtzShotgunCM/DII-Ptz_initrlx_0002*_[0-9][0-9][0-9][0-9].pdb 2020-07-13_allPtzShotgunCM/*sc
zip -j 13July_allshotgun_R1_stats.zip 2020-07-13_allPtzShotgunCM/DII-Ptz_initrlx_0002*_[0-9][0-9][0-9][0-9].stats
zip -j 13July_allshotgun_R1_fastas.zip 2020-07-13_allPtzShotgunCM/DII-Ptz_initrlx_0002*_[0-9][0-9][0-9][0-9].fasta

zip -j 22July_CMtoMuts_R1.pdbsScores.zip 2020-07-22_CMtoMuts/DII-*_[0-9][0-9][0-9][0-9].pdb 2020-07-22_CMtoMuts/*sc
zip -j 22July_CMtoMuts_R1.stats.zip 2020-07-22_CMtoMuts/DII-*_[0-9][0-9][0-9][0-9].stats
zip -j 22July_CMtoMuts_R1.fastas.zip 2020-07-22_CMtoMuts/DII-*_[0-9][0-9][0-9][0-9].fasta
