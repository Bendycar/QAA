#!/usr/bin/env python
import bioinfo
import numpy as np
import matplotlib.pyplot as plt
import gzip

files = ["Undetermined_trimmed_1P.fastq.gz", "Undetermined_trimmed_2P.fastq.gz", "Fox_trimmed_1P.fastq.gz", "Fox_trimmed_2P.fastq.gz"]

file = files[0]

with gzip.open(file, mode="rt") as fh1:
    lengths = {}
    line_count = 0
    for line in fh1:
        line = line.strip('\n')
        line_count += 1
        if line_count % 4 == 2:
            if len(line) in lengths:
                lengths[len(line)] += 1
            else:
                lengths[len(line)] = 1

x1 = sorted(list(lengths.keys()))
y1 = sorted(list(lengths.values()))

file = files[1]

with gzip.open(file, mode="rt") as fh1:
    lengths = {}
    line_count = 0
    for line in fh1:
        line = line.strip('\n')
        line_count += 1
        if line_count % 4 == 2:
            if len(line) in lengths:
                lengths[len(line)] += 1
            else:
                lengths[len(line)] = 1

x2 = sorted(list(lengths.keys()))
y2 = sorted(list(lengths.values()))

title = f"{file.split("_")[0]}_S0_L008"

fig, ax = plt.subplots()       
ax.plot(x1,y1, alpha = .5, color = "cornflowerblue", label = "R1")
ax.plot(x2,y2, alpha = .5, color = "fuchsia", label = "R2") 
ax.set_yscale('log')
ax.legend()
ax.set_xlabel("Read length")
ax.set_ylabel("Count")
#plt.title(f"Read length distribution of {title} across R1 and R2")
plt.savefig(f"{title}_length_distribution_line.png") 


file = files[2]

with gzip.open(file, mode="rt") as fh1:
    lengths = {}
    line_count = 0
    for line in fh1:
        line = line.strip('\n')
        line_count += 1
        if line_count % 4 == 2:
            if len(line) in lengths:
                lengths[len(line)] += 1
            else:
                lengths[len(line)] = 1

x1 = sorted(list(lengths.keys()))
y1 = sorted(list(lengths.values()))

file = files[3]

with gzip.open(file, mode="rt") as fh1:
    lengths = {}
    line_count = 0
    for line in fh1:
        line = line.strip('\n')
        line_count += 1
        if line_count % 4 == 2:
            if len(line) in lengths:
                lengths[len(line)] += 1
            else:
                lengths[len(line)] = 1

x2 = sorted(list(lengths.keys()))
y2 = sorted(list(lengths.values()))

title = f"{file.split("_")[0]}_S6_L008"


fig, ax = plt.subplots()       
ax.plot(x1,y1, alpha = .5, color = "cornflowerblue", label = "R1")
ax.plot(x2,y2, alpha = .5, color = "fuchsia", label = "R2") 
ax.set_yscale('log')
ax.legend()
ax.set_xlabel("Read length")
ax.set_ylabel("Count")
#plt.title(f"Read length distribution of {title} across R1 and R2")
plt.savefig(f"{title}_length_distribution_line.png") 