#~/bin/bash

#set -x

ID="docker-tomcat"
NETWORK="inetwork"
PORTS="-p 8005:8005 -p 8009:8009 -p 8080:8080 -p 8443:8443"
HOST_SHARED_DIR="$(pwd)/data"
GUEST_SHARED_DIR="/data"
VOLUMES="-v ${HOST_SHARED_DIR}:${GUEST_SHARED_DIR}"
IMAGE="davik3000/docker/tomcat"

# detect network
_network_present=$(sudo docker network ls | grep -e ${NETWORK})

if [ -z "${_network_present}" ] ; then
  sudo docker network create ${NETWORK}
fi;

# check host shared folder
if [ ! -d "${HOST_SHARED_DIR}" ] ; then
  mkdir -p ${HOST_SHARED_DIR}
fi;

# execute container
_container_present=$(sudo docker ps -a | grep -e ${ID})
_container_created=$(echo ${_container_present} | grep -e "Created")
_container_exited=$(echo ${_container_present} | grep -e "Exited")

if [ -z "${_container_present}" ] ; then
  echo "Run new container"
  sudo docker run -d --name ${ID} -h ${ID} --network ${NETWORK} ${PORTS} ${VOLUMES} ${IMAGE}
elif [ -n "${_container_created}" ] ; then
  echo "The current container has been only created, so it cannot be executed."
  echo "Please, remove it before continue"
  echo ""
  echo "Exiting.."
elif [ -n "${_container_exited}" ] ; then
  echo "Start existing container"
  sudo docker start ${ID}
else
  echo "Container ${ID} already up and running"
fi
