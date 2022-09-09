#!/bin/bash

inputfile=$1 # output of sbsdig. Don't add file extension
outdirpath='/lustre19/expphy/volatile/halla/sbs/pdbforce/g4sbs_output'

script='/work/halla/sbs/pdbforce/jlab-farm-replay/run-digi-replay.sh'

$script $inputfile $outdirpath
