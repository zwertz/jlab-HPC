#!/bin/bash

# ------------------------------------------------------------------------- #
# This script runs SIMC events on ifarm and then uses the output ROOT files #
# to submit g4sbs, sbsdig, and replay jobs to the batch farm.               #
# ---------                                                                 #
# P. Datta <pdbforce@jlab.org> CREATED 04-19-2023                           #
# ---------                                                                 #
# ** Do not tamper with this sticker! Log any updates to the script below.  #
# ------------------------------------------------------------------------- #

# Setting environments for SIMC & G4SBS work directories
export SIMC=/w/halla-scshelf2102/sbs/pdbforce/SIMC/simc_gfortran
export G4SBS=/w/halla-scshelf2102/sbs/pdbforce/G4SBS/install

# ------------------- Notes and Instructions (READ BEFORE EXECUTION) ---------------- #
# ----------------------------------------------------------------------------------- #
# 1. This script takes 3 arguments:                                                   #
#    a. SIMC infile w/o file extention. Must be located at $SIMC/infiles directory.   #
#    b. First job id.                                                                 #
#    c. Total no. of jobs to submit.                                                  #
# 2. Total no. of events per g4sbs job gets determined by SIMC infile ("ngen" flag)   #
# 3. Be sure to edit "workflowname" variable appropriately before executing script.   #
# 4. Be sure to edit "outdirpath" variable appropriately before executing script.     #
# 5. "isdebug" = 1 will be interpreted as debug mode.                                 #
# 6. SIMC jobs get executed on ifarm (not on batch farm) and all the output files get #
#    moved to $outdirpath/simcoutdir directory.                                       #
# 7. After all the SIMC jobs are finished a summary CSV file, $infile_summary.csv get # 
#    created and kept in the directory mentioned above which contain the important    #
#    normalization factors per job that are necessary for analysis.                   #
# 8. Interdependency: simc-jobs.py                                                    #
# ----------------------------------------------------------------------------------- #

# ------ Variables needed to be set properly for successful execution ------ #
# -------------------------------------------------------------------------- #
# SIMC input file (don't add file extension). Must be located at $SIMC/infiles. 
# G4SBS macro should have same name as SIMC input file just with different 
# file extention and should be located at $G4SBS/scripts.
infile=$1
# No. of jobs to submit (# to generate per job get set by SIMC infile ("ngen" flag))
fjobid=$2 # first job id
njobs=$3  # total no. of jobs to submit 
# ----/\---- Above variables are taken as arguments to this script ---/\---- # 
# Debug mode or not [0=False] (If true, comments out all swif2 commands)
isdebug=1
# Workflow name
workflowname='test'
# Specify a directory on volatile to store simc, g4sbs, sbsdig, & replayed outfiles.
# Working on a single directory is convenient & safe for the above mentioned
# four processes to run coherently without any error.
outdirpath='/w/halla-scshelf2102/sbs/pdbforce/jlab-HPC/test'
# -------------------------------------------------------------------------- #

# Sanity check 1: Validating the number of arguments provided
if [[ "$#" -ne 3 ]]; then
    echo -e " \n --!!--\n ERROR! Illegal number of arguments!! \n ------"
    echo -e " This script takes 3 arguments: <infile> <fjobid> <njobs>"
    echo -e "  1. <infile>: SIMC infile w/o file extention. Must be located at SIMC/infiles directory."
    echo -e "  2. <fjobid>: First job id."  
    echo -e "  3. <njobs> : Total no. of jobs to submit."
    echo -e " ------"
    echo -e ' ** Make sure "workflowname" & "outdirpath" variables are set properly in the script.'
    echo -e ' ** Read the "Notes and Instructions" block at the top of script for more information.\n'
    exit;
fi

# Sanity check 2: Create the output directory if necessary
if [[ ! -d $outdirpath ]]; then
    { #try
	mkdir $outdirpath
    } || { #catch
	echo -e "\n!!!!!!!! ERROR !!!!!!!!!"
	echo -e $outdirpath "doesn't exist and cannot be created!\n"
	exit;
    }
fi

# Sanity check 3: Check for the existance of SIMC infile
simcmacro=$SIMC'/infiles/'$infile'.inp'
if [[ ! -f $simcmacro ]]; then
    echo -e "\n!!!!!!!! ERROR !!!!!!!!!"
    echo -e "SIMC infile, $simcmacro, doesn't exist! Aborting!\n"
    exit;
fi

# Sanity check 4: Finding matching G4SBS preinit macro for SIMC infile
g4sbsmacro=$G4SBS'/scripts/'$infile'.mac'
if [[ ! -f $g4sbsmacro ]]; then
    echo -e "\n!!!!!!!! ERROR !!!!!!!!!"
    echo -e "G4SBS preinit macro, $g4sbsmacro, doesn't exist! Aborting!\n"
    exit;
