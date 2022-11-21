#!/bin/bash

#SBATCH --partition=production
#SBATCH --account=halla
#SBATCH --mem-per-cpu=1500

#SWIF_JOB_WORK_DIR=$PWD # for testing purposes
echo 'swif_job_work_dir='$SWIF_JOB_WORK_DIR

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
ldd /work/halla/sbs/pdbforce/LIBSBSDIG/install/bin/sbsdig |& grep not

# Setup sbsdig specific environments
export LIBSBSDIG=/work/halla/sbs/pdbforce/LIBSBSDIG/install
source $LIBSBSDIG/bin/sbsdigenv.sh

# run the sbsdig command
dbfile=$LIBSBSDIG/db/db_gmn_conf.dat

txtfile=$1 # .txt file containing input file paths
infilename=$2

echo $infilename >>$txtfile

sbsdig $dbfile $txtfile

