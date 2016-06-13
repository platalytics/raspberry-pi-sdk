#!/bin/bash

if [ $# -ne 6 ]; then
    echo "usage: ./deploy.sh <board-ip> <board-username> <board-password> <device-key> <host> <api-key>"
else
    boardIp=$1
    boardUserName=$2
    boardPassword=$3
    ssh_port=$4
    device_id=$5
    front_end_host=$6

    libraries="./lib"
    code_path="./src"
    core_path="./core"

    chmod 755 ./copy.sh
    chmod 755 ./setup.sh
    chmod 755 ./setup-video.sh
    
    echo "starting..."
    curl -H 'Content-Type: application/json' -X POST -d '{"device_key":"'${device_id}'","status":"true","step":"1"}' ${front_end_host}

    # monitoring script deployment
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${core_path} /root/ 1>/dev/null

    # copying code files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${code_path} /root/ 1>/dev/null

    # copying library files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${libraries} /root/ 1>/dev/null

    curl -H 'Content-Type: application/json' -X POST -d '{"device_key":"'${device_id}'","status":"true","step":"2"}' ${front_end_host}

    # setup
    ./setup.sh ${board_ip} ${board_username} ${board_password} ${device_id} ${ssh_port} ${front_end_host}
    # setup video streaming
    #./setup-video.sh
fi
