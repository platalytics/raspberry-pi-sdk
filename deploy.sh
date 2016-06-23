#!/bin/bash

if [ $# -ne 12 ]; then
    echo """Usage: ./deploy.sh -<option1> <value1> ...
    -i IP address
    -u username having root access
    -p password of specified username
    -s SSH port
    -d device ID/key generated from Platalytics Platform
    -f frontend host"

    echo "Example: ./deploy -i 192.168.1.X -u root -p raspberry -s 22 -d KEY -f http://host:port/xxx/xxx?api_key=xxx"
else
    while getopts ":i:u:p:s:d:f:" opt; do
        case $opt in
            i)
                board_ip=$OPTARG
                ;;
            u)
                board_username=$OPTARG
                ;;
            p)
                board_password=$OPTARG
                ;;
            s)
                ssh_port=$OPTARG
                ;;
            d)
                device_id=$OPTARG
                ;;
            f)
                front_end_host=$OPTARG
                ;;
            \?)
                echo "Invalid flag: -$OPTARG." ; exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument."
                ;;
        esac
    done

    libraries="./lib"
    code_path="./src"
    core_path="./core"

    chmod 755 ./copy.sh
    chmod 755 ./setup.sh
    chmod 755 ./core/camera/init.sh
    chmod 755 ./core/ack/curl-notify.sh

    echo "starting..."

    #notifying frontend
    ./core/ack/curl-notify.sh "-d" ${device_id} "-f" ${front_end_host} "-s 1"

    # monitoring script deployment
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${core_path} /root/ 1>/dev/null

    # copying code files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${code_path} /root/ 1>/dev/null

    # copying library files
    ./copy.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${libraries} /root/ 1>/dev/null

     #notifying frontend
    ./core/ack/curl-notify.sh ${device_id} ${front_end_host} "2"

    # setup
    ./setup.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${device_id} ${front_end_host}
fi
