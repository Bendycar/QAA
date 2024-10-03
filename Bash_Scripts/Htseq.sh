#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 4
#SBATCH --mem=128G

conda activate QAA

conda list -n QAA

/usr/bin/time -v htseq-count --stranded=yes /home/bcarr/bgmp/bioinfo/Bi623/QAA/7_2E_fox_S6_L008Aligned.out.sam /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.112.gtf > fox_stranded.out

/usr/bin/time -v htseq-count --stranded=reverse /home/bcarr/bgmp/bioinfo/Bi623/QAA/7_2E_fox_S6_L008Aligned.out.sam /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.112.gtf > fox_reverse.out

/usr/bin/time -v htseq-count --stranded=yes /home/bcarr/bgmp/bioinfo/Bi623/QAA/Undetermined_S0_L008Aligned.out.sam /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.112.gtf > Undetermined_stranded.out

/usr/bin/time -v htseq-count --stranded=reverse /home/bcarr/bgmp/bioinfo/Bi623/QAA/Undetermined_S0_L008Aligned.out.sam /home/bcarr/bgmp/bioinfo/Bi623/QAA/Mus_musculus.GRCm39.112.gtf > Undetermined_reverse.out

exit