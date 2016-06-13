#!/bin/bash

if [ $# -ne 6 ]; then
    echo "usage: ./init.sh <board-ip> <board-username> <board-password> <device-key> <front_end_host>"
else
    board_ip=$1
    board_username=$2
    board_password=$3
    ssh_port=$4
    device_id=$5
    front_end_host=$6

    chmod 755 ./install.sh

    ./install.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${device_id} ${front_end_host}
fi
