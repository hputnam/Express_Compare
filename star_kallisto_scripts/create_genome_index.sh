#!/bin/bash
#SBATCH --mem=64G

# Create M. capitata index
STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir /r/corals/Nitya/pipelines/genome_indices/ \
--genomeFastaFiles /r/corals/Nitya/pipelines/genomes/mcap_genome.fa \
--sjdbGTFfile /r/corals/Nitya/pipelines/annotations/Mcap.exons.GFFannotation.gff

# Create P. acuta index
STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir /r/corals/Nitya/pipelines/genome_indices/ \
--genomeFastaFiles /r/corals/Nitya/pipelines/genomes/pacuta_genome.fasta \
--sjdbGTFfile /r/corals/Nitya/pipelines/annotations/pacuta.gff
