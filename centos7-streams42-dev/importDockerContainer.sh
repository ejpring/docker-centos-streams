#!/bin/bash

# Copyright (C) 2018  International Business Machines Corporation
# All Rights Reserved

set -o pipefail

################################################################################
#
# This script imports a Docker container from a compressed tarball. See README.md for details.
#
################################################################################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

source $here/../config/centos7.cfg

containerName=centos7-streams$streamsVersion-dev

tarballFilename=DockerContainer.$containerName.tar.gz

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# import container from a compressed tarball

step "importing container from a compressed tarball $tarballFilename ..."
gunzip -c $tarballFilename | docker import || die "sorry, could not decompress and import '$tarballFilename', $?"
echo "imported container from $tarballFilename"

exit 0

