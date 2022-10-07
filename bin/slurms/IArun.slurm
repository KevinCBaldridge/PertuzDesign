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
#SBATCH -N 1               # Total # of nodes 
#SBATCH -n 48              # Total # of mpi tasks
#SBATCH -t 04:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=baldridge.kevin@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Pertuzumab-Engineeri       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...
module load remora
module list
pwd
date +%Y-%m-%d_%H:%S:%M

# Launch MPI code... 

#unrelated, but i'll move previous data into the work data folder

pwd
export HPertEngr=$HOME/Pertuzumab-Engineering/
export WP=$WORK/PtzEng/
export SP=$SCRATCH/PtzEng/
cp -rnL $WP/data/2020-04-23_PyIgClassifyDB/database/ $SCRATCH
export ROSETTA3_DB=$SCRATCH/database
export LD_PRELOAD=/home1/apps/tacc-patches/python_cacher/myopen.so
cp $WP/bin/python/postRAbD.py .
cp $WP/bin/seqident.awk .
cp $WP/bin/postCMRAbD.sh .
#cp $WP/data/2020-06-08_TruncAndRelax/2020-06-08_TruncAndRelax/PDBlist.txt .
#that PDBlist didn't come out right from previous script, so the PDBlist was made manually in this case
/usr/bin/time -p postCMRAbD.sh scorefilelist.txt
