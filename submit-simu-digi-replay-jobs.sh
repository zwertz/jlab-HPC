#!/bin/bash

preinit=$1 # don't add file extension
nevents=$2
njobs=$3
workflowname='gmng4_sbs8_0p'
swif2 create $workflowname
# specify a directory on volatile to store g4sbs, sbsdig, & replayed files.
# Working on a single directory is convenient safe for the above mentioned
# three processes to run smoothly.
outdirpath='/lustre19/expphy/volatile/halla/sbs/pdbforce/g4sbs_output/gmng4_sbs8'

# Validating the number of arguments provided
if [[ "$#" -ne 3 ]]; then
    echo -e "\n--!--\n Illegal number of arguments!!"
    echo -e " This script expects 3 arguments: <preinit> <nevents> <njobs> \n"
    exit;
fi

for ((i=1; i<=$njobs; i++))
do
    # lets submit g4sbs jobs first
    outfilename=$preinit'_job_'$i'.root'
    postscript=$preinit'_job_'$i'.mac'
    g4sbsjobname=$preinit'_job_'$i

    g4sbsscript='/work/halla/sbs/pdbforce/jlab-HPC/run-g4sbs-simu.sh'

    swif2 add-job -workflow $workflowname -partition production -name $g4sbsjobname -cores 1 -disk 5GB -ram 1500MB $g4sbsscript $preinit $postscript $nevents $outfilename $outdirpath

    # now, it's time for digitization
    txtfile=$preinit'_job_'$i'.txt'
    sbsdigjobname=$preinit'_digi_job_'$i
    sbsdiginfile=$outdirpath'/'$outfilename

    sbsdigscript='/work/halla/sbs/pdbforce/jlab-HPC/run-sbsdig.sh'
    
    swif2 add-job -workflow $workflowname -antecedent $g4sbsjobname -partition production -name $sbsdigjobname -cores 1 -disk 5GB -ram 1500MB $sbsdigscript $txtfile $sbsdiginfile

    # finally, lets replay the digitized data
    digireplayinfile=$preinit'_job_'$i
    digireplayjobname=$preinit'_digi_replay_job_'$i

    digireplayscript='/work/halla/sbs/pdbforce/jlab-HPC/run-digi-replay.sh'
    
    swif2 add-job -workflow $workflowname -antecedent $sbsdigjobname -partition production -name $digireplayjobname -cores 1 -disk 5GB -ram 1500MB $digireplayscript $digireplayinfile $outdirpath
done

# run the workflow and then print status
swif2 run $workflowname
swif2 status $workflowname
