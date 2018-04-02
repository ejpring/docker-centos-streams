#!/bin/bash

# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

##### load global definitions #####

[ -f /etc/bashrc ] && source /etc/bashrc

##### set process limits for InfoSphere Streams #####

ulimit -Su 10000
ulimit -Hu 10000

##### set InfoSphere Streams environment variables #####

[[ -d /opt/ibm/InfoSphere_Streams ]] && export STREAMS_INSTALL=/opt/ibm/InfoSphere_Streams/$( ls /opt/ibm/InfoSphere_Streams | grep -v var )
[[ -x $STREAMS_INSTALL/bin/streamsprofile.sh ]] && source $STREAMS_INSTALL/bin/streamsprofile.sh -s

##### set Java environment variables #####

[[ -d $STREAMS_INSTALL/java ]] && export JAVA_HOME=$STREAMS_INSTALL/java
[[ -d $JAVA_HOME/bin ]] && export PATH=$JAVA_HOME/bin:$PATH

##### set Ant and Maven environment variable #####

export ANT_HOME=/usr/share/apache-ant-1.9.2
export M2_HOME=/usr/share/apache-maven-3.0.5
export PATH=$ANT_HOME/bin:$M2_HOME/bin:$PATH

##### set Linux environment variables #####

export LANG=en_US.UTF-8
export EDITOR=emacs
export PATH=.:$HOME/bin:$PATH
export TZ=America/New_York


