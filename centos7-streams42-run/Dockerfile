# Copyright (C) 2017, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This Dockerfile builds an image containing CentOS 7 and a subset of Streams
# 4.2 suitable for running standalone Streams applications compiled
# elsewhere.  See the README.md file for instructions on creating and using this
# image.
#
################################################################################

# start with a basic CentOS image from the CentOS project

FROM centos:centos7

# define arguments passed from 'docker build' command

ARG ROOT_PASSWORD
ARG STREAMS_SUBSET_PACKAGE

# install the Linux packages used below

RUN yum -y install curl bsdtar && \
    yum clean all

# set the 'root' account's initial password

RUN echo root:$ROOT_PASSWORD | chpasswd 

# create an administrator account for Streams product files

RUN useradd streamsadmin && \
    chmod 0755 /home/streamsadmin

# create a user account for running Streams applications

RUN useradd streamsrun && \
    chmod 0755 /home/streamsrun

# put a .bashrc file in the home directory of the streamsrun user account

ADD streamsrun.bashrc /home/streamsrun/.bashrc

# create a mount point for a Streams Application Bundle (SAB file) in the streamsrun user account

VOLUME /home/streamsrun/bundle

# download and install a runtime subset of IBM Streams with either 'tar' or 'bsdtar'

RUN curl -s $STREAMS_SUBSET_PACKAGE | tar -xz -C / --owner=streamsadmin --group=streamsadmin
#RUN curl -s $STREAMS_SUBSET_PACKAGE | bsdtar -f - -x -z -C / --uname streamsadmin --gname streamsadmin

# by default, run a BASH shell under the 'streamsrun' user account when this image is executed 

CMD ["/sbin/runuser", "-l", "streamsrun"]
