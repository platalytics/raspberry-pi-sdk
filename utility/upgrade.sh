#!/bin/bash
#Updating the GPU firmware
sudo apt-get install rpi-update

#update the software
sudo rpi-update

#Updating userspace and kernel Software
sudo apt-get update
sudo apt-get upgrade
