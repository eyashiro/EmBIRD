# README

# Embedded Barcoded Illumina Read Demultiplexer (EmBIRD)

Last modified: 11 April 2024

Author: Erika Yashiro, Ph.D.

Version: 1.1.3


EmBIRD demultiplexes Illumina fastq amplicon DNA reads according to the nucleotide barcodes embedded upstream of the forward and the reverse PCR primers. Variable-lengthed barcodes are accepted and a linker region between the barcode and PCR primers should be indicated. The current version of EmBIRD expects barcodes to be present upstream of both forward and reverse primers. EmBird will automatically sort the reads so that in the final output files, the reads containing the forward primers are in the R1 files and the reads with the reverse primers are in the R2 files.

# Installation

Make sure that you have a working Linux operating system on your computer.

1. Download a copy of the EmBIRD and place it in a directory.
```
$ git clone https:/github.com/eyashiro/EmBIRD.git

OR

wget https://github.com/eyashiro/EmBIRD/releases/tag/v1.1.3  # or other version
```

2. Install the following dependencies

* cutadapt (currently used v4.5)
* zlib 1.2.6 or higher
* pigz 2.8 (for cutadapt to be able to use multicore feature)

Currently EmBIRD is set to use up to 4 threads but you can change the settings in the script in the cutadapt command lines.

3. Make sure that all of the dependencies are accessible via PATH.

# Running EmBIRD

The input sequencing files should be in fastq.gz format and both the R1 and R2 files should be placed in the same directory. There should be one directory per library.

Large fastq.gz files should be split, for instance, when all the reads from a library are in a single fastq.gz R1 and R2 file. I've noticed that for a server with 90 GB RAM, the following split size works best: for 2x101bp data, split into 4M reads/file; for 2x151bp data, split into 2-3M reads/file.

You can use the following commands:

```
# Here are two example file names
$ ls Lib1/
DogV4_1_L4_R1_001_dkxi29ke.fastq DogV4_1_L4_R2_001_ioowkxdi.fastq

# split each file to have 4M reads per file.
$ cd Lib1  # change directory
$ zcat DogV4_1_L4_R1_001_dkxi29ke.fastq.gz | split -l 16000000 --numeric-suffixes=001 --additional-suffix=".fastq" DogV4_1_L4_R1_0

$ zcat DogV4_1_L4_R2_001_ioowkxdi.fastq | split -l 16000000 --numeric-suffixes=001 --additional-suffix=".fastq" DogV4_1_L4_R2_0

# move the split files to a new directory
$ mkdir ../Lib1_split
$ mv *.fastq ../Lib1_split/.

# gzip all of the split fastq files. Pigz can parallelize the gzip run.
$ pigz ../Lib1_split/*
```

Each sequencing library should have its own directory, and all the reads from a sequencing library should be placed in their respective directory. The directory tree should look as follows:

```
# Parent path:
$ /home/data/Campaign2020

# Library 1 (Col2) path:
$ /home/data/Campaign2020/Lib1
# Library 2 (Col2) path:
$ /home/data/Campaign2020/Lib2
# Library 3 (Col2) path:
$ /home/data/Campaign2020/Lib3
```

The adapter barcode and primers file should be placed in the working directory where you want your output data to written to. When specifying the adapter barcode primers file, the file name should contain no path string.

The adapter barcode and primers file should list the following columns in this order, separated by a semi-colon, no spaces:
* Row1: title of the columns.
* Col1: sample name (no spaces, use alphanumeric characters, - and _)
* Col2: raw fastq.gz directory name in which sample belongs R1 (in our example: Lib1, Lib2, Lib3)
* Col3: raw fastq.gz directory name in which sample belongs R2
* Col4: F primer sequence
* Col5: R primer sequence
* Col6: F barcode sequence
* Col7: R barcode sequence
* Col8: F linker
* Col9: R linker

Degenerate bases must be specified in IUPAC code. \
The sample names should not be replicated in the adapter barcode and primers file.

To run emBIRD:
```
# Go to the directory where the adapter barcode and primers list file is located.
$ cd demultLib

# Make sure that EmBIRD and dependencies are accessible from your PATH
$ echo $PATH

# Run EmBIRD
$ embird [path to gz directory containing library reads] [adapter barcode & primers list file] [0 or 1 mismatches allowed in barcodes]
# example:
embird /home/data/Campaign2020 samplessheet.txt 1
```
