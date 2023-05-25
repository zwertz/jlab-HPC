#!/bin/bash

##
# This script cleans up the root_hist file in the current directory.
# ----
# P. Datta <pdbforce@jlab.org> CREATED 05/23/23
##

SCRIPT_DIR='/w/halla-scshelf2102/sbs/pdbforce/jlab-HPC'

python3 $SCRIPT_DIR/utility.py remove_duplicates ${PWD}/root_hist
mv root_hist_temp root_hist
