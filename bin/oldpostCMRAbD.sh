source ~/.bashrc
conda activate pandas1
cp $WP/bin/rosetta_scripts/IA.rst .
cp $WP/bin/python/postRAbD.py .
cp $WP/bin/seqident.awk .
chmod u+rwx seqident.awk
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
	mv PDBlist.txt PDBlist.txt.`date +%N`
fi

while read line
do
	export timescorefloopstart=$SECONDS
	echo "decoyFilename,HchainSeq,H1seq,H2seq,H4seq,H3seq" >dfSeq_H.${line##*/}.csv
	echo "decoyFilename,LchainSeq,L1seq,L2seq,L4seq,L3seq" >dfSeq_L.${line##*/}.csv
	export i=1

	while read nextline
	do
		export pathname=${line%\/*}
		export decoyname=$(echo $nextline | tr -d '"'|tr -d '{' |tr ':' '	'|tr ',' '	' | cut -f2)
		if [[ $decoyname == *"pre_model_"* ]]
		then
			laterpart=${decoyname##pre_model_1}
			fullfilename=$pathname"/pre_model_1_"$laterpart".pdb"
		else
			fullfilename=$pathname"/"$decoyname".pdb"
		fi
		if [ -a "$fullfilename.gz" ]
		then
				gunzip "$fullfilename.gz" &
				echo "gunzipping $fullfilename.gz"
		fi
		echo $fullfilename >>PDBlist.txt
	done <"$line"
	wait
	export timegzdone=$SECONDS
	echo "time to do gzip loop:"`expr $timegzdone - $timescorefloopstart`

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

	while read nextline
	do
		export pathname=${nextline%\/*}
		export decoyname=$(echo $nextline | tr -d '"'|tr -d '{' |tr ':' '	'|tr ',' '	' | cut -f2)

		if [ -a "$nextline" ]
		then
#			if [[ $(ps|wc -l) -lt $cpucount ]]
#			then
				if [[ $nextline == *"Ptz"* ]]
				then
				pdb2fasta.sh $nextline |awk -v fullname=$nextline -v scorefile=${line##*/} -v counter=${i} \
				'/chain H/{print  ">" fullname "_H" >>scorefile"_H.fa";getline;print substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5) substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5) substr($0,index($0,"RFTLS")+5,8) substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >>scorefile"_H.fa";print fullname"_H,"$0","substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5)","substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5)","substr($0,index($0,"RFTLS")+5,8)","substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >"tmp/dfSeq_H."scorefile".csv."counter};
				 /chain L/{print  ">" fullname "_L" >>scorefile"_L.fa" ;getline;print substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5) substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5) substr($0,index($0,"RFSGS")+5,6) substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >>scorefile"_L.fa"; print fullname"_L,"$0","substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5)","substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5)","substr($0,index($0,"RFSGS")+5,6)","substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >"tmp/dfSeq_L."scorefile".csv."counter};' &
				elif [[ $nextline == *"Tsz"* ]]
				then
				pdb2fasta.sh $nextline |awk -v fullname=$nextline -v scorefile=${line##*/} -v counter=${i} \
				 '/chain H/{print  ">" fullname "_H" >>scorefile"_H.fa" ;getline;print substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5) substr($0,index($0,"LEWVA")+5,(index($0,"YADSV")-index($0,"LEWVA"))-5) substr($0,index($0,"RFTIS")+5,8) substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >>scorefile"_H.fa";print fullname"_H,"$0","substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5)","substr($0,index($0,"LEWVA")+5,(index($0,"YADSV")-index($0,"LEWVA"))-5)","substr($0,index($0,"RFTIS")+5,8)","substr($0,index($0,"AVYYC")+5,(index($0,"WGQGT")-index($0,"AVYYC"))-5) >"tmp/dfSeq_H."scorefile".csv."counter};
				 /chain L/{print  ">" fullname "_L" >>scorefile"_L.fa" ;getline;print substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5) substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5) substr($0,index($0,"RFSGS")+5,6) substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >>scorefile"_L.fa"; print fullname"_L,"$0","substr($0,index($0,"VTITC")+5,(index($0,"WYQQK")-index($0,"VTITC"))-5)","substr($0,index($0,"PKLLI")+5,(index($0,"GVPSR")-index($0,"PKLLI"))-5)","substr($0,index($0,"RFSGS")+5,6)","substr($0,index($0,"ATYYC")+5,(index($0,"FGQGT")-index($0,"ATYYC"))-5) >"tmp/dfSeq_L."scorefile".csv."counter};' &
				else 
				echo "error with $nextline, does not match Tsz or Ptz"
				fi
