#!/bin/bash

# Copyright (C) 2018  International Business Machines Corporation
# All Rights Reserved

set -o pipefail

################################################################################
#
# This script imports a Docker container from a compressed tarball. See README.md for details.
#
################################################################################

die() { echo ; echo "$*" >&2 ; exit 1 ; }
step() { echo ; echo -e "$*" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

source $here/../config/centos7.cfg

tarballName=centos7-streams$streamsVersion-dev.tar.gz

###############################################################################

# make sure Docker is installed and running 

step "verifying Docker is available ..."
which docker 1>/dev/null || die "sorry, 'docker' command not found"
docker info 1>/dev/null || die "sorry, Docker is not running"

# import container from a compressed tarball

step "importing container from a compressed tarball ..."
gunzip -c $tarballName | docker import || die "sorry, could not decompress and import '$tarballName', $?"
echo "imported container from $tarballName.tar.gz"

exit 0

