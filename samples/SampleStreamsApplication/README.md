Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved

## SampleStreamsApplication

This repository contains a simple IBM Streams application, plus scripts for compiling and running the application with Docker images that contain subsets of IBM Streams. The host directory containing the Streams application to be compiled and run is mounted from a directory in the host computer's file system.


### prepare Streams subsets

The Docker images need only subsets of the Streams product to compile and run applications. These subsets must be prepared in advance and stored on an HTTP server accessible by Docker. To prepare Streams subsets, please see the instructions in the ['centos7-base' directory](../../centos7-base).


### install Docker

Install [Docker for Windows](https://docs.docker.com/windows/) or [Docker for Mac](https://docs.docker.com/mac/) (and see [Docker on Windows](https://developer.ibm.com/bluemix/2015/04/16/installing-docker-windows-fixes-common-problems/) for help with common problems, if needed).


### compile the sample application

To compile a Streams application, you will need to create a Docker image that contains the Streams compiler. To do that, follow the instructions for [creating a 'centos7-streams42-bld' image](../../centos7-streams42-bld).

After creating the Docker image, before compiling the application, change the parameters in the build script to match your environment, as indicated by the comments at the top of the script:

    $HOME/git/docker-centos-streams/samples/SampleStreamsApplication/buildStreamsApplication.sh


### run the sample application

To run a Streams application, you will need to create a Docker image that contains the Streams runtime. To do that, follow the instructions for [creating a 'centos7-streams42-run' image](../../centos7-streams42-run).

After creating the Docker image, before running the application, change the parameters in the run script to match your environment, as indicated by the comments at the top of the script:

    $HOME/git/docker-centos-streams/samples/SampleStreamsApplication/runStreamsApplication.sh


