#!/bin/bash
#SBATCH --job-name="ZaneStringtieAssemblyPAcuta"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/stringtie_assembly
#SBATCH --exclusive #SBATCH -c 20

module load StringTie/2.1.3-GCC-8.3.0

ids=("1471" "1637" "Sample1" "Sample2" "Sample3")
for file in "${ids[@]}"
do
stringtie -A gene_abundance/"$file".gene_abundance.tab -p 8 --rf -e -G Pocillopora_acuta_HIv1.genes.gff3 -o "$file".gtf "$file".downsampled.bam
done
