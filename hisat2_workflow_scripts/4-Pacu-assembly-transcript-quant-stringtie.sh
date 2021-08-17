#!/bin/bash
#SBATCH --job-name="Pacu_stringtie"
#SBATCH -t 100:00:00
#SBATCH --export=/opt/software/StringTie/2.1.4-GCC-9.3.0/bin/prepDE.py
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH --exclusive
#SBATCH --nodes 1 --ntasks-per-node=20
#SBATCH --mem=250GB
#SBATCH -D /data/putnamlab/erin_chille/Express_Compare

##This script is to assemble and quantify gene counts from the RNA sequences from M. capitata samples prepped in two ways.

echo "Loading programs" $(date)
module load StringTie/2.1.4-GCC-9.3.0 #Transcript assembly: StringTie
module load GffCompare/0.12.1-GCCcore-8.3.0 #Transcript assembly QC: GFFCompare
module load Python/2.7.18-GCCcore-9.3.0 #Python for prepde.py script
module list

#StringTie reference-guided assembly

echo "Starting assembly!" $(date)
base="$(pwd)"
out="stringtie/trimmomatic/paired"
ids=( "1041" "1471" "1637" "Sample1" "Sample2" "Sample3" ) #Make an array of sequences to assemble
for ID in ${ids[@]}; do
      	stringtie -p $SLURM_NTASKS_PER_NODE -e --conservative -C "$out"/"$ID"_coverage -G ref/Structural_annotation_experimental.gff -o "$out"/"$ID".gtf bam/trimmomatic/paired/"$ID".bam
      	echo "n transcripts:" $(zgrep -c "transcript" "$out"/"$ID"_coverage.gtf)
	echo "n CDS:" "$(zgrep -c "CDS" "$out"/"$ID"_coverage.gtf)"       
	echo "StringTie-assembly-to-ref" "$ID" $(date)
done

echo "Assembly complete! Starting assembly evaluation." $(date)

cd "$base"/"$out" #change working dir
for id in "${ids[@]}"; do echo -e "$id""\t""$base""$out""/""$id"".gtf" >> Pacu_samplelist.txt; done #Make mergelist
for id in "${ids[@]}"; do echo -e "$base""/""$out""/""$id"".gtf" >> Pacu_mergelist.txt; done #Make samplelist

gffcompare -r "$base"/ref/Structural_annotation_experimental.gff -R -G -V -o Pacu -i Pacu_mergelist.txt #Compute the accuracy and precision of assembly
	# -r = Reference
	# -R = Ignore reference sequences with no aligned transcripts in any 1 sample to calculate sensitivity
	# -Q = Ignore reference sequences with no aligned transcripts in all samples to calculate sensitivity
	# -V = Verbose mode
	
echo "Assessment of GTFs complete! Starting gene count matrix assembly." $(date)
python /opt/software/StringTie/2.1.4-GCC-9.3.0/bin/prepDE.py -g Pacu_gene_count_matrix.csv -i Pacu_samplelist.txt #Compile the gene count matrix
