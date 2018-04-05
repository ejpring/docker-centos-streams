Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## IBM Streams for Docker

Docker allows IBM Streams applications to be developed, compiled, and run on machines that Streams does not support natively, including Windows and MacOS machines, and Linux distributions other than RHEL/CentOS. This repository contains Dockerfiles and associated scripts that create Docker images and containers with IBM Streams.

To minimize their size, three separate Dockerfiles containing subsets of IBM Streams can be created:

* [centos7-streams42-dev](centos7-streams42-dev) creates an image for application development (5.3 GB)
* [centos7-streams42-bld](centos7-streams42-bld) creates an image for compiling applications (1.75 GB)
* [centos7-streams42-run](centos7-streams42-run) creates an image for running applications (735 MB)

These images can be packed into compressed tarballs for distribution on a network server:

* 'DockerImage.centos7-streams42-dev.tar.gz' contains the application development image (2.8 GB)
* 'DockerImage.centos7-streams42-bld.tar.gz' contains the compiler image (822 MB)
* 'DockerImage.centos7-streams42-run.tar.gz' contains the runtime image (348 GB)

The Streams subsets and Docker images can be created automatically from Streams install packages:

* [centos7-base](centos7-base) Dockerfiles and scripts that create Streams subsets and Docker images (1.9 GB)

These Dockerfiles access a network server with HTTP and SFTP, as specified in this configuration file:

* [./config/centos7.cfg](./config/centos7.cfg)

The ['centos7-streams42-dev' image](centos7-streams42-dev) has a full Streams application development environment that can be used like a virtual machine or remote server. It has an Xfce desktop that can be accessed via VNC if you prefer GIU development tools, or you can log into it via SSH if you prefer command-line tools. For an example of how to develop Streams applications in this way, see:

* [Streams development container](samples/StreamsDevelopmentContainer)

Alternatively, the ['centos7-streams42-bld'](centos7-streams42-dev) and ['centos7-streams42-run'](centos7-streams42-dev) images can be used to compile and run Streams applications without logging into a container. For an example of how to develop Streams applications in this way, see:

* [simple Streams application](samples/SimpleStreamsApplication)
