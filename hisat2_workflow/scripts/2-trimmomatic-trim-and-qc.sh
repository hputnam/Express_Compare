#!/bin/bash
#SBATCH --job-name="trim"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH --mem=128GB
#SBATCH -D /data/putnamlab/erin_chille/Express_Compare

module load Trimmomatic/0.38-Java-1.8
module load FastQC/0.11.8-Java-1.8
module load MultiQC/1.7-foss-2018b-Python-2.7.15

echo -e "\nSTEP 2: TRIMMOMATIC \n Trimming fastq files" $(date)

#set base variable
base="/data/putnamlab/erin_chille/Express_Compare"

#the illumina clip file name
ic_file="TruSeq3-PE.fa"

trim_dir="trimmed"

# Create arrays with all the ID #s
cd "$base"/fastq/not_trimmed
RIBO=( "Sample1" "Sample2" "Sample3" "Sample4" "Sample5" "Sample6" )
POLYA=( "1041" "1471" "1637" "1101" "1548" "1628" )
#runs for each untrimmed file RIBO
for file in "${RIBO[@]}"; do
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.38.jar PE -phred33 "$file"_R1.fastq.gz "$file"_R2.fastq.gz "$base"/fastq/"$trim_dir"/"$file"_1P "$base"/fastq/"$trim_dir"/"$file"_1U "$base"/fastq/"$trim_dir"/"$file"_2P "$base"/fastq/"$trim_dir"/"$file"_2U ILLUMINACLIP:"$base"/fasta/"$ic_file":2:30:10  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36    
done

#runs for each untrimmed file POLYA
for file in "${POLYA[@]}"; do
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.38.jar PE -phred33 "$file"_R1_001.fastq.gz "$file"_R2_001.fastq.gz "$base"/fastq/"$trim_dir"/"$file"_1P "$base"/fastq/"$trim_dir"/"$file"_1U "$base"/fastq/"$trim_dir"/"$file"_2P "$base"/fastq/"$trim_dir"/"$file"_2U ILLUMINACLIP:"$base"/fasta/"$ic_file":2:30:10  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36    
done
echo -e "\nTrimming complete. Now moving on to step 3 \nSTEP 3: TRIMMING QC \nRunning fastqc on trimmed fastq files" $(date)

cd "$base"/fastq/"$trim_dir"
chmod 755 *

for file in ./*
do
	fastqc "${file}"  --outdir "$base"/fastqc/trimmed
	chmod 755 "$file"
done

cd "$base"/fastqc/trimmed
multiqc . --outdir "$base"/multiqc/trimmed

#changing permissions of multiqc output to make public
chmod 755 "$file" "$base"/multiqc/trimmed/*

echo -e "\n STEP 3 (Trimming and QC) COMPLETE" $(date)
