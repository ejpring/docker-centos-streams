#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################### functions used in this script #############################

die() { echo ; echo -e "\e[1;31m$*\e[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\e[1;34m$*\e[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

source $HOME/config/centos7.cfg

################################################################################

step "verifying Linux commands are available ..."
which sudo 1>/dev/null || die "sorry, 'sudo' command not found"
which scp 1>/dev/null || die "sorry, 'scp' command not found"
which wget 1>/dev/null || die "sorry, 'wget' command not found"
which tar 1>/dev/null || die "sorry, 'tar' command not found"

step "verifying 'sudo' privileges ..."

sudo whoami 1>/dev/null 2>/dev/null || die "sorry, 'sudo' privileges are not enabled"

step "verifying Streams install package is readable ..."

wget --spider $streamsInstallPackageServerURL/$streamsInstallPackage 1>/dev/null 2>/dev/null || die "sorry, could not read Stream install package $streamsInstallPackageLibraryURL/$streamsInstallPackage"

step "verifying Streams subset package server is writeable ..."

timestampFilename=StreamsSubset.timestamp
date "+%Y-%m-%d %H:%M:%S" >/tmp/$timestampFilename || die "sorry, could not create /tmp/$timestampFilename"
scp -p /tmp/$timestampFilename $streamsSubsetPackageServerSCP/$timestampFilename || die "sorry, could not write to Streams subset package server $streamsSubsetPackageServer"
rm /tmp/$timestampFilename || die "sorry, could not erase /tmp/$timestampFilename"

step "installing Streams from $streamsInstallPackageServerURL/$streamsInstallPackage ..."

$here/script/installStreamsProduct.sh $streamsInstallPackageServerURL/$streamsInstallPackage || exit $?

step "storing Streams subsets at $streamsSubsetPackageServer ..."

$here/script/prepareStreamsDevelopmentSubset.sh $streamsSubsetPackageServerSCP || exit $?
$here/script/prepareStreamsBuildSubset.sh $streamsSubsetPackageServerSCP || exit $?
$here/script/prepareStreamsRuntimeSubset.sh $streamsSubsetPackageServerSCP || exit $?

step "Done."

exit $?
