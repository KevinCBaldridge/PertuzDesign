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

#SBATCH -J DIIRelax           # Job name
#SBATCH -o DIIRelax.o%j       # Name of stdout output file
#SBATCH -e DIIRelax.e%j       # Name of stderr error file
#SBATCH -p skx-normal          # Queue (partition) name
#SBATCH -N 4               # Total # of nodes 
#SBATCH -n 192              # Total # of mpi tasks
#SBATCH -t 08:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=baldridge.kevin@utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Pertuzumab-Engineeri       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date +%Y-%m-%d_%H:%S:%M

# Launch MPI code... 

# i realized the HPertEngr and WPertEngr variables aren't inheriting right, so let's set it here

export HPertEngr=$HOME/Pertuzumab-Engineering/
export WPertEngr=$WORK/Pertuzumab-Engineering/
cd $WPertEngr/results/2020-03-31_benchmarkingRelax

echo "working directory is now `pwd`"
$HPertEngr/bin/benchmarkingRelax_SKX-N4-n192.sh         # Use ibrun instead of mpirun or mpiexec

# ---------------------------------------------------
