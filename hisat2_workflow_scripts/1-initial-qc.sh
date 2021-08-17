#!/bin/bash
#SBATCH --job-name="trimQC"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH --mem=128GB
#SBATCH -D /data/putnamlab/erin_chille/Express_Compare

module load FastQC/0.11.8-Java-1.8
module load MultiQC/1.7-foss-2018b-Python-3.6.6
module load Trimmomatic/0.32-Java-1.7.0_80

#set base variable
base="/data/putnamlab/erin_chille/Express_Compare"

echo -e "\n STEP 1: INITIAL QC \n Running fastqc and multiqc on fastq files before trimming" $(date)

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

echo -e "\n Initial QC complete. Now moving on to step 2 \n STEP 2: TRIMMOMATIC \n Trimming fastq files" $(date)

#the illumina clip file name
ic_file="TruSeq3-PE.fa"

trim_dir="trimmed"
gunzip *.fastq.gz

# Create arrays with all the ID #s
cd "$base"/fastq/not_trimmed
gunzip *.fastq.gz
R1s=($(ls *R1*))
R2s=($(ls *R2*))
ids=($(ls *R1* | cut -d _ -f 1))

#runs for each untrimmed file
for file in "${ids[@]}"
do
    #trimmomatic command
    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.32.jar PE -phred33 "$R1s" "$R2s" -baseout "$file" ILLUMINACLIP:"$base"/fasta/"$ic_file":2:30:10  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    
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
gzip *.fastq

echo -e "\nTrimming complete. Now moving on to step 3 \nSTEP 3: TRIMMING QC \nRunning fastqc on trimmed fastq files" $(date)
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

echo -e "\nTrimming and QC complete!" $(date)
