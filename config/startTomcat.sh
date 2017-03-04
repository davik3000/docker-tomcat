#!/bin/bash

echo "$(date) - Starting Tomcat..."

while [[ -z "$stop" ]]; do
    # check if process is running
    pmon=`ps -ef | grep tomcat | grep -v grep`

    if [[ -z "$pmon" ]]
    then
        ${CATALINA_HOME}/bin/startup.sh

        # check if process is running
        pmon=`ps -ef | grep tomcat | grep -v grep`
        if [[ -z "$pmon" ]]
        then
            echo "$(date) - Errors on executing Tomcat. Exiting..."
            stop="true"
        fi
    else
        echo "$(date) - Tomcat is running. Sleep 1 min and check again..."
        sleep 1m
    fi
done;
