# RNA-seq Kallisto Pipeline
## Montipora capitata and Pocillopora acuta
https://www.ncbi.nlm.nih.gov/bioproject/PRJNA744524 <br>
Nitya Nadgir <br>
Referenced from Hailey McKelvie and Jack Freeman, Tufts University [here](https://github.com/hputnam/Tufts_URI_CSM_RNASeq/blob/master/Connelly/Kallisto_pipeline/Connelly_kallisto_pipeline.md)

### 1) make directories and download data

a) make directories: base directory, directory for data, directory for scripts
```
mkdir kallisto 
cd kallisto

mkdir fastq
chmod 775 fastq
cd fastq
mkdir not_trimmed
chmod 775 not_trimmed

cd ..
mkdir scripts 
cd scripts
nano download_fastq.sh
```
b) script to download raw reads as fastq files:
https://www.ebi.ac.uk/ena/browser/view/PRJNA744524
```
#!/bin/bash

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/054/SRR15089754/SRR15089754_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/054/SRR15089754/SRR15089754_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/055/SRR15089755/SRR15089755_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/055/SRR15089755/SRR15089755_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/056/SRR15089756/SRR15089756_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/056/SRR15089756/SRR15089756_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/057/SRR15089757/SRR15089757_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/057/SRR15089757/SRR15089757_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/058/SRR15089758/SRR15089758_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/058/SRR15089758/SRR15089758_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/059/SRR15089759/SRR15089759_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/059/SRR15089759/SRR15089759_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/060/SRR15089760/SRR15089760_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/060/SRR15089760/SRR15089760_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/061/SRR15089761/SRR15089761_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/061/SRR15089761/SRR15089761_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/062/SRR15089762/SRR15089762_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/062/SRR15089762/SRR15089762_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/063/SRR15089763/SRR15089763_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/063/SRR15089763/SRR15089763_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/064/SRR15089764/SRR15089764_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/064/SRR15089764/SRR15089764_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/065/SRR15089765/SRR15089765_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/065/SRR15089765/SRR15089765_2.fastq.gz

#makes all the files public
for file in *.fastq.gz
do
	chmod 755 $file
done
```
c) run the script
```
chmod 775 download_fastq.sh
./download_fastq.sh
```
### 2) Verify md5 of the fastq files
```
md5sum *.fastq.gz > checksum.md5
md5sum -c checksum.md5
```
### 3) FastQC and MultiQC

a) Make directories for FastQC output on raw reads
```
cd /r/corals/kallisto
mkdir fastqc
chmod 775 fastqc
cd fastqc
mkdir not_trimmed
chmod 775 not_trimmed
cd ..
```
b) Make directories for MultiQC output on raw reads
```
mkdir multiqc
chmod 775 multiqc
cd multiqc
mkdir not_trimmed
chmod 775 not_trimmed 
cd ..
```
c) Script to run FastQC and MultiQC on raw reads
```
cd scripts
nano fastqc_multiqc
```
```
#!/bin/sh
#runs fastqc and multiqc on fastq files before trimming
#the base path is given below

#base path
base="/r/corals/Nitya/kallisto"

#running fastqc on not trimmed fastq files
for file in "$base"/fastq/not_trimmed/*.fastq.gz
do
    fastqc "${file}"  --outdir "$base"/fastqc/not_trimmed
done

#changing permissions to make fastqc output files public
for file in "$base"/fastqc/not_trimmed/*
do
    chmod 755 "$file"
done

#running multiqc on the not trimmed fastqc
cd "$base"/fastqc/not_trimmed

multiqc . --outdir "$base"/multiqc/not_trimmed

#changing permissions of multiqc output to make public
for file in "$base"/multiqc/not_trimmed/*
do
    chmod 755 "$file"
done
```
```
./fastqc_multiqc.sh
```
d) Open multiqc report
```
scp nnadgi01@homework.cs.tufts.edu:/r/corals/Nitya/pipelines/multiqc/trimmed/multiqc_report.html Downloads
```
### 4) FastQC and MultiQC on trimmed reads

