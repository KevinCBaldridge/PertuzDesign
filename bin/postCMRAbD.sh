source ~/.bashrc
conda activate pandas1
cp $WP/bin/rosetta_scripts/IA.rst .
cp $WP/bin/python/postDesign.py .
cp $WP/bin/seqident.awk .

export timescriptstart=$SECONDS
declare -A outarray
#export cpu2count=$(expr $cpucount * 2)
######################################################
#the if block here checks for the passed argument
if [ -z "$1" ]
then
	echo "must pass scorefile list as argument"
	exit 2
fi
#=====================================================
#the if block here checks for the passed argument is help, only old style option single dash -h though...
if [[ $1 == "-h" ]]
then
	echo "help under construction ?"
	exit 3
fi
#=====================================================
#the if block here removes a previous pdb list if necessary
if [ -a pdblist*.txt ]
then
	rm pdblist.*.txt
fi
#=====================================================
#the if block here checks for the presence of colkeys file
#the if block here makes a tmp folder if necessary
if [ ! -d tmp/ ]
then
	mkdir tmp
fi
#=====================================================
#the if block here checks for the presence of colkeys file
if [ -a  colKeys1.tsv ]
then
	echo "found column key file, proceeding"
else
	echo "can't find column key file"
	exit 1
fi
#===========
if [[ -a PDBlist.txt ]] 
then
	mv PDBlist.txt PDBlist.txt.pregunzip`date +%N`
fi

if [[ -a dfSeq.agg.csv ]]
then
	mv dfSeq.agg.csv dfSeq.agg.csv.`date +%N`
fi


