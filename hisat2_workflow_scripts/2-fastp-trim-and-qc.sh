#!/bin/bash
#SBATCH --job-name="trimQC"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH --mem=128GB
#SBATCH -D /data/putnamlab/erin_chille/BSF_3_Stage/Pacu

##This script is quality trim and subsequently QC SE RNA sequences from three P. acuta life stages swimming & metamophosed larvae,and recruits:
#https://github.com/hputnam/BSF_3_Stage
#FastQ sequences from 9 samples representing, 3 biological reps each
#ENA Project PRJNA306839 (https://www.ebi.ac.uk/ena/browser/view/PRJNA306839)

echo "Loading programs" $(date)

#Load programs for bioinformatic analysis
#module load Python/2.7.15-foss-2018b #Python
module load FastQC/0.11.8-Java-1.8 #Quality check: FastQC
module load MultiQC/1.7-foss-2018b-Python-2.7.15 #Quality check: MultiQC
module load fastp/0.19.7-foss-2018b #Quality trimming: Fastp
module list

echo "Starting read trimming." $(date)

cd /data/putnamlab/erin_chille/BSF_3_Stage/Pacu/raw_reads #move to correct dir
array1=($(ls *.fastq.gz)) #Make an array of sequences to trim

for i in ${array1[@]}; do #Make a loop that trims each file in the array
         fastp --in1 ${i} --out1 ../clean_reads/${i} --qualified_quality_phred 20 --unqualified_percent_limit 10 --cut_right cut_right_window_size 5 cut_right_mean_quality 20 -h ../clean_reads/${i}.fastp.html -j ../clean_reads/${i}.fastp.json
         fastqc ../clean_reads/${i}
done

echo "Read trimming complete. Starting assessment of clean reads." $(date)

cd /data/putnamlab/erin_chille/BSF_3_Stage/Pacu/clean_reads #move to correct dir
multiqc ./ #Compile MultiQC report from FastQC files

echo "Cleaned MultiQC report generated. Have a look-see at the results while the number of reads per sequence is tabulated" $(date)

zgrep -c "@SRR" *.fastq.gz #Check the number of reads per file again

echo "Assessment of trimmed reads complete" $(date)
