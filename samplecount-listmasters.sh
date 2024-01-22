#!/bin/bash

#
# This script is will count the number of reads in each sample after an embird run.
# Go into the tempdir/ folder containing the listmaster- files and simply run the script from there.
# A log file will be output with the number of reads in each sample.
# Note that only the lastmasters files will be read.
#
# Author: Erika Yashiro Ph.D.
# Last modified: 8 November 2023
#



SLIST=$(ls | grep "listmaster" | awk -F "." '{ print $2 }' | sort | uniq)

echo "Total number of reads in the listmaster files for each sample." > sample_counts.log

for SNAME in $SLIST
  do
  printf "$SNAME : "  >> sample_counts.log
  cat listmaster.$SNAME.* | wc -l >> sample_counts.log
  done
