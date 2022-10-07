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

#SBATCH -J relax           # Job name
#SBATCH -o relax.o%j       # Name of stdout output file
#SBATCH -e relax.e%j       # Name of stderr error file
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

# i realized the HPertEngr and WPertEngr variables aren't inheriting right, so let's set it here

pwd
export HPertEngr=$HOME/Pertuzumab-Engineering/
export WP=$WORK/PtzEng/
export SP=$SCRATCH/PtzEng/
#cd $WPertEngr/results/2020-04-15_retryingTrials4-9cont/
#cp $WPertEngr/data/2020-04-08_Classified-DII-Fab/DII-Fab-renum.pdb $SP/data/2020-06-02_freshstart/

#stage everything over from $WORK or $HOME filesystems as appropriate

cp $WP/bin/RelaxCrystalStrucs.sh .
cp $WP/bin/flagfiles/pareto_optimal_flags.txt .
cp $WP/data/2020-06-08_TruncAndRelax/DII-Ptz.pdb $WP/data/2020-06-08_TruncAndRelax/DIV-Tsz.pdb .
cp -rL $WP/data/2020-04-23_PyIgClassifyDB/database/ /tmp/
#cp $WORK/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351[SAFY].pdb.gz \
#   $WORK/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_T436A_D437A_N460[AVT]*pdb \
#  $SP/data/2020-06-02_freshstart/

#set environmental variables that subscripts will use
export ROSETTA3_DB=/tmp/database


export LD_PRELOAD=/home1/apps/tacc-patches/python_cacher/myopen.so
ls DI*pdb >PDBlist.start.txt
/usr/bin/time -p  RelaxCrystalStrucs.sh
mv $SP/results/2020-06-08_TruncAndRelax/ $WP/data/2020-06-08_TruncAndRelax/
#if [ $? == 0 ]
#then
# ---------------------------------------------------
#fi
