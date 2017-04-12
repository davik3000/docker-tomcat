#~/bin/bash

#set -x

ID="docker-tomcat"
NETWORK="inetwork"
HOST_SHARED_DIR="$(pwd)/data"
GUEST_SHARED_DIR="/data"
PROXY_ENV_FILE="docker_proxy.envfile"
IMAGE="davik3000/docker/tomcat"

# detect network
_network_present=$(sudo docker network ls | grep -e ${NETWORK})
if [ -z "${_network_present}" ] ; then
  sudo docker network create ${NETWORK}
fi

# check host shared folder
if [ ! -d "${HOST_SHARED_DIR}" ] ; then
  mkdir -p ${HOST_SHARED_DIR}
fi

# check proxy envfile
[ -f "${PROXY_ENV_FILE}" ] || touch "${PROXY_ENV_FILE}"

# detect local proxy settings
_proxy_envvars=$(printenv | grep -i -e 'proxy')
if [ -n "${_proxy_envvars}" ] ; then
  echo "Loading local proxy setting into Docker envfile"
  echo "${_proxy_envvars}" > "${PROXY_ENV_FILE}"
fi

# execute container
_container_present=$(sudo docker ps -a | grep -e ${ID})
_container_created=$(echo ${_container_present} | grep -e "Created")
_container_exited=$(echo ${_container_present} | grep -e "Exited")

OPT_NAME="--name ${ID}"
OPT_HOSTNAME="-h ${ID}"
OPT_ENVFILE="--env-file ${PROXY_ENV_FILE}"
OPT_NETWORK="--network ${NETWORK}"
OPT_PORTS="-p 8005:8005 -p 8009:8009 -p 8080:8080 -p 8443:8443"
OPT_VOLUMES="-v ${HOST_SHARED_DIR}:${GUEST_SHARED_DIR}"

if [ -z "${_container_present}" ] ; then
  echo "Run new container"
  sudo docker run -d ${OPT_NAME} ${OPT_HOSTNAME} ${OPT_ENVFILE} ${OPT_NETWORK} ${OPT_PORTS} ${OPT_VOLUMES} ${IMAGE}
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
