#!/bin/sh

## Edits
# P. Datta <pdbforce@jlab.org> Created 01-24-2021

# This scripts finds the max segments of a given run

# Define variables
run=$1 # run number

# -- Check arguments -----------------------------//
if [[ $run == "" ]]; then
    echo " Please enter a valid run # as first argument."
    exit;
fi

DATA_DIR=/mss/halla/sbs/raw
CACHE_DIR=/cache/halla/sbs/raw

# -- Let's check in the cache disk first -----//
for (( i=0; i<=1000; i++ ))
do
    if [[ ! -f "$CACHE_DIR/e1209019_"$run".evio.0."$i ]]
    then
	max=$((i-1))
	if [[ $max == -1 ]]
	then
	    break;
	else
	    echo "-----"
	    echo " Found in /cache/... "
	    echo " Run "$run" has total "$((max+1))" segments."
	    echo "-----"
	    exit;
	fi
    fi
done

# -- Let's check in the cache disk first -----//
for (( i=0; i<=1000; i++ ))
do
    if [[ ! -f "$DATA_DIR/e1209019_"$run".evio.0."$i ]]
    then
	max=$((i-1))
	if [[ $max == -1 ]]
	then
	    echo "--!-- evio file doesn't exist!"
	    exit;
	else
	    echo "-----"
	    echo " Found in /mss/, not in /cache/... "
	    echo " Run "$run" has total "$((max+1))" segments."
	    echo "-----"
	    exit;
	fi
    fi
done
