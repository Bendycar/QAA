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

To determine the proportion of reads with adapters trimmed, I looked at the slurm output for cutadapt and found this:

Undetermined:
  Read 1 with adapter:                 543,021 (3.7%)
  Read 2 with adapter:                 607,660 (4.1%)

Fox:
  Read 1 with adapter:                 173,473 (3.3%)
  Read 2 with adapter:                 212,512 (4.0%)


### 9/7/24:

Working on setting up the trimmomatic commands. I realized that I had to tell it if the files are gzipped or not, and I wasn't sure how cutadapt outputs its results. After a little googling, I found that the "file: unix command will tell me this.

	$file Undetermined_R1_cut
	Undetermined_R1_cut: ASCII text

So it seems to be uncompressed. However, I will ask trimmomatic to compress it in the output. 

I ran trimmomatic on the 4 files as paired-end data (using the PE flag in trimmomatic). As requested, I specified the following parameters:

LEADING: quality of 3
TRAILING: quality of 3
SLIDING WINDOW: window size of 5 and required quality of 15
MINLENGTH: 35 bases

And used the -baseout parameter to allow trimmomatic to outmatically name my output files. Therefore, the full command looked like:

/usr/bin/time -v trimmomatic PE Undetermined_R1_cut Undetermined_R2_cut -baseout Undetermined_trimmed.fastq.gz \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:5:15 \
MINLEN:35

And the same for my other set of reads. 

I wrote a quick python script (trimmomatic_plots.py) for generating plots of the R1 and R2 reads side by side for each set of trimmed files.
Looking at these graphs, it is clear that the R2 reads are trimmed more extensively than R1. This makes sense -- we would expect R2 to be lower quality than R1, mostly due to degradation of the reagents used over time. 

## PART 3

### 9/8/24:

I installed the required packages from conda:

 	$ conda install star
 	$ conda install numpy
 	$ conda install matplotlib
 	$ conda install htseq

Then, I downloaded the "primary assembly" file for the mouse genome from ensemble:

	$ wget https://ftp.ensembl.org/pub/release-112/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna_sm.primary_assembly.fa.gz

But this was talking forever, so I cancelled the job to get my command line back, and instead put it into a quick little script called "download_mouse.sh". 

Luckily the GTF file is much smaller, so I was able to download that straight from the command line.

	$ wget https://ftp.ensembl.org/pub/release-112/gtf/mus_musculus/Mus_musculus.GRCm39.112.gtf.gz

I gunzipped both of these files, then copied my "STAR_Database.sh" script from PS8. I changed the relevent file paths, then ran it on sbatch.

After generating the STAR Database, it is time to align my reads. I copied over the STAR_Alignment bash script from PS8, and changed only the file paths and output names.

This ran significantly faster than I expected -- only about 50 seconds for each. However, it produced a SAM file of reasonable size and reported exit status 0, so I am going to trust the results.

Now, it's time to count the aligned / unmapped reads. I copied in my "Count_Alignment.py" script from PS8, added argparse to take file inputs, then ran it on both files. I got the following results:

	$ ./Count_Alignment.py -f Undetermined_S0_L008Aligned.out.sam 

		Number of aligned reads: 163734
		Number of unmapped reads: 4858770

	$ ./Count_Alignment.py -f 7_2E_fox_S6_L008Aligned.out.sam 

		Number of aligned reads: 9424733
		Number of unmapped reads: 340673

These results are interesting, especially the ratio of aligned to unmapped reads in the Undetermined file. It seems to make sense that the "Undetermined" reads would not map well, however, so I'm not terribly worried quite yet (although I will be if it doesn't match with htseq).

After reading the documentation for Htseq-count, it seems like all you need to provide it is in gtf file, sam file, and a flag for strandedness. I heard from Lauren that the default is to output to standard out, so I also included a ">" to dump the results into a file instead. I created a script called "Htseq.sh" to run all 4 runs, then called it a day to let it do its thing.

### 9/9/24