fi

# Creating a sub-directory (simcout) to keep all the SIMC outputs
export simcoutdir=$outdirpath'/simcout'
if [[ ! -d $simcoutdir ]]; then
    mkdir $simcoutdir
fi

# Creating a CSV file to write a summary table of normalization factors by job
simcnormtable=$simcoutdir'/'$infile'_summary.csv'

# Reading SIMC infile ("ngen" flag) to determine the # g4sbs events to generate
nevents=$(python3 simc-jobs.py 'grab_param_value' $simcmacro 'ngen')
if [[ $nevents -lt 0 ]]; then
    echo -e "\n!!!!!!!! ERROR !!!!!!!!!"
    echo -e "Illegal no. of events! nevents = $nevents | Aborting!\n"
    exit;
else
    echo -e "\n ** $nevents g4sbs events will be generated per job!"
fi

# Creating the workflow
if [[ $isdebug == 0 ]]; then
    swif2 create $workflowname
else
    echo -e "\nDebug mode!\n"
fi

# Loop to create jobs
for ((i=$fjobid; i<$((fjobid+njobs)); i++))
do
    # lets generate SIMC events first
    pushd $SIMC >/dev/null
    ./run_simc_tree $infile
    mv 'worksim/'$infile'.root' $simcoutdir'/'$infile'_job_'$i'.root' 
    mv 'outfiles/'$infile'_start_random_state.dat' $simcoutdir'/'$infile'_start_random_state_job_'$i'.dat'
    mv 'outfiles/'$infile'.geni' $simcoutdir'/'$infile'_job_'$i'.geni'
    mv 'outfiles/'$infile'.gen' $simcoutdir'/'$infile'_job_'$i'.gen'
    mv 'outfiles/'$infile'.hist' $simcoutdir'/'$infile'_job_'$i'.hist'
    mv 'runout/'$infile'.out' $simcoutdir'/'$infile'_job_'$i'.out'
    simcoutfile=$simcoutdir'/'$infile'_job_'$i'.root'
    popd >/dev/null

    # Abort if SIMC job wasn't successfull
    if [[ ! -f $simcoutfile ]]; then
	echo -e "\n!!!!!!!! ERROR !!!!!!!!!"
	echo -e "SIMC event generation failed! job_$i"
	exit;
    fi
    echo -e "\nSIMC event generation successful! job_$i\n"

    # time to write summary table with normalization factors
    if [[ ($i == 0) || (! -f $simcnormtable) ]]; then
	python3 simc-jobs.py 'grab_norm_factors' 'just_a_placeholder' '1' > $simcnormtable
    fi
    python3 simc-jobs.py 'grab_norm_factors' $simcoutdir'/'$infile'_job_'$i'.hist' '0' >> $simcnormtable

    # submitting g4sbs jobs using SIMC outfiles
    outfilename=$infile'_job_'$i'.root'
    postscript=$infile'_job_'$i'.mac'
    g4sbsjobname=$infile'_job_'$i

    g4sbsscript='/work/halla/sbs/pdbforce/jlab-HPC/run-g4sbs-w-simc.sh'

    if [[ $isdebug == 0 ]]; then
	swif2 add-job -workflow $workflowname -partition production -name $g4sbsjobname -cores 1 -disk 5GB -ram 1500MB $g4sbsscript $infile $postscript $nevents $outfilename $outdirpath $simcoutfile
    fi

    # now, it's time for digitization
    txtfile=$infile'_job_'$i'.txt'
    sbsdigjobname=$infile'_digi_job_'$i
    sbsdiginfile=$outdirpath'/'$outfilename

    sbsdigscript='/work/halla/sbs/pdbforce/jlab-HPC/run-sbsdig.sh'
    
    if [[ $isdebug == 0 ]]; then
	swif2 add-job -workflow $workflowname -antecedent $g4sbsjobname -partition production -name $sbsdigjobname -cores 1 -disk 5GB -ram 1500MB $sbsdigscript $txtfile $sbsdiginfile
    fi

    # finally, lets replay the digitized data
    digireplayinfile=$infile'_job_'$i
    digireplayjobname=$infile'_digi_replay_job_'$i

    digireplayscript='/work/halla/sbs/pdbforce/jlab-HPC/run-digi-replay.sh'
    
    if [[ $isdebug == 0 ]]; then
	swif2 add-job -workflow $workflowname -antecedent $sbsdigjobname -partition production -name $digireplayjobname -cores 1 -disk 5GB -ram 1500MB $digireplayscript $digireplayinfile $outdirpath
    fi
done

# run the workflow and then print status
if [[ $isdebug == 0 ]]; then
    swif2 run $workflowname
    echo -e "\n Getting workflow status.. [may take a few minutes!] \n"
    swif2 status $workflowname
fi
