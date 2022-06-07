## GATK downsampling protocol

# load modules
```
module load SAMtools/1.12-GCC-10.2.0
module load picard/2.25.1-Java-11
java -jar $EBROOTPICARD/picard.jar
```
# count original number of reads in .bam files
```
for file in *.bam
> do
> echo $file
> samtools view -c $file
> done
```
# perform downsampling to about 2 million reads per Sample
```
java -jar $EBROOTPICARD/picard.jar DownsampleSam INPUT=1041.bam O=1041.downsampled.bam P=0.2
```
# count reads in downsampled .bam files

Sample_ID | number of reads
------------|------------
1041.downsampled.bam | 18975322
1101.downsampled.bam | 18684042
1471.downsampled.bam | 19017022
1548.downsampled.bam | 19045874
1628.downsampled.bam | 19087149
1637.downsampled.bam | 18894850
Sample1.downsampled.bam | 18980246
Sample2.downsampled.bam | 19067556
Sample3.downsampled.bam | 19040496
Sample4.downsampled.bam | 19005470
Sample5.downsampled.bam | 18975898
Sample6.downsampled.bam | 19004386
