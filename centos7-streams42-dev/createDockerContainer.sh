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

# this URL points at the HTTP directory where Streams subset packages are stored

streamsSubsetPackageLibraryURL=http://splanet02.watson.ibm.com:8080/upload/StreamsSubsetPackages

# uncomment one of the following lines to choose which release of Streams will be used

#streamsSubsetPackage=StreamsSubset.centos7-streams4200-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4211-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4212-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4213-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4220-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4240-dev.tar.gz
#streamsSubsetPackage=StreamsSubset.centos7-streams4241-dev.tar.gz
streamsSubsetPackage=StreamsSubset.centos7-streams4242-dev.tar.gz

regex="StreamsSubset\.(.+)\.tar\.gz"
[[ $streamsSubsetPackage =~ $regex ]] && imageName="${BASH_REMATCH[1]}"

dockerBuildParameters=(
    --file $here/Dockerfile
    --tag=$imageName
    --build-arg ROOT_PASSWORD=password
    --build-arg USER_PASSWORD=password
    --build-arg ADMIN_PASSWORD=password
    --build-arg VNC_GEOMETRY=1440x900
    --build-arg STREAMS_SUBSET_PACKAGE=$streamsSubsetPackageLibraryURL/$streamsSubsetPackage
)

containerName=$imageName

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

# build an image from the Dockerfile using the parameters above

step "building image '$imageName' from Dockerfile $here/Dockerfile ..."
( IFS=$'\n' ; printf "\nimage parameters:\n${dockerBuildParameters[*]}\n\n" )
docker build ${dockerBuildParameters[*]} $here || die "sorry, could not build image '$imageName', $?"

# create a container from the image using the parameters above

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
step "how to share files between container and host:"
echo "    container's directory /home/streamsdev is host's directory $homeDirectory/streamsdev"
exit 0

