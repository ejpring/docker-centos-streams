Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## Docker image 'centos7-streams42-bld'

This repository contains a Dockerfile and associated scripts, intended for use with [Docker](https://www.docker.com/). It creates an image for compiling [IBM Streams](http://ibmstreams.github.io/) applications, consisting of:

* a build subset of **IBM Streams release 4.2**
* CentOS release 7
* Java 1.8
* an SSH server
* some open-source libraries

The host directory containing the Streams application to be compiled is mounted from a directory in the host computer's file system.

To build the image, Docker will need access to an HTTP server where subsets of IBM Streams have been stored. See ['centos7-base'](../centos7-base) for instructions on preparing subsets of IBM Streams.

Building the image will take about six minutes with a fast network connection. It will be about 1.75 GB in size.


### prepare Streams subsets

The image will need only a subset of the Streams product to compile applications. This subset must be prepared in advance and stored on an HTTP server accessible by Docker. To prepare Streams subsets, please see the instructions in the ['centos7-base' directory](../centos7-base).


### install Docker

Install [Docker for Windows](https://docs.docker.com/windows/) or [Docker for Mac](https://docs.docker.com/mac/) (and see [Docker on Windows](https://developer.ibm.com/bluemix/2015/04/16/installing-docker-windows-fixes-common-problems/) for help with common problems, if needed).


### create an image

Clone or download the 'git' repository ['docker-centos-streams'](https://github.com/ejpring/docker-centos-streams).

Before creating the image, change the parameters in this configuration file to match your environment:

    $HOME/git/docker-centos-streams/config/centos7.cfg

Then, to create the image, execute this script:

    $HOME/git/docker-centos-streams/centos7-streams42-bld/createDockerImage.sh

The image includes these accounts:

* '**streamsadmin**' is an administrator account for Streams. This account is used for compiling Streams applications.

* '**root**' is the Linux 'superuser' account. The 'streamsadmin' account has unrestricted 'sudo' privileges, so it is not necessary to use the 'root' account.

All passwords in the container are initially set to 'password'.

The container has these external connection points:

* TCP port 2222 is exposed for logging into the container via SSH
* The /home/streamsadmin/application directory is mounted from the host computer's file system


### use the image

After creating the image, use it to compile Streams applications. For an example of how to do this, see the [SampleStreamsApplication directory](../../samples/SampleStreamsApplication).

The compiler produces Streams Application Bundles, which are SAB files stored in the 'output' subdirectory of the application directory. The ['centos7-streams42-run' image](../centos7-streams42-run) can be used to run SAB bundles.


### use the image on another machine

If you want to use the image on another machine, you can store it as a compressed tarball on a network server by executing this script:

    $HOME/git/docker-centos-streams/centos7-streams42-bld/storeDockerImage.sh

The 'DockerImage.centos7-streams42-bld.tar.gz' file produced by this script contains the image produced by the 'createDockerImage.sh' script. It can be loaded from a network server on another machine like this:

    curl http://splanet02.watson.ibm.com:8080/upload/StreamsSubsetPackages/DockerImage.centos7-streams42-bld.tar.gz | docker load
