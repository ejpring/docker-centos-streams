#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

# This script creates a Docker container from an image and a home directory for
# the 'streamsdev' user account.

################### parameters used in this script ############################

set -o pipefail

here=$( cd ${0%/*} ; pwd )

imageName=centos7-base

containerName=centos7-base

sshPort=2222

vncPort=5901

dockerCreateParameters=(
    --name $containerName
    --hostname streamshost
    --publish $sshPort:22
    --publish $vncPort:5901
    --env VNC_GEOMETRY=1440x900
    --volume $here/prepare:/home/streamsdev/prepare:rw
    --volume $HOME/.ssh:/home/streamsdev/.ssh:ro
    ###--security-opt seccomp=unconfined
)

################### functions used in this script #############################

die() { echo ; echo "$*" >&2 ; exit 1 ; }
step() { echo ; echo -e "$*" ; }

################################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# skip this if the container already exists

if [[ $( docker ps -a -q -f name=$containerName ) != "" ]] ; then
    echo "container $containerName already exists"
    exit 0
fi

# create a container from the image

step "creating container $containerName from image $imageName ..."
( IFS=$'\n' ; printf "\ncontainer parameters:\n${dockerCreateParameters[*]}\n\n" )
docker create ${dockerCreateParameters[*]} $imageName supervisord || die "sorry, could not create containiner '$containerName', $?"

# remove any stale public SSH keys from old containers

step "removing stale public SSH key for old containers from 'known_keys' file, if necessary ..."
ssh-keygen -R "[localhost]:$sshPort" 2>/dev/null

# tell the user how to access the container

step "how to start and stop container '$containerName':"
echo "    docker start $containerName"
echo "    docker stop $containerName"
step "how to access user 'streamsdev' in container '$containerName':"
echo "    for Xfce desktop, connect VNC viewer to 'localhost:$vncPort'"
echo "    for command-line login, enter 'ssh -p $sshPort streamsdev@localhost'"

step "Done."
exit 0
