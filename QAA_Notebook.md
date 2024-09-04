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

##9/4/24:

I let my plotting script run overnight, so I checked them this morning and they seemed reasonable!
Given that this code has been thoroughly tested, I'm going to assume these are correct. 

I wanted to compare these to the output of FastQC, but I was having trouble viewing the html files within Talapas. 
