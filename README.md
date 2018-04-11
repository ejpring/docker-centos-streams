Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## IBM Streams for Docker

[Docker](https://www.docker.com/) allows [IBM Streams](http://ibmstreams.github.io/) applications to be developed, compiled, and run on machines that Streams does not support natively, including Windows and MacOS machines, and Linux distributions other than [RHEL](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)/[CentOS](https://www.centos.org/). Applications developed in Docker containers can also run in the [Streaming Analytics service](https://www.ibm.com/cloud/streaming-analytics) on [IBM Cloud](https://www.ibm.com/cloud/).

This repository contains [Dockerfiles](https://docs.docker.com/engine/reference/builder/) and associated scripts that create Docker images with subsets of IBM Streams. Three separate subsets of IBM Streams can be created:

* [centos7-streams42-dev](./centos7-streams42-dev) creates an image for application development (5.3 GB)
* [centos7-streams42-bld](./centos7-streams42-bld) creates an image for compiling applications (1.75 GB)
* [centos7-streams42-run](./centos7-streams42-run) creates an image for running applications (735 MB)

The scripts pack images into compressed tarballs and store them on a network server:

* 'DockerImage.centos7-streams42-dev.tar.gz' contains the application development image (2.8 GB)
* 'DockerImage.centos7-streams42-bld.tar.gz' contains the compile-only image (822 MB)
* 'DockerImage.centos7-streams42-run.tar.gz' contains the runtime-only image (348 GB)

All of the Docker images can be automatically created and stored from a Streams install package by executing this script, which takes about two hours:

* ['createEverything.sh' script](./createEverything.sh)

The scripts need access a network server via HTTP and SFTP, as specified in this configuration file:

* ['centos7.cfg' file](./config/centos7.cfg)

The ['centos7-streams42-dev' image](./centos7-streams42-dev) has a full Streams application development environment that can be used like a virtual machine or remote server. It has an Xfce desktop that can be accessed via VNC if you prefer GIU development tools, or you can log into it via SSH if you prefer command-line tools. For an example of how to develop Streams applications in this way, see:

* [Streams development container](./samples/StreamsDevelopmentContainer)

Alternatively, the ['centos7-streams42-bld'](./centos7-streams42-dev) and ['centos7-streams42-run'](./centos7-streams42-dev) images can be used to compile and run Streams applications without logging into a container. For an example of how to develop Streams applications in this way, see:

* [compile a Streams application with Docker](./samples/SimpleStreamsApplication#compile-the-sample-application)

* [run a Streams application with Docker](./samples/SimpleStreamsApplication#run-the-sample-application-locally)

You can also run Streams applications remotely in the [Streaming Analytics service](https://console.bluemix.net/docs/services/StreamingAnalytics/) on [IBM Cloud](https://www.ibm.com/cloud/). For an example of running a compiled Streams application on IBM Cloud, see:

* [run a Streams application on IBM Cloud](./samples/SimpleStreamsApplication#run-the-sample-application-on-ibm-cloud)