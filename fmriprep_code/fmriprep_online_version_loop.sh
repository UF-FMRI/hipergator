#!/bin/bash


# loops through subjects
for SUB in {101..101}
do

#runs subject-level preprocessing scripts via sbatch on the hipergator
   sbatch fmriprep_online_version.sh $SUB

done
