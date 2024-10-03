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
--readFilesIn /home/bcarr/bgmp/bioinfo/Bi623/QAA/Undetermined_trimmed_1U.fastq.gz /home/bcarr/bgmp/bioinfo/Bi623/QAA/Undetermined_trimmed_2P.fastq.gz \  #NOTE: Should have used 1P, not 1U!
--genomeDir /home/bcarr/bgmp/bioinfo/Bi623/QAA/STAR_Database \
--outFileNamePrefix Undetermined_S0_L008

exit
