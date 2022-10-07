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
#SBATCH -N 16               # Total # of nodes 
#SBATCH -n 768              # Total # of mpi tasks
#SBATCH -t 48:00:00        # Run time (hh:mm:ss)
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
export HPertEngr=$HOME/Pertuzumab-Engineering/
export WP=$WORK/PtzEng/
export SP=$SCRATCH/PtzEng/
cp -rnL $WP/data/2020-04-23_PyIgClassifyDB/database/ $SCRATCH
export ROSETTA3_DB=$SCRATCH/database
export LD_PRELOAD=/home1/apps/tacc-patches/python_cacher/myopen.so

#copy script and make sure its executable
cp -n $WP/bin/RAbDgraft_S310SAFY.sh .
chmod u+rwx ./RAbDgraft_S310SAFY.sh
#copy flagfile and resfile
cp -n $WP/bin/flagfiles/common_flags_trials1-9.txt .
cp -n $WP/bin/resfiles/RAbDrlxLimit.resfile.txt .

#copy input PDBs and construct the pdblist 
cp -n  /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Arlx_0010.pdb.gz /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Frlx_0008.pdb.gz  /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Srlx_0008.pdb     /work/02034/kcb734/stampede2/Pertuzumab-Engineering/data/2020-04-23_allPDBsSoFar/2020-04-09_repeat8apr/DII-Fab-renum_S351Yrlx_0001.pdb.gz   .
ls *pdb.gz *pdb >PDBlist.txt


/usr/bin/time -p  ./RAbDgraft_S310SAFY.sh 



if [[ -a scorefilelist.txt ]] 
then
	mv scorefilelist.txt scorefilelist.txt.`date +%N`
fi

ls *.sc >scorefilelist.txt
cp $WP/colKeys1.tsv . 
cp $WP/bin/python/postRAbD.py .
cp $WP/bin/seqident.awk .
cp $WP/bin/postCMRAbD.sh .
/usr/bin/time -p postCMRAbD.sh ./scorefilelist.txt
