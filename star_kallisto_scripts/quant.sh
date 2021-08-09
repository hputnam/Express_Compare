#!/bin/bash

echo Starting Quant...

base="/r/corals/Nitya/pipelines"
cd "$base"/fastq/trimmed/

ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )

length=${#ids[@]}

for (( i=0; i<length; i++ ))
do
	echo Running file ${ids[$i]}

	#Separates the files by species
	if ((i < 12)) && ((i >= 0)) && ((i != 1)) && ((i != 2)) && ((i != 7)) && ((i != 8)) && ((i != 9)) && ((i != 10)); 
	then
		#echo $fileNum is M. capitata
		kallisto quant -i "$base"/indices/mcap_index.idx -o "$base"/kallisto_output/mcap/"${ids[$i]}" "${ids[$i]}"_1P "${ids[$i]}"_2P
	else
		#echo $fileNum is P. acuta	
		kallisto quant -i "$base"/indices/pacuta_index.idx -o "$base"/kallisto_output/pacuta/"${ids[$i]}" "${ids[$i]}"_1P "${ids[$i]}"_2P
	fi	
done

#updates the permissions and nesting of the files such that the path to 
#output is /r/corals/kallisto_output/[mcap/pacuta]/[sample_id]/kallisto

#directories in output are mcap and pacuta
for dir in "$base"/kallisto_output/*
do
	chmod 775 $dir
	cd $dir
	
	#within each dir corresponds to a sample id that contains
	# kallisto output of a .h5, .tsv, and .json file
	for sample_id in $dir/*
	do
		cd $sample_id
		mkdir kallisto
		chmod 775 kallisto
		mv abundance.h5 kallisto
		mv abundance.tsv kallisto
		mv run_info.json kallisto
		chmod 755 kallisto/*
		cd ..
	done
	
	cd ..
done
