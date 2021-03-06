#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

# This script creates a Docker container from an image and a home directory for
# the 'streamsdev' user account.

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

imageName=centos7-base

script=/home/streamsdev/prepare/prepareStreamsSubsetPackages.sh

dockerRunParameters=(
    -it
    --rm
    --volume $here/prepare:/home/streamsdev/prepare:ro
    --volume $here/../config:/home/streamsdev/config:ro
    --volume $HOME/.ssh:/home/streamsdev/.ssh:ro
)

################### functions used in this script #############################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

step "creating Streams subset packages with $script ..."
docker run ${dockerRunParameters[*]} $imageName /sbin/runuser -l streamsdev -c $script || die "Sorry, could not run $script, $?" 

step "Done."
exit 0
