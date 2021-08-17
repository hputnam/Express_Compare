#!/bin/bash
#SBATCH --mem=64G

ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )

length=${#ids[@]}

for (( i=0; i<length; i++ ))
do
    # Separate by species
    if ((i != 1)) && ((i != 2)) && ((i != 7)) && ((i != 8)) && ((i != 9)) && ((i != 10)); 
    then
        STAR \
        --runMode alignReads \
        --quantMode TranscriptomeSAM \
        --outTmpDir /r/corals/Nitya/pipelines/star_output/aligned_reads/${ids[i]} \
        --readFilesIn /r/corals/Nitya/pipelines/fastq/trimmed/${ids[i]}_1P /r/corals/Nitya/pipelines/fastq/trimmed/${ids[i]}_2P  \
        --genomeDir /r/corals/Nitya/pipelines/star_output/genome_indices \
        --sjdbGTFfeatureExon exon \
        --sjdbGTFtagExonParentTranscript Parent \
        --sjdbGTFfile /r/corals/Nitya/pipelines/annotations/Mcap.exons.GFFannotation.gff \
        --twopassMode Basic \
        --twopass1readsN -1 \
        --outStd Log BAM_Unsorted BAM_Quant \
        --outSAMtype BAM Unsorted \
        --outReadsUnmapped Fastx \
        --outFileNamePrefix /r/corals/Nitya/pipelines/star_output/aligned_reads/${ids[i]}
    else
        STAR \
        --runMode alignReads \
        --quantMode TranscriptomeSAM \
        --outTmpDir /r/corals/Nitya/pipelines/star_output/aligned_reads/${ids[i]} \
        --readFilesIn /r/corals/Nitya/pipelines/fastq/trimmed/${ids[i]}_1P /r/corals/Nitya/pipelines/fastq/trimmed/${ids[i]}_2P  \
        --genomeDir /r/corals/Nitya/pipelines/star_output/genome_indices \
        --sjdbGTFfeatureExon exon \
        --sjdbGTFtagExonParentTranscript Parent \
        --sjdbGTFfile /r/corals/Nitya/pipelines/annotations/Pacuta.exons.GFFannotation.gff \
        --twopassMode Basic \
        --twopass1readsN -1 \
        --outStd Log BAM_Unsorted BAM_Quant \
        --outSAMtype BAM Unsorted \
        --outReadsUnmapped Fastx \
        --outFileNamePrefix /r/corals/Nitya/pipelines/star_output/aligned_reads/${ids[i]}
    fi
done
