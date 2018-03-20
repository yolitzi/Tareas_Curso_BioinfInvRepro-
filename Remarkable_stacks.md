#4.Running the pipeline ~[[⇑top]](http://catchenlab.life.illinois.edu/stacks/manual/#top)~

**4.1. Clean the data**

In a typical analysis, data will be received from an Illumina sequencer, or some other type of sequencer as FASTQ files. The first requirement is to demultiplex, or sort, the raw data to recover the individual samples in the Illumina library. While doing this, we will use the [Phred](https://en.wikipedia.org/wiki/Phred_quality_score) scores provided in the FASTQ files to discard sequencing reads of low quality. These tasks are accomplished using the <span style="color:green">**process_radtags**</span> program. 

![Stacks1](http://catchenlab.life.illinois.edu/stacks/manual/process_radtags.png) 

 Some things to consider when running this program:

- <span style="color:green">**process_radtags**</span> can handle both single-end or paired-end Illumina sequencing. 

-  The raw data can be compressed, or gzipped (files end with a `".gz"` suffix).

- You can supply a list of barcodes, or indexes, to <span style="color:green">**process_radtags**</span> in order for it to demultiplex your samples. These barcodes can be single-end barcodes or combinatorial barcodes (pairs of barcodes, one on each of the paired reads). Barcodes are specified, one per line (or in tab separated pairs per line), in a text file.
	- If, in addition to your barcodes, you also supply a sample name in an extra column within the barcodes file, <span style="color:green">**process_radtags**</span> will name your output files according to sample name instead of barcode.
- If you believe your reads may contain adapter contamination, <span style="color:green">**process_radtags**</span> can filter it out.
- You can supply the restriction enzyme used to construct the library. In the case of double-digest RAD, you can supply both restriction enzymes.
- If instructed, (-r command line option), <span style="color:green">**process_radtags**</span> will correct barcodes and restriction enzyme sites that are within a certain distance from the true barcode or restriction enzyme cutsite.

**4.1.1 Understanding barcodes/indexes and specifying the barcode type**

Genotype by sequencing libraries sample the genome by selecting DNA adjacent to one or more restriction enzyme cutsites. By reducing the amount of total DNA sampled, most researchers will multiplex many samples into one molecular library. Individual samples are demarcated in the library by ligating an oligo barcode onto the restriction enzyme-associated DNA for each sample. Alternatively, an index barcode is used, where the barcode is located upstream of the sample DNA within the sequencing adaptor. Regardless of the type of barcode used, after sequencing, the data must be demultiplexed so the samples are again separated. The `process_radtags` program will perform this task, but we much specify the type of barcodes used, and where to find them in the sequencing data. 

There are a number of different configurations possible, each of them is detailed below.

1.  If your data are single-end or paired-end, with an inline barcode present only on the single-end (marked in red):


	>@HWI-ST0747:188:C09HWACXX:1:1101:2968:2083 1:N:0: <span style="color:red">TTATG</span>ATGCAGGACCAGGATGACGTCAGCACAGTGCGGGTCCTCCATGGATGCTCCTCGGTCGTGGTTGGGGGAGGAGGCA + @@@DDDDDBHHFBF@CCAGEHHHBFGIIFGIIGIEDBBGFHCGIIGAEEEDCC;A?;;5,:@A?=B5559999B@BBBBBA @HWI-ST0747:188:C09HWACXX:1:1101:2863:2096 1:N:0: <span style="color:red">TTATG</span>ATGCAGGCAAATAGAGTTGGATTTTGTGTCAGTAGGCGGTTAATCCCATACAATTTTACACTTTATTCAAGGTGGA + CCCFFFFFHHHHHJJGHIGGAHHIIGGIIJDHIGCEGHIFIJIH7DGIIIAHIJGEDHIDEHJJHFEEECEFEFFDECDDD @HWI-ST0747:188:C09HWACXX:1:1101:2837:2098 1:N:0: <span style="color:red">GTGCC</span>TTGCAGGCAATTAAGTTAGCCGAGATTAAGCGAAGGTTGAAAATGTCGGATGGAGTCCGGCAGCAGCGAATGTAAA 


	Then you can specify the `--inline_null`flag to <span style="color:green">**process_radtags**</span>. This is also the default behavior and the flag can be ommitted in this case. 
	

2. If your data are **single-end** or **paired-end**, with a single index barcode (in blue):

	>@9432NS1:54:C1K8JACXX:8:1101:6912:1869 1:N:0:<span style="color:blue">ATGACT</span> TCAGGCATGCTTTCGACTATTATTGCATCAATGTTCTTTGCGTAATCAGCTACAATATCAGGTAATATCAGGCGCA + CCCFFFFFHHHHHJJJJJJJJIJJJJJJJJJJJHIIJJJJJJIJJJJJJJJJJJJJJJJJJJGIJJJJJJJHHHFF @9432NS1:54:C1K8JACXX:8:1101:6822:1873 1:N:0:<span style="color:blue">ATGACT</span> CAGCGCATGAGCTAATGTATGTTTTACATTCCAGAAAGAGAGCTACTGCTGCAGGTTGTGATAAAATAAAGTAAGA + B@@FFFFFHFFHHJJJJFHIJHGGGHIJIIJIJCHJIIGGIIIGGIJEHIJJHII?FFHICHFFGGHIIGG@DEHH @9432NS1:54:C1K8JACXX:8:1101:6793:1916 1:N:0:<span style="color:blue">ATGACT</span> TTTCGCATGCCCTATCCTTTTATCACTCTGTCATTCAGTGTGGCAGCGGCCATAGTGTATGGCGTACTAAGCGAAA + @C@DFFFFHGHHHGIGHHJJJJJJJGIJIJJIGIJJJJHIGGGHGII@GEHIGGHDHEHIHD6?493;AAA?;=;= 

>Then you can specify the `--index_null` flag to <span style="color:green">**process_radtags**</span>.
	

3.If your data are single-end with both an inline barcode (in red) and an index barcode (in blue):

>>@9432NS1:54:C1K8JACXX:8:1101:6912:1869 1:N:0:<span style="color:blue">ATCACG</span> <span style="color:red">TCAGC</span>CATGCTTTCGACTATTATTGCATCAATGTTCTTTGCGTAATCAGCTACAATATCAGGTAATATCAGGCGCA + CCCFFFFFHHHHHJJJJJJJJIJJJJJJJJJJJHIIJJJJJJIJJJJJJJJJJJJJJJJJJJGIJJJJJJJHHHFF @9432NS1:54:C1K8JACXX:8:1101:6822:1873 1:N:0:<span style="color:blue">ATCACG</span> <span style="color:red">GTCCG</span>CATGAGCTAATGTATGTTTTACATTCCAGAAAGAGAGCTACTGCTGCAGGTTGTGATAAAATAAAGTAAGA + B@@FFFFFHFFHHJJJJFHIJHGGGHIJIIJIJCHJIIGGIIIGGIJEHIJJHII?FFHICHFFGGHIIGG@DEHH@9432NS1:54:C1K8JACXX:8:1101:6793:1916 1:N:0: <span style="color:blue">ATCACG</span>
<span style="color:red">GTCCG</span>GTCCGCATGCCCTATCCTTTTATCACTCTGTCATTCAGTGTGGCAGCGGCCATAGTGTATGGCGTACTAAGCGAAA + 
@C@DFFFFHGHHHGIGHHJJJJJJJGIJIJJIGIJJJJHIGGGHGII@GEHIGGHDHEHIHD6?493;AAA?;=;=


Then you can specify the `--index_null` flag to <span style="color:green">**process_radtags**</span>.

4.If your data are **paired-end** with an inline barcode on the single-end (in red) and an index barcode (in blue):

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 1:N:0:CGATGT <span style="color:red">ACTGG</span>CATGATGATCATAGTATAACGTGGGATACATATGCCTAAGGCTAAAGATGCCTTGAAGCTTGGCTTATGTT + #1=DDDFFHFHFHIFGIEHIEHGIIHFFHICGGGIIIIIIIIAEIGIGHAHIEGHHIHIIGFFFGGIIIGIIIEE7 @9432NS1:54:C1K8JACXX:7:1101:5708:1737 1:N:0:CGATGT <span style="color:red">TTCGA</span>CATGTGTTTACAACGCGAACGGACAAAGCATTGAAAATCCTTGTTTTGGTTTCGTTACTCTCTCCTAGCAT + #1=DFFFFHHHHHJJJJJJJJJJJJJJJJJIIJIJJJJJJJJJJIIJJHHHHHFEFEEDDDDDDDDDDDDDDDDD@

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 2:N:0:<span style="color:blue">CGATGT</span>
AACTTTGATAGAAGAACAACATAAGCCAAGCTTCAAGGCATCTTTAGCCTTAGGCATATGTATCCCACGTTA
+
@@@DFFFFHGHDHIIJJJGGIIIEJJJCHIIIGIJGGEGGIIGGGIJIJIHIIJJJJIJJJIIIGGIIJJJIICEH
@9432NS1:54:C1K8JACXX:7:1101:5708:1737 2:N:0:<span style="color:blue">CGATGT</span>
AGTCTTGTGAAAAACGAAATCTTCCAAAATGCTAGGAGAGAGTAACGAAACCAAAACAAGGATTTTCAATGCTTTG
+
C@CFFFFFHHHHHJJJJJJIJJJJJJJJJJJJJJIJJJHIJJFHIIJJJJIIJJJJJJJJJHGHHHHFFFFFFFED

Then you can specify the `--index_null` flag to <span style="color:green">**process_radtags**</span>.

5.If your data are <span style="color:green">**process_radtags**</span> with indexed barcodes on the single and paired-ends (in blue):

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 1:N:0:<span style="color:blue">ATCACG+CGATGT</span> ACTGGCATGATGATCATAGTATAACGTGGGATACATATGCCTAAGGCTAAAGATGCCTTGAAGCTTGGCTTATGTT + #1=DDDFFHFHFHIFGIEHIEHGIIHFFHICGGGIIIIIIIIAEIGIGHAHIEGHHIHIIGFFFGGIIIGIIIEE7 @9432NS1:54:C1K8JACXX:7:1101:5708:1737 1:N:0:<span style="color:blue">ATCACG+CGATGT</span> TTCGACATGTGTTTACAACGCGAACGGACAAAGCATTGAAAATCCTTGTTTTGGTTTCGTTACTCTCTCCTAGCAT + #1=DFFFFHHHHHJJJJJJJJJJJJJJJJJIIJIJJJJJJJJJJIIJJHHHHHFEFEEDDDDDDDDDDDDDDDDD@

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 2:N:0:<span style="color:blue">ATCACG+CGATGT</span> AATTTACTTTGATAGAAGAACAACATAAGCCAAGCTTCAAGGCATCTTTAGCCTTAGGCATATGTATCCCACGTTA + @@@DFFFFHGHDHIIJJJGGIIIEJJJCHIIIGIJGGEGGIIGGGIJIJIHIIJJJJIJJJIIIGGIIJ<span style="color:blue">ATCACG+CGATGT</span>ATCACG+CGATGT AGTCTTGTGAAAAACGAAATCTTCCAAAATGCTAGGAGAGAGTAACGAAACCAAAACAAGGATTTTCAATGCTTTG + C@CFFFFFHHHHHJJJJJJIJJJJJJJJJJJJJJIJJJHIJJFHIIJJJJIIJJJJJJJJJHGHHHHFFFFFFFED 

Then you can specify the `--index_null` flag to <span style="color:green">**process_radtags**</span>.

6. If your data are **paired-end** with inline barcodes on the single and paired-ends (in red):

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 1:N:0: <span style="color:red">ACTGG</span>CATGATGATCATAGTATAACGTGGGATACATATGCCTAAGGCTAAAGATGCCTTGAAGCTTGGCTTATGTT +
	 #1=DDDFFHFHFHIFGIEHIEHGIIHFFHICGGGIIIIIIIIAEIGIGHAHIEGHHIHIIGFFFGGIIIGIIIEE7 @9432NS1:54:C1K8JACXX:7:1101:5708:1737 1:N:0: <span style="color:red">TTCGA</span>ATGTGTTTACAACGCGAACGGACAAAGCATTGAAAATCCTTGTTTTGGTTTCGTTACTCTCTCCTAGCAT +
	 #1=DFFFFHHHHHJJJJJJJJJJJJJJJJJIIJIJJJJJJJJJJIIJJHHHHHFEFEEDDDDDDDDDDDDDDDDD@ 

>>@9432NS1:54:C1K8JACXX:7:1101:5584:1725 2:N:0: <span style="color:red">AATTT</span>ACTTTGATAGAAGAACAACATAAGCCAAGCTTCAAGGCATCTTTAGCCTTAGGCATATGTATCCCACGTTA + @@@DFFFFHGHDHIIJJJGGIIIEJJJCHIIIGIJGGEGGIIGGGIJIJIHIIJJJJIJJJIIIGGIIJJJIICEH @9432NS1:54:C1K8JACXX:7:1101:5708:1737 2:N:0: <span style="color:red">AGTCT</span>TGTGAAAAACGAAATCTTCCAAAATGCTAGGAGAGAGTAACGAAACCAAAACAAGGATTTTCAATGCTTTG + C@CFFFFFHHHHHJJJJJJIJJJJJJJJJJJJJJIJJJHIJJFHIIJJJJIIJJJJJJJJJHGHHHHFFFFFFFED

>Then you can specify the `--index_null` flag to <span style="color:green">**process_radtags**</span>.
   
