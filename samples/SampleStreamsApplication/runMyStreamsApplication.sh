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

applicationBundle=$HOME/MyStreamsApplication/output/MyStreamsNamespace.Main.sab

applicationDataDirectory=$HOME/MyStreamsApplication/data

applicationSubmissionTimeParameterList=(
    sourceFilename=/home/streamsrun/data/poem.in
    sinkFilename=/home/streamsrun/data/poem.out
)

dockerRunParameterList=(
    -v $( dirname $applicationBundle ):/home/streamsrun/bundle:ro
    -v $applicationDataDirectory:/home/streamsrun/data:rw
)

dockerImageName=$( basename $here )

traceLevel=3 # ... 0 for off, 1 for error, 2 for warn, 3 for info, 4 for debug, 5 for trace

###############################################################################

# make sure Docker is installed and running 

docker info 1>/dev/null || exit $?

# make sure application bundle and data directory exist

[[ -f $applicationBundle ]] || die "sorry, could not find Streams application bundle $applicationBundle, $?"
[[ -d $applicationDataDirectory ]] || die "sorry, could not find Streams application data directory $application/DataDirectory, $?"

# run the Streams application

step "running Streams application bundle $applicationBundle ..."
#docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "export"
#docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "ls -al \$STREAMS_INSTALL/java/jre/bin"
#docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "$streamsApplicationBundle -t $traceLevel ${applicationSubmissionTimeParameterList[*]}" || die "Sorry, could not run Streams application $applicationNamespace::$applicationComposite, $?" 
#docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "\$STREAMS_INSTALL/java/jre/bin/java -jar $streamsApplicationBundle -t $traceLevel ${applicationSubmissionTimeParameterList[*]}" || die "Sorry, could not run Streams application bundle $streamsApplicationBundle, $?" 

bundleName=$( basename $applicationBundle )
docker run ${dockerRunParameterList[*]} $dockerImageName /sbin/runuser -l streamsrun -c "java -jar /home/streamsrun/bundle/$bundleName -t $traceLevel ${applicationSubmissionTimeParameterList[*]}" || die "Sorry, could not run Streams application bundle $streamsApplicationBundle, $?" 

exit 0

