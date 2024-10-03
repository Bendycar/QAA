#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 8
#SBATCH --time=0-3

conda activate QAA

conda list -n QAA

/usr/bin/time -v STAR --runThreadN 8 \
--runMode alignReads \
--outFilterMultimapNmax 3 \
--outSAMunmapped Within KeepPairs \
--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--readFilesCommand zcat \
--readFilesIn /home/bcarr/bgmp/bioinfo/Bi623/QAA/Fox_trimmed_1P.fastq.gz /home/bcarr/bgmp/bioinfo/Bi623/QAA/Fox_trimmed_2P.fastq.gz \
--genomeDir /home/bcarr/bgmp/bioinfo/Bi623/QAA/STAR_Database \
--outFileNamePrefix 7_2E_fox_S6_L008

exit