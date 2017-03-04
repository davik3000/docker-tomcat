# Apache Tomcat 8.5.6 (with Oracle JDK 1.7.79) Docker image #
================================

It will create a CentOS 7 based image with a vanilla installation of Apache Tomcat 9.5.6 and Oracle JDK 1.7.79.

## Pre-requirement ##

Prior to build the image, copy the installer files under this folder:

    ./sw/apache-tomcat-8.5.6.tar.gz
    ./sw/jdk-7u79-linux-x64.tar.gz

## Build the container image ##

Execute the script `build.sh`. If available, it will load and apply the current proxy settings to the docker image.

It's possible to specify a custom image name as first argument, otherwise the default will be used.

    # ./build.sh <myImageName>
    + Using image name: <myImageName>
    ...

### Default image name ###

`davik3000/docker/tomcat`

### Exposed ports: ###

`8005`

## Create (run) a docker container ##

If not already present, it's a best practice to use a common private network between your containers, so run this command:

    # docker network create inetwork 

After that, you can choose to run the container in detached or interactive mode.

### Detached mode: -d ###
    # ID=<hostname>; docker run -d --name ${ID} -h ${ID} --network inetwork -P <image name>

### TTY interactive mode: -ti ###
    # ID=<hostname>; docker run -ti --name ${ID} -h ${ID} --network inetwork -P <image name>


Note:
Replace `<hostname>` value with a valid hostname. Remember that, if not specified, the docker daemon create a random *name* and a random *hostname*.
Use the `-n` and `-h` options to specify yours.

The `-P` option automatically creates random port numbers to bind the exposed image port numbers.

### Share/Persist data through Volumes ###

You can specify, with `-v` option, a volume to share with the container.

    # docker run -ti -v <host volume name>:<container mount point> [...]

Note:
With `<host volume name>` Docker will create a persistent volume inside its installation folder (usually at `/var/lib/docker/volumes`).

If `<host volume name>` is an absolute path of the host, Docker will share this folder with the container.

## Stop/Restart/Attach to an existing container ##

    # docker stop <container name or id>

    # docker start <container name or id>

    # docker attach <container name or id>

