#!/bin/bash
#SBATCH --job-name="trimQC"
#SBATCH --mem=128GB


##This script is quality trim 12 samples of P. acuta and M. capitata
# Project: PRJNA744524
# https://www.ebi.ac.uk/ena/browser/view/PRJNA744524?show=reads
# From Erin Chille's documentation 

echo "Loading programs" $(date)

echo "Starting read trimming." $(date)

cd /path/fastq/not_trimmed #move to correct dir
array1=($(ls *.fastq)) #Make an array of sequences to trim

for i in ${array1[@]}; do #Make a loop that trims each file in the array PAIRED END (Mcap and Spis)
         fastp --in1 ${i} --in2 $(echo ${i}|sed s/_R1/_R2/) --out1 ../fastp_trimmed/${i} --out2 ../fastp_trimmed/$(echo ${i}|sed s/_R1/_R2/) --detect_adapter_for_pe \
         --qualified_quality_phred 20 --unqualified_percent_limit 10 --cut_right cut_right_window_size 5 cut_right_mean_quality 20 \
         -h ../fastp_trimmed/${i}.fastp.html -j ../fastp_trimmed/${i}.fastp.json
done


echo "Assessment of trimmed reads complete" $(date)
