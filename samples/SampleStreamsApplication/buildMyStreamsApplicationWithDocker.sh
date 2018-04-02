#!/bin/bash

# Copyright (C) 2016, 2017  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This script builds an image for a Docker container. See README.md for details.
#
################################################################################

die() { echo ; echo "$*" >&2 ; exit 1 ; }
step() { echo ; echo -e "$*" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

homeDirectory=$HOME/dockerhome.centos6/streamsdev

toolkitDirectory=$HOME/StreamsToolkits

applicationDirectory=$here

applicationNamespace=MyStreamsApplication

applicationComposite=Main

applicationCompileTimeParameterList=(
)

streamsToolkitList=(
)

streamsCompilerOptionsList=(
    --verbose-mode
    --spl-path=$( IFS=: ; echo "${streamsToolkitList[*]}" )
    --optimized-code-generation
    --main-composite=$applicationNamespace::$applicationComposite
)

gccOptions=""

ldOptions=""

dockerRunParameterList=(
    --rm
    --volume $homeDirectory:/home/streamsdev:rw
    --volume $toolkitDirectory:/home/streamsdev/toolkits
    --volume $applicationDirectory:/home/streamsdev/application
)

dockerImageName=centos6-streams4212-dev

###############################################################################

# make sure Docker is running and image is available 

docker info 1>/dev/null || die "sorry, could not find Docker, $?"
docker image inspect $dockerImageName 1>/dev/null || die "sorry, could not find Docker image $dockerImageName, $?"

# make sure the Streams application source file exists

[[ -f $applicationDirectory/$applicationNamespace/$applicationComposite.spl ]] || die "sorry, could not find Streams application source file $applicationDirectory/$applicationNamespace/$applicationComposite.spl, $?"

# log parameters used for this compilation

step "compile configuration for Streams application $applicationNamespace::$applicationComposite ..."
( IFS=$'\n' ; echo -e "\nStreams toolkits:\n${streamsToolkitList[*]}" )
( IFS=$'\n' ; echo -e "\nStreams compiler options:\n${streamsCompilerOptionsList[*]}" )
( IFS=$'\n' ; echo -e "\n$applicationNamespace::applicationComposite compile-time parameters:\n${applicationCompileTimeParameterList[*]}" )
echo -e "\nGNU compiler parameters:\n$gccOptions" 
echo -e "\nGNU linker parameters:\n$ldOptions" 

# compile Streams application

step "compiling Streams application $applicationNamespace::$applicationComposite ..."
#docker run -it ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsdev 
docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsdev -c "cd /home/streamsdev/application && sc ${streamsCompilerOptionsList[*]} \"--cxx-flags=$gccOptions\" \"--ld-flags=$ldOptions\" ${applicationCompileTimeParameterList[*]}" || die "Sorry, could not compile Streams application $applicationNamespace::$applicationComposite, $?" 

exit 0

