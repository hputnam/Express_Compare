#!/bin/bash
#SBATCH -J star_indices #job name
#SBATCH --time=00-04:00:00 #requested time (DD-HH:MM:SS)
#SBATCH --output=MyJob.%j.%N.out #saving standard output to file, %j=JOBID, %N=NodeName
#SBATCH --error=MyJob.%j.%N.err  #saving standard error to file, %j=JOBID, %N=NodeName
#SBATCH -c 11 
#SBATCH --mem=128GB
#SBATCH --mail-type=ALL #email options
#SBATCH --mail-user=megan.gelement@tufts.edu

# Adapted from script by Nitya Nadgir (https://github.com/hputnam/Express_Compare/blob/main/star_kallisto_workflow/scripts/create_genome_index.sh)

module load STAR

# Create M. capitata index
STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Indices/Mcap \
--genomeFastaFiles /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Genomes/mcap_genome.fa \
--sjdbGTFfile /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Annotation_Files/Mcap.exons.GFFannotation.gff

# Create P. acuta index: The P. acuta annotation is in GFF3 format, and therefore requires extra parameters (see STAR manual 2.2.3)
STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Indices/Pacuta \
--genomeFastaFiles /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Genomes/pacuta_genome.fasta \
--sjdbGTFfile /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Annotation_Files/Pacuta.exons.GFFannotation.gff \
--sjdbGTFtagExonParentTranscript Parent \
--limitGenomeGenerateRAM 118006769710
