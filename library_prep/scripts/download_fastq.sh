#!/bin/bash

cd /r/corals/Nitya/kallisto/fastq/not_trimmed

echo downloading files

#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/054/SRR15089754/SRR15089754_1.fastq.gz
#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/054/SRR15089754/SRR15089754_2.fastq.gz

#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/055/SRR15089755/SRR15089755_1.fastq.gz
#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/055/SRR15089755/SRR15089755_2.fastq.gz

#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/056/SRR15089756/SRR15089756_1.fastq.gz
#wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/056/SRR15089756/SRR15089756_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/057/SRR15089757/SRR15089757_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/057/SRR15089757/SRR15089757_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/058/SRR15089758/SRR15089758_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/058/SRR15089758/SRR15089758_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/059/SRR15089759/SRR15089759_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/059/SRR15089759/SRR15089759_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/060/SRR15089760/SRR15089760_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/060/SRR15089760/SRR15089760_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/061/SRR15089761/SRR15089761_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/061/SRR15089761/SRR15089761_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/062/SRR15089762/SRR15089762_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/062/SRR15089762/SRR15089762_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/063/SRR15089763/SRR15089763_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/063/SRR15089763/SRR15089763_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/064/SRR15089764/SRR15089764_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/064/SRR15089764/SRR15089764_2.fastq.gz

wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/065/SRR15089765/SRR15089765_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/SRR150/065/SRR15089765/SRR15089765_2.fastq.gz

#makes all the files public
for file in *.fastq.gz
do
	chmod 755 $file
done
