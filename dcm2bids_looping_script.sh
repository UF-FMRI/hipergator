#!/bin/bash
#SBATCH --account=stevenweisberg
#SBATCH --qos=stevenweisberg
#SBATCH --job-name=MVPA_BIDS
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=stevenweisberg@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=5gb
#SBATCH --time=5:00:00
#SBATCH --output=dcm2bids_%j.out
pwd; hostname; date

# script for running dcm2bids on multiple participants. Currently set up for multiple sessions.
# if only one session, take out the 'ses in XX' loop, and take out the '-s 0${ses}' of the Step 2 below
# You will need one config file for each subject and each session. You can use one config file if all the runs are the same between participants, but that is unlikely.
# BP 1/21/20

#set up the following paths
study_main_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/
sourcedata_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/sourcedata
code_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/code/hipergator


module load dcm2bids
module load mricrogl

# loops through subjects
for SUB in {112..128}
do


  # Skip 111 and 119
  [ "$SUB" -eq 111 ] && continue
  [ "$SUB" -eq 119 ] && continue

  # loops through sessions. Get rid of this loop entirely if there is only one session. Also get rid of '-s 0${ses}' in step 2
  for ses in 1
  do

  # selects the correct subject and session config file. these MUST be created before running this script. Change the .json name as needed.
  config_json=dcm2bids_config.json

  # Step 1: converts the dicoms into nifti files and puts them in a temporary folder
  dcm2bids_helper -d $sourcedata_dir/${SUB}

  # Step 2: moves the niftis from the temporary folder into BIDS named folder
  dcm2bids -d $sourcedata_dir/${SUB}/ -p ${SUB} -s 0${ses} -c $code_dir/$config_json

  #removes the temporary folder
  rm -R $study_main_dir/tmp_dcm2bids

  done
done
