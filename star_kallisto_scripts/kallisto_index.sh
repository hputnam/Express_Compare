#!/bin/bash 
cd ../indices

# Create Pacuta Index
wget https://osf.io/nr83q/download
mv download pacuta_transcriptome.fasta
kallisto index -i pacuta_index.idx acuta_transcriptome.fasta
chmod 775 pacuta_index.idx

# Create Mcap index
wget http://cyanophora.rutgers.edu/montipora/Mcap.mRNA.fa.gz
mv Mcap.mRNA.fa Mcap.fa
kallisto index -i mcap_index.idx Mcap.fa
chmod 775 mcap_index.fa
