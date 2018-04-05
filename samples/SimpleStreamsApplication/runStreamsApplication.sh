#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This script builds an image for a Docker container. See README.md for details.
#
################################################################################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

# uncomment one of the following lines to choose which Docker image to use

#dockerImageName=centos7-streams4200-run
#dockerImageName=centos7-streams4211-run
#dockerImageName=centos7-streams4212-run
#dockerImageName=centos7-streams4213-run
#dockerImageName=centos7-streams4220-run
#dockerImageName=centos7-streams4240-run
#dockerImageName=centos7-streams4241-run
dockerImageName=centos7-streams4242-run

applicationBundle=$here/output/SimpleStreamsApplication.Main.sab

applicationDataDirectory=$here/data

applicationSubmissionTimeParameterList=(
    inputFilename=/home/streamsrun/data/poem.in
    outputFilename=/home/streamsrun/data/poem.out
    "\"stringParameter=Hello, world\""
    integerParameter=42
    floatParameter=3.14159
    booleanParameter=true
    "\"listParameter=[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]\""
    "\"mapParameter={200: 'OK', 301: 'Moved Permanently', 408: 'Request Timeout', 501: 'Not Implemented'}\""
)

dockerRunParameterList=(
    --rm
    -v $( dirname $applicationBundle ):/home/streamsrun/bundle:ro
    -v $applicationDataDirectory:/home/streamsrun/data:rw
)

traceLevel=3 # ... 0 for off, 1 for error, 2 for warn, 3 for info, 4 for debug, 5 for trace

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# make sure application bundle and data directory exist

[[ -f $applicationBundle ]] || die "sorry, could not find Streams application bundle $applicationBundle, $?"
[[ -d $applicationDataDirectory ]] || die "sorry, could not find Streams application data directory $application/DataDirectory, $?"

# run the Streams application

( IFS=$'\n' ; echo -e "\nsubmission-time parameters:\n${applicationSubmissionTimeParameterList[*]}" )

step "running Streams application bundle $applicationBundle ..."
bundleName=$( basename $applicationBundle )
#docker run -it ${dockerRunParameterList[*]} $dockerImageName
docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "java -jar /home/streamsrun/bundle/$bundleName -t $traceLevel ${applicationSubmissionTimeParameterList[*]}" || die "Sorry, could not run Streams application bundle $streamsApplicationBundle, $?" 

exit 0

