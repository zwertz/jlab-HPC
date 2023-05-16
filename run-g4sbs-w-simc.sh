#!/bin/bash

# ------------------------------------------------------------------------- #
# This script runs g4sbs simulation jobs using SIMC generated events.       #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 04-19-2023                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script above.  #
# ------------------------------------------------------------------------- #

#SBATCH --partition=production
#SBATCH --account=halla
#SBATCH --mem-per-cpu=1500

# list of arguments
preinit=$1
postscript=$2
nevents=$3
outfilebase=$4
outdirpath=$5
simcoutfile=$6
run_on_ifarm=$7
g4sbsenv=$8

# paths to necessary libraries (ONLY User specific part) ---- #
export G4SBS=$g4sbsenv
# ----------------------------------------------------------- #

ifarmworkdir=${PWD}
if [[ $run_on_ifarm == 1 ]]; then
    SWIF_JOB_WORK_DIR=$ifarmworkdir
    echo -e "Running all jobs on ifarm!"
fi
echo -e 'Work directory = '$SWIF_JOB_WORK_DIR

MODULES=/etc/profile.d/modules.sh 

if [[ $(type -t module) != function && -r ${MODULES} ]]; then 
source ${MODULES} 
fi 

if [ -d /apps/modulefiles ]; then 
module use /apps/modulefiles 
fi 

# setup farm environments
source /site/12gev_phys/softenv.sh 2.4
module load gcc/9.2.0 
ldd $G4SBS/bin/g4sbs |& grep not

# Setup g4sbs specific environments
source $G4SBS/bin/g4sbs.sh

# creating post script
echo '/g4sbs/simcfile '$simcoutfile >>$postscript
echo '/g4sbs/filename '$outfilebase'.root' >>$postscript
echo '/g4sbs/run '$nevents >>$postscript
#cat $postscript

g4sbs --pre=$preinit'.mac' --post=$postscript 

# idiot proofing
if [[ ! -d $outdirpath ]]; then
    mkdir $outdirpath
fi
mv $outfilebase'.root' $outdirpath
mv $outfilebase'.csv' $outdirpath

# clean up the work directory
rm $postscript
