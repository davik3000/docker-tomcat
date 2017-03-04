FROM centos:7

##########
# Shared #
##########

# To avoid each time to invalidate the Docker build cache, call the "yum update" sequence ASAP
RUN yum update -y && \
    yum clean all

##########
# Config #
##########
# Set the variables used in this Dockerfile
ARG SW_SRC_DIR=sw
ARG SW_DST_DIR=/var/tmp/install
ARG JDK_PKG=jdk-7u79-linux-x64.tar.gz
ARG TOMCAT_PKG=apache-tomcat-8.5.6.tar.gz

ARG MY_OPT_DIR=/opt

ARG MY_JDK_FULLV=jdk1.7.0_79
ARG MY_JAVA_HOME=${MY_OPT_DIR}/${MY_JDK_FULLV}
ARG MY_JRE_HOME=${MY_JAVA_HOME}/jre

ARG MY_TOMCAT_FULLV=apache-tomcat-8.5.6
ARG MY_CATALINA_HOME=${MY_OPT_DIR}/${MY_TOMCAT_FULLV}
ARG MY_CATALINA_BASE=${MY_CATALINA_HOME}

#############
# Execution #
#############
# Pre-requirements
WORKDIR ${SW_DST_DIR}
COPY ${SW_SRC_DIR}/${JDK_PKG} ${SW_DST_DIR}/
COPY ${SW_SRC_DIR}/${TOMCAT_PKG} ${SW_DST_DIR}/

# Exec yum update and install utils
RUN yum update -y && \
    yum install -y \
      vim && \
    yum clean all

WORKDIR ${MY_OPT_DIR}

# Install JDK and Tomcat
RUN tar -xzf ${SW_DST_DIR}/${JDK_PKG}    -C ${MY_OPT_DIR}/ && \
    tar -xzf ${SW_DST_DIR}/${TOMCAT_PKG} -C ${MY_OPT_DIR}/ && \
    alternatives --install /usr/bin/java  java  ${MY_JAVA_HOME}/bin/java  1 && \
    alternatives --install /usr/bin/jar   jar   ${MY_JAVA_HOME}/bin/jar   1 && \
    alternatives --install /usr/bin/javac javac ${MY_JAVA_HOME}/bin/javac 1 && \
    rm -rf ${SW_DST_DIR}

ENV JAVA_HOME ${MY_JAVA_HOME}
ENV JRE_HOME  ${MY_JRE_HOME}

ENV CATALINA_HOME ${MY_CATALINA_HOME}
ENV CATALINA_BASE ${MY_CATALINA_BASE}

ENV PATH ${JAVA_HOME}/bin:${JRE_HOME}/bin:${PATH}

EXPOSE 8005

# Run script
# COPY startTomcat.sh /
# RUN chmod 0755 startTomcat.sh
# RUN ln -s /opt/apache-tomcat-8.5.6/bin/startup.sh /startTomcat.sh
ADD config/startTomcat.sh /
WORKDIR /
CMD /startTomcat.sh
#CMD /bin/bash
