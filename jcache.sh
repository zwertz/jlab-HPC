#!/bin/sh

## Edits
# P. Datta <pdbforce@jlab.org> Created 01-24-2021

# This scripts jcache evio files for a run for desired
# segments. First it checks in the cache directory. If
# a segment already exists then it asks for user input. 

# Define variables
run=$1 # run number
segs=$2 # maximum no of segments we wanna jcache, -1 => all
min=0 # starting segment number
#$max # total number of segments

# -- Check arguments -----------------------------//
if [[ $run == "" ]]; then
    echo " Please enter a valid run # as first argument."
    exit;
elif [[ $segs == "" ]]; then
    echo " Please specify how many segments to jcache, as 2nd argument. -1 => All"
    exit;
fi

DATA_DIR=/mss/halla/sbs/raw
CACHE_DIR=/cache/halla/sbs/raw

# -- Let's check in the cache disk first -----//
for (( i=0; i<=1000; i++ ))
do
    if [[ ! -f "$CACHE_DIR/e1209019_"$run".evio.0."$i ]]
    then
	maxCH=$((i-1))
	if [[ $maxCH == -1 ]]
	then
	    echo "----"
	    echo " Needs cache-ing. Preceeding.. "
	    break;
	else
	    bool=5
	    break;
	fi
    fi
done

# -- Found some segs in the cache, want more? -----//
if [[ $bool == 5 ]]; then
    while true; do
	echo " --**-- "
	echo " Found "$((maxCH+1))" Segments of in cache."
	echo " Wanna jcache more, if exists? [Y/N] "
	read -p "" yn
	case $yn in
	    [Yy]*)
		min=$((maxCH+1))
		segs=1000
		break; ;;
	    [Nn]*) 
		exit;
	esac
    done
fi    

# -- Let's find out how many segments are there -----//
for (( i=$min; i<=1000; i++ ))
do
    if [[ ! -f "$DATA_DIR/e1209019_"$1".evio.0."$i ]]
    then
	max=$((i-1))
	if [[ $max == -1 ]]
	then
	    echo  -e "--!-- evio files  doesn't exist for run "$1"."
	    exit;
	else
	    break;
	fi
    fi
    # In case we don't wanna jcache all segments
    if [[ $segs != -1 ]] && [[ $segs -lt $i ]]; then
	bool=99
	break;
    fi
done

# -- Let's check second argument -----------------------//
if [[ $2 -gt $max ]] && [[ $bool != 99 ]]; then
     while true; do
	echo "-----"
	echo " Run "$1" has only "$((max+1))" segments."
	echo " Wanna jcache all of them? [Y/N] "
	read -p "" yn
	case $yn in
	    [Yy]*)
		segs=-1
		break; ;;
	    [Nn]*) 
		exit;
	esac
    done
fi

# -- Let's jcache all the segments we want -------------//
if [[ $segs == -1 ]]
    then
    for (( i=0; i<=$max; i++ ))
    do
	jcache get $DATA_DIR/e1209019_$1.evio.0.$i
    done
elif [[ $segs == 1000 ]]; then
    for (( i=$min; i<=$max; i++ ))
    do
	jcache get $DATA_DIR/e1209019_$1.evio.0.$i
    done
else
    for (( i=0; i<=$segs; i++ ))
    do
	jcache get $DATA_DIR/e1209019_$1.evio.0.$i
    done
fi

# Getting request status
# jcache pendingRequest -u <username>
   
	
