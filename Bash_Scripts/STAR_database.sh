#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 8
#SBATCH --time=0-3

conda activate QAA

conda list -n QAA

/usr/bin/time -v STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir /home/bcarr/bgmp/bioinfo/Bi623/QAA/STAR_Database \
--genomeFastaFiles /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.dna_sm.primary_assembly.fa \
--sjdbGTFfile /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.112.gtf

exit
