Copyright &copy; 2016, 2018  International Business Machines Corporation
All Rights Reserved


## Streams Development Container

This repository contains scripts that creates a [Docker container](https://www.docker.com/) for [IBM Streams](http://ibmstreams.github.io/) application development, consisting of:

* a development subset of **IBM Streams release 4.2**
* CentOS release 7
* Xfce desktop version 4
* Java 1.8
* Python 2.7 and 3.5
* servers for SSH and VNC access
* lots of open-source utilities, tools, and libraries

The container provides an Xfce desktop for those who prefer to develop applications with GUI tools, including Streams Studio, and also supports SSH access for those who prefer command-line tools. The host directory of the user account in the container is mounted from a directory in the host computer's file system, initialized with a basic Xfce configuration.

To build the container, Docker will need an image of a subset of IBM Streams suitable for application development. See the ['centos7-base' directory](../../centos7-base) directory for instructions on preparing images of IBM Streams.

The image for this container is named 'centos7-streams42-dev'. It is stored on a network server in a compressed tarball named 'DockerImage.centos7-streams42-dev.tar.gz', which is about 2.8 GB in size. You will need to download this image into Docker. After that, it takes only a few seconds to create a container, which will be about 5.3 GB in size.


### quick start procedure

The procedure for building the container is described in detail below, but if you are familiar with Docker, then you may want to follow this procedure to get started quickly:

* install [Docker](https://www.docker.com) and increase its processor and memory resources
* load a Docker image from a network server
* execute the 'createDockerContainer.sh' script
* execute the 'createHomeDirectory.sh' script 
* start the 'StreamsForDocker' container
* login to the container's Xfce desktop by connecting a VNC viewer to 'localhost:5901'
* or, login to the container's command line with 'ssh -p 2222 streamsdev@localhost'

All passwords in the container are initially set to 'password'.


### install Docker

Install [Docker for Windows](https://docs.docker.com/windows/) or [Docker for Mac](https://docs.docker.com/mac/) (and see [Docker on Windows](https://developer.ibm.com/bluemix/2015/04/16/installing-docker-windows-fixes-common-problems/) for help with common problems, if needed).

The default processor and memory resources Docker allocates may not be sufficient for Streams application development. If necessary, you can increse them with the Docker 'Preferences' panel, like this:

![Docker preferences->General panel](../../README.images/Docker-preferences-general-panel.png)


### load an image

The container will be created from an image named 'centos7-streams42-dev' that contains CentOS and a subset of IBM Streams suitable for application development. Instructions for creating the image are in the 'git' repository ['docker-centos-streams'](https://github.com/ejpring/docker-centos-streams).

After the 'centos7-streams42-dev' image has been created and saved on a network server, you can load it onto this machine by executing this command:

    curl http://servername/directoryname/DockerImage.centos7-streams4242-dev.tar.gz | docker load


### create a container

Clone or download the 'git' repository ['docker-centos-streams'](https://github.com/ejpring/docker-centos-streams).

Before creating the container, change the parameters in this script to match your environment:

    $HOME/git/docker-centos-streams/samples/StreamsDevelopmentContainer/createDockerContainer.sh

Then, to create the container, execute that script.

The container includes these accounts:

* '**streamsdev**' is a user account for developing Streams applications. Its home directory is mounted from the host computer's file system. It has an Xfce desktop that can be accessed via VNC and a command line that can be accessed via SSH (see 'accessing the container' below).

* '**streamsadmin**' is an administrator account for Streams. It owns the Streams product files, but is not otherwise used, so it is not necessary to login as 'streamsadmin'.

* '**root**' is the Linux 'superuser' account. The 'streamsdev' account has unrestricted 'sudo' privileges, so it is not necessary to login directly as 'root'.

All passwords in the container are initially set to 'password'.

The container has these external connection points:

* TCP port 2222 is exposed for logging into the container via SSH
* TCP port 5901 is exposed for connecting a VNC viewer to its Xfce desktop
* The initial VNC screen dimensions are set from the VNC_GEOMETRY environment variable
* The /home/streamsdev directory is mounted from the host computer's file system


### create a home directory 

The container will mount the home directory for the 'streamsdev' user account from a directory in the host computer's file system. 

To create a home directory for the 'streamsdev' user account, execute this script:

    $HOME/git/docker-centos-streams/samples/StreamsDevelopmentContainer/createHomeDirectory.sh

The script will create the directory $HOME/dockerhome.centos7/streamsdev, if it does not already exist, and initialize it with configuration files for Linux, the Xfce desktop, and SSH, if they do not already exist.


### start the container

After the container and home directory have been created, you can start the container by executing this command:

    docker start StreamsDevelopmentContainer

The home directory of the 'streamsdev' user account will be mounted from the '$HOME/dockerhome.centos7/streamsdev' directory in the host computer's file system. 

You can use the Xfce desktop of the 'streamsdev' user account by connecting a VNC viewer to the address 'localhost:1' or 'localhost:5901', depending on which viewer you use:

![VNC Viewer connect panel](../../README.images/VNC-Viewer-connect-panel.png)

Or, you can login to the 'streamsdev' user account with SSH by typing this command at a prompt in a Terminal window:

    ssh -p 2222 streamsdev@localhost

When you are finished with the container, You can stop it by executing this command:

    docker stop StreamsDevelopmentContainer

Whatever work you did in the container while it was running will be retained, and will be available in the container when you start it again. Any changes you made in the home directory of the 'streamsdev' user account are available after the container has stopped, in the directory $HOME/dockerhome.centos7/streamsdev created by the 'createHomeDirectory.sh' script.


### use the container

After starting the container and connecting a VNC viewer to its Xfce desktop, use the icons at the top of the desktop to launch common development tools:

![Xfce toolbar icons](../README.images/Xfce-toolbar-icons.png)

* the 'Display' icon changes the size of the Xfce desktop
* the 'Terminal' icon opens a Bash window with a command-line prompt
* the 'File Manager' icon opens a directory and file explorer
* the 'Gedit' icon opens the Gnome text editor
* the 'Firefox' icon opens the Firefox web browser
* the 'Emacs' icon opens the Gnu Emacs text editor
* the 'Wireshark' icon opens the Wireshark network analyzer tool
* the 'Streams Studio' icon opens the Eclipse development platform
* the 'top' icon opens the 'top' system status tool

There are also several utility scripts in the container that can be executed by opening a Terminal window and entering these commands at a prompt:

* **configureSSH.sh** creates SSH configuration files for the user account, if they do not already exist. Note that the 'createHomeDirectory.sh' script described above copies your SSH configuration, if you have one, from your laptop's file system into the user account's home directory. The 'configureSSH.sh' script is needed only if you do not already have an SSH configuration.

* **startStreamsInstance.sh** starts a Streams domain and instance, if they are not already running, after creating them, if they do not yet exist. The names are taken from the $STREAMS_DOMAIN_ID and $STEAMS_INSTANCE_ID environment variables, which by default are 'StreamsDomain' and 'StreamsInstance', respectively.

* **stopStreamsInstance.sh** stops the Streams domain and instance, if they are running.

* **removeStreamsInstance.sh** stops the Streams domain and instance, if they are running, and then removes them.

None of these scripts accept any arguments, but some of them have static parameters that can be changed by altering variables declared at the top of the script file.


### optionally install KDE desktop

If you prefer to use the KDE desktop instead of Xfce, you can install it in the container by executing this command in a Linux Terminal window at a command prompt:

    sudo yum group install kde

To switch from the Xfce desktop to KDE, edit the /home/streamsdev/.vnc/xstartup file and change the last line from "startxfce4 &" to "startkde &". Then stop the container and start it again.


### optionally install Mongo database

If you need the Mongo database, you can install it in the container by executing this command at a Linux Terminal window at a command prompt:

    sudo yum install mongodb python-pymongo php-pecl-mongo

