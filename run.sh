ID="docker-tomcat"
PORTS="-p 8005:8005 -p 8009:8009 -p 8080:8080 -p 8443:8443"
IMAGE="davik3000/docker/tomcat"

sudo docker run -d --name ${ID} -h ${ID} --network inetwork ${PORTS} ${IMAGE}
