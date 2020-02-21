#!/bin/bash
#SBATCH --account=XXXXaccountnamehere
#SBATCH --qos=XXXXqosnamehere
#SBATCH --job-name=pydeface
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=XXXXemailhere
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=5gb
#SBATCH --time=30:00:00
#SBATCH --output=pydeface_%j.out
#pwd; hostname; date

#This code defaces BIDS-compliant T1 data using pydeface.
#Currently set up for 2 session studies.
#Outputs 2 files for notes -- participants who are missing T1 data, and participants whose T1 data did not successfully deface.

#MUST SET THESE
BIDS_dir=/full_directory_path/BIDS_data_folder
warning_dir=/full_directory_path/warnings_folder #I do not recommend this to be the same as your BIDS folder

module load pydeface
module load fsl

for SUB in 1 2 3
do

for ses in 1 2
do

#checking if T1 exists
if [ -f $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w.nii ]; 
    
    #run pydeface
    then pydeface $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w.nii
  
    #checking if pydeface ran successfully
    if [ -f $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w_defaced.nii ]; 
      #remove the old T1 (that is not defaced)
      then rm sub-${SUB}_ses-0${ses}_T1w.nii
      #rename the defaced T1 to be BIDS compliant
      mv $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w_defaced.nii $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w.nii
    
    #if pydeface did not run successfully 
    else
      if [ ! -f $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w_defaced.nii ]; then
      #make a note of the participant who was not defaced
      echo "pydeface failed for sub-${SUB} session-0${ses}" >> $warning_dir/pydeface_failed_files.txt
      fi
    fi
    
#if T1 does not exist
else
    if [ ! -f $BIDS_dir/sub-${SUB}/ses-0${ses}/anat/sub-${SUB}_ses-0${ses}_T1w.nii ]; then
    #make a note. check this later to make sure missing files are supposed to be missing
    echo "pydeface failed for sub-${SUB} session-0${ses}" >> $warning_dir/pydeface_nonexistant_files.txt
    fi
fi


done
done
