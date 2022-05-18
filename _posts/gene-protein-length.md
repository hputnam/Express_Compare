---
layout: post
title: Wednesday May 18
date: 2022-05-18
categories: Express_Compare
tags: GOSeq
---
The GOSeq package typically relies on the UCSC genome browser for gene length. Neither *Mcap* nor *Pacuta* are on the list of supported organisms, the user must supply length data and the category mappings. This post details how to obtain length data from genome assembly/protein-coding genes.

Genome assembly and predicted protein-coding genes for [*M. capitata*](http://cyanophora.rutgers.edu/montipora/)and [*P. acuta*](http://cyanophora.rutgers.edu/Pocillopora_acuta/)
Scripts adapted from [Sediment Stress Project, by Jill Ashey](https://github.com/JillAshey/SedimentStress/blob/master/Bioinf/TranscriptLengths.md)

## *Montipora capitata*

```
# transcript length

awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,length($0)}' Montipora_capitata_HIv2.assembly.fasta > length.mRNA_Mcap.txt

# protein length

awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,length($0)}' Montipora_capitata_HIv2.genes.gff3 > length.protein_Mcap.txt

```
## *Pocillopora acuta*
```
# transcript length

awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,length($0)}' Pocillopora_acuta_HIv1.assembly.fasta > length.mRNA_Pacuta.txt

# protein length

awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,length($0)}' Pocillopora_acuta_HIv1.genes.gff3 > length.protein_Pacuta.txt
```
