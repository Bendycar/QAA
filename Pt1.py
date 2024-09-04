#!/usr/bin/env python
import argparse
import bioinfo
import argparse
import numpy as np
import matplotlib.pyplot as plt
import gzip

def get_args():

    parser = argparse.ArgumentParser(description="Takes all 4 FASTQ files")
    parser.add_argument("-r", help="FASTQ file to be analyzed", type = str, required = True)
    parser.add_argument("-l", help = "nucleotide length of sequence line", type = str, required = True)
    return parser.parse_args()
        
args = get_args()

read = args.r
read_length = int(args.l)

with gzip.open(read, mode="rt") as fh1:
    read_qscores = np.zeros(read_length, dtype = int) 
    line_count = 0
    for line in fh1:
        line = line.strip('\n') # type: ignore
        line_count += 1
        if line_count % 4 == 0:
            for score in range(len(line)):
                read_qscores[score] += bioinfo.convert_phred(line[score]) # type: ignore
    read_qscores = read_qscores / (line_count/4)


x = range(read_length)
y = read_qscores
split_file = read.split('/')
just_fastq = split_file[6] #This extracts the whole "Undetermined_S0_L008_....fastq.gz" to use as the title
title = just_fastq.split(".")[0] #Just removes the ".fastq.gz"


fig, ax = plt.subplots()             
ax.plot(x,y) 
ax.set_xlabel("Nucleotide position")
ax.set_ylabel("Average Q-Score across all reads")
plt.title(f"Average Q-Score at each nucleotide position across all reads of {title}")
plt.savefig(f"{title}_distribution.png") #Should be 'R1_distribution.png' etc
        


