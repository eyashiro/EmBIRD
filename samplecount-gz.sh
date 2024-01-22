#!/bin/bash

# This script is will count the number of reads in each sample after an embird run.
# Go into the folder containing the fastq.gz files and simply run the script from there.
# A log file will be output with the number of reads in each sample.
# Note that only the R1 fastq.gz files are read, since it's assumed that the R1 and R2 files contain the same exact header entries.
#
# Author: Erika Yashiro Ph.D.
# Last modified: 7 November 2023
#


echo "Number of reads in the fastq.gz output files for each sample." > sample_counts.gz.log

SLIST=$(ls | grep "fastq.gz")

for SNAME in $SLIST
  do
  HEADERID=$(zcat "$SNAME" | sed -n '1p' | awk -F ":" '{ print $1 }')
  printf "$SNAME number of headers : " >> sample_counts.gz.log
  zcat "$SNAME" | grep -c "$HEADERID" >> sample_counts.gz.log
  printf "    total number of lines : " >> sample_counts.gz.log
  zcat "$SNAME" | wc -l >> sample_counts.gz.log
  done
