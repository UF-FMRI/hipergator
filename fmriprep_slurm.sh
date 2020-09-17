#!/bin/bash
#SBATCH --account=XXXXaccountnamehere
#SBATCH --qos=XXXXqosnamehere
#SBATCH --job-name=fmriprep
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=XXXXemailhere
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20gb
#SBATCH --time=20:00:00
#SBATCH --output=fmriprep_SUB_sed_%j.out
#pwd; hostname; date
 
module load singularity

# MUST set the following directories to run fmriprep. If using this script with looping script, they will be set.

echo "SUB_sed"
BIDS_dir=BIDS_sed 
output_dir=OUTPUT_sed
singularity_dir=SINGULARITY_sed
fmriprep_version=VERSION_sed
freesurfer_dir=FREESURFER_sed

singularity run --cleanenv $singularity_dir/$fmriprep_version $BIDS_dir $output_dir participant --participant-label SUB_sed --work-dir $output_dir --omp-nthreads 8 --mem-mb 12000 --fs-license-file $freesurfer_dir/license.txt --use-aroma 
 


 
