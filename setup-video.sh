#!/bin/bash
cd /usr/src
wget  "https://s3.amazonaws.com/Plat-libraries/mpeg.tar.gz"
if [ $? -ne 0 ]; then
    echo 'downloading FFmpeg failed'
    exit
fi
tar zxvf mpeg.tar.gz
chmod 777 -R FFmpeg/
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
    exit
fi

sudo apt-get install uv4l uv4l-raspicam
if [[ $? -ne 0 ]]; then
    echo "The command failed, exiting."
    exit
fi
