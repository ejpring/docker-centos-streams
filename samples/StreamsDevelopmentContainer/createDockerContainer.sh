#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This script creates a Docker container from an image. See README.md for details.
#
################################################################################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

imageName=centos7-streams4242-dev

containerName=StreamsDevelopmentContainer

sshPort=2222

vncPort=5901

homeDirectory=$HOME/dockerhome.centos7

dockerCreateParameters=(
    --name $containerName
    --hostname streamshost
    --publish $sshPort:22
    --publish $vncPort:5901
    --env VNC_GEOMETRY=1440x900
    --volume $homeDirectory/streamsdev:/home/streamsdev:rw
    ###--security-opt seccomp=unconfined
)

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# create a container from the image using the parameters above

step "creating container $containerName from image $imageURL ..."
( IFS=$'\n' ; printf "\ncontainer parameters:\n${dockerCreateParameters[*]}\n\n" )
docker create ${dockerCreateParameters[*]} $imageURL supervisord || die "sorry, could not create containiner '$containerName', $?"

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
step "how to share files between container and host:"
echo "    container's directory /home/streamsdev is host's directory $homeDirectory/streamsdev"
exit 0

