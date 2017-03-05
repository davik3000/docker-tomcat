#!/bin/bash

IMAGE_NAME="davik3000/docker/tomcat"
TOMCAT_VERSION=""
JDK_VERSION=""

BUILD_ARGS_PROXY=""
BUILD_ARGS_SW=""

BUILD_ARGS=""

### Functions ###
parseArgs() {
  if [ -n "$1" ] ; then
    IMAGE_NAME=$1
  fi
  echo "+ Using image name: ${IMAGE_NAME}"

  if [ -n "$2" ] ; then
    TOMCAT_VERSION=$2
  fi
  echo "+ Using Tomcat version: ${TOMCAT_VERSION}"

  if [ -n "$3" ] ; then
    JDK_VERSION=$3
  fi
  echo "+ Using JDK version: ${JDK_VERSION}"
}

apply_proxy_settings() {
  echo "+ Checking and applying proxy settings"

  # proxy settings
  if [ -n "${HTTP_PROXY}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg HTTP_PROXY=${HTTP_PROXY}"
  fi
  if [ -n "${http_proxy}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg http_proxy=${http_proxy}"
  fi

  if [ -n "${HTTPS_PROXY}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg HTTPS_PROXY=${HTTPS_PROXY}"
  fi
  if [ -n "${https_proxy}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg https_proxy=${https_proxy}"
  fi

  if [ -n "${FTP_PROXY}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg FTP_PROXY=${FTP_PROXY}"
  fi
  if [ -n "${ftp_proxy}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg ftp_proxy=${ftp_proxy}"
  fi

  if [ -n "${NO_PROXY}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg NO_PROXY=${NO_PROXY}"
  fi
  if [ -n "${no_proxy}" ] ; then
    BUILD_ARGS_PROXY="${BUILD_ARGS_PROXY} --build-arg no_proxy=${no_proxy}"
  fi
  
  if [ -n "${BUILD_ARGS_PROXY}" ] ; then
    echo "Proxy settings were found and will be used during build."
    BUILD_ARGS="${BUILD_ARGS} ${BUILD_ARGS_PROXY}"
  fi
}

apply_sw_settings() {
  echo "+ Applying sw versions"

  if [ -n "${TOMCAT_VERSION}" ] ; then
    BUILD_ARGS_SW="${BUILD_ARGS_SW} --build-arg TOMCAT_PKG=${TOMCAT_VERSION}"
  fi

  if [ -n "${JDK_VERSION}" ] ; then
    BUILD_ARGS_SW="${BUILD_ARGS_SW} --build-arg JDK_PKG=${JDK_VERSION}"
  fi

  if [ -n "${BUILD_ARGS_SW}" ] ; then
    echo "Sw settings were found and will be used during build."
    BUILD_ARGS="${BUILD_ARGS} ${BUILD_ARGS_SW}"
  fi
}

build() {
  echo "+ Building the image"

  sudo docker build ${BUILD_ARGS} -t ${IMAGE_NAME} .

  if [ $? -ne 0 ] ; then
    echo "! There was an error building the image."
    exit 1
  fi
}

### Main ###
parseArgs $1 $2 $3
apply_proxy_settings
#apply_sw_settings
build