I took a look at my Htseq output files, which seem to be a familiar list of genes and their corresponding counts of matched reads. I decided to run a series of bash commands to assess the number of mapped vs total reads on each file:

	$ cat fox_reverse.out | grep -v "^__" | awk '{sum+= $2} END{print sum}'
	$ cat fox_reverse.out | awk '{sum+= $2} END{print sum}'

I applied the same combination of commands to every output file, to produce the following table:

| Htseq Metric |  Fox Reverse     | Fox Forward | Undetermined Reverse | Undetermined Forward
| -------- | ------- | ------- | ------- | -------
| Mapped reads | 4,026,702 | 171,207 | 17,097 | 1,350
| Total reads  |    4,882,703   | 4,882,703    | 2,511,252 | 2,511,252
| % mapped | 82.46%  |   3.51%  | 0.68% | 0.054%

I also created a similar table for my python script data:


| Script Metric |  Fox | Undetermined
| -------- | ------- | ------- |
| Mapped reads | 9,424,733 | 163,734 
| Total reads  |    9,765,406   | 5,022,504
| % mapped | 96.51%  |   3.26%  

There are a number of interesting things to note in these tables. First, I can confirm that the sum of the total reads for each forward and reverse file in Htseq matches the total reads of each file as analyzed by my script, a reassuring finding. Second, we can note the clear discrepency in matched reads between the "Fox" file and the "Undetermined" file, the reason for which should be obvious from the name of the latter. The "Undetermined" data are a collection of from reads whose biological source that could not be identified, so it makes perfect sense that they do not map well to a single genome. Finally, there is a clear difference is percent of mapped reads between the Htseq output and my python script's output. This is likey due to the fact that the Htseq algorithm also takes in a GTF file as input, whereas mine only uses the information in the SAM file. Looking at the tail of the Htseq output, we can see there are several criteria for which a read will be counted as unmapped:

	__no_feature    4320237
	__ambiguous     4091
	__too_low_aQual 13136
	__not_aligned   163337
	__alignment_not_unique  210695

In the documentation available online (https://htseq.readthedocs.io/en/release_0.11.1/count.html), the "not aligned" parameter is described as "reads in the SAM file without alignment" -- which is exactly what our python script is looking for. Therefore, it appears that all the other fields use information from the GTF file that our script is not privy to. I believe this is the primary source of the discrepency between my output and their's. To test this, I wanted to see if the sum of all their mapped reads plus everything except the "not aligned" field would equal my number of mapped reads: 4,026,702 + 171,207 + 390065 + 78768 + 13136 + 210695 + 4320237 + 4091 + 13136 + 210695 = 9,438,732

My number of mapped reads: 9,424,733

9,424,733 - 9,438,732 = -13,999

So close and yet so far -- after correcting for information contained within the GTF file, my script actually reports about 14,000 fewer mapped reads than Htseq. The only explanation I can think of for this discrepency is that my script eliminates secondary alignments, which may be a subset of the "alignment not unique" field -- therefore, some proportion of those reads were not counted by both my script and the Htseq algorithm, and therefore should not have been added to the corrected total.

To determine if the data are strand specific, I consulted the internet. According to Devon Ryna on biostars (https://www.biostars.org/p/205987/), who states that the option with more reads mapped will be the correct option. In our case, this is likely reverse: in the "Fox" file, 82.46% of reads mapped under the reverse setting, whereas only 3.51% mapped in the forward. For "Undetermined", this was a little more unclear -- only .68% mapped in reverse, and .054% forward. Although this is technically a large change proportionally, I don't think this should be interpreted as a significant difference. Instead, I believe this is again indicative of the fact that these data come from many different sources, and can't be reliably mapped to a genome. 






Note to self for later: The "splice-aware" description of STAR refers to the fact that we are attempting to align RNAseq data to a reference genome. Because introns have been spliced out, we may capture a read of mRNA that spans across exons. The splice aware algorithm can account for this by aligning such a read over the gap created by an intron in the reference genome. 

Things to review: Strandedness in general, what exactly is a "feature"