#!/bin/bash

# ------------------------------------------------------------------------- #
# This script submits real data replay jobs for GMn/nTPE data to batch farm.# 
# There is a flag to force all the jobs to run on ifarm instead. It was     #
# created based on Andrew Puckett's script.                                 #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 11-09-2022                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script above.  #
# ------------------------------------------------------------------------- #

# Setting necessary environments (ONLY User Specific part)
export SCRIPT_DIR=/w/halla-scshelf2102/sbs/pdbforce/jlab-HPC
export ANALYZER=/work/halla/sbs/pdbforce/ANALYZER/install
export SBSOFFLINE=/work/halla/sbs/pdbforce/SBSOFFLINE/install
export SBS_REPLAY=/work/halla/sbs/pdbforce/SBS-replay
export DATA_DIR=/cache/mss/halla/sbs/raw

runnum=$1
nevents=$2
maxsegments=$3
run_on_ifarm=$4
workflowname='sbs14-sbs70p-lh2'
outdirpath='/volatile/halla/sbs/pdbforce/gmn-replays'

## To-do [05/13/2023]
## 1. figure out how to handle run_on_ifarm = 1 case for job submissions.
## 2. Implement checks to make sure outdir path exists and user has permission to create /log 
##    and /rootfiles subdirectories in it.

for ((i=0; i<=$maxsegments; i++))
do
    fnameout_pattern='/farm_out/pdbforce/pdatta_gmn_'$runnum'_segment'$i'.out'
    #    sbatch --output=$fnameout_pattern run_GMN_sbatch_nohodo.sh $runnum -1 0 e1209019 $i 1
    jobname='pdatta_gmn_'$runnum'_segment'$i
    
    # look for first segment on cache disk:
    firstsegname='e1209019_'$runnum'.evio.0.0'
    mssfirst='mss:/mss/halla/sbs/raw/'$firstsegname
    cachefirst='/cache/mss/halla/sbs/raw/'$firstsegname
    
    eviofilename='e1209019_'$runnum'.evio.0.'$i
    mssfilename='mss:/mss/halla/sbs/raw/'$eviofilename
    cachefile='/cache/mss/halla/sbs/raw/'$eviofilename
    
    script=$SCRIPT_DIR'/run-gmn-replay.sh'

    testfilename='/mss/halla/sbs/raw/'$eviofilename
    
    outfilename='match:e1209019_fullreplay_'$runnum'*seg'$i'*.root'
    logfilename='match:replay_gmn_'$runnum'*seg'$i'*.log'

    outcopydir=$outdirpath'/rootfiles'
    logcopydir=$outdirpath'/logs'

    if [ -f "$testfilename" ]; 
    then
	echo 'Adding new swif2 job, runnum='$runnum', segment='$i 
    
	if [ $i -gt 0 ]
	then
	    echo 'segment '$i' also requires first segment'
	    swif2 add-job -workflow $workflowname -partition production -name $jobname -cores 1 -disk 25GB -ram 1500MB -input $cachefile $mssfilename -input $cachefirst $mssfirst $script $runnum $nevents 0 e1209019 $i 1 $DATA_DIR $outdirpath $run_on_ifarm $ANALYZER $SBSOFFLINE $SBS_REPLAY
	else
	    echo 'segment '$i' IS first segment'
	    swif2 add-job -workflow $workflowname -partition production -name $jobname -cores 1 -disk 25GB -ram 1500MB -input $cachefile $mssfilename $script $runnum $nevents 0 e1209019 $i 1 $DATA_DIR $outdirpath $run_on_ifarm $ANALYZER $SBSOFFLINE $SBS_REPLAY
	fi
    fi
done
