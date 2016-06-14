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

send_user "\ninstalling camera\n"

spawn ssh ${remote_end} -p ${ssh_port}
expect {
    -re ".*yes/no.*" {
        send "yes\r"; exp_continue
	-re ".*assword.*" { send "$board_password\r" }
    }
    -re ".*assword.*" { send "$board_password\r" }
}

# pre-installation setup
expect "*~#" { send "chmod 755 /root/core/camera/installer/setupcam.sh\r" }
expect "*~#" { send "/root/core/camera/installer/setupcam.sh\r" }

# start streaming
expect "*~#" { send "chmod 755 /root/src/streamer/start.sh\r" }
expect "*~#" { send "nohup sh -c '/root/src/streamer/start.sh 104.236.51.246 8082 12345 320 240' &\r" }
expect "*~#" { send "exit\r" }

interact
