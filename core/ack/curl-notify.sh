#!/bin/bash

# validate arguments

if [ $# -ne 6 ]; then
   echo """Usage: ./curl-notify.sh -<option1> <value1> ...
    -d device ID/key generated from Platalytics Platform
    -f frontend host
    -s step"

    echo "Example: ./curl-notify.sh -d KEY -f http://host:port/xxx/xxx?api_key=xxx -s 1"
else
    while getopts ":d:f:s:" opt; do
        case $opt in
            d)
                device_id=$OPTARG
                ;;
            f)
                front_end_host=$OPTARG
                ;;
            s)
                step=$OPTARG
                ;;
            \?)
                echo "Invalid flag: -$OPTARG." ; exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument."
                ;;
        esac
    done

    curl -H 'Content-Type: application/json' -X POST -d '{"device_key":"'${device_id}'","status":"true","step":"'${step}'"}' ${front_end_host}

fi
