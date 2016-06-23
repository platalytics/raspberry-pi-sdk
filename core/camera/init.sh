#!/bin/bash

if [ $# -ne 12 ]; then
    echo """Usage: ./init.sh -<option1> <value1> ...
    -i IP address
    -u username having root access
    -p password of specified username
    -s SSH port
    -d device ID/key generated from Platalytics Platform
    -f frontend host"

    echo "Example: ./init.sh -i 192.168.1.X -u root -p raspberry -s 22 -d KEY -f http://host:port/xxx/xxx?api_key=xxx"
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

    chmod 755 ./install.sh

    ./install.sh ${board_ip} ${board_username} ${board_password} ${ssh_port} ${device_id} ${front_end_host}
fi
