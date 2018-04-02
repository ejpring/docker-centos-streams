# Copyright (C) 2016, 2018  International Business Machines Corporation
# All Rights Reserved

################################################################################
#
# This Dockerfile builds an image containing CentOS 7 and Streams 4.2
# suitable for Streams application development.  See the README.md file for
# instructions on creating and using this image.
#
################################################################################


# start with a basic CentOS image from the CentOS project

FROM centos:centos7

# define arguments passed from 'docker build' command

ARG ROOT_PASSWORD
ARG USER_PASSWORD
ARG ADMIN_PASSWORD
ARG VNC_GEOMETRY
ARG STREAMS_SUBSET_PACKAGE

# update RPMs in base package to current versions, but preserve the locales from the base image

RUN cp -p /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.original && \
    yum -y update && \
    yum clean all && \
    mv /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.updated && \
    cp -p /usr/lib/locale/locale-archive.original /usr/lib/locale/locale-archive

# install the X11 Window system, X fonts, the Xfce desktop, and lots of tools
# and utilities and development libraries

RUN yum -y install epel-release && \
    yum -y groupinstall development x11 xfce emacs && \
    yum -y install xorg-x11-fonts* xterm xdg-utils xfce4-cpugraph-plugin xfce4-netload-plugin && \
    yum -y install openssh-clients openssh-server tigervnc-server sudo wget curl gedit gvim git git-gui gitk file-roller ant maven bind-utils net-tools firefox perl-XML-Simple && \
    yum -y install jq nc wireshark-gnome pkgconfig cmake yasm pandoc bc python python-pip bsdtar && \
    yum -y install openssl-devel libpcap-devel curl-devel libcurl-devel bzip2-devel gtk2-devel jasper-devel libjpeg-devel libmicrohttpd-devel libpng-devel libsvm-devel libtiff-devel libv41-devel zlib-devel numactl-libs numactl-devel valgrind-devel libXpm-devel giflib-devel ncurses-devel && \
    yum clean all

# install Supervisord version 3 with 'setuptools'

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

# make 'ping' run as root so it can open sockets in 'raw' mode 
RUN chmod 4755 /bin/ping

# allow Wireshark to capture network traffic

RUN setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/sbin/dumpcap && \
    chown root /usr/sbin/dumpcap && \
    chmod u+s /usr/sbin/dumpcap

# install Python 3.5 from CentOS community repository

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python35u-3.5.2 python35u-pip python35u-devel && \
    yum clean all
RUN ln -sf /usr/bin/python3.5 /bin/python3 && \
    ln -sf /usr/bin/pip3.5 /bin/pip3 && \
    ln -sf /usr/bin/python3.5m-x86_64-config /bin/python3-config && \
    ln -sf /usr/bin/pyvenv-3.5 /bin/pyvenv3 && \
    ln -sf /usr/bin/pydoc3.5 /bin/pydoc3

# install Ant and Maven

RUN curl -s http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.2-bin.tar.gz | tar -xz -C /usr/share
RUN curl -s https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz | tar -xz -C /usr/share

# install 'kt' utility

RUN curl -s --location https://github.com/fgeller/kt/releases/download/v11.1.0/kt-v11.1.0-linux-amd64.txz | tar -xJ -C /usr/bin

# set the 'root' account's initial password

RUN echo root:$ROOT_PASSWORD | chpasswd 

# create an account for Streams administration and set its initial password

RUN useradd streamsadmin && \
    chmod 0755 /home/streamsadmin && \
    echo streamsadmin:$ADMIN_PASSWORD | chpasswd  && \
    echo "streamsadmin ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

# create a user account for Streams application development and set its initial
# password

RUN useradd streamsdev && \
    chmod 0755 /home/streamsdev && \
    echo streamsdev:$USER_PASSWORD | chpasswd && \
    echo "streamsdev ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

# create a mount point for the home directory of the streamsdev user account

VOLUME /home/streamsdev

# download and install a development subset of IBM Streams with either 'tar' or 'bsdtar'

RUN curl -s $STREAMS_SUBSET_PACKAGE | tar -xz -C / --owner=streamsadmin --group=streamsadmin
#RUN curl -s $STREAMS_SUBSET_PACKAGE | bsdtar -f - -x -z -C / --uname streamsadmin --gname streamsadmin

# expose HTTP and HTTPS ports for Streams Console

expose 8080
expose 8443

# run the 'supervisor' daemon as the root process in the container, instead of
# 'initd', configured to launch SSH and VNC daemons

ADD supervisord.conf /etc/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

