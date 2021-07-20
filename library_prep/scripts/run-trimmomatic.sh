#!/bin/sh
#trims fastq files using trimmomatic

#base path
base="/r/corals/Nitya/kallisto"

#the illumina clip file name
ic_file="TruSeq3-PE.fa"

trim_dir="trimmed"
cd "$base"/fastq/not_trimmed
gunzip *.fastq.gz

# Create arrays with all the ID #s
ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )


#runs for each untrimmed file
for file in "${ids[@]}"
do
    #trimmomatic command
    java -jar /usr/sup/bin/trimmomatic.jar PE -phred33 "$file"_1.fastq "$file"_2.fastq -baseout "$file" ILLUMINACLIP:"$base"/fasta/"$ic_file":2:30:10  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    

    #makes the trimmed fastq file public
    chmod 755 "$file"_1P
    chmod 775 "$file"_1U
    chmod 775 "$file"_2P
    chmod 775 "$file"_2U

    #moves the trimmed fastq file to its respective directory	
    mv "$file"_1P "$base"/fastq/"$trim_dir"
    mv "$file"_1U "$base"/fastq/"$trim_dir"
    mv "$file"_2P "$base"/fastq/"$trim_dir"
    mv "$file"_2U "$base"/fastq/"$trim_dir"
done
