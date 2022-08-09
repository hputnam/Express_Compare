## GATK downsampling for *P. acuta* version 2 genome 
## Date: 20220808 


# load modules
```
module load SAMtools/1.12-GCC-10.2.0
module load picard/2.25.1-Java-11
java -jar $EBROOTPICARD/picard.jar
```
# count original number of reads in *P. acuta* .bam files
```
for file in *.bam
> do
> echo $file
> samtools view -c $file
> done
```

Species | Sample_ID | number of reads | P
------- | --------- | --------------- | --
*P. acuta* | 1041 | 29542860 | 0.57
*P. acuta* | 1471 | 24810652 | 0.68
*P. acuta* | 1637 | 25696486 | 0.65
*P. acuta* | Sample1 | 26187725 | 0.64
*P. acuta* | Sample2 | 16860951 | 1
*P. acuta* | Sample 3 | 20484189 | 0.82


# perform downsampling to about 16.860,951 reads per sample 
```
java -jar $EBROOTPICARD/picard.jar DownsampleSam INPUT=Sample3.bam O=Sample3.downsampled.bam P=0.82

```
#### arguments 

* INPUT = $file.bam 
    * input bam file from HiSat2 alignment output
* O = $file.downsampled.bam 
    * output is also a bam file, but it is helpful to denote that the file has been downsampled 
* P = proportion of reads to downsample to-- for example if you woud like to downsample to 50% of the total reads, P would = 0.5; this number should change based on the number of reads you have per sampel 
 

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
1041.downsampled.bam | 16834609
1471.downsampled.bam | 16872376
1637.downsampled.bam | 16698575
Sample1.downsampled.bam | 16763699
Sample2.downsampled.bam | 16860951
Sample3.downsampled.bam | 16795882

