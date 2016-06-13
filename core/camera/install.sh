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

send_user "\ninstalling camera\n"

spawn ssh ${remote_end} -p ${ssh_port}
expect {
    -re ".*yes/no.*" {
        send "yes\r"; exp_continue
	-re ".*assword.*" { send "$boardPassword\r" }
    }
    -re ".*assword.*" { send "$boardPassword\r" }
}

# pre-installation setup

expect "*~#" { send "chmod 755 /root/core/camera/installer/setupcam.sh"}
expect "*~#" { send "/root/core/camera/installer/setupcam.sh"}

# acknowledge frontend here

expect "*~#" { send "exit\r" }

interact
