#!/bin/bash
ps -ef | grep ffmpeg | awk '{ print $2 }' | xargs kill
