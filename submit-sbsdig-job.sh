#!/bin/bash

inputfile=$1 # .txt file containing input file paths
jobname=$2
workflowname='ewertz_Simulation'
outdirpath='/lustre19/expphy/volatile/halla/sbs/ewertz/Simulation/SBS4'

script='/work/halla/sbs/ewertz/jlab-HPC/run-sbsdig.sh'

#swif2 add-job -workflow $workflowname -partition production -name $jobname -cores 1 -disk 5GB -ram 1500MB $script $inputfile $outdirpath

$script $inputfile $outdirpath # for testing purposes
