#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 4
#SBATCH --mem=16G

conda activate QAA

conda list -n QAA

/usr/bin/time -v fastqc -o ./FastQC_Output /projects/bgmp/shared/2017_sequencing/demultiplexed/Undetermined_S0_L008_R1_001.fastq.gz 
/usr/bin/time -v fastqc -o ./FastQC_Output /projects/bgmp/shared/2017_sequencing/demultiplexed/Undetermined_S0_L008_R2_001.fastq.gz
/usr/bin/time -v fastqc -o ./FastQC_Output /projects/bgmp/shared/2017_sequencing/demultiplexed/7_2E_fox_S6_L008_R1_001.fastq.gz
/usr/bin/time -v fastqc -o ./FastQC_Output /projects/bgmp/shared/2017_sequencing/demultiplexed/7_2E_fox_S6_L008_R2_001.fastq.gz

exit