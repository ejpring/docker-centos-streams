# Copyright (C) 2016, 2017  International Business Machines Corporation
# All Rights Reserved

#!/bin/bash

################################################################################
#
# This script builds an image for a Docker container. See README.md for details.
#
################################################################################

die() { echo ; echo "$*" >&2 ; exit 1 ; }
step() { echo ; echo -e "$*" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

toolkitDirectory=$HOME/StreamsToolkits

applicationDirectory=$HOME/MyStreamsApplication

applicationNamespace=MyStreamsApplication

applicationComposite=Main

applicationCompileTimeParameterList=(
    someParameter=someValue
)

streamsToolkitList=(
    /home/streamsadmin/toolkits/streamsx.json/com.ibm.streamsx.json
    /home/streamsadmin/toolkits/streamsx.inet/com.ibm.streamsx.inet
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
    -v $applicationDirectory:/home/streamsadmin/application:rw
    -v $toolkitDirectory:/home/streamsadmin/toolkits:ro
)

dockerImageName=$( basename $here )

###############################################################################

# make sure Docker is installed and running 

docker info 1>/dev/null || exit $?

# make sure the Streams application source file exists

[[ -f $applicationDirectory/$applicationNamespace/$applicationComposite.spl ]] || die "sorry, could not find Streams application source file $applicationDirectory/$applicationNamespace/$applicationComposite.spl, $?"

# log parameters used for this compilation

step "compile configuration for Streams application $applicationNamespace::$applicationComposite ..."
( IFS=$'\n' ; echo -e "\nStreams toolkits:\n${streamsToolkitList[*]}" )
( IFS=$'\n' ; echo -e "\nStreams compiler options:\n${streamsCompilerOptionsList[*]}" )
echo -e "\nGNU compiler parameters:\n$gccOptions" 
echo -e "\nGNU linker parameters:\n$ldOptions" 
( IFS=$'\n' ; echo -e "\n$applicationNamespace::applicationComposite compile-time parameters:\n${applicationCompileTimeParameterList[*]}" )

# compile Streams application

step "compiling Streams application $applicationNamespace::$applicationComposite ..."
docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsadmin -c "cd application && sc ${streamsCompilerOptionsList[*]} \"--cxx-flags=$gccOptions\" \"--ld-flags=$ldOptions\" -- ${applicationCompileTimeParameterList[*]}" || die "Sorry, could not compile Streams application $applicationNamespace::$applicationComposite, $?" 

exit 0

