# RNA-Seq STAR Pipeline
## Montipora capitata and Pocillopora acuta
https://www.ncbi.nlm.nih.gov/bioproject/PRJNA744524
Megan Gelement <br>
Reference: Jill Ashey STAR pipeline, Nitya Nadgir STAR pipeline

Working directory: /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/

### 1) Get the data
Copy trimmed reads from Tufts server onto Tufts HPC: 

```
rsync -azPh /r/corals/Nitya/pipelines/fastq/trimmed/ mgelem01@login.pax.tufts.edu:/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare

```
Copied Mcap.exons.GFFannotation.gff and Pacuta.exons.GFFannotation.gff from /r/corals/Nitya/pipelines/annotations.

Copied mcap_genome.fa and pacuta_genome.fasta from /r/corals/Nitya/pipelines/genomes.

Subdirectories: "Genomes" holds genome fasta files; "Annotation Files" holds annotation files; "Trimmed_Reads_Fastp/Mcap" and "Trimmed_Reads_Fastp/Pacuta" hold the reads trimmed with Fastp; "Trimmed_Reads_Trimmomatic/Mcap" and "Trimmed_Reads_Trimmomatic/Pacuta" hold the reads trimmed with Trimmomatic (see documentation by Nitya Nadgir (UPDATE WITH PATH TO CORRECT DOCUMENTATION) for detailed process).


### 2) Create Genome Indices

Run script to generate indices:
```
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
```

### 3) Install stringtie

From working directory:
```
git clone https://github.com/gpertea/stringtie
cd stringtie
```

Download zlib source code from https://zlib.net (version 1.2.11, tar.gz format) and unzip:

```
scp /Users/megangelement/Downloads/zlib-1.2.11.tar mgelem01@login.pax.tufts.edu:/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/stringtie
tar -xvf zlib-1.2.11.tar
rm zlib-1.2.11.tar
mv zlib-1.2.11/ zlib/
```

Update stringtie Makefile. The following changes were made: 

On line 4, added:
```
ZLIB := ./zlib
```
On line 7, added -I${ZLIB} to INCDIRS:
```
INCDIRS := -I. -I${GDIR} -I${BAM} -I${ZLIB}
```
On line 30, added: 
```
LDFLAGS += -L${ZLIB}
```

To compile and test stringtie: 
```
make release
make test
```

Results: 
```
Test 1: Short reads
  OK.
Test 2: Short reads and super-reads
  OK.
Test 3: Long reads
  OK.
Test 4: Long reads with annotation guides
  OK.
```

### 4) Run STAR and stringtie
#### a) Run the script below on the Trimmomatic reads:

```
#!/bin/bash
#SBATCH -J run_star_exp
#SBATCH --time=00-06:00:00
#SBATCH -c 11
#SBATCH --array=54-65 
#SBATCH --output=MyJob.%j.%N.out  #saving standard output to file, %j=JOBID,%N=NodeName
#SBATCH --error=MyJob.%j.%N.err   #saving standard error to file, %j=JOBID,%N=NodeName
#SBATCH --mem=128G
#SBATCH --mail-type=ALL    #email options
#SBATCH --mail-user=megan.gelement@tufts.edu

# useful var:
# SLURM_ARRAY_TASK_ID
# thus, filename of interest will be:
# /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/SRR*${SLURM_ARRAY_TASK_ID}_*P

umask 007
outputdir="/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare"

module load STAR

# BEFORE RUNNING THIS:
# Make sure that $(outputdir) and $(outputdir)/Output

mkdir ${outputdir}/Output/${SLURM_ARRAY_TASK_ID}

# sort by genome; P. acuta annotation file in GFF3 format requires paramter "sjdbGTFtagExonParentTranscript Parent" instead of default (transcript_id)
if [[ "${SLURM_ARRAY_TASK_ID}" =~ ^(54|57|58|59|60|65)$ ]]; then 
  genome="Mcap"
   STAR \
   --runThreadN 10 \
   --runMode alignReads \
   --quantMode TranscriptomeSAM \
   --outTmpDir ${outputdir}/TMP/${SLURM_ARRAY_TASK_ID}_TMP \
   --readFilesIn /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Trimmomatic/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_1P /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Trimmomatic/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_2P \
   --genomeDir ${outputdir}/Indices/${genome}/ \
   --sjdbGTFfeatureExon exon \
   --sjdbGTFfile ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
   --twopassMode Basic \
   --twopass1readsN -1 \
   --outStd Log BAM_Unsorted BAM_Quant \
   --outSAMtype BAM SortedByCoordinate \
   --outReadsUnmapped Fastx \
   --outFileNamePrefix ${outputdir}/Output/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.
else
  genome="Pacuta"
  STAR \
  --runThreadN 10 \
  --runMode alignReads \
  --quantMode TranscriptomeSAM \
  --outTmpDir ${outputdir}/TMP/${SLURM_ARRAY_TASK_ID}_TMP \
  --readFilesIn /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Trimmomatic/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_1P /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Trimmomatic/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_2P \
  --genomeDir ${outputdir}/Indices/${genome}/ \
  --sjdbGTFfeatureExon exon \
  --sjdbGTFtagExonParentTranscript Parent \
  --sjdbGTFfile ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
  --twopassMode Basic \
  --twopass1readsN -1 \
  --outStd Log BAM_Unsorted BAM_Quant \
  --outSAMtype BAM SortedByCoordinate \
  --outReadsUnmapped Fastx \
  --outFileNamePrefix ${outputdir}/Output/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.
fi

/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/stringtie/stringtie -e -B \
 -G ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
 -o ${outputdir}/Output/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.gtf \
 ${outputdir}/Output/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.Aligned.sortedByCoord.out.bam
```