a) Make directories to store trimmed reads, FastQC, and MultiQC outputs
```
cd /r/corals/Nitya/kallisto/fastq
mkdir trimmed
chmod 775 trimmed
cd ..

cd fastqc
mkdir trimmed
chmod 775 trimmed
cd ..

cd multiqc
mkdir trimmed
chmod 775 trimmed
cd ..
```
b) Get the paired end illumina adapter file
```
mkdir fasta
chmod 775 fasta
cd fasta
wget https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/TruSeq3-PE.fa
```
c) Run trimmomatic (paired end mode)
```
cd /r/corals/Nitya/kallisto/scripts
run-trimmomatic.sh
```
```
#!/bin/sh
#trims fastq files using trimmomatic

#base path
base="/r/corals/Nitya/kallisto"

#the illumina clip file name
illumina="TruSeq3-PE.fa"

trim_dir="trimmed"

cd "$base"/fastq/not_trimmed
gunzip *.fastq.gz

# Create an array with all the ID #s
ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )


#runs for each untrimmed file
for file in "${ids[@]}"
do
    #trimmomatic command
    java -jar /usr/sup/bin/trimmomatic.jar PE -phred33 "$file"_1.fastq "$file"_2.fastq -baseout "$file" ILLUMINACLIP:"$base"/fasta/"$illumina":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    

    #makes the trimmed fastq file public
    chmod 755 "$file"_1P
    chmod 775 "$file"_1U
    chmod 775 "$file"_2P
    chmod 775 "$file"_2U

    #moves the trimmed fastq file to its respective directory	
    mv "$file"_1P "$base"/fastq/"$trim_dir"
    mv "$file"_1U "$base"/fastq/"$trim_dir"
    mv "$file"_2P "$base"/fastq/"$trim_dir"
    mv "$file"_2U "$base"/fastq/"$trim_dir"
done
```
For paired end data, trimmomatic takes two input files and four output files. 
The paired output files, _1P and _2P, correspond to files where both reads survived the processing. 
The unpaired output files, _1U and _2U, correspond to output where a read survived but the partner did not. 
Trimmomatic documentation can be seen [here](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf). 

Trimmomatic arguments:
* ```PE```: paired end reads
* ```-phred33```: base quality encoding
* ```ILLUMINACLIP```: find and remove Illumina adapters
* ```SLIDINGWINDOW:<windowSize>:<requiredQuality>```: cutting when the average quality within the window falls below a given threshold
    * ```windowSize```: specifies the number of bases to average across
    * ```requiredQuality```: specifies the average quality required.
* ```LEADING:<quality>```: removes low-quality bases from the beginning
    * ```quality```: minimum quality required to keep a base
* ```TRAILING:<quality>```: removes low-quality bases from the end 
    * ```quality```: minimum quality required to keep a base
* ```MINLEN<length>```: removes reads that fall below the specified minimum length 

d) Run FastQC and MultiQC on trimmed reads: ```trimmed-fastqc-multiqc.sh```
```
#!/bin/sh

#base path
base="/r/corals/Nitya/pipelines"

#running fastqc on trimmed fastq files
for file in "$base"/fastq/trimmed/*
do
    fastqc "${file}"  --outdir "$base"/fastqc/trimmed
done


#changing permissions to make fastqc output files public
for file in "$base"/fastqc/trimmed/*
do
    chmod 755 "$file"
done

#running multiqc on the trimmed fastqc
cd "$base"/fastqc/trimmed

multiqc . --outdir "$base"/multiqc/trimmed

#changing permissions of multiqc output to make public
for file in "$base"/multiqc/trimmed/*
do
    chmod 755 "$file"
done
```
e) Run the script
```
chmod 755 trimmed-fastqc-multiqc.sh
./trimmed-fastqc-multiqc.sh
```
f) Open multiqc report
```
scp nnadgi01@homework.cs.tufts.edu:/r/corals/Nitya/kallisto/multiqc/trimmed/multiqc_report.html Downloads
```
