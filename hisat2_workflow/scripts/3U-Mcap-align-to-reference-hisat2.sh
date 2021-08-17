#!/bin/bash
#SBATCH --job-name="3-Mcap"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH -D /data/putnamlab/erin_chille/Express_Compare
#SBATCH --exclusive
#SBATCH -c 20

##This script is to align RNA sequences from Mcap RNA sequences obtained using different library prep methods
#https://github.com/hputnam/Express_Compare

echo "Loading programs" "$(date)"
module load HISAT2/2.1.0-foss-2018b #Alignment to reference genome: HISAT2
module load SAMtools/1.9-foss-2018b #Preparation of alignment for assembly: SAMtools

#echo "Downloading reference complete. Indexing for alignment with HISAT2." "$(date)"
#hisat2-build -f ref/Mcap.fa ref/Mcap
#echo "Index complete" "$(date)"

echo -e "Align reads to the indexed reference files (0-download-ref-files.sh) and save alignments in a sorted bam file." "$(date)"

trimmed="fastq/trimmed"
ids=( "1101" "1548" "1628" "Sample4" "Sample5" "Sample6" )

#runs for each untrimmed file
for file in "${ids[@]}"; do
	echo "Starting alignment of sample" "$file" "$(date)"
	hisat2 -p 20 --rf --dta -q -x ref/Mcap -U "$trimmed"/"$file"_1U,"$trimmed"/"$file"_2U -S "$file".unpaired.sam
        samtools sort -@ 20 -o bam/unpaired/"$file".bam "$file".unpaired.sam
        rm "$file".unpaired.sam
        echo "HISAT2 complete for" "$file" "$(date)"
done

echo "HISAT2 complete." "$(date)"
