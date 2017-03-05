#!/bin/bash
# Collect Username, ssh & Enable Passwords
echo "Enter the username: "
read -s -e user
echo "Enter the SSH Password: "
read -s -e password
echo "Enter the Enable Password: "
read -s -e enable
# Open device list & send the collected information to script
for device in `cat hosts`; do
./copytftpflash.sh $device $user $password $enable;
done
