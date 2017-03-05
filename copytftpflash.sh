#!/usr/bin/expect -f


# Set variables
set hostname [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set enablepassword [lindex $argv 3]
set date [exec date +%F]
set server 10.100.100.2

#Log results
log_file -a scpcopy-$date.log

# Announce device and time
send_user "\n"
send_user ">>>>>Working on $hostname @ [exec date]<<<<<\n"
send_user "\n"

#Don't check keys
spawn ssh -o StrictHostKeyChecking=no $username\@$hostname

#Connection issues & priv password
expect {
timeout { send_user "\nTimeout Exceeded - Check Host\n"; exit 1 }
eof { send_user "\nSSH Connection to $hostname failed\n"; exit 1 }
"*assword:" { send "$password\r" }
}

#Enable password
expect {
default { send_user "\nLogin Failed - Check Password\n"; exit 1 }
"*#" { send "\r" }
"*>" {
send "enable\n"
expect "*assword:"
send "$enablepassword\r"
}
}

# Copy IOS from TFTP Server
expect {
"*#" {
send "copy tftp: flash:\r"
expect {
"Address or name of remote host*" {
send "10.100.100.2\r"
expect "Source filename*"
send "abc.bin\r"
expect "Destination filename*"
send "abc.bin\r"
expect "*copied*"
send "exit\r"
}
}
}
}



