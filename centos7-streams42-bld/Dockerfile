# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This Dockerfile builds an image containing CentOS 7 and a subset of Streams 4.2
# suitable for compiling Streams applications to be deployed elsewhere.  See the
# README.md file for instructions on creating and using this image.
#
################################################################################


# start with a basic CentOS 7 image from the CentOS project

FROM centos:centos7

# define arguments passed from 'docker build' command

ARG ROOT_PASSWORD
ARG ADMIN_PASSWORD
ARG STREAMS_SUBSET_PACKAGE

# update RPMs in base package to current versions, but preserve the locales from the base image

RUN cp -p /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.original && \
    yum -y update && \
    yum clean all && \
    mv /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.updated && \
    cp -p /usr/lib/locale/locale-archive.original /usr/lib/locale/locale-archive

# install the some Linux tools and utilities and libraries

RUN yum -y groupinstall emacs && \
    yum -y install sudo which wget curl xdg-utils bind-utils net-tools openssh-clients openssh-server git gcc gcc-c++ initscripts perl-XML-Simple && \
    yum -y install openssl-devel curl-devel libcurl-devel bzip2-devel libmicrohttpd-devel zlib-devel numactl-libs numactl-devel && \
    yum clean all

# enable SSH login access via TCP port 22

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN mkdir /var/run/sshd
EXPOSE 22

# make 'ping' run as root so it can open sockets in 'raw' mode

RUN chmod 4755 /bin/ping

# install Ant and Maven 

RUN curl -s http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.2-bin.tar.gz | tar -xz -C /usr/share
RUN curl -s https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz | tar -xz -C /usr/share

# set the 'root' account's initial password

RUN echo root:$ROOT_PASSWORD | chpasswd 

# create an account for Streams administration and set its initial password

RUN useradd streamsadmin && \
    chmod 0755 /home/streamsadmin && \
    echo streamsadmin:$ADMIN_PASSWORD | chpasswd  && \
    echo "streamsadmin ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

# put a .bashrc file in the home directory of the streamsadmin user account

ADD streamsadmin.bashrc /home/streamsadmin/.bashrc

# create a mount point for an application source directory in the streamsadmin user account

VOLUME /home/streamsadmin/application

# download and install a development subset of IBM Streams with either 'tar' or 'bsdtar'

RUN curl -s $STREAMS_SUBSET_PACKAGE | tar -xz -C / --owner=streamsadmin --group=streamsadmin
#RUN curl -s $STREAMS_SUBSET_PACKAGE | bsdtar -f - -x -z -C / --uname streamsadmin --gname streamsadmin

# by default, run a BASH shell under the 'streamsadmin' user account when this image is executed 

CMD ["/sbin/runuser", "-l", "streamsadmin"]


