# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This Dockerfile builds an image containing CentOS 7 and the dependencies 
# of IBM Streams. It is useful for creating subsets of IBM Streams for 
# more specialized Docker images.
#
################################################################################


# start with a basic CentOS image from the CentOS project

FROM centos:centos7

# define arguments passed from 'docker build' command

ARG ROOT_PASSWORD
ARG USER_PASSWORD
ARG ADMIN_PASSWORD
ARG VNC_GEOMETRY

# update RPMs in base package to current versions, but preserve the locales from the base image

RUN cp -p /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.original && \
    yum -y update && \
    yum clean all && \
    mv /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.updated && \
    cp -p /usr/lib/locale/locale-archive.original /usr/lib/locale/locale-archive

# install the X11 Window system, X fonts, the Xfce desktop, and some tools
# and utilities and libraries that Streams depends upon

RUN yum -y install epel-release && \
    yum -y groupinstall development x11 xfce emacs && \
    yum -y install xorg-x11-fonts* xterm xdg-utils xfce4-cpugraph-plugin xfce4-netload-plugin && \
    yum -y install openssh-clients openssh-server tigervnc-server sudo wget curl gedit gvim git git-gui gitk file-roller ant maven bind-utils net-tools firefox perl-XML-Simple && \
    yum clean all

# install Supervisor version 3 with 'setuptools', not 'yum'

RUN yum -y install python-setuptools && \
    yum clean all && \
    easy_install supervisor

# allow SSH access via TCP port 22

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN mkdir /var/run/sshd
EXPOSE 22

#  allow VNC access via TCP port 5901

ENV VNC_GEOMETRY=$VNC_GEOMETRY
EXPOSE 5901

# assign a unique machine identifier for DBus

RUN /bin/dbus-uuidgen >/etc/machine-id && \
    mkdir -p /var/run/dbus

# set the 'root' account's initial password

RUN echo root:$ROOT_PASSWORD | chpasswd 

# make 'ping' run as root so it can open sockets in 'raw' mode 
RUN chmod 4755 /bin/ping

# create an account for Streams administration

RUN useradd streamsadmin && \
    chmod 0755 /home/streamsadmin && \
    echo streamsadmin:$ADMIN_PASSWORD | chpasswd

# create a user account for Streams application development and
# copy basic Linux and Xfce configuration files into it

RUN useradd streamsdev && \
    chmod 0755 /home/streamsdev && \
    echo streamsdev:$USER_PASSWORD | chpasswd && \
    echo "streamsdev ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
ADD --chown=streamsdev:streamsdev home.streamsdev.tar.gz /home/streamsdev

# create a mount point for scripts that prepare subsets of the IBM Streams product
VOLUME /home/streamsdev/prepare
VOLUME /home/streamsdev/.ssh

# run the 'supervisor' daemon as the root process instead of 'initd',
# configured to launch only the SSH and VNC daemons

ADD supervisord.conf /etc/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

