##9/3/24:

Created and verified the conda environment containing FastQC:

 	$ conda create -n QAA
 	$ conda activate QAA
 	$ conda install FastQC
	$ fastqc --version
	$ conda install python
	$ conda install matplotlib


FastQC was confirmed to be the correct version, so I proceded to the next step!

Library Assignments are here: /projects/bgmp/shared/Bi623/QAA_data_assignments.txt

And the files themselves are here: /projects/bgmp/shared/2017_sequencing/demultiplexed/

I have:  7_2E_fox_S6_L008 and Undetermined_S0_L008

After looking a little at the files directory, I realized that there are R1 and R2 files for each assignment.
Additionally, there is a "_001" at the end of each that is not included on the data assignments file.
Therefore, these are the full filenames for the four files that I will be working with:

Undetermined_S0_L008_R1_001.fastq.gz
Undetermined_S0_L008_R2_001.fastq.gz
7_2E_fox_S6_L008_R1_001.fastq.gz
7_2E_fox_S6_L008_R2_001.fastq.gz

I wanted to confirm that these sequences are 101 nucleotides long, as expected, so I did a little exploratory data analysis:

$ zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/Undetermined_S0_L008_R1_001.fastq.gz | sed -n 2~4p | head -1 | wc -m

Which returned 102. I know bash includes the newline character in its count, so I know this file actually has 101 characters. I also applied this command to every other of the above files, and confirmed this for all of them.

I copied my Pt1 python script (which creates the plots) from the demultiplexing assignment, and set up a bash script to run this on each file at a time.

I git cloned the bioinfo module, and copied bioinfo.py into the current directory. 

## 9/4/24:

I let my plotting script run overnight, so I checked them this morning and they seemed reasonable!
Given that this code has been thoroughly tested, I'm going to assume these are correct. 

I wanted to compare these to the output of FastQC, but I was having trouble viewing the html files within Talapas. Luckily this is on a git repo, so I just pulled them down to my local machine and used "explorer.exe ." to view them. 

Looking at the FastQC plots, they seem to share the same general shape as my python script's quality score plots -- another point of evidence that my script works! 

However, there are several important differences between their application and mine. Most notably, their application was significantly faster. Below are a series of tables summarizing key metrics for all 4 reads:


### Undetermined_R1

| Metric |  My Script     | FastQC
| -------- | ------- | ------- |
| Runtime  |   9:08.76   | 1:03.09    |
| CPU | 98%    | 97%    |

### Undetermined_R2

| Metric |  My Script     | FastQC
| -------- | ------- | ------- |
| Runtime  |   9:03.85   | 1:02.22    |
| CPU | 99%    | 101%    |


### Fox_R1

| Metric |  My Script     | FastQC
| -------- | ------- | ------- |
| Runtime  |    3:19.70   | 0:22.21    |
| CPU | 97%  | 101%    |

### Fox_R2

| Metric |  My Script     | FastQC
| -------- | ------- | ------- |
| Runtime  |    3:18.34   | 0:23.21    |
| CPU | 99%  | 106%    |

Obviously, their code was significantly faster. In terms of computational efficiency, it appears that they used similar (or if anything, slightly more) CPU capacity. However, I did notice that their tool has an option to multithread, which is definitely not the case in mine!! Additionally, their tool presents the results in a very nice looking GUI, whereas mine simply outputs a png.

Looking at the results of the FastQC output, it seems clear to me that these are of sufficiently high quality for downstream analysis. Not only is the per base quality score relatively high for everything beyond the first few bases (which I'm sure trimmomatic will remove), the per base N content is negligible for every read, and the GC content closely matches the expected distribution. It is extremely difficult to find any faults in this data, so I would feel great about proceeding with downstream analysis. 

## PART 2:

First, I installed and verified the appropriate software in my QAA environment:

 	$ conda activate QAA
 	$ conda install cutadapt
 	$ conda install trimmomatic
 	$ cutadapt --version
 	$ trimmomatic -version
 
 These commands verified that I successfully installed in correct version of the required software. 

 To determine the adapter sequences used, I looked at the "Adapter Content" section of the FastQC output. Unfortunately, the plots show very little adapter content in my reads, and the color scheme chosen is extremely non-colorblind-friendly. Luckily, Lena assured me that the line with the highest expression is the "Illumina Universal Adapater". After a quick google search, I was able to find these values: 

 Read 1: AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
 Read 2: AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

 which match the sequences given on the github assignment. 

 To sanity check this, I searched the reads for the adapter that should be present, and the adapters that shouldn't be present. For example:

$ zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/Undetermined_S0_L008_R1_001.fastq.gz | grep "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" | wc -l
30808

$ zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/Undetermined_S0_L008_R2_001.fastq.gz | grep "AGATCGGAAGAGCACACGTCTGAACTCC
AGTCA" | wc -l
0

The R1 adapter had a huge amount of matches in R1, and none in R2. I ran similar commands for all other combinations for all 4 files, and found the same results. 