while read line
do



	if [ -a "${line##*/}_H.fa" ]
	then
		echo "removing ${line##*/}_H.fa"
		rm "${line##*/}_H.fa"
	fi
	if [ -a "${line##*/}_L.fa" ]
	then
		echo "removing ${line##*/}_L.fa"
		rm "${line##*/}_L.fa"
	fi
	lineline=${line%.sc}
	echo "decoyFilename,HchainSeq,H1seq,H2seq,H4seq,H3seq" >dfSeq_H.${lineline##*/}.csv
	echo "decoyFilename,LchainSeq,L1seq,L2seq,L4seq,L3seq" >dfSeq_L.${lineline##*/}.csv
	export i=1


	export timescorefloopstart=$SECONDS
	while read nextline
	do
#			#break down file name into two parts, path and decoy
		export pathname=${line%\/*}
		export decoyname=$(echo $nextline | tr -d '"'|tr -d '{' |tr ':' '	'|tr ',' '	' | cut -f2)
#			#specific to relax mode in RAbD, fix a naming discrepancy between PDBs and scorefiles
		if [[ $decoyname == *"pre_model_"* ]]
		then
			laterpart=${decoyname##pre_model_1}
			fullfilename=$pathname"/pre_model_1_"$laterpart".pdb"
		else
			fullfilename=$pathname"/"$decoyname".pdb"
		fi
#			#gunzip if necessary
		if [ -a "$fullfilename.gz" ]
		then
				gunzip "$fullfilename.gz" &
				echo "gunzipping $fullfilename.gz"
		fi

#			#echo the gunzipped, fixed name of the pdb full path into the PDBlist file
		echo $fullfilename >>PDBlist.txt
	done <"$line"
	wait
	export timegzdone=$SECONDS
	echo "time to do gzip loop for ${line##*/}:"`expr $timegzdone - $timescorefloopstart`

	#loop over it again to do the pdb2fasta conversion and dfSeq construction for later seqident and such
	while read nextline
	do
#			#break down file name into two parts, path and decoy
		export pathname=${line%\/*}
		export decoyname=$(echo $nextline | tr -d '"'|tr -d '{' |tr ':' '	'|tr ',' '	' | cut -f2)
#			#specific to relax mode in RAbD, fix a naming discrepancy between PDBs and scorefiles
		if [[ $decoyname == *"pre_model_"* ]]
		then
			laterpart=${decoyname##pre_model_1}
			fullfilename=$pathname"/pre_model_1_"$laterpart".pdb"
		else
			fullfilename=$pathname"/"$decoyname".pdb"
		fi


#			#ensure the file is there, do pdb2fasta conversion, choosing between Ptz and Tsz to pull out CDRs while creating H/L chain dfSeqs and fastas for align,seqident, and python
		if [ -a "$fullfilename" ]
		then
				if [[ $fullfilename == *"Ptz"* ]]
				then
				pdb2fasta.sh $fullfilename |awk -v fullname=$fullfilename -v scorefile=${line##*/} -v counter=${i} \
				'/chain H/{print  ">" fullname "_H" >>scorefile"_H.fa";getline;print substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5) substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5) substr($0,index($0,"RFTLS")+5,8) substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >>scorefile"_H.fa";print fullname"_H,"$0","substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5)","substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5)","substr($0,index($0,"RFTLS")+5,8)","substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >"tmp/dfSeq_H."scorefile".csv."counter};
				 /chain L/{print  ">" fullname "_L" >>scorefile"_L.fa";getline;print substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5) substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5) substr($0,index($0,"RFSGS")+5,6) substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >>scorefile"_L.fa"; print fullname"_L,"$0","substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5)","substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5)","substr($0,index($0,"RFSGS")+5,6)","substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >"tmp/dfSeq_L."scorefile".csv."counter};' &
				elif [[ $fullfilename == *"Tsz"* ]]
				then
				pdb2fasta.sh $fullfilename |awk -v fullname=$fullfilename -v scorefile=${line##*/} -v counter=${i} \
				 '/chain H/{print  ">" fullname "_H" >>scorefile"_H.fa" ;getline;print substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5) substr($0,index($0,"LEWVA")+5,(index($0,"YADSV")-index($0,"LEWVA"))-5) substr($0,index($0,"RFTIS")+5,8) substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >>scorefile"_H.fa";print fullname"_H,"$0","substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5)","substr($0,index($0,"LEWVA")+5,(index($0,"YADSV")-index($0,"LEWVA"))-5)","substr($0,index($0,"RFTIS")+5,8)","substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >"tmp/dfSeq_H."scorefile".csv."counter};
				 /chain L/{print  ">" fullname "_L" >>scorefile"_L.fa" ;getline;print substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5) substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5) substr($0,index($0,"RFSGS")+5,6) substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >>scorefile"_L.fa"; print fullname"_L,"$0","substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5)","substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5)","substr($0,index($0,"RFSGS")+5,6)","substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >"tmp/dfSeq_L."scorefile".csv."counter};' &
				else 
				echo "error with $fullfilename, does not match Tsz or Ptz"
				fi
			export i=$(expr $i + 1)
		else
			echo "cant find the pdb file"
			echo $fullfilename 
		fi
	done <"$line"
	wait
	export timepdb2fastadone=$SECONDS
	echo "time to do pdb2fasta conversions and  write to tempfiles for dfSeq.${lineline##*/}.csv:	"`expr $timepdb2fastadone - $timegzdone `







	for keyH in `ls tmp/dfSeq_H*csv.[1-9]*`
	do
		(cat $keyH >>dfSeq_H.${lineline##*/}.csv) && rm $keyH
	done

	for keyL in `ls tmp/dfSeq_L*csv.[1-9]*`
	do
		(cat $keyL >>dfSeq_L.${lineline##*/}.csv) && rm $keyL
	done
	awk 'BEGIN{FS=",";OFS=",";print "decoyFilename,HchainSeq,H1seq,H2seq,H4seq,H3seq,LchainSeq,L1seq,L2seq,L4seq,L3seq"};NR==FNR{h[substr($1,1,length($1)-2)]=substr($1,1,length($1)-2)","$2","$3","$4","$5","$6}; NR>FNR{l[substr($1,1,length($1)-2)]=$2","$3","$4","$5","$6}; END{for (key in h){print h[key],l[key]};}' dfSeq_H.${lineline##*/}.csv dfSeq_L.${lineline##*/}.csv \
	|grep -v "decoyFilena," |sort -r|uniq >>dfSeq.agg.csv

	export timedftot=$SECONDS
	echo "time to serially write out to dfSeq_H.${lineline##*/}.csv and dfSeq_L.${lineline##*/}.csv:"`expr $timedftot - $timepdb2fastadone`
	awk '/Ptz/{print $0;getline; print $0};'<"${line##*/}_H.fa">tmp/Ptz.${line##*/}_H.fa &
	awk '/Tsz/{print $0;getline; print $0};'<"${line##*/}_H.fa">tmp/Tsz.${line##*/}_H.fa &
	awk '/Ptz/{print $0;getline; print $0};'<"${line##*/}_L.fa">tmp/Ptz.${line##*/}_L.fa &
	awk '/Tsz/{print $0;getline; print $0};'<"${line##*/}_L.fa">tmp/Tsz.${line##*/}_L.fa &
	wait
	echo ">wt
AASGFTFTDYTMDDVNPNSGGSIVDRSKNTLARNLGPSFYFDY" >>tmp/Ptz.${line##*/}_H.fa
	echo ">wt
AASGFNIKDTYIHRIYPTNGYTRADTSKNTASRWGGDGFYAMDY" >>tmp/Tsz.${line##*/}_H.fa
	echo ">wt
KASQDVSIGVAYSASYRYTGSGTDFQQYYIYPYT" >>tmp/Ptz.${line##*/}_L.fa
	echo ">wt
RASQDVNTAVAYSASFLYSRSGTDFQQHYTTPPT" >>tmp/Tsz.${line##*/}_L.fa

	clustalo -i tmp/Ptz.${line##*/}_H.fa --outfmt=clu >Ptz.${line##*/}_H.clustal &
	clustalo -i tmp/Tsz.${line##*/}_H.fa --outfmt=clu >Tsz.${line##*/}_H.clustal &
	clustalo -i tmp/Ptz.${line##*/}_L.fa --outfmt=clu >Ptz.${line##*/}_L.clustal &
	clustalo -i tmp/Tsz.${line##*/}_L.fa --outfmt=clu >Tsz.${line##*/}_L.clustal &
	wait
	plotcon Ptz.${line##*/}_H.clustal  -graph svg -winsize 1 -goutfile Ptz.${line##*/}_H.cons -gtitle "Ptz in ${line##*/}_H" &
	plotcon Tsz.${line##*/}_H.clustal  -graph svg -winsize 1 -goutfile Tsz.${line##*/}_H.cons -gtitle "Tsz in ${line##*/}_H" &
	plotcon Ptz.${line##*/}_L.clustal  -graph svg -winsize 1 -goutfile Ptz.${line##*/}_L.cons -gtitle "Ptz in ${line##*/}_L" &
	plotcon Tsz.${line##*/}_L.clustal  -graph svg -winsize 1 -goutfile Tsz.${line##*/}_L.cons -gtitle "Tsz in ${line##*/}_L" &
	wait
	./seqident.awk <Ptz.${line##*/}_H.clustal >Ptz.seqident.${line##*/}_H.tsv &
	./seqident.awk <Tsz.${line##*/}_H.clustal >Tsz.seqident.${line##*/}_H.tsv &
	./seqident.awk <Ptz.${line##*/}_L.clustal >Ptz.seqident.${line##*/}_L.tsv &
	./seqident.awk <Tsz.${line##*/}_L.clustal >Tsz.seqident.${line##*/}_L.tsv &
	wait 
	timepostalign=$SECONDS

done 	< $1


export timeloopend=$SECONDS
export loopruntime=$(expr $timeloopend - $timescriptstart)
echo "loop run time for "`wc -l $1|awk '{print $1}'`" scorefiles was $loopruntime seconds, now executing interfaceanalyzer:"


export tmplogfile=`date +%Y-%m-%d@%H:%M:%S`.IA.log
echo "Now do the interface analyzer to get right scores across the board, see the file $tmplogfile for the output from that"|tee $tmplogfile


if [[ -a $1.IA.agg.sc ]] 
then
	mv $1.IA.agg.sc $1.IA.agg.sc`date +%N`
fi

/usr/bin/time -p ibrun $TACC_ROSETTA_BIN/rosetta_scripts*release \
	-l PDBlist.txt \
	-parser:protocol IA.rst \
	-out:level 200 \
	-out:file:score_only "$1.IA.agg.sc" \
	-scorefile_format json \
	-no_nstruct_label &> $tmplogfile

#this little loop will separate the IA.agg.sc file into respective scorefiles again for nomenclature reasons in the python script
#while read line
#do
#line1=${line%.sc}
#line2=${line1##*/}
#awk 'BEGIN{FS=",";}; NR==FNR{a[$1]=$1;} NR>FNR{if($1 in a){print $0}}' $line $1.IA.agg.sc >${line2}".IA.sc"
#done <$1

#ls *.IA.sc >scorefilelist.IA.txt

/usr/bin/time -p python3 postDesign.py $1.IA.agg.sc





#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#exit 9
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>





export timestartlogo=$SECONDS
#make some associative arrays and store up the sequences etc looping through the big dataframe file
declare -A stringseq 
declare -A scorefiles
declare -A mutants
declare -A rlxBools
declare -A rankmetrics
declare -A fullpath

if [[ -a TSVlist.txt ]] 
then
	mv TSVlist.txt TSVlist.txt.`date +%N`
fi

while read line 
do 
	set -- $line 
	stringseq[($1$2$3$4$8)]=$5$6$7
	scorefiles[($8)]=$i
	mutants[($2)]=$i
	rlxBools[($3)]=$i
	rankmetrics[($4)]=$i
	fullpath[($9)]=$8" "$2" "$3" "$4
done <dfTops.tsv 
for key1 in ${!scorefiles[@]}
do
	for key2 in ${!mutants[@]}
	do
		for key3 in ${!rlxBools[@]}
		do
			for key4 in ${!rankmetrics[@]}
			do
				key1=${key1%)}
				key1=${key1#(}
				key2=${key2%)}
				key2=${key2#(}
				key3=${key3%)}
				key3=${key3#(}
				key4=${key4%)}
				key4=${key4#(}
#			if [[ $(ps|wc -l) -lt $cpu2count ]]
#			then
				cat dfTops.tsv | grep "${key2}	${key3}	${key4}.*${key1}"  |cut -f1,5,6,7 |awk '{print ">"$1;print $2$3$4}' |clustalo -i - --infmt=fa	| weblogo  \
				 --stacks-per-line 48 --title "${key1} ${key2} ${key3} ${key4}" \
				 --format png_print \
				 >${key1}.${key2}.${key3}.${key4}.logo.png &
#			else
#				sleep 5
#				cat dfTops.tsv | grep "${key2}	${key3}	${key4}.*${key1}"  |cut -f1,5,6,7 |awk '{print ">"$1;print $2$3$4}' |clustalo -i - --infmt=fa 				| weblogo  \
#				 --stacks-per-line 48 --title "${key1} ${key2} ${key3} ${key4}" \
#				 --format png_print \
#				 >${key1}.${key2}.${key3}.${key4}.logo.png &
#			fi
			done
		done
	done
done
wait
echo "time to make logos:"`expr $SECONDS - $timestartlogo`
export logotime=$SECONDS

