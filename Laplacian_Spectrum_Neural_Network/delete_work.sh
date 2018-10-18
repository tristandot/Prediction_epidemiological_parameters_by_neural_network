#!/bin/sh

#SBATCH --array=0-128

rsync -a --delete empty_dir/   work/

rm *.out
