# PtzEng

This codebase is the basis for work I did while homebound during the COVID-19 pandemic as part of my work in Daniel Leahy's lab at The University of Texas at Austin on engineering Pertuzumab for modified specificity towards mutated HER2 in certain cancers. 
<br><br>Please note that results and my detailed notes on progress throughout the project are NOT included here as that data is still unpublished and therefore confidential.
<hr>
The software uses the Rosetta framework and specifically the RAbD package under Rosetta Commons. Please see the <a href="https://www.rosettacommons.org/docs/latest/application_documentation/antibody/RosettaAntibodyDesign">manual for RAbD on Rosetta Commons</a> for more information on that package, provided by Adolf-Bryfogle et al (<a href="http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006112">original publication</a>). Additionally, a number of python libraries are used for visualizing output from the RAbD algorithm. Additionally, it uses the relax and score_jd2 functions of Rosetta for the protein model preparation prior to antibody design stage, and the InterfaceAnalyzer tool from RosettaCommons (manual page <a href="https://www.rosettacommons.org/docs/latest/application_documentation/analysis/interface-analyzer">here</a>) for analyzing resultant structures. 
<hr>
The main directory contains a couple of files for reference about residue numbering and organization of other files, and these files may also be used by some of the other pre- and post-processing scripts. <br><br>
The bin directory contains the majority of the heavy-lifting, largely in bash and a subfolder containing the slurm batch submission scripts for the TACC scheduling on the remote HPC cluster, Stampede2. <br><br>
Additionally, there are a number of subdirectories (cdr_instructions, flagfiles, resfiles) that contain configuration files for Rosetta and the subdirectory for the Rosetta scripts themselves (rosetta_scripts)<br><br>
Lastly, python was also used for analysis and visualization of results from the design algorithms, these scripts are in the python subdirectory.
<hr>

