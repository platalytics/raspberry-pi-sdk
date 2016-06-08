#!/bin/bash

if [ $# -ne 5 ]; then
	 echo "usage: ./video-setup.sh streaming-server-ip streaming-server-port secret-password width height"
else
    host=$1
    port=$2
    password=$3
    width=$4
    height=$5
    url="http://$host:$port/$password/$width/$height/"
    echo $url
    sudo uv4l --sched-rr --driver raspicam --auto-video_nr
    v4l2-ctl --set-fmt-video=width=$width,height=$height,pixelformat=H264 -d /dev/video0
    nohup dd if=/dev/video0 bs=512K | /usr/src/FFmpeg/ffmpeg -i - -f video4linux2 -f mpeg1video -b 800k -r 30 $url >/dev/null 2>&1 &
fi