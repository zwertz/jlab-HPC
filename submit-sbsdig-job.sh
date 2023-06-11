#!/bin/bash

# ------------------------------------------------------------------------- #
# This script runs sbsdig jobs on ifarm or submits them to batch farm.      #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 11-09-2022                           #
# ------------------------------------------------------------------------- #

# Setting necessary environments (ONLY User Specific part)
export SCRIPT_DIR=/Path/to/jlab-HPC/repository
export LIBSBSDIG=/Path/to/libsbsdig/install/directory

# Filebase of the g4sbs output file (w/o file extention)
g4sbsfilebase=$1
# Directory at which g4sbs output files are existing which we want to digitize
g4sbsfiledir=$2
fjobid=$3       # first job id
njobs=$4        # total no. of jobs to submit 
run_on_ifarm=$5 # 1=>Yes (If true, runs all jobs on ifarm)
# workflow name
workflowname=

# Validating the number of arguments provided
if [[ "$#" -ne 5 ]]; then
    echo -e "\n--!--\n Illegal number of arguments!!"
    echo -e " This script expects 5 arguments: <g4sbsfilebase> <g4sbsfiledir> <fjobid> <njobs> <run_on_ifarm>\n"
    exit;
else 
    if [[ $run_on_ifarm -ne 1 ]]; then
	echo -e '\n------'
	echo -e ' Check the following variable(s):'
	echo -e ' "workflowname" : '$workflowname''
	while true; do
	    read -p "Do they look good? [y/n] " yn
	    echo -e ""
	    case $yn in
		[Yy]*) 
		    break; ;;
		[Nn]*) 
		    read -p "Enter desired workflowname : " temp1
		    workflowname=$temp1
		    break; ;;
	    esac
	done
    fi
fi

# Creating the workflow
if [[ $run_on_ifarm -ne 1 ]]; then
    swif2 create $workflowname
else
    echo -e "\nRunning all jobs on ifarm!\n"
fi

# creating jobs
for ((i=$fjobid; i<$((fjobid+njobs)); i++))
do
    txtfile=$g4sbsfilebase'_job_'$i'.txt'
    sbsdigjobname=$g4sbsfilebase'_digi_job_'$i
    sbsdiginfile=$g4sbsfiledir'/'$g4sbsfilebase'_job_'$i'.root'

    sbsdigscript=$SCRIPT_DIR'/run-sbsdig.sh'

    if [[ $run_on_ifarm -ne 1 ]]; then
	swif2 add-job -workflow $workflowname -partition production -name $sbsdigjobname -cores 1 -disk 5GB -ram 1500MB $sbsdigscript $txtfile $sbsdiginfile $run_on_ifarm $LIBSBSDIG
    else
	$sbsdigscript $txtfile $sbsdiginfile $run_on_ifarm $LIBSBSDIG
    fi
done

# run the workflow and then print status
if [[ $run_on_ifarm -ne 1 ]]; then
    swif2 run $workflowname
    echo -e "\n Getting workflow status.. [may take a few minutes!] \n"
    swif2 status $workflowname
fi
