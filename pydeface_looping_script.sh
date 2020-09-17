#!/bin/bash
# loops through subjects
dir1=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/derivatives/fmriprep
dir2=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS

warning_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/pydeface_warnings #I do not recommend this to be the same as your BIDS folder
mkdir $warning_dir

for SUB in {108..128}
do
  # Skip 111 and 119
  [ "$SUB" -eq 111 ] && continue
  [ "$SUB" -eq 119 ] && continue

  BIDS_dir_sub_ses1=$dir1/sub-${SUB}/anat
  BIDS_dir_sub_ses2=$dir2/sub-${SUB}/ses-01/anat
  echo $BIDS_dir_sub_ses1
  echo $BIDS_dir_sub_ses2
  sbatch pydeface_slurm.sh $SUB $BIDS_dir_sub_ses1 $warning_dir
  sbatch pydeface_slurm.sh $SUB $BIDS_dir_sub_ses2 $warning_dir
done
