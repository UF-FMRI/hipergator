#!/bin/bash
#SBATCH --account=XXXXaccountnamehere
#SBATCH --qos=XXXXqosnamehere
#SBATCH --job-name=mriqc
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=XXXXemailhere
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24gb
#SBATCH --time=60:00:00
#SBATCH --output=mriqc_%j.out
#pwd; hostname; date
 
module load singularity

singularity_dir=/full_directory_path/singularity_location_folder
BIDS_dir=/full_directory_path/BIDS_data_folder
MRIQC_output_dir=/full_directory_path/MRIQC_folder
MRIQC_version=mriqc_0.15.0.img
#fd_thres= #set this to voxel size

 
# RUNNING PARTICULAR SUBJECTS
for SUB in	1 2 3
do

# running dataset for single participants
singularity run --cleanenv $singularity_dir/$MRIQC_version $BIDS_dir $MRIQC_output_dir participant --participant-label $SUB --hmc-fsl --fd_thres 3 --work-dir $MRIQC_output_dir --float32 #--n_proc 4

done


# RUNNING WHOLE DATASET

# running whole dataset for single and group. change memory requested -- 10gb is barely enough
#singularity run --cleanenv $singularity_dir/$MRIQC_version $BIDS_dir $MRIQC_output_dir participant --hmc-fsl --fd_thres 3 --work-dir $MRIQC_output_dir --float32 #--n_proc 4

# running for just group level. Change memory requested -- 5gb seems to be more than enough
#singularity run --cleanenv $singularity_dir/$MRIQC_version $BIDS_dir $MRIQC_output_dir group --hmc-fsl --fd_thres 3 --work-dir $MRIQC_output_dir --float32 # --n_proc 4
