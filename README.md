# data_preprocessing
This repository contains code to use for preprocessing fMRI data on the [UF Hipergator](https://help.rc.ufl.edu/doc/UFRC_Help_and_Documentation). 

This was originally created for the [Ebner Lab OT Aging study](https://github.com/rjpolk/data_preprocessing), with initial modification by Steven Weisberg.

Instructions for use: 

It is recommended that you fork this repo over to your own Github account. That way you can modify as you see fit and keep scripts with their custom group names and requirements for your own lab. Once you have done that, you can clone THAT repo onto Hipergator. It is recommended that you make changes locally (on a text editor on your own computer), then push them to the repo and pull them on Hipergator. Alternatively, you could make changes directly on Hipergator and push them from there. 

1. Create a Hipergator account. 
2. Login and navigate to your /ufrc/GROUP/USERNAME/ 
3. Git clone https://github.com/GITHUBACCOUNT/hipergator.git
4. (Optional): Add to your .bashrc - alias hip="cd /ufrc/GROUP/USERNAME/hipergator"  


Steps:
1. Convert raw dicoms to BIDS compliant niftis: 

   dcm2bids_looping_script.sh, dcm2bids_example_config.json
   
   You can loop through multiple participants using dcm2bids_looping_script.sh and submit this job to slurm. The dcm2bids_config.json files must be created before you run this. An example config.json is uploaded here (dcm2bids_example_config.json) -- but you will need to check your data and make your own based on this. If participants have all the same runs in the same order, you could make just one .json file and use it for each participant/session. But, if there were errors during the scan and runs have different order numbers, you will need to make a different config.json for each participant/session. The dcm2bids_looping_script.sh was created with a different config.json file for each different subject/session. But the script can be easily altered.
   

2. Deface the BIDS anatomical data using pydeface: 

   pydeface_slurm.sh
   
   You can use the pydeface_slurm.sh to submit this job to slurm. Be sure to change the directory paths before running.
   

3. Run quality checks on data using MRIQC: 

   mriqc_slurm.sh
   
   The mriqc_slurm.sh script can submit this job to the slurm. Be sure to change the directory paths before running. There are three options you can use in this script: participant level only, participant level plus group level, and group level only.
   
   
4. Preprocessing data using fMRIprep: 

   fmriprep_looping_script.sh, fmriprep_slurm.sh
   
   The fmriprep_slurm.sh can be used to submit to slurm manually, or you can loop through multiple participants using fmriprep_looping_script.sh to submit each individual participant to slurm. Be sure to change the directory paths before running. If using the looping script, you do not need to change the paths on the slurm script.
