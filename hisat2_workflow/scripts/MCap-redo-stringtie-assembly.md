## stringtie assembly for *M. cap* aligned to the version 2 genome, redone on 20220810 with reads downsampled to lowest read count by species rather than all samples

## date: 20220810

## Stringtie assembly 1

#### I copied the downsampled BAM filesfrom the hisat2_alignment/mcap/BAM/downsampled directory, to the directory where I will run the Stringtie assemblies and merge

```
cp ./*.bam* /data/putnamlab/shared/Express_Compare/stringtie_assembly/Mcap_BAM

```

#### to set up for Stringtie assembly, symbolically link the reference genome (GFF3 format) to the directory with downsampled BAM files 

```
ln -s /data/putnamlab/shared/Express_Compare/REF/Montipora_capitata_HIv2.genes.gff3

```

#### create a shell script containing Stringtie assembly arguments

```
nano mcap-redo-stringtie-assembly.sh

``` 
## shell script 
```
#!/bin/bash
#SBATCH --job-name="ZaneStringtieAssemblyMCapREDO"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/stringtie_assembly/Mcap_BAM
#SBATCH --exclusive #SBATCH -c 20

module load StringTie/2.1.3-GCC-8.3.0

ids=("1101" "1548" "1628" "Sample4" "Sample5" "Sample6")
for file in "${ids[@]}"
do
stringtie -A gene_abundance/"$file".gene_abundance.tab -p 8 --rf -e -G Montipora_capitata_HIv2.genes.gff3 -o "$file".gtf "$file".downsampled.bam
done
```
#### submit batch job 
```
sbatch mcap-redo-stringtie-assembly.sh
```

#### sbatch information 
date | batch number | successful | slurm ouput deleted? | notes
---- | ------------ | ---------- | ----- | --------
20220810 | 170310 | yes | no | n/a 

## Stringtie merge 

#### symbolically link gene annotations to directory with gtf files 
```
ln -s /data/putnamlab/shared/Express_Compare/REF/Montipora_capitata_HIv2.genes.gff3
```

#### create a .txt file containing a list of gtf files used in merge mode 
```
nano mcap-redo-merge-list.txt
```

#### copy list of .gtf files into the .txt file with one file per line 
```
1101.gtf
1548.gtf
1628.gtf
Sample4.gtf
Sample5.gtf
Sample6.gtf
```

#### execute Stringtie merge in directory containing .gtf files from Stringtie assembly
```
module load StringTie/2.1.3-GCC-8.3.0
stringtie --merge -p 8 -G Montipora_capitata_HIv2.genes.gff3 -o mcap-redo-merged.gtf mcap-redo-merge-list.txt
```

#### Stringtie merge arguments:
    * --merge: specifies merge mode (see above for explanation)
    * -p: specifies the number of processing threads (CPUs) to use for transcript assembly. The default is 1 
    * -G: reference genome included in merging of GTF files
    * -o: output file name
    * <mcap-redo-merge-list.txt>: this text file contains the list of GTF files to be merged 

#### create additional script for Stringtie run 2 

```
nano mcap-redo-stringtie-assembly2.sh
```
```
#!/bin/bash
#SBATCH --job-name="ZaneStringtieAssembly2McapREDO"
#SBATCH -t 100:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=laurenzane@uri.edu
#SBATCH -D /data/putnamlab/shared/Express_Compare/stringtie_assembly/Mcap_BAM
#SBATCH --exclusive #SBATCH -c 20

module load StringTie/2.1.3-GCC-8.3.0
ids=("1101" "1548" "1628" "Sample4" "Sample5" "Sample6")
for file in "${ids[@]}"
do
stringtie -A gene_abundance/"$file".gene_abundance.tab -p 8 --rf -e -G /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF1-redo/mcap-redo-merged.gtf -o "$file".2.gtf "$file".downsampled.bam
done
```

#### sbatch information 

date | batch number | successful | slurm ouput deleted? | notes
---- | ------------ | ---------- | ----- | --------
20220810 | 170316 | yes | no | n/a

## compiling GTF output files into gene and transcript count matrices for run 1 and 2 of Stringtie assembly

#### create a text file containing a list of all samples 
```
nano samplelist.txt
```

#### .txt file contents
```
1101.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/1101.2.gtf
1548.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/1548.2.gtf
1628.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/1628.2.gtf
Sample4.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/Sample4.2.gtf
Sample5.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/Sample5.2.gtf
Sample6.2.gtf /data/putnamlab/shared/Express_Compare/stringtie_assembly/Output/Mcap/GTF2-redo/Sample6.2.gtf
```
#### compile GTF output files into gene and transcript count matrices

```
module load StringTie/2.1.3-GCC-8.3.0
prepDE.py -g gene_count_matrix2.csv -t transcript_count_matrix2.csv -i samplelist.txt
```
## from local directory copy counts matrices from remote directory 
```
scp laurenzane@ssh3.hac.uri.edu:/data/putnamlab/shared/Express_Compare/stringtie_assembly/stringtie_counts_matrices/Mcap/redo*.csv* ./
```

