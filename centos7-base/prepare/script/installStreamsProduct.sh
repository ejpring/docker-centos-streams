#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################### parameters used in this script ##############################

streamsInstallURL=$1
[[ -n $streamsInstallURL ]] || die "sorry, no Streams install package library URL specified"

here=$( cd ${0%/*} ; pwd )

streamsInstallProperties=$here/IBMStreamsSetup.properties

streamsStudioIni=$here/streamsStudio.ini

streamsStudioPassword=password

eclipseEGitInstallURL=http://download.eclipse.org/egit/updates

eclipseEGitInstallIUs=org.eclipse.egit.feature.group,org.eclipse.jgit.feature.group

################### functions used in this script #############################

die() { echo ; echo -e "\e[1;31m$*\e[0m" >&2 ; exit 1 ; }
step() { echo ; echo -e "\e[1;34m$*\e[0m" ; }

################################################################################

[[ -d /opt/ibm/InfoSphere_Streams ]] && echo "Streams is already installed in /opt/ibm/InfoSphere_Streams" && exit 0

step "downloading and unpacking Streams install package from $streamsInstallURL ..."
[[ ! -d /tmp/StreamsInstallFiles ]] || sudo rm -rf /tmp/StreamsInstallFiles || die "sorry, could not delete old Streams installer, $?"
( wget -q -O- $streamsInstallURL | tar -xz -C /tmp ) || die "sorry, could not download and unpack $streamsInstallURL, $?"

step "installing Streams in /opt/ibm/InfoSphere_Stream with $streamsInstallProperties ..."
sudo $( ls /tmp/StreamsInstallFiles/*.bin ) -f $streamsInstallProperties || [[ $? -lt 2 ]] || die "sorry, could not install Streams, $?"
sudo rm -rf /tmp/StreamsInstallFiles || die "sorry, could not delete Streams installer, $?"

step "checking Streams install directory ..."
STREAMS_INSTALL=/opt/ibm/InfoSphere_Streams/$( ls /opt/ibm/InfoSphere_Streams | grep -v var )
[[ -x $STREAMS_INSTALL/bin/streamsprofile.sh ]] || die "sorry, Streams not installed properly in $STREAMS_INSTALL, $?"

step "unpacking Streams Studio ..."
sudo tar -xf $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio.tar.gz -C $STREAMS_INSTALL/etc/StreamsStudio || die "sorry, could not unpack Streams Studio, $?"
sudo rm -f $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio.tar.gz $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio-Win.zip 

step "installing Eclipse EGit in Streams Studio ..."
sudo $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio/streamsStudio -application org.eclipse.equinox.p2.director -noSplash -repository $eclipseEGitInstallURL -installIUs $eclipseEGitInstallIUs || die "sorry, could not install EGit in Streams Studio, $?"

step "patching Streams Studio configuration file with $streamsStudioIni ..."
sudo mv $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio/streamsStudio.ini $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio/streamsStudio.ini-original || die "sorry, could not rename old streamsStudio.ini file, $?"
sudo cp $streamsStudioIni $STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio/streamsStudio.ini || die "sorry, could not create new streamsStudio.ini file, $?"
sudo bash -c "echo $streamsStudioPassword >$STREAMS_INSTALL/etc/StreamsStudio/StreamsStudio/streamsStudio.password" || die "sorry, could not create streamsStudio.password file, $?"

step "setting ownership of Streams files ..."
sudo chown -Rh streamsadmin:streamsadmin $STREAMS_INSTALL/etc/StreamsStudio || die "sorry, could not set ownership for Streams files, $?"

exit 0
