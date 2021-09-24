# RNA-seq STAR Pipeline
## Montipora capitata and Pocillopora acuta
https://www.ncbi.nlm.nih.gov/bioproject/PRJNA744524
Megan Gelement and Nitya Nadgir <br>
Reference: Jill Ashey STAR pipeline

### 1) Get the data

a) Make directories to store STAR output
```
cd /r/corals/Nitya/pipelines
mkdir star_output
chmod 775 star_output
cd star_output
mkdir genome_indices
chmod 775 genome_indices
mkdir aligned_reads
chmod 775 aligned_reads
mkdir genomes
mkdir annotations
```

b) obtain reference genome (.fasta or .fna) and reference annotation (.gtf or .gff).
```
cd /r/corals/Hollie/Public/Coral_Resources/Genomes/Coral/Pacuta
cp Pocillopora_acuta_genome_v1.fasta ../../../../../../Nitya/pipelines/genomes
cd ../Mcap
cp Mcap.genome_assembly.fa.gz ../../../../../../Nitya/pipelines/genomes
cd /r/corals/Nitya/pipelines/genomes
gzip -d Mcap.genome_assembly.fa.gz
chmod 775 Mcap.genome_assembly.fa
mv Mcap.genome_assembly.fa mcap_genome.fa
mv Pocillopora_acuta_genome_v1.fasta pacuta_genome.fasta  
```
c) copy reference annotation to working directory
```
cd /r/corals/Hollie/Public/Coral_Resources/Genomes/Coral/Pacuta
cp Structural_annotation_experimental.gff ../../../../../../Nitya/pipelines/annotations
mv Structural_annotation_experimental.gff pacuta.gff
wget http://cyanophora.rutgers.edu/montipora/Mcap.GFFannotation.gff
mv Mcap.GFFannotation.gff mcap.gff
chmod 775 mcap.gff
```
d) Dr. Hollie Putnam's R script to "fix" M. capitata gff annotation file
```
#Load Mcap gene gff
Mcap.gff <- read.csv(file="genome-feature-files/Mcap.GFFannotation.gff.1", header=FALSE, sep="\t") 

#rename columns
colnames(Mcap.gff) <- c("scaffold", "Gene.Predict", "id", "gene.start","gene.stop", "pos1", "pos2","pos3", "gene")


#NEED TO SUB 2 NUMBERS AFTER _cds
Mcap.gff$gene <- gsub("_cds[0123456789]*;", ".t1;", Mcap.gff$gene) #change the second part of the GeMoMa genes from cds11 to t.1 to match Augustus
Mcap.gff$gene <-sub("(;[^;]+);.*", "\\1", Mcap.gff$gene) #remove everything after the second ; in the gene column
Mcap.gff$gene <- gsub("Parent=", "  gene_id ", Mcap.gff$gene) #remove ID= from GeMoMa genes

#If id ==CDS replace ID= with transcript_id, else replace with nothing
Mcap.gff <- Mcap.gff %>% 
  mutate(gene = ifelse(Gene.Predict %in% c("GeMoMa") & 
                         id == "CDS" ,  
                       gsub("ID=", "transcript_id ", gene), gsub("ID=", "", gene)))

#If id ==gene remove everything after the ; else replace with nothing
Mcap.gff <- Mcap.gff %>% 
  mutate(gene = ifelse(Gene.Predict %in% c("GeMoMa") & 
                         id == "gene" ,  
                       gsub(";.*", "", gene), gsub("ID=", "", gene)))

# sub to add quotes around the transcript name
Mcap.gff$gene <- gsub("transcript_id ", "transcript_id \"", Mcap.gff$gene) 
Mcap.gff$gene <- gsub(";", "\";", Mcap.gff$gene) 

#add quotes before the gene_id
Mcap.gff$gene <- gsub("gene_id ", "gene_id \"", Mcap.gff$gene) 

#If id ==CDS add "; at the end else replace with nothing
Mcap.gff <- Mcap.gff %>% 
  mutate(gene = ifelse(id == "CDS" ,  
                         paste0(gene, "\";"), paste0(gene, "")))

#save file
write.table(Mcap.gff, file="/Users/hputnam/MyProjects/Meth_Compare/genome-feature-files/Mcap.GFFannotation.fixed.gff", sep="\t", 
            col.names = FALSE, row.names=FALSE, quote=FALSE)
```

### 2) Create Genome Indices
a) create directory to store genome indices
```
mkdir genome_indices
chmod 775 genome_indices
```
b) create genome index for M. cap: ```mcap_genome_index.sh```
```
#!/bin/bash
#SBATCH --mem=64G

STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir //r/corals/Nitya/pipelines/star_output/genome_indices/mcap \
--genomeFastaFiles /r/corals/Nitya/pipelines/genomes/mcap_genome.fa \
--sjdbGTFfile /r/corals/Nitya/pipelines/annotations/Mcap.exons.GFFannotation.gff
```

c) create genome index for P. acuta
```
STAR --runThreadN 10 \
--runMode genomeGenerate \
--genomeDir /r/corals/Nitya/pipelines/star_output/genome_indices/pacuta \
--genomeFastaFiles /r/corals/Nitya/pipelines/genomes/pacuta_genome.fasta \
--sjdbGTFfile /r/corals/Nitya/pipelines/annotations/Structural_annotation_experimental.gff
```

### 3) Run STAR
```
#!/bin/bash
#SBATCH --mem=64G

ids=( "SRR15089754" "SRR15089755" "SRR15089756" "SRR15089757" "SRR15089758" "SRR15089759" "SRR15089760" "SRR15089761" "SRR15089762" "SRR15089763" "SRR15089764" "SRR15089765" )

length=${#ids[@]}

for (( i=0; i<length; i++ ))
do
    # Separate by species
    if ((i != 1)) && ((i != 2)) && ((i != 7)) && ((i != 8)) && ((i != 9)) && ((i != 10)); 
    then
        # Sample is M. cap 
        
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
        # Sample is P. acuta
        
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
```

b) run Stringtie
```
#!/bin/bash

# For mcap
stringtie -p 1 -G /r/corals/Nitya/pipelines/annotations/Mcap.exons.GFFannotation.gff -o output_mcap.gff mcap.bam

# For pacuta
stringtie -p 1 -G /r/corals/Nitya/pipelines/annotations/Structural_annotation_experimental.gff -o output_pacuta.gff pacuta.bam
```
