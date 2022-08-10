## GATK downsampling for *M. cap* 

### Date: 20220810 

### notes: I am redo-ing the downsampling step because originally I downsampled to the lowest number of reads for all samples regardless of species. I decided to downsample to the lowest number within a species because the annotation qualities and mapping efficiency will differ per species. Coincidentally, 

### load modules
```
module load SAMtools/1.12-GCC-10.2.0
module load picard/2.25.1-Java-11
java -jar $EBROOTPICARD/picard.jar
```
### count original number of reads in *M. cap* .bam files
```
for file in *.bam
> do
> echo $file
> samtools view -c $file
> done
```

### downsampling information table 
Species | Sample_ID | number of reads | P
------- | --------- | --------------- | --
*M. cap* | 1101 | 39764959 | 0.53
*M. cap* | 1548 | 30727605 | 0.70
*M. cap* | 1628 | 38182073 | 0.55
*M. cap* | Sample4 | 21361627 | 1
*M. cap* | Sample5 | 36480300 | 0.58
*M. cap* | Sample6 | 29665414 | 0.72

## reads were downsampled to 21,361,627 reads 

```
java -jar $EBROOTPICARD/picard.jar DownsampleSam INPUT=Sample6.bam O=Sample6.downsampled.bam P=0.72

```

#### arguments 

* INPUT = $file.bam 
    * input bam file from HiSat2 alignment output
* O = $file.downsampled.bam 
    * output is also a bam file, but it is helpful to denote that the file has been downsampled 
* P = proportion of reads to downsample to-- for example if you woud like to downsample to 50% of the total reads, P would = 0.5; this number should change based on the number of reads you have per sample
 

# count reads in downsampled .bam files to confirm successful downsampling 
```
for file in *downsampled.bam
> do
> echo $file
> samtools view -c $file
> done
```
Sample_ID | number of reads
------------|------------
1101.downsampled.bam | 21072988
1548.downsampled.bam | 21503609
1628.downsampled.bam | 20999607
Sample4.downsampled.bam | 21361627
Sample5.downsampled.bam | 21163426
Sample6.downsampled.bam | 21373799

