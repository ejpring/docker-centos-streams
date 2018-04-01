#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################### functions used in this script #############################

die() { echo ; echo -e "\e[1;31m$*\e[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\e[1;34m$*\e[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

# this URL points at the HTTP directory where Streams install packages are stored

streamsInstallPackageLibraryURL=http://syss069.pok.stglabs.ibm.com/release

# uncomment one of the following lines to choose which release of Streams will be installed

#streamsInstallPackage=streams-4.2.0.0/Developer/eGA/Streams-DE-4.2.0.0-x86_64-el7.tar.gz
#streamsInstallPackage=streams-4.2.1.1/InstallBundles/el7/x86_64/IBMStreams-install.tar.gz-4.2.1-20170405.023755-14.tar.gz
#streamsInstallPackage=streams-4.2.1.2/Developer/fix/4.2.1.2-IM-Streams-DE-el7-x86_64-fp0002/Streams-4.2.1.2-x86_64-el7.tar.gz
#streamsInstallPackage=streams-4.2.1.3/Developer/fix/4.2.1.3-IM-Streams-DE-el7-x86_64-fp0003/Streams-4.2.1.3-x86_64-el7.tar.gz
#streamsInstallPackage=streams-4.2.2.0/Product/fix/4.2.2.0-IM-Streams-el7-x86_64-/Streams-4.2.2.0-x86_64-el7.tar.gz
#streamsInstallPackage=streams-4.2.4.0/streams.install-4.2.4.0-el7-20180105.172958-149.tar.gz
#streamsInstallPackage=streams-4.2.4.1/streams.install-4.2.4.1-el7-20180221.223417-23.tar.gz
streamsInstallPackage=streams-4.2.4.2/streams.install-4.2.4.2-20180315.195442-15.el7.tar.gz

# this link points at the SFTP directory where Streams subset packages will be stored

streamsSubsetPackageServer="pring@splanet02.watson.ibm.com:upload/StreamsSubsetPackages"

################################################################################

step "verifying Linux commands are available ..."
which sudo 1>/dev/null || die "sorry, 'sudo' command not found"
which scp 1>/dev/null || die "sorry, 'scp' command not found"
which wget 1>/dev/null || die "sorry, 'wget' command not found"
which tar 1>/dev/null || die "sorry, 'tar' command not found"

step "verifying 'sudo' privileges ..."

sudo whoami 1>/dev/null 2>/dev/null || die "sorry, 'sudo' privileges are not enabled"

step "verifying Streams install package is readable ..."

wget --spider $streamsInstallPackageLibraryURL/$streamsInstallPackage 1>/dev/null 2>/dev/null || die "sorry, could not read Stream install package $streamsInstallPackageLibraryURL/$streamsInstallPackage"

step "verifying Streams subset package server is writeable ..."

timestampFilename=StreamsSubset.timestamp
date "+%Y-%m-%d %H:%M:%S" >/tmp/$timestampFilename || die "sorry, could not create /tmp/$timestampFilename"
scp -p /tmp/$timestampFilename $streamsSubsetPackageServer/$timestampFilename || die "sorry, could not write to Streams subset package server $streamsSubsetPackageServer"
rm /tmp/$timestampFilename || die "sorry, could not erase /tmp/$timestampFilename"

step "installing Streams from $streamsInstallPackageLibraryURL/$streamsInstallPackage ..."

$here/script/installStreamsProduct.sh $streamsInstallPackageLibraryURL/$streamsInstallPackage || exit $?

step "storing Streams subsets at $streamsSubsetPackageServer ..."

$here/script/prepareStreamsDevelopmentSubset.sh $streamsSubsetPackageServer || exit $?
$here/script/prepareStreamsBuildSubset.sh $streamsSubsetPackageServer || exit $?
$here/script/prepareStreamsRuntimeSubset.sh $streamsSubsetPackageServer || exit $?

step "Done."

exit $?
