#!/bin/bash

# -------------------------------------------------------------------------- #
# This script sets various environmet paths reuired by the "submit-" scripts #
# Environment paths are user specific, hence all the entries in this script  #
# have been kept in a templated format. User must modify the necessary paths #
# appropriately for proper execution of any process.                         #
# ---------                                                                  #
# P. Datta <pdbforce@jlab.org> CREATED 07-25-2023                            #
# ---------                                                                  #
# ** Do not tamper with this sticker! Log any updates to the script above.   #
# -------------------------------------------------------------------------- #

# Required by all
export SCRIPT_DIR=/Path/to/jlab-HPC/repository

# Required by the scripts running G4SBS simulations
export G4SBS=/Path/to/G4SBS/install/directory

# Required by the scripts running SIMC (simc_gfortran) jobs
export SIMC=/Path/to/simc_gfortran/repository

# Required by the scripts running digitization jobs using sbsdig
export LIBSBSDIG=/Path/to/libsbsdig/install/directory

# Required by the scripts running replay (data or MC) jobs
export ANALYZER=/Path/to/analyzer/install/directory
export SBSOFFLINE=/Path/to/SBS-offline/install/directory
export SBS_REPLAY=/Path/to/SBS-replay/repository

#Path to data directories
#The path is written this way below becauses strings will need to be added to the left side of them, ie /cache/$GMN_DATA_PATH
export GMN_DATA_PATH=halla/sbs/raw
export GEN_DATA_PATH=halla/sbs/GEnII/raw
