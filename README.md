# Raspberry Pi SDK

Before you dive in to setting up the SDK for your device there are some instructions that need to be followed along.

1. You need a `linux`-based environment to setup
2. Make sure you have `expect` utility installed

   Get `expect` on Ubuntu/Debian

        $ sudo apt-get install expect

Add execution permissions to script `deploy.sh`

    $ chmod +x deploy.sh

Run deployment script

    $ ./deploy.sh -<option1> <value1> ...
        -i IP address
        -u username having root access
        -p password of specified username
        -s SSH port
        -d device ID/key generated from Platalytics Platform
        -f frontend host

Example

    $ ./deploy -i 192.168.1.X -u root -p arduino -s 22 -d KEY -f [url]


This does everything in one go. Sets up protocol libraries and installs required dependencies on Raspberry Pi board.

You can find examples in `examples/` folder.