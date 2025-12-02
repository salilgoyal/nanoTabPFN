#!/bin/bash
#SBATCH --job-name=nanotabpfn_train
#SBATCH --partition=deho
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:1
#SBATCH --output=logs/nanotabpfn_%j.out
#SBATCH --error=logs/nanotabpfn_%j.err

# Print job information
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURM_NODELIST"
echo "Start time: $(date)"
echo "Working directory: $(pwd)"

# Load required modules (adjust as needed for your Sherlock environment)
ml python/3.12
ml devel
ml py-h5py/3.10.0_py312
ml py-pyarrow/18.1.0_py312

# Activate virtual environment if you have one
source /scratch/users/salilg/envs/tabpfn_env/.venv/bin/activate

# Check if data file exists
if [ ! -f "300k_150x5_2.h5" ]; then
    echo "ERROR: Data file 300k_150x5_2.h5 not found!"
    echo "Please download it first using:"
    echo "curl http://ml.informatik.uni-freiburg.de/research-artifacts/nanoTabPFN/300k_150x5_2.h5 --output 300k_150x5_2.h5"
    exit 1
fi

# Print GPU information
if command -v nvidia-smi &> /dev/null; then
    echo "GPU information:"
    nvidia-smi
fi

# Run training
echo "Starting training..."
python train.py

echo "End time: $(date)"
echo "Job completed!"