#### b) Run the (only slightly altered) script below on the fastp reads:

```
#!/bin/bash
#SBATCH -J run_star_exp
#SBATCH --time=00-06:00:00
#SBATCH -c 11
#SBATCH --array=54-65 
#SBATCH --output=MyJob.%j.%N.out  #saving standard output to file, %j=JOBID,%N=NodeName
#SBATCH --error=MyJob.%j.%N.err   #saving standard error to file, %j=JOBID,%N=NodeName
#SBATCH --mem=128G
#SBATCH --mail-type=ALL    #email options
#SBATCH --mail-user=megan.gelement@tufts.edu

umask 007
outputdir="/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare"

module load STAR

# BEFORE RUNNING THIS:
# Make sure that $(outputdir) and $(outputdir)/Output_Fastp

mkdir ${outputdir}/Output_Fastp/${SLURM_ARRAY_TASK_ID}

# sort by genome; P. acuta annotation file in GFF3 format requires parameter "sjdbGTFtagExonParentTranscript Parent" instead of default (transcript_id)
if [[ "${SLURM_ARRAY_TASK_ID}" =~ ^(54|57|58|59|60|65)$ ]]; then
  genome="Mcap"
   STAR \
   --runThreadN 10 \
   --runMode alignReads \
   --quantMode TranscriptomeSAM \
   --outTmpDir ${outputdir}/TMP_Fastp/${SLURM_ARRAY_TASK_ID}_TMP \
   --readFilesIn /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Fastp/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_1.fastq /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Fastp/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_2.fastq \
   --genomeDir ${outputdir}/Indices/${genome}/ \
   --sjdbGTFfeatureExon exon \
   --sjdbGTFfile ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
   --twopassMode Basic \
   --twopass1readsN -1 \
   --outStd Log BAM_Unsorted BAM_Quant \
   --outSAMtype BAM SortedByCoordinate \
   --outReadsUnmapped Fastx \
   --outFileNamePrefix ${outputdir}/Output_Fastp/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.
else
  genome="Pacuta"
  STAR \
  --runThreadN 10 \
  --runMode alignReads \
  --quantMode TranscriptomeSAM \
  --outTmpDir ${outputdir}/TMP_Fastp/${SLURM_ARRAY_TASK_ID}_TMP \
  --readFilesIn /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Fastp/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_1.fastq /cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/Trimmed_Reads_Fastp/${genome}/SRR150897${SLURM_ARRAY_TASK_ID}_2.fastq \
  --genomeDir ${outputdir}/Indices/${genome}/ \
  --sjdbGTFfeatureExon exon \
  --sjdbGTFtagExonParentTranscript Parent \
  --sjdbGTFfile ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
  --twopassMode Basic \
  --twopass1readsN -1 \
  --outStd Log BAM_Unsorted BAM_Quant \
  --outSAMtype BAM SortedByCoordinate \
  --outReadsUnmapped Fastx \
  --outFileNamePrefix ${outputdir}/Output_Fastp/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.
fi

/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare/stringtie/stringtie -e -B \
 -G ${outputdir}/Annotation_Files/${genome}.exons.GFFannotation.gff \
 -o ${outputdir}/Output_Fastp/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.gtf \
 ${outputdir}/Output_Fastp/${SLURM_ARRAY_TASK_ID}/${SLURM_ARRAY_TASK_ID}.Aligned.sortedByCoord.out.bam
```

### 5) Run prepDE on Trimmomatic and Fastp Output

Get current version of prepDE < ... > 

```
#!/bin/bash
#SBATCH -J run_prep_DE
#SBATCH --time=00-00:20:00
#SBATCH --output=MyJob.%j.%N.out  #saving standard output to file, %j=JOBID,%N=NodeName
#SBATCH --error=MyJob.%j.%N.err   #saving standard error to file, %j=JOBID,%N=NodeName
#SBATCH --mail-type=ALL
#SBATCH --mail-user=megan.gelement@tufts.edu


# This script runs prepDE.py3 on each species by library prep method and trimming method

dataset=(Mcap_PolyA Mcap_RiboFree Pacu_PolyA Pacu_RiboFree)
datadir="/cluster/tufts/cowenlab/Projects/Run_STAR_Express_Compare"

module load python/3.5.0

for i in "${dataset[@]}"
	do
		# Fastp
		echo "Creating gene count matrix for fastp data: "
		echo $i
		# Copy prepDE script to relevant directory
		cp ${datadir}/stringtie/prepDE.py3 ${datadir}/Output_Fastp/$i
		cd ${datadir}/Output_Fastp/$i
		umask 007
		# Run script
		python3 prepDE.py3
		# Remove copy	
		rm prepDE.py3
		
		# Trimmomatic
		echo "Creating gene count matrix for trimmomatic data: "
		echo $i
		cp ${datadir}/stringtie/prepDE.py3 ${datadir}/Output_Trimmomatic/$i
		cd ${datadir}/Output_Trimmomatic/$i
		umask 007
		python3 prepDE.py3
		rm prepDE.py3
	done
```

