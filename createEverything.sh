#!/bin/bash

# Copyright (C) 2018  International Business Machines Corporation
# All Rights Reserved

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

################### functions used in this script #############################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################################################################################

here=$( cd ${0%/*} ; pwd )

$here/centos7-base/createDockerImage.sh || die "sorry, could not create centos7-base image"
$here/centos7-base/createDockerContainer.sh || die "sorry, could not create centos7-base container"
$here/centos7-base/createStreamsSubsets.sh || die "sorry, could not create Streams subsets"

$here/centos7-streams42-dev/createDockerImage.sh || die "sorry, could not create centos7-streams42-dev image"
$here/centos7-streams42-dev/createDockerContainer.sh || die "sorry, could not create centos7-streams42-dev container"
$here/centos7-streams42-dev/exportDockerContainer.sh || die "sorry, could not export centos7-streams42-dev container"

$here/centos7-streams42-bld/createDockerImage.sh || die "sorry, could not create centos7-streams42-bld image"

$here/centos7-streams42-run/createDockerImage.sh || die "sorry, could not create centos7-streams42-run image"

$here/samples/SampleStreamsApplication/buildStreamsApplication.sh || die "sorry, could not build sample Streams application"
$here/samples/SampleStreamsApplication/runStreamsApplication.sh || die "sorry, could not run sample Streams application"

step "Done."
exit 0
