#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 4
#SBATCH --mem=16G

conda activate QAA

conda list -n QAA

/usr/bin/time -v trimmomatic PE Undetermined_R1_cut Undetermined_R2_cut -baseout Undetermined_trimmed.fastq.gz \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:5:15 \
MINLEN:35

/usr/bin/time -v trimmomatic PE fox_R1_cut Fox_R2_cut -baseout Fox_trimmed.fastq.gz \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:5:15 \
MINLEN:35

exit