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
#SBATCH -t 06:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=baldridge.kevin@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Pertuzumab-Engineeri       # Allocation name (req'd if you have more than 1)
module load remora
module list
pwd
date +%Y-%m-%d_%H:%S:%M

# Launch MPI code... 

pwd
export HPertEngr=$HOME/Pertuzumab-Engineering/
export WP=$WORK/PtzEng/
export SP=$SCRATCH/PtzEng/
cp -rnL $WP/data/2020-04-23_PyIgClassifyDB/database/ $SCRATCH
export ROSETTA3_DB=$SCRATCH/database
export LD_PRELOAD=/home1/apps/tacc-patches/python_cacher/myopen.so
#copy input PDBs and construct the pdblist 
cp -n  /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Arlx_0010.pdb.gz /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Frlx_0008.pdb.gz  /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Srlx_0008.pdb     /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Yrlx_0001.pdb.gz   .
ls *pdb.gz *pdb >PDBlist.txt


cp 	$WP/bin/resfiles/Lib1.resfile.txt \
	$WP/bin/resfiles/Lib2.resfile.txt \
	$WP/bin/resfiles/Lib3a.resfile.txt \
	$WP/bin/resfiles/Lib3b.resfile.txt \
	$WP/bin/resfiles/Lib3c.resfile.txt \
	$WP/bin/resfiles/Lib4a.resfile.txt \
	$WP/bin/resfiles/Lib4b.resfile.txt \
	$WP/bin/resfiles/Lib4c.resfile.txt \
	$WP/bin/resfiles/Lib5a.resfile.txt \
	$WP/bin/resfiles/Lib5b.resfile.txt \
	$WP/bin/resfiles/Lib5c.resfile.txt \
	.
export ROSETTA3_DB=$SCRATCH/database

cp $WP/bin/CM.S310SAFYsubshelling.sh .
chmod u+rwx CM.S310SAFYsubshelling.sh

/usr/bin/time -p ./CM.S310SAFYsubshelling.sh
