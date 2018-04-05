#!/bin/bash

## Copyright (C) 2016, 2018  International Business Machines Corporation
## All Rights Reserved

set -o pipefail

################### functions used in this script #############################

die() { echo ; echo -e "\e[1;31m$*\e[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\e[1;34m$*\e[0m" ; }

################### parameters used in this script ############################

here=$( cd ${0%/*} ; pwd )

source $HOME/config/centos7.cfg

package=home.streamsdev.tar.gz

inclusions=(
    .bashrc
    .config
    .emacs
    .emacs.lisp
    .profile
    .toprc
    .vnc
    Desktop
    bin
    icons
)

exclusions=(
    --exclude='*~'
    --exclude='#*#'
    --exclude='*.log'
    --exclude='*.pid'
    --exclude='.DS_Store'
    --exclude='home.streamsdev.tar.gz'
)

################################################################################

step "packing directory $HOME into $streamsSubsetPackageServerSCP/$package ..."

cd $HOME || die "sorry, could not change to directory $HOME, $?"
IFS=: read -a fields <<<"$streamsSubsetPackageServerSCP"
tar -cpz ${exclusions[*]} ${inclusions[*]} | ssh -x ${fields[0]} "cat >${fields[1]}/$package" || die "sorry, could not create package $package, $?"
echo "packed directory $HOME into $streamsSubsetPackageServerSCP/$package"

exit 0



[[ ! -f $package ]] || rm -f $package || die "sorry, could not delete old package $package, $?"
cd $HOME || die "sorry, could not change to directory $HOME, $?"
tar -cpzf $here/$package ${exclusions[*]} ${inclusions[*]} || die "sorry, could not create package $package, $?"

exit 0
