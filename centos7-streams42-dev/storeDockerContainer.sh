#!/bin/bash

# Copyright (C) 2018  International Business Machines Corporation
# All Rights Reserved

set -o pipefail

################################################################################
#
# This script exports a Docker container to a compressed tarball. See README.md for details.
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

step "storing container $containerName on $streamsSubsetPackageServerSCP/$tarballFilename ..."
IFS=: read -a fields <<<"$streamsSubsetPackageServerSCP"
docker export $containerName | gzip -c | ssh -x ${fields[0]} "cat >${fields[1]}/$tarballFilename" || die "sorry, could not export containiner '$containerName', $?"
echo "$containerName exported to $streamsSubsetPackageServerSCP/$tarballFilename"

exit 0



step "exporting container $containerName to a compressed tarball ..."
docker export $containerName | gzip >$tarballFilename || die "sorry, could not export and compress containiner '$containerName', $?"
echo "exported container $containerName to $tarballFilename"

step "copying compressed tarball $tarballFilename to $streamsSubsetPackageServerSCP ..."
scp -p $tarballFilename $streamsSubsetPackageServerSCP || die "sorry, could not copy compressed tarball $tarballFilename to $streamsSubsetPackageServer, $?"

step "deleting temporary compressed tarball $tarballFilename ..."
rm $tarballFilename || die "sorry, could not delete $tarballFilename"

exit 0

