# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

#!/bin/bash

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

#dockerImageName=centos7-streams4200-bld
#dockerImageName=centos7-streams4211-bld
#dockerImageName=centos7-streams4212-bld
#dockerImageName=centos7-streams4213-bld
#dockerImageName=centos7-streams4220-bld
#dockerImageName=centos7-streams4240-bld
#dockerImageName=centos7-streams4241-bld
dockerImageName=centos7-streams4242-bld

applicationNamespace=SimpleStreamsApplication

applicationComposite=Main

applicationCompileTimeParameterList=(
)

streamsToolkitDirectory=$HOME/StreamsToolkits

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
    --volume $streamsToolkitDirectory:/home/streamsadmin/toolkits:ro
    --volume $here:/home/streamsadmin/application:rw
)

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# make sure the Streams application source file exists

[[ -f $here/$applicationNamespace/$applicationComposite.spl ]] || die "sorry, could not find Streams application source file $here/$applicationNamespace/$applicationComposite.spl, $?"

# log parameters used for this build

step "compile configuration for Streams application $applicationNamespace::$applicationComposite ..."
( IFS=$'\n' ; echo -e "\nStreams toolkits:\n${streamsToolkitList[*]}" )
( IFS=$'\n' ; echo -e "\nStreams compiler options:\n${streamsCompilerOptionsList[*]}" )
( IFS=$'\n' ; echo -e "\n$applicationNamespace::applicationComposite compile-time parameters:\n${applicationCompileTimeParameterList[*]}" )
echo -e "\nGNU compiler parameters:\n$gccOptions" 
echo -e "\nGNU linker parameters:\n$ldOptions" 

# build Streams application

step "compiling Streams application $applicationNamespace::$applicationComposite ..."
docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsadmin -c "cd /home/streamsadmin/application && sc ${streamsCompilerOptionsList[*]} \"--cxx-flags=$gccOptions\" \"--ld-flags=$ldOptions\" ${applicationCompileTimeParameterList[*]}" || die "Sorry, could not compile Streams application $applicationNamespace::$applicationComposite, $?" 

step "built application $applicationNamespace::$applicationComposite into Streams Application Bundle:"
find $here -name '*.sab'
exit 0

