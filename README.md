Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## IBM Streams for Docker

Docker allows IBM Streams applications to be developed, compiled, and run on machines that Streams does not support natively, including Windows and MacOS machines, and Linux distributions other than RHEL/CentOS. This repository contains Dockerfiles and associated scripts that create Docker images and containers with IBM Streams.

To minimize their size, three separate Dockerfiles containing subsets of IBM Streams can be created:

* [centos7-streams42-dev](centos7-streams42-dev) creates a container for application development (5.3GB)
* [centos7-streams42-bld](centos7-streams42-bld) creates an image for compiling applications (1.75GB)
* [centos7-streams42-run](centos7-streams42-run) creates an image for running applications (735MB)

The subsets of Streams must be prepared before images and containers can be created. They can be created automatically from Streams install packages:

* [centos7-base](centos7-base) creates subsets of IBM Streams (1.9GB)

These Dockerfiles access a network server with HTTP and SFTP, as specified in this configuration file:

* [./config/centos7.cfg](./config/centos7.cfg)

The ['centos7-streams42-dev' container](centos7-streams42-dev) has a full Streams application development environment that can be used like a virtual machine or remote server. It has an Xfce desktop that can be accessed via VNC if you prefer GIU development tools, or you can log into it via SSH if you prefer command-line tools.

Alternatively, the ['centos7-streams42-bld'](centos7-streams42-dev) and ['centos7-streams42-run'](centos7-streams42-dev) images can be used to compile and run Streams applications without logging into a container. For an example of how to develop Streams applications in this way, see:

* [sample Streams application](samples/SampleStreamsApplication)
