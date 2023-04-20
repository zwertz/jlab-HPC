#!/bin/bash

# ------------------------------------------------------------------------- #
# This script submits sbsdig jobs to batch farm.                            #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 11-09-2022                           #
# ------------------------------------------------------------------------- #

inputfile=$1 # .txt file containing input file paths
jobname=$2
outdirpath='/lustre19/expphy/volatile/halla/sbs/pdbforce/g4sbs_output'

script='/work/halla/sbs/pdbforce/jlab-HPC/run-sbsdig.sh'

swif2 add-job -workflow test-g4sbs -partition production -name $jobname -cores 1 -disk 5GB -ram 1500MB $script $inputfile $outdirpath

#$script $inputfile $outdirpath # for testing purposes
