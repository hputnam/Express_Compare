#!/bin/bash
#SBATCH --job-name="ZanePAcutaAlignment2"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/REF
#SBATCH --exclusive #SBATCH -c 20

module load SAMtools/1.10-GCC-8.3.0
module load HISAT2/2.2.1-foss-2019b

ids=("1041" "1471" "1637" "Sample1" "Sample2" "Sample3")
for file in "${ids[@]}"; do hisat2 -p 20 --rf --dta -q -x PAcuta/Pacuta -1 "$fi$
samtools sort -@ 20 -o "$file".bam "$file".sam;
done
