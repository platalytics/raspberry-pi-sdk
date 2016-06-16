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

# stop streaming
expect "*~#" { send "killall ffmpeg\r" }
expect "*~#" { send "exit\r" }

interact
