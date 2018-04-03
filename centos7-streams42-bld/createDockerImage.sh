#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
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

source $here/../config/centos7.cfg

streamsSubsetPackage=StreamsSubset.centos7-streams$streamsVersion-bld.tar.gz

imageName=centos7-streams$streamsVersion-bld

dockerBuildParameters=(
    --file $here/Dockerfile
    --tag=$imageName
    --build-arg ROOT_PASSWORD=password
    --build-arg ADMIN_PASSWORD=password
    --build-arg STREAMS_SUBSET_PACKAGE=$streamsSubsetPackageServerURL/$streamsSubsetPackage
)

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# build an image from the Dockerfile using the parameters above

step "building image '$imageName' from Dockerfile $here/Dockerfile ..."
( IFS=$'\n' ; printf "\nimage parameters:\n${dockerBuildParameters[*]}\n\n" )
docker build ${dockerBuildParameters[*]} $here || die "sorry, could not build image '$imageName', $?"

step "built Docker image '$imageName'"
exit 0

