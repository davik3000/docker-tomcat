#!/bin/bash

IMAGE_NAME="davik3000/docker/tomcat"

PROXY_SETTINGS=""

### Functions ###
parseArgs() {
  if [ -n "$1" ] ; then
    IMAGE_NAME=$1
  fi
  echo "+ Using image name: ${IMAGE_NAME}"
}

apply_proxy_settings() {
  echo "+ Checking and applying proxy settings"

  # proxy settings
  if [ -n "${HTTP_PROXY}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg HTTP_PROXY=${HTTP_PROXY}"
  fi
  if [ -n "${http_proxy}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg http_proxy=${http_proxy}"
  fi

  if [ -n "${HTTPS_PROXY}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg HTTPS_PROXY=${HTTPS_PROXY}"
  fi
  if [ -n "${https_proxy}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg https_proxy=${https_proxy}"
  fi

  if [ -n "${FTP_PROXY}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg FTP_PROXY=${FTP_PROXY}"
  fi
  if [ -n "${ftp_proxy}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg ftp_proxy=${ftp_proxy}"
  fi

  if [ -n "${NO_PROXY}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg NO_PROXY=${NO_PROXY}"
  fi
  if [ -n "${no_proxy}" ] ; then
    PROXY_SETTINGS="${PROXY_SETTINGS} --build-arg no_proxy=${no_proxy}"
  fi
  
  if [ -n "${PROXY_SETTINGS}" ] ; then
    echo "Proxy settings were found and will be used during build."
  fi

}

build() {
  echo "+ Building the image"
  sudo docker build ${PROXY_SETTINGS} -t ${IMAGE_NAME} .

  if [ $? -ne 0 ] ; then
    echo "! There was an error building the image."
    exit 1
  fi
}

### Main ###
parseArgs $1
apply_proxy_settings
build

