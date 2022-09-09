#!/bin/bash

# submit calibration jobs

setnum=$1
iter=$2
prefix=$3

jobname=$prefix-$iter
configfile=$prefix.cfg

script='/work/halla/sbs/pdbforce/jlab-farm-replay/run-bbcal-calibration.sh'

swif2 add-job -workflow bbcal-calib-sbs14 -partition production -name bbcal-calib-$jobname -cores 1 -disk 25GB -ram 1500MB  $script $setnum $iter $configfile


#Example: ./submit-bbcal-calibration.sh 45 1 sbs4-sbs50p ##SBS4,SBS50%,1st iter
