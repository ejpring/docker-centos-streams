#!/bin/bash

## Copyright (C) 2016, 2018  International Business Machines Corporation
## All Rights Reserved

################### functions used in this script #############################

die() { echo ; echo -e "\e[1;31m$*\e[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\e[1;34m$*\e[0m" ; }

################### parameters used in this script ############################

streamsSubsetPackageServer=$1
[[ -n $streamsSubsetPackageServer ]] || die "sorry, no Streams subset package server link specified"

STREAMS_INSTALL=/opt/ibm/InfoSphere_Streams/$( ls /opt/ibm/InfoSphere_Streams | grep -v var )
[[ -d $STREAMS_INSTALL/bin ]] || die "sorry, Streams not found in /opt/ibm/InfoSphere_Streams" 

# determine which release of CentOS is running

osRelease=$( cat /etc/redhat-release | perl -n -e 'm/CentOS .* release (6|7)\./; print $1' )
[[ -n $osRelease ]] || die "sorry, not sure which release of CentOS is running"
osRelease=$osRelease

# determine which release of Streams is installed

streamsRelease=$( echo $STREAMS_INSTALL | perl -n -e ' s/\.//g; m/\/([0-9]+)$/; print $1' )
[[ -n $streamsRelease ]] || die "sorry, not sure which release of Streams this is"

package=/tmp/StreamsSubset.centos$osRelease-streams$streamsRelease-dev.tar.gz

inclusions=(
    $STREAMS_INSTALL
)

exclusions=(
    --exclude=$STREAMS_INSTALL/install/tar/*.tgz
    --exclude=$STREAMS_INSTALL/StreamsDomainHost/* 
    --exclude=$STREAMS_INSTALL/etc/eclipse/* 
    --exclude=$STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio-Win.zip 
    --exclude=$STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio.tar.gz
)

################################################################################

step "packing development subset of $STREAMS_INSTALL into $package ..."
[[ ! -f $package ]] || sudo rm -f $package || die "sorry, could not delete old package $package, $?"
sudo tar -cpzf $package ${exclusions[*]} ${inclusions[*]} || die "sorry, could not create package $package, $?"

step "copying package $package to $streamsSubsetPackageServer .."
scp -p $package $streamsSubsetPackageServer || die "sorry, could not copy package $package to $streamsSubsetPackageServer, $?"

step "deleting temporary package $package ..."
sudo rm -f $package || die "sorry, could not delete temporary $package, $?"

exit 0
