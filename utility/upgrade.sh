#!/bin/bash

# updating the GPU firmware
sudo apt-get install rpi-update

# update the software
sudo rpi-update

# updating userspace and kernel software
sudo apt-get update
sudo apt-get upgrade
