#!/bin/sh
#runs fastqc and multiqc on fastq files before trimming
#the base path is given below


#base path
base="/r/corals/Nitya/kallisto"

#running fastqc on not trimmed fastq files
for file in "$base"/fastq/not_trimmed/*.fastq.gz
do
    fastqc "${file}"  --outdir "$base"/fastqc/not_trimmed
done

#changing permissions to make fastqc output files public
for file in "$base"/fastqc/not_trimmed/*
do
    chmod 755 "$file"
done

#running multiqc on the not trimmed fastqc
cd "$base"/fastqc/not_trimmed

multiqc . --outdir "$base"/multiqc/not_trimmed

#changing permissions of multiqc output to make public
for file in "$base"/multiqc/not_trimmed/*
do
    chmod 755 "$file"
done
