#!/bin/bash

if [ $# -ne 6 ]; then
    echo "usage: ./deploy.sh <board-ip> <board-username> <board-password> <ssh-port> <device-key> <front_end_host> "
else
    board_ip=$1
    board_username=$2
    board_password=$3
    ssh_port=$4
    device_id=$5
    front_end_host=$6

    libraries="./lib"
    code_path="./src"
    core_path="./core"

    chmod 755 ./copy.sh
    chmod 755 ./setup.sh
    chmod 755 ./setup-video.sh
    chmod 755 ./core/ack/curl-notify.sh

    echo "starting..."

    #notifying frontend
    ./core/ack/curl-notify.sh ${device_id} ${front_end_host} "1"

    # monitoring script deployment
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${core_path} /root/ 1>/dev/null

    # copying code files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${code_path} /root/ 1>/dev/null

    # copying library files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${libraries} /root/ 1>/dev/null

     #notifying frontend
    ./core/ack/curl-notify.sh ${device_id} ${front_end_host} "2"

    # setup
    ./setup.sh ${board_ip} ${board_username} ${board_password} ${device_id} ${ssh_port} ${front_end_host}
    # setup video streaming
    #./setup-video.sh
fi
