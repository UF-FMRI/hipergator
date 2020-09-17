#!/bin/bash
#SBATCH --account=stevenweisberg
#SBATCH --qos=stevenweisberg-b
#SBATCH --job-name=pydeface
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=stevenweisberg@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4gb
#SBATCH --time=12:00:00
#SBATCH --output=pydeface_%j.out
#pwd; hostname; date

#This code defaces BIDS-compliant T1 data using pydeface.
#Outputs 2 files for notes -- participants who are missing T1 data, and participants whose T1 data did not successfully deface.

#Looping script sets these
SUB=$1
BIDS_dir_sub_ses=$2
warning_dir=$3

module load pydeface
module load fsl



for imageOriginal in $BIDS_dir_sub_ses/sub-${SUB}*T1w.nii.gz
do

  #checking if T1 exists
  if [ -f ${imageOriginal} ];
    #create the basename of the file (without extension)
    then image=$(basename $imageOriginal .nii.gz)
    #run pydeface
    pydeface ${imageOriginal}

    #checking if pydeface ran successfully
    if [ -f ${BIDS_dir_sub_ses}/${image}*defaced* ];
      #remove the old T1 (that is not defaced)
      then rm ${imageOriginal}
      #rename the defaced T1 to be BIDS compliant
      mv ${BIDS_dir_sub_ses}/${image}*defaced* ${imageOriginal}

    #if pydeface did not run successfully
    else
      if [ ! -f ${BIDS_dir_sub_ses}/${image}*defaced* ]; then
      #make a note of the participant who was not defaced
      echo "pydeface failed for ${imageOriginal} - pydeface didn't run" >> $warning_dir/pydeface_failed_files.txt
      fi
    fi

  #if T1 does not exist
  else
      if [ ! -f ${imageOriginal} ]; then
      #make a note. check this later to make sure missing files are supposed to be missing
      echo "pydeface failed for ${imageOriginal} - T1 does not exist" >> $warning_dir/pydeface_nonexistent_files.txt
      fi
  fi


done
