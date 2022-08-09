---
layout: post
title: Wednesday, June 22
date: 2022-06-22
categories: Express_Compare
tags: Bioinformatics
---

## download *P.acuta* version 2 and copy to remote directory

[*P.acuta version 2 reference genome](http://cyanophora.rutgers.edu/Pocillopora_acuta/)

* for HiSat2 alignment, we will use the reference genome which is a .fasta file

## copy from local Express Compare directoy to remote directory and unzip file
```
scp Pocillopora_acuta_HIv2.assembly.fasta.gz laurenzane@ssh3.hac.uri.edu:/data/putnamlab/shared/Express_Compare/REF
<br>
gunzip Pocillopora_acuta_HIv2.assembly.fasta.gz

```
## use HiSat2-build to build index for *P. acuta* genomes

```
module load HISAT2/2.2.1-foss-2019b
hisat2-build -f REF/Pocillopora_acuta_HIv2.assembly.fasta REF/Pacuta

```
## symbolically link cleaned and trimmed fastq files to the REF directory from the QC directory

```
ln -s /data/putnamlab/shared/Express_Compare/QC/trimmed/pacuta/*fastq* ./

```

## run HiSat2
* job numbers:
  * 154220; status = failed (copied old script incorrectly to new script)
  * 154222; status =
```

#!/bin/bash
#SBATCH --job-name="pacuta-align-v2"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/REF
#SBATCH --exclusive #SBATCH -c 20

module load SAMtools/1.10-GCC-8.3.0
module load HISAT2/2.2.1-foss-2019b

ids=("1041" "1471" "1637" "Sample1" "Sample2" "Sample3")
for file in "${ids[@]}";
do hisat2 -p 20 --rf --dta -q -x Pacuta_index/Pacuta -1 "$fi$
samtools sort -@ 20 -o "$file".bam "$file".sam;
done

``` 
