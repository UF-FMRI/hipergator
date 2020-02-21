#!/bin/bash
#SBATCH --account=stevenweisberg
#SBATCH --qos=stevenweisberg
#SBATCH --job-name=pydeface
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=stevenweisberg@ufl.edu
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
BIDS_dir=/ufrc/stevenweisberg/stevenweisberg/Arrows_VVA_MRI
warning_dir=/ufrc/stevenweisberg/stevenweisberg/Arrows_VVA_MRI/warnings #I do not recommend this to be the same as your BIDS folder

module load pydeface
module load fsl

for SUB in PCA_1 PCA_2
do

for ses in 01
do

BIDS_dir_sub_ses=$BIDS_dir/sub-${SUB}/ses-${ses}/anat/
T1_sub_ses=sub-${SUB}_ses-${ses}_T1w.nii
image=${BIDS_dir_sub_ses}${T1_sub_ses}
#checking if T1 exists
if [ -f ${image} ];

    #run pydeface
    then pydeface ${image}

    #checking if pydeface ran successfully
    if [ -f ${image}_defaced.nii ];
      #remove the old T1 (that is not defaced)
      then rm ${image}
      #rename the defaced T1 to be BIDS compliant
      mv ${image}_defaced.nii ${image}_T1w.nii

    #if pydeface did not run successfully
    else
      if [ ! -f ${image}_T1w_defaced.nii ]; then
      #make a note of the participant who was not defaced
      echo "pydeface failed for sub-${SUB} session-${ses}" >> $warning_dir/pydeface_failed_files.txt
      fi
    fi

#if T1 does not exist
else
    if [ ! -f ${image} ]; then
    #make a note. check this later to make sure missing files are supposed to be missing
    echo "pydeface failed for sub-${SUB} session-${ses}" >> $warning_dir/pydeface_nonexistent_files.txt
    fi
fi


done
done