#			else 
#				sleep 5
#				pdb2fasta.sh $nextline |awk -v fullname=$nextline -v scorefile=${line##*/} \
#				 '/chain H/{print  ">"fullname >>scorefile".fa" ;getline;print substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5) substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5) substr($0,index($0,"RFTLS")+5,8) >>scorefile".fa";print fullname","$0","substr($0,index($0,"LRLSC")+5,(index($0,"WVRQA")-index($0,"LRLSC"))-5)","substr($0,index($0,"LEWVA")+5,(index($0,"YNQRF")-index($0,"LEWVA"))-5)","substr($0,index($0,"RFTLS")+5,8)};' \
#				 >tmp/dfSeq_H.${line##*/}.csv${i} &
#			fi
			export i=$(expr $i + 1)
		else
			echo "cant find the pdb file"
			echo $nextline 
		fi
	done < PDBlist.txt
	wait
	export timefastadone=$SECONDS


	echo "time to write to tempfiles for dftot.${line##*/}.csv:"`expr $timefastadone - $timegzdone`
	for keyH in `ls tmp/*_H*csv.[1-9]*`
	do
		cat $keyH >>dfSeq_H.${line##*/}.csv
		rm $keyH
	done

	for keyL in `ls tmp/*_L*csv.[1-9]*`
	do
		cat $keyL >>dfSeq_L.${line##*/}.csv
		rm $keyL
	done
	awk 'BEGIN{FS=",";OFS=",";print "decoyFilename,HchainSeq,H1seq,H2seq,H4seq,H3seq,LchainSeq,L1seq,L2seq,L4seq,L3seq"};NR==FNR{h[substr($1,1,length($1)-2)]=substr($1,1,length($1)-2)","$2","$3","$4","$5","$6}; NR>FNR{l[substr($1,1,length($1)-2)]=$2","$3","$4","$5","$6}; END{for (key in h){print h[key],l[key]};}' ../2020-06-18_rosScriptswriting/dfSeq_H.score_CM.sc.csv ../2020-06-18_rosScriptswriting/dfSeq_L.score_CM.sc.csv \
	|grep -v "decoyFilena," >dfSeq.${line##*/}.csv


	export timedftot=$SECONDS
	echo "time to serially write out to dfSeq_H.${line##*/}.csv and dfSeq_L.${line##*/}.csv:"`expr $timedftot - $timefastadone`
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
	tmp1=${line##*/}
	export tmplogfile=`date +%Y-%m-%d@%H:%M:%S`.${line##*/}.IA.log
	echo "Now do the interface analyzer to get right scores across the board, see the file $tmplogfile for the output from that"
	/usr/bin/time -p ibrun $TACC_ROSETTA_BIN/rosetta_scripts*release \
	-l PDBlist.txt \
	-parser:protocol IA.rst \
	-out:level 200 \
	-out:file:score_only ${tmp1%\.sc}".IA.sc" \
	-scorefile_format json \
	-no_nstruct_label &> $tmplogfile

ls *.IA.sc >scorefilelist.IA.txt


/usr/bin/time -p python3 postRAbD.py scorefilelist.IA.txt



#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

