Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## Docker image 'centos7-streams42-run'

This repository contains a Dockerfile and associated scripts, intended for use with [Docker](https://www.docker.com/). It creates an image for running [IBM Streams](http://ibmstreams.github.io/) applications, consisting of:

* a runtime subset of **IBM Streams release 4.2**
* CentOS release 7
* Java 1.8

The host directory containing the Streams Application Bundle (SAB file) to run is mounted from a directory in the host computer's file system.

To build the image, Docker will need access to an HTTP server where subsets of IBM Streams have been stored. See ['centos7-base'](../centos7-base) for instructions on preparing subsets of IBM Streams.

Building the image will take about XXX minutes with a fast network connection. It will be about 735 MB in size.


### prepare Streams subsets

The iamge will need only a subset of the Streams product to run applications. This subset must be prepared in advance and stored on an HTTP server accessible by Docker. To prepare Streams subsets, please see the instructions in the ['centos7-base' directory](../centos7-base).


### install Docker

Install [Docker for Windows](https://docs.docker.com/windows/) or [Docker for Mac](https://docs.docker.com/mac/) (and see [Docker on Windows](https://developer.ibm.com/bluemix/2015/04/16/installing-docker-windows-fixes-common-problems/) for help with common problems, if needed).


### create an image

Clone or download the 'git' repository ['docker-centos-streams'](https://github.com/ejpring/docker-centos-streams).

Before creating the image, change the parameters in this configuration file to match your environment:

    $HOME/git/docker-centos-streams/config/centos7.cfg

Then, to create the image, execute this script:

    $HOME/git/docker-centos-streams/centos7-streams42-run/createDockerImage.sh

The image includes these accounts:

* '**streamsadmin**' is an administrator account for Streams. This account owns the Streams product files, but is not otherwise used.

* '**streamsrun**' is a user account for Streams. This account is used for running Streams applications.

* '**root**' is the Linux 'superuser' account. 

All passwords in the container are initially set to 'password'.

The container has this external connection point:

* The /home/streamsrun/bundle directory is mounted from the host computer's file system


### use the image

After creating the image, use it to run Streams Application Bundles (SAB files). For an example of how to do this, see the [SampleStreamsApplication directory](../../samples/SampleStreamsApplication).

The compiler produces Streams Application Bundles, which are SAB files stored in the 'output' subdirectory of the application directory. The ['centos7-streams42-bld' image](../centos7-streams42-bld) can be used to compile Streams applications.

