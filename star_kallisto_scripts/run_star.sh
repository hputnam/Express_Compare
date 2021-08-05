#!/bin/bash
#SBATCH --mem=64G
#SBATCH --array=54-65
#SBATCH -n 10

# Separate by species

module load STAR/2.5.3a-foss-2016b

if ((${SLURM_ARRAY_TASK_ID} > 54)) && ((${SLURM_ARRAY_TASK_ID} < 65)) && ((${SLURM_ARRAY_TASK_ID} !=  54)) && ((${SLURM_ARRAY_TASK_ID} != 57)) && ((${SLURM_ARRAY_TASK_ID} != 58)) && ((${SLURM_ARRAY_TASK_ID} != 59)) && ((${SLURM_ARRAY_TASK_ID} != 60));
then
    GENOME=/path/to/annotations/pacuta.gff
else
    GENOME=/path/to/annotations/mcap.gff
fi

STAR \
--runMode alignReads \
--quantMode TranscriptomeSAM \
--outTmpDir /path/to/temp/dir/${SLURM_ARRAY_TASK_ID}_TMP \
--readFilesIn /path/to/fastq/trimmed/SRR150897${SLURM_ARRAY_TASK_ID}_1P /path/to/fastq/trimmed/SRR150897${SLURM_ARRAY_TASK_ID}_2P  \
--genomeDir /r/corals/Nitya/pipelines/star_output/genome_indices/ \
--sjdbGTFfeatureExon exon \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFfile ${GENOME} \
--twopassMode Basic \
--twopass1readsN -1 \
--outStd Log BAM_Unsorted BAM_Quant \
--outSAMtype BAM Unsorted \
--outReadsUnmapped Fastx \
--outFileNamePrefix /path/to/out/aligned_reads/SRR150897${SLURM_ARRAY_TASK_ID}
