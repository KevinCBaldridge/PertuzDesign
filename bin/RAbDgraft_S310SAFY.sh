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
echo "ROSETTA3_DB="${ROSETTA3_DB}
echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
PDBlist contents:
////////////////////////////////////////////////////////////////////////

"
cat PDBlist.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
common_flags_trials1-9.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat common_flags_trials1-9.txt

echo "
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
RAbDrlxLimit.resfile.txt contents:
////////////////////////////////////////////////////////////////////////

"
cat RAbDrlxLimit.resfile.txt

} &>./`date +%Y-%m-%d@%H:%M:%S`.Ptz.RAbDgraft_S310SAFY.ctllog


set -x 
{
/usr/bin/time -p ibrun $TACC_ROSETTA_BIN/antibody_designer*release \
        @common_flags_trials1-9.txt \
	-flip_HNQ \
	-resfile RAbDrlxLimit.resfile.txt \
	-ex1 -ex2 -extrachi_cutoff 0 \
	-use_input_sc \
	-l PDBlist.txt \
	-graft_design_cdrs H1 H2 \
	-seq_design_cdrs H1 H2 H4 \
	-suffix _RAbD_S310SAFY \
	-scorefile_format json \
	-out:pdb_gz \
	-out:level 200 \
        -nstruct 1000 
} &> `date +%Y-%m-%d@%H:%M:%S`.Ptz.RAbDgraft_S310SAFY.outerr
