#!/bin/bash

echo 'adduser script for vsftpd'
echo -n 'Enter username : '
read user
echo -n 'Enter password : '
read -s password
echo ''
echo -n 'Confirm password : '
read -s passwordBis
echo ''

if [ "$password" = "$passwordBis" ]; then
	echo "${user}:$(openssl passwd -1 {password})" >> /conf/vsftpd/virtual_users        
        mkdir -p "/var/ftp/${user}/data"
        chown -R ftp:ftp "/var/ftp/${user}"
        chmod 555 "/var/ftp/${user}"
        cp "/etc/vsftpd/user_conf.example" "/conf/vsftpd/user_conf/${user}"
else
        echo 'Please enter the same password'
fi

