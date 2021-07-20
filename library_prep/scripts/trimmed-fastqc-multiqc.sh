#!/bin/sh

#base path
base="/r/corals/Nitya/kallisto"

#running fastqc on trimmed fastq files
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
