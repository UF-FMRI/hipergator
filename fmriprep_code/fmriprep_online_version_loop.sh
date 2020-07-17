#!/bin/bash


# loops through subjects
for SUB in {107..128}
do

    # Skip 111 and 119
    [ "$SUB" -eq 111 ] && continue
    [ "$SUB" -eq 119 ] && continue

#runs subject-level preprocessing scripts via sbatch on the hipergator
   sbatch fmriprep_online_version.sh $SUB

done
