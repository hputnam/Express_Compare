#!/bin/bash
#SBATCH --job-name="ZaneMCapAlignment20211124"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/REF
#SBATCH --exclusive #SBATCH -c 20
module load SAMtools/1.10-GCC-8.3.0
module load HISAT2/2.2.1-foss-2019b
ids=("1101" "1628" "1548" "Sample4" "Sample5" "Sample6")
for file in "${ids[@]}";
do hisat2 -p 20 --rf --dta -q -x MCap/MCap -1 "$file"_R1_001.clean.fastq.gz -2 $
samtools sort -@ 20 -o "$file".bam "$file".sam; done
