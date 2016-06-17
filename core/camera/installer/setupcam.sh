#!/bin/bash

device_id=$1
front_end_host=$2

if [ -f "/usr/src/mpeg.tar.gz" ]
then
	echo "/usr/src/mpeg.tar.gz already found. skipping download."

else
    curl -H 'Content-Type: application/json' -X POST -d '{"status":true,"device_key":"'${device_id}'","action":"started"}' ${front_end_host}

	cd /usr/src
	rm -rf *mpeg*
	rm -rf *x264*
	wget  "https://s3.amazonaws.com/Plat-libraries/mpeg.tar.gz"
	if [ $? -ne 0 ]; then
	    echo 'downloading FFmpeg failed'
	    exit
	fi
	tar zxvf mpeg.tar.gz
	chmod 777 -R FFmpeg/ffmpeg
	wget  "https://s3.amazonaws.com/Plat-libraries/x264.tar.gz"
	if [ $? -ne 0 ]; then
		echo 'downloading x264 failed'
		exit
	fi
	tar zxvf x264.tar.gz
	chmod 777 -R x264
	echo 'adding key '
	curl http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc | sudo apt-key add -
	if [ $? -ne 0 ]; then
		echo "curl apt key"
	    exit
	fi

	echo 'deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ wheezy main' >> /etc/apt/sources.list
	if [ $? -ne 0 ]; then
		echo "add new source to  /etc/apt/sources.list failed, exiting."
	    exit
	fi

	sudo apt-get update
	if [ $? -ne 0 ]; then
		echo "Update command failed, exiting."
	fi

	sudo apt-get install uv4l uv4l-raspicam
	if [[ $? -ne 0 ]]; then
	    echo "The command failed, exiting."
	    exit
	fi

    curl -H 'Content-Type: application/json' -X POST -d '{"status":true,"device_key":"'${device_id}'","action":"finished"}' ${front_end_host}
fi