## Run Kallisto
#### Reference: Hailey McKelvie and Jack Freeman [here](https://github.com/hputnam/Tufts_URI_CSM_RNASeq/blob/master/Connelly/Kallisto_pipeline/Connelly_kallisto_pipeline.md)
Create indices to run kallisto
[Kallisto documentation](https://pachterlab.github.io/kallisto/manual)

a) Make directoriy to store indices
```
cd ..
mkdir indices
cd scripts
```
b) Script to create indices for M. capitata and P. acuta
```
#!/bin/bash 
cd ../indices

# Create Pacuta Index
wget https://osf.io/nr83q/download
mv download pacuta_transcriptome.fasta
kallisto index -i pacuta_index.idx acuta_transcriptome.fasta
chmod 775 pacuta_index.idx

# Create Mcap index
wget http://cyanophora.rutgers.edu/montipora/Mcap.mRNA.fa.gz
mv Mcap.mRNA.fa Mcap.fa
kallisto index -i mcap_index.idx Mcap.fa
chmod 775 mcap_index.fa
```
Argumets for ```kallisto index```:
*  ```-i```: file name for the kallisto index to be created

c) Make directories for kallisto output
```
mkdir kallisto_output
chmod 775 kallisto_output
cd kallisto_output
mkdir mcap
chmod 775 mcap
mkdir pacuta
chmod 775 pacuta
```
d) Run kalliso quant aligning the kallisto index to the species

```
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
```
Arguments for ```kallisto quant```:
* ```-i```: filename for the index that will be used for quantification
* ```-o```: directory to write the output to 
The default running mode is paired-end, and requires an even number of paired fastq files

e) Run script
```
chmod 775 quant.sh
./quant.sh
```
f) Run Kallisto on fastp trimmed reads
```
#!/bin/bash

echo Starting Quant...

base="/path/pipelines"
cd "$base"/fastq/fastp_trimmed/

ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )

length=${#ids[@]}

for (( i=0; i<length; i++ ))
do
	echo Running file ${ids[$i]}

	#Separates the files by species
	if ((i < 12)) && ((i >= 0)) && ((i != 1)) && ((i != 2)) && ((i != 7)) && ((i != 8)) && ((i != 9)) && ((i != 10)); 
	then
		#echo $fileNum is M. capitata
		kallisto quant -i "$base"/indices/mcap_index.idx -o "$base"/kallisto_output/fastp_mcap/"${ids[$i]}" "${ids[$i]}"_1.fastq "${ids[$i]}"_2.fastq
	else
		#echo $fileNum is P. acuta	
		kallisto quant -i "$base"/indices/pacuta_index.idx -o "$base"/kallisto_output/fastp_pacuta/"${ids[$i]}" "${ids[$i]}"_1.fastq "${ids[$i]}"_2.fastq
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
```
