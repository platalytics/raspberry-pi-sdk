#!/usr/bin/expect

# validate arguments

set timeout -1
set boardIp [lindex $argv 0]
set boardUserName [lindex $argv 1]
set boardPassword [lindex $argv 2]
set device_id [lindex $argv 3]
set ssh_port [lindex $argv 4]
set front_end_host [lindex $argv 5]

set remoteEnd "$boardUserName@$boardIp"

send_user "\nmake sure your pi board is connected to internet to install these dependencies"
send_user "\n- distribute\n- python-openssl\n- pip\n- paho-mqtt-1.1\n- kafka-python-1.1.1\n"

spawn ssh ${remote_end} -p ${ssh_port}
expect {
    -re ".*yes/no.*" {
        send "yes\r"; exp_continue
	-re ".*assword.*" { send "$boardPassword\r" }
    }
    -re ".*assword.*" { send "$boardPassword\r" }
}

# pre-installation setup
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"3\""}

expect "*~#" { send "apt-get update\r" }
expect "*~#" { send "apt-get install python-openssl\r" }
expect "*~#" { send "easy_install pip\r" }

# installing local/offline versions of supported python libraries 
expect "*~#" { send "pip install /root/lib/paho-mqtt-1.1.tar.gz\r" }
#expect "*~#" { send "pip install /root/lib/kafka-python-1.1.1.tar.gz\r" }

# other protocol packages
# expect "*~#" { send "pip install /root/lib/amqp-1.4.7.tar.gz\r" }
# expect "*~#" { send "pip install /root/lib/CoAPthon-4.0.0.tar.gz -r /root/lib/coap_req\r" }

expect "*~#" { send "chmod 775 /root/core/logger/loggerdaemon.py\r" }
expect "*~#" { send "chmod 775 /root/src/mqtt/mqtt-sender.py\r" }
expect "*~#" { send "nohup sh -c '/root/core/logger/loggerdaemon.py $device_id &'\r" }
expect "*~#" { send "chmod 775 /root/core/controls/controlsdaemon.py\r" }

# setting running daemons
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"4\""}
expect "*~#" { send "echo ${device_id} 1>/root/key.conf\r" }
expect "*~#" { send "nohup sh -c '/root/core/logger/loggerdaemon.py' 1>/dev/null 2>&1 &\r" }
expect "*~#" { send "echo ${device_id}controlcallback 1>/root/controls.conf\r" }
expect "*~#" { send "nohup sh -c '/root/core/controls/controlsdaemon.py' 1>/dev/null 2>&1 &\r" }

# adding bootloader entries
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"5\""}
expect "*~#" { send "cat /root/core/bootloader/entry 1>/etc/rc.local\r" }
expect "*~#" { send "echo 'nohup sh -c '/root/core/logger/loggerdaemon.py' 1>/dev/null 2>&1 &' >> /etc/rc.local\r" }
expect "*~#" { send "echo 'nohup sh -c '/root/core/controls/controlsdaemon.py' 1>/dev/null 2>&1 &' >> /etc/rc.local\r" }
expect "*~#" { send "echo 'exit 0' >> /etc/rc.local\r" }


# cleaning up
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"6\""}
expect "*~#" { send "rm -rf /root/lib\r" }

# rebooting
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"7\""}
## reboot here ##

# completion ack
expect "*~#" { send "./root/core/ack/curl-notify.sh  '${device_id}' '${front_end_host}' \"8\""}

expect "*~#" { send "exit\r" }

interact
