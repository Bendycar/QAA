#!/usr/bin/env python
import argparse

def get_args():

    parser = argparse.ArgumentParser(description="Takes all 4 FASTQ files")
    parser.add_argument("-f", help="SAM file to be analyzed", type = str, required = True)
    return parser.parse_args()
        
args = get_args()

file = args.f

aligned = 0
unmapped = 0

with open(file, "r") as fh:
    for line in fh:
        if line.startswith("@"):
            continue

        line = line.split('\t')
        flag = int(line[1])
        QName = line[0]

        if ((flag & 256) != 256):
            primary = True
        else:
            primary = False

        if((flag & 4) != 4):
            mapped = True
        else:
            mapped = False

        if mapped == True and primary == True:
            aligned += 1
        elif mapped == False and primary == True:
            unmapped += 1

print(f"Number of aligned reads: {aligned}")
print(f"Number of unmapped reads: {unmapped}")
