Copyright &copy; 2016, 2017  International Business Machines Corporation
All Rights Reserved

## MyStreamsApplication

This repository contains a simple IBM Streams sample application, plus scripts for compiling and submitting the application to an IBM Bluemix Streaming Analytics service. 

The SPL source file for the sample application is [Main.spl](MyStreamsApplication/Main.spl).

To compile the application into a 'Streams application bundle' (a SAB file), you will need the IBM Streams compiler:

* If you are already using a Streams development environment, whether on a real machine, a virtual machine, or a Docker container, you can use the 'sc' command or the Streams Studio tools to compile the SPL source file into a SAB bundle.

* If you do not have a Streams development environment, you can create a Docker image containing the Streams compiler. See the ['centos6-streams4212-build'](https://github.ibm.com/pring/centos6-streams4212-build) repository for details.

To execute the application, you will need an IBM Streams runtime instance. If you already have a Streams development environment, you can use the 'streamtool' command or the Streams Studio tools to submit the SAB bundle to a runtime instance. Or, you can create a runtime instance in the IBM Bluemix Streaming Analytics service. See [Getting Started with Streaming Analytics](https://console.bluemix.net/docs/services/StreamingAnalytics/index.html) for details.


### MyStreamsApplication in an IBM Bluemix Streaming Analytics instance

In addition to the SPL source file [Main.spl](MyStreamsApplication/Main.spl), this repository contains scripts for running the application in an IBM Bluemix Streaming Analytics instance.

First, do this:

* Create a Streams runtime instance with the IBM Bluemix Streaming Analytics service. See the [Bluemix Streaming Analytics service dashboard](https://console.bluemix.net/dashboard/services).

* Store your credentials for the Bluemix Streaming Analytics service in a file named 'vcap.json' in the same directory as the scripts. This file must have a specific JSON structure, as shown on the ['Streaming Analytics service credentials page'](https://console.bluemix.net/docs/services/StreamingAnalytics/r_vcap_services.html#vcap_services). You can fill in the [VCAP template file](vcap-template.json) and then rename it to 'vcap.json'.

* If you do not have a Streams development environment, create a Docker image containing the Streams compiler. See the 
['centos6-streams4212-build'](https://github.ibm.com/pring/centos6-streams4212-build/blob/master/README.md)
repository for instructions.

Then, do either of these:

* If you have a Streams development environment, compile the sample application [Main.spl](MyStreamsApplication/Main.sp) into a SAB bundle with the [buildMyStreamsApplication.sh](buildMyStreamsApplication.sh) script.

* If you do not have a Streams development environment,
but you have created a Docker image containing the Streams compiler,
compile the sample application [Main.spl](MyStreamsApplication/Main.sp) into a SAB bundle with the [buildMyStreamsApplicationWithDocker.sh](buildMyStreamsApplicationWithDocker.sh) script.

Then, use these scripts at a command prompt:

* [python3 startStreamsService.py](startStreamsService.py) starts the Bluemix Streaming Analytics service

* [python3 checkStreamsService.py](checkStreamsService.py) displays the current status of the service 

* [buildMyStreamsApplication.sh](buildMyStreamsApplication.sh) compiles the SPL source code into a Streams Application Bundle (a SAB file) locally, using the Streams product installed in your real or virtual Linux machine

* [buildMyStreamsApplicationWithDocker.sh](buildMyStreamsApplicationWithDocker.sh) compiles the SPL source code into a Streams Application Bundle (a SAB file) locally, using the Streams product installed in a Docker container on your Windows or MacOS machine

* [python3 buildMyStreamsApplicationWithService.py](buildMyStreamsApplicationWithService.py) compiles the SPL source code into a Streams Application Bundle (a SAB file) remotely, using the Bluemix Streaming Analytics service

* [python3 submitStreamsApplication.py](submitStreamsApplication.py) submits the compiled SAB file to run in the service

* [python3 showStreamsOperatorMetrics.py](showStreamsOperatorMetrics.py) displays the current metrics of each of the application's operators

* [python3 storeStreamsJobLogs.py](storeStreamsJobLogs.py) stores the logs of jobs running the application in compressed 'tar' archives

* [python3 storeStreamsPELogs.py](storeStreamsPELogs.py) stores the console logs and application traces of processing elements (PEs) running the application in separate text files

* [python3 cancelStreamsJobs.py](cancelStreamsJobs.py) cancels any jobs running the submitted application

* [python3 stopStreamsService.py](stopStreamsService.py) stops the service after canceling any running jobs

These scripts use the [Streaming Analytics REST API](https://console.bluemix.net/apidocs/220-streaming-analytics).
