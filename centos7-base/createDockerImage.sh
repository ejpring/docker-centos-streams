#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

# This script builds an image for a Docker container. See README.md for details.

################### functions used in this script #############################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

imageName=centos7-base

dockerBuildParameters=(
    --file $here/Dockerfile
    --tag=$imageName
    --build-arg ROOT_PASSWORD=password
    --build-arg USER_PASSWORD=password
    --build-arg ADMIN_PASSWORD=password
    --build-arg VNC_GEOMETRY=1440x900
)

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# skip this if the image already exists

if [[ $( docker images -a -q $containerName ) != "" ]] ; then
    echo "image $imageName already exists"
    exit 0
fi

# build an image from the Dockerfile using the parameters above

step "building image '$imageName' from Dockerfile $here/Dockerfile ..."
( IFS=$'\n' ; printf "\nimage parameters:\n${dockerBuildParameters[*]}\n\n" )
docker build ${dockerBuildParameters[*]} $here || die "sorry, could not build image '$imageName', $?"

exit 0

