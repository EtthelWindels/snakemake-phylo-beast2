#!/bin/bash

#SBATCH -n 1
#SBATCH --time=240:00:00
#SBATCH --mem-per-cpu=1000
#SBATCH --tmp=1000                        # per node!!
#SBATCH --job-name=snakemake
#SBATCH --output=snakemake.out
#SBATCH --error=snakemake.err


source activate snakemake
module load new gcc/4.8.2 r/3.6.0 # make sure the svglite R package is installed (only available for R version > 3.5.0, set dependencies=T)
module load java
cd $SCRATCH/snakemake-phylo-beast2
#snakemake --profile slurm --unlock
snakemake --cores 348 --profile slurm --use-conda --keep-going --ignore-incomplete --rerun-triggers mtime
#snakemake-phylo-beast2/slurm should be in ~/.config/snakemake