#!/bin/bash

if [ $# -ne 7 ]; then
    echo "usage: ./deploy.sh <board-ip> <board-username> <board-password> <device-key> <device-group-key> <host> <api-key>"
else
    boardIp=$1
    boardUserName=$2
    boardPassword=$3
    deviceId=$4
    deviceGroupId=$5
    host=$6
    apiKey=$7

    libraryPath="./lib"
    codePath="./src"
    monitoringDaemonPath="./logger"

    chmod 755 ./copy.sh
    chmod 755 ./setup.sh
    chmod 755 ./setup-video.sh
    curl -H 'Content-Type: application/json' -X POST -d '{"device_key":"'${deviceId}'","status":"true","step":"1"}' http://${host}/iot/api/devices/deploy?api_key=${apiKey}


    # monitoring script deployment
    ./copy.sh $boardIp $boardUserName $boardPassword $monitoringDaemonPath /root/ 1>/dev/null

    # copying code files
    ./copy.sh $boardIp $boardUserName $boardPassword $codePath /root/ 1>/dev/null

    # copying library files
    ./copy.sh $boardIp $boardUserName $boardPassword $libraryPath /root/ 1>/dev/null

     curl -H 'Content-Type: application/json' -X POST -d '{"device_key":"'${deviceId}'","status":"true","step":"2"}' http://${host}/iot/api/devices/deploy?api_key=${apiKey}

    # setup
    ./setup.sh $boardIp $boardUserName $boardPassword $deviceId $host $apiKey
    # setup video streaming
    ./setup-video.sh
fi
