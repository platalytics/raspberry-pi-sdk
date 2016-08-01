#!/usr/bin/expect

# validate arguments

set timeout -1
set board_ip [lindex $argv 0]
set board_user_name [lindex $argv 1]
set board_password [lindex $argv 2]
set ssh_port [lindex $argv 3]
set device_id [lindex $argv 4]
set front_end_host [lindex $argv 5]

set remote_end "$board_user_name@$board_ip"

send_user "\nmake sure your pi board is connected to internet to install these dependencies"
send_user "\n- distribute\n- python-openssl\n- pip\n- paho-mqtt-1.1\n- kafka-python-1.1.1\n"

spawn ssh ${remote_end} -p ${ssh_port}
expect {
    -re ".*yes/no.*" {
        send "yes\r"; exp_continue
	-re ".*assword.*" { send "$board_password\r" }
    }
    -re ".*assword.*" { send "$board_password\r" }
}

# pre-installation setup
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 3\r" }
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
expect "*~#" { send "nohup sh -c '/root/core/logger/loggerdaemon.py ${device_id} &'\r" }
expect "*~#" { send "chmod 775 /root/core/controls/controlsdaemon.py\r" }

# setting running daemons
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 4\r" }
expect "*~#" { send "echo ${device_id} 1>/root/key.conf\r" }
expect "*~#" { send "nohup sh -c '/root/core/logger/loggerdaemon.py' 1>/dev/null 2>&1 &\r" }
expect "*~#" { send "echo ${device_id}controlcallback 1>/root/controls.conf\r" }
expect "*~#" { send "nohup sh -c '/root/core/controls/controlsdaemon.py' 1>/dev/null 2>&1 &\r" }

# adding bootloader entries
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 5\r" }
expect "*~#" { send "cat /root/core/bootloader/entry 1>/etc/rc.local\r" }
expect "*~#" { send "echo 'nohup sh -c '/root/core/logger/loggerdaemon.py' 1>/dev/null 2>&1 &' >> /etc/rc.local\r" }
expect "*~#" { send "echo 'nohup sh -c '/root/core/controls/controlsdaemon.py' 1>/dev/null 2>&1 &' >> /etc/rc.local\r" }
expect "*~#" { send "echo 'exit 0' >> /etc/rc.local\r" }


# cleaning up
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 6\r" }
expect "*~#" { send "rm -rf /root/lib\r" }

# rebooting
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 7\r" }
## reboot here ##

# completion ack
expect "*~#" { send "/root/core/ack/curl-notify.sh -d '${device_id}' -f '${front_end_host}' -s 8\r" }

expect "*~#" { send "exit\r" }

interact
