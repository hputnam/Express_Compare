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
