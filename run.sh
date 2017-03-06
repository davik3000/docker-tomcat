#~/bin/bash

#set -x

ID="docker-tomcat"
NETWORK="inetwork"
PORTS="-p 8005:8005 -p 8009:8009 -p 8080:8080 -p 8443:8443"
IMAGE="davik3000/docker/tomcat"

# detect network
_network_present=$(sudo docker network ls | grep -e ${NETWORK})

if [ -z "${_network_present}" ] ; then
  sudo docker network create ${NETWORK}
fi;

# execute container
sudo docker run -d --name ${ID} -h ${ID} --network ${NETWORK} ${PORTS} ${IMAGE}
