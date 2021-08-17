#!/bin/bash
#SBATCH --job-name="sra"
#SBATCH -t 500:00:00
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=erin_chille@uri.edu
#SBATCH --exclusive
#SBATCH -D /data/putnamlab/erin_chille/Express_Compare

##This script is to upload raw sequencing reads to ncbi for a SRA submission

module load Aspera-Connect/3.9.6

echo "Starting upload" $(date)
ascp -i /data/putnamlab/erin_chille/Express_Compare/aspera.openssh -QT -l100m -k1 -d /data/putnamlab/erin_chille/Express_Compare subasp@upload.ncbi.nlm.nih.gov:uploads/hputnam_uri.edu_QNN358Eq
echo "Upload complete" $(date)
