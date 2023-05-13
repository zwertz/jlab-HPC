#!/bin/bash

# ------------------------------------------------------------------------- #
# This script runs real data replay jobs for GMn/nTPE data. It was created  #
# based on Andrew Puckett's script.                                         #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 11-09-2022                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script above.  #
# ------------------------------------------------------------------------- #

#SBATCH --partition=production
#SBATCH --account=halla
#SBATCH --mem-per-cpu=1500

# List of arguments
runnum=$1
maxevents=$2
firstevent=$3
prefix=$4
firstsegment=$5
maxsegments=$6
run_on_ifarm=$7

ifarmworkdir=${PWD}
if [[ $run_on_ifarm == 1 ]]; then
    SWIF_JOB_WORK_DIR=$ifarmworkdir
    echo -e "Running all jobs on ifarm!"
fi
echo 'Work directory = '$SWIF_JOB_WORK_DIR

MODULES=/etc/profile.d/modules.sh 

if [[ $(type -t module) != function && -r ${MODULES} ]]; then 
source ${MODULES} 
fi 

if [ -d /apps/modulefiles ]; then 
module use /apps/modulefiles 
fi 

source /site/12gev_phys/softenv.sh 2.4
module load gcc/9.2.0 
ldd /work/halla/sbs/pdbforce/ANALYZER/install/bin/analyzer |& grep not

export ANALYZER=/work/halla/sbs/pdbforce/ANALYZER/install
source $ANALYZER/bin/setup.sh
source /work/halla/sbs/pdbforce/SBSOFFLINE/install/bin/sbsenv.sh

#export SBS_REPLAY=/work/halla/sbs/SBS_REPLAY/SBS-replay
export SBS_REPLAY=/work/halla/sbs/pdbforce/SBS-replay
export DB_DIR=$SBS_REPLAY/DB
export DATA_DIR=/cache/mss/halla/sbs/raw

export OUT_DIR=$SWIF_JOB_WORK_DIR
export LOG_DIR=$SWIF_JOB_WORK_DIR

echo 'OUT_DIR='$OUT_DIR
echo 'LOG_DIR='$LOG_DIR

# ------
export ANALYZER_CONFIGPATH=$SBS_REPLAY/replay
# ------

cp $SBS/run_replay_here/.rootrc $SWIF_JOB_WORK_DIR

analyzer -b -q 'replay_gmn.C+('$runnum','$maxevents','$firstevent','\"$prefix\"','$firstsegment','$maxsegments')'

outfilename=$OUT_DIR'/e1209019_*'$runnum'*.root'
logfilename=$LOG_DIR'/replay_gmn_'$runnum'*.log' 

# move output files
mv $outfilename /volatile/halla/sbs/pdbforce/gmn-replays/rootfiles
mv $logfilename /volatile/halla/sbs/pdbforce/gmn-replays/logs

# clean up the work directory
rm .rootrc
