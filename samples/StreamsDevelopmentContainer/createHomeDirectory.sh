#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

set -o pipefail

################################################################################
#
# This script ..........
#
################################################################################

die() { echo ; echo -e "\033[1;31m$*\033[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\033[1;34m$*\033[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

homeDirectoryPackageURL=http://splanet02.watson.ibm.com:8080/upload/StreamsSubsetPackages/home.streamsdev.tar.gz

homeDirectory=$HOME/dockerhome.centos7

###############################################################################

# if the home directory does not already exist, create it

if [[ ! -d $homeDirectory/streamsdev ]] ; then
    step "creating 'streamsdev' home directory in $homeDirectory ..."
    mkdir -p $homeDirectory/streamsdev || die "sorry, could not create 'streamsdev' home directory, $?"
fi    

# if the home directory is empty, fill it with basic Linux and Xfce configuration files

if [[ ! -f $homeDirectory/streamsdev/.bashrc ]] ; then
    step "initializing 'streamsdev' home directory in $homeDirectory/streamsdev ..."
    curl $homeDirectoryPackageURL | tar -xzf - -C $homeDirectory/streamsdev || die "sorry, could not initialize 'streamsdev' home directory, $?"
fi

# if there is an SSH configuration available, copy it into the home directory

if [[ ! -d $homeDirectory/streamsdev/.ssh ]] && [[ -d $HOME/.ssh ]] ; then
    step "copying SSH configuration to 'streamsdev' home directory $homeDirectory/streamsdev/.ssh ..."
    cp -rp $HOME/.ssh $homeDirectory/streamsdev || die "sorry, could not copy SSH configuration to 'streamsdev' home directory, $?"
    cat $HOME/.ssh/*.pub >>$homeDirectory/streamsdev/.ssh/authorized_keys 2>/dev/null
    chmod 0600 $homeDirectory/streamsdev/.ssh/*
fi

exit 0

