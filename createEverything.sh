#!/bin/bash

# Copyright (C) 2018  International Business Machines Corporation
# All Rights Reserved

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

################### functions used in this script #############################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################################################################################

set -e 

here=$( cd ${0%/*} ; pwd )

$here/centos7-base/createDockerImage.sh
$here/centos7-base/createDockerContainer.sh
$here/centos7-base/createStreamsSubsets.sh

$here/centos7-streams42-dev/createDockerImage.sh
$here/centos7-streams42-dev/storeDockerImage.sh

$here/centos7-streams42-bld/createDockerImage.sh
$here/centos7-streams42-bld/storeDockerImage.sh

$here/centos7-streams42-run/createDockerImage.sh
$here/centos7-streams42-run/storeDockerImage.sh

$here/samples/StreamsDevelopmentContainer/createDockerContainer.sh

$here/samples/SimpleStreamsApplication/buildStreamsApplication.sh
$here/samples/SimpleStreamsApplication/runStreamsApplication.sh

step "Done."
exit 0
