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

#SBATCH -J quickTestRelax           # Job name
#SBATCH -o quickTestRelax.o%j       # Name of stdout output file
#SBATCH -e quickTestRelax.e%j       # Name of stderr error file
#SBATCH -p normal          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes 
#SBATCH -n 68              # Total # of mpi tasks
#SBATCH -t 04:00:00        # Run time (hh:mm:ss)
#SBATCH --mail-user=kcb734@tacc.utexas.edu
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH -A Pertuzumab-Engineeri       # Allocation name (req'd if you have more than 1)

# Other commands must follow all #SBATCH directives...

module list
pwd
date +%Y-%m-%d_%H:%S:%M

# Launch MPI code... 
# first time I ran this with ibrun, but turns out that duh I don't need to run that script manyu times haha.

#second time i realized the HPertEngr and WPertEngr variables aren't inheriting right, so let's set it here

export HPertEngr=$HOME/Pertuzumab-Engineering/
export WPertEngr=$WORK/Pertuzumab-Engineering/

$HPertEngr/bin/1S78-prepForMut.sh         # Use ibrun instead of mpirun or mpiexec

# ---------------------------------------------------
