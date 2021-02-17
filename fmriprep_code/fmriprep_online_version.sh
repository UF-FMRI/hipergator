#!/bin/bash
#
#SBATCH --account=stevenweisberg
#SBATCH --qos=stevenweisberg-b
#SBATCH -J fmriprep
#SBATCH --time=48:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4G
# Outputs ----------------------------------
#SBATCH --output=fmriprep_%j.out
#SBATCH --mail-user=stevenweisberg@ufl.edu
#SBATCH --mail-type=END,FAIL
# ------------------------------------------

BIDS_DIR="/blue/stevenweisberg/stevenweisberg/rtQuest/rtQuest"
DERIVS_DIR="derivatives/fmriprep"
LOCAL_FREESURFER_DIR="/blue/stevenweisberg/stevenweisberg/rtQuest/rtQuest/derivatives/freesurfer"

# Prepare some writeable bind-mount points.
TEMPLATEFLOW_HOST_HOME=$HOME/.cache/templateflow
FMRIPREP_HOST_CACHE=$HOME/.cache/fmriprep
mkdir -p ${TEMPLATEFLOW_HOST_HOME}
mkdir -p ${FMRIPREP_HOST_CACHE}


# Make sure FS_LICENSE is defined in the container.
export SINGULARITYENV_FS_LICENSE=$HOME/freesurfer/license.txt

# Designate a templateflow bind-mount point
export SINGULARITYENV_TEMPLATEFLOW_HOME="/templateflow"
SINGULARITY_CMD="singularity run --cleanenv -B $BIDS_DIR:/data -B ${TEMPLATEFLOW_HOST_HOME}:${SINGULARITYENV_TEMPLATEFLOW_HOME} -B $L_SCRATCH:/work -B ${LOCAL_FREESURFER_DIR}:/fsdir /blue/stevenweisberg/stevenweisberg/hipergator_neuro/fmriprep/fmriprep-20.1.1.simg"

# Parse the participants.tsv file and extract one subject ID from the line corresponding to this SLURM task.
#subject=$( sed -n -E "$((${SLURM_ARRAY_TASK_ID} + 1))s/sub-(\S*)\>.*/\1/gp" ${BIDS_DIR}/participants.tsv )
subject=$1

# Remove IsRunning files from FreeSurfer
find ${LOCAL_FREESURFER_DIR}/sub-$subject/ -name "*IsRunning*" -type f -delete

# Compose the command line
cmd="${SINGULARITY_CMD} /data /data/${DERIVS_DIR} participant --participant-label $subject -w /work/ -vv --omp-nthreads 8 --nthreads 12 --mem_mb 30000 --output-spaces MNI152NLin2009cAsym:res-2 anat fsnative fsaverage5 --use-aroma --fs-subjects-dir /fsdir"

# Setup done, run the command
echo Running task ${SLURM_ARRAY_TASK_ID}
echo Commandline: $cmd
eval $cmd
exitcode=$?

# Output results to a table
echo "sub-$subject   ${SLURM_ARRAY_TASK_ID}    $exitcode" \
      >> ${SLURM_JOB_NAME}.${SLURM_ARRAY_JOB_ID}.tsv
echo Finished tasks ${SLURM_ARRAY_TASK_ID} with exit code $exitcode
exit $exitcode
