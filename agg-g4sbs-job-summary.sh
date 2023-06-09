#!/bin/bash

# ------------------------------------------------------------------------- #
# This script aggregates summary of g4sbs simulation jobs.                  #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 05-12-2023                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script above.  #
# ------------------------------------------------------------------------- #

#SBATCH --partition=production
#SBATCH --account=halla
#SBATCH --mem-per-cpu=150

infile=$1
istitle=$2
outfile=$3
scriptdirenv=$4

# paths to necessary libraries (ONLY User specific part) ---- #
export SCRIPT_DIR=$scriptdirenv
# ----------------------------------------------------------- #

if [[ $istitle -eq 1 ]]; then
    python3 $SCRIPT_DIR'/'utility.py 'grab_g4sbs_norm_factors' $infile $istitle > $outfile
else
    python3 $SCRIPT_DIR'/'utility.py 'grab_g4sbs_norm_factors' $infile $istitle >> $outfile
fi

