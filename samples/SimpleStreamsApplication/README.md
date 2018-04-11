Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved

## simple Streams application

This repository contains a simple IBM Streams application, plus scripts for compiling and running the application with Docker images that contain subsets of IBM Streams. The host directory containing the Streams application to be compiled and run is mounted from a directory in the host computer's file system.


### prepare Streams subsets

The Docker images need only subsets of the Streams product to compile and run applications. These images must be prepared in advance and stored on an HTTP server accessible by Docker. To prepare the images, please see the instructions in the ['centos7-base' directory](../../centos7-base) directory.


### install Docker

Install [Docker for Windows](https://docs.docker.com/windows/) or [Docker for Mac](https://docs.docker.com/mac/) (and see [Docker on Windows](https://developer.ibm.com/bluemix/2015/04/16/installing-docker-windows-fixes-common-problems/) for help with common problems, if needed).


### load the images

If the Streams subset images for compiling and running Streams applications are not aleady in Docker, you can load them from a network server by executing these commands:

    curl http://servername/directoryname/DockerImage.centos7-streams42-bld.tar.gz | docker load

    curl http://servername/directoryname/DockerImage.centos7-streams42-run.tar.gz | docker load


### compile the sample application

To compile a Streams application, you will need to create a Docker image that contains the Streams compiler. To do that, follow the instructions for [creating a 'centos7-streams42-bld' image](../../centos7-streams42-bld).

After creating the Docker image, before compiling the application, change the parameters in the build script to match your environment, as indicated by the comments at the top of the script:

    $HOME/git/docker-centos-streams/samples/SimpleStreamsApplication/buildStreamsApplication.sh


### run the sample application locally

To run a compiled Streams application locally, you will need to create a Docker image that contains the Streams runtime. To do that, follow the instructions for [creating a 'centos7-streams42-run' image](../../centos7-streams42-run).

After creating the Docker image, before running the application, change the parameters in the run script to match your environment, as indicated by the comments at the top of the script:

    $HOME/git/docker-centos-streams/samples/SimpleStreamsApplication/runStreamsApplication.sh


### run the sample application on IBM Cloud

Alternatively, you can create a Streaming Analytics service on IBM Cloud to run Streams applications remotely. See [Getting Started with Streaming Analytics](https://console.bluemix.net/docs/services/StreamingAnalytics/) for an introduction.

To create a Streaming Analytics service, go to your [IBM Cloud dashboard](https://console.bluemix.net/dashboard/apps) and click 'Create Resource'. Search for 'Streaming Analytics', click on it, select the 'Beta - enhanced' plan, and click 'Create'.

To use your Streaming Analytics service from outside IBM Cloud, you will need to get credentials for it and store them locally. To create credentials, go to your [IBM Cloud dashboard](https://console.bluemix.net/dashboard/apps) again and click on your service, then click on 'Service Credentials', then click on 'New Credentials'. Fill in the form and click 'Add', then click on 'View Credentials', then click the 'copy to clipboard' icon.  Then use any text editor to open the file ['vcap-template.json'](./cloud/vcap-template.json) in this directory', fill it in as indicated by the comments, and save the file as 'vcap.json' in this directory.

The service can be managed remotely via the [Streaming Analytics REST API](https://console.bluemix.net/apidocs/220-streaming-analytics). If you have installed Python version 3, you  can install [IBM Streams Python support](http://ibmstreams.github.io/streamsx.topology/doc/releases/1.9/pythondoc/) by executing this command:

    pip install streamsx==1.9.0a2

Then, use these scripts in the ['cloud' subdirectory](./cloud) at a command prompt to manage your Streaming Analytics service:

* [python3 startStreamsService.py](./cloud/startStreamsService.py) starts the Streaming Analytics service

* [python3 checkStreamsService.py](./cloud/checkStreamsService.py) displays the current status of the service 

* [python3 submitStreamsApplication.py](./cloud/submitStreamsApplication.py) submits the compiled Streams application to run in the service

* [python3 retrieveStreamsJobLogs.py](./cloud/retrieveStreamsJobLogs.py) stores the logs of jobs running the application in compressed 'tar' archives

* [python3 cancelStreamsJobs.py](./cloud/cancelStreamsJobs.py) cancels any jobs running the submitted application

* [python3 stopStreamsService.py](./cloud/stopStreamsService.py) stops the service after canceling any running jobs



