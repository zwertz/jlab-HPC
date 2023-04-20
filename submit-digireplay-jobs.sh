#!/bin/bash

# ------------------------------------------------------------------------- #
# This script submits jobs to replay digitized data to batch farm.          #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 11-09-2022                           #
# ------------------------------------------------------------------------- #

inputfile=$1 # output of sbsdig. Don't add file extension
outdirpath='/lustre19/expphy/volatile/halla/sbs/pdbforce/g4sbs_output'

script='/work/halla/sbs/pdbforce/jlab-HPC/run-digi-replay.sh'

$script $inputfile $outdirpath
