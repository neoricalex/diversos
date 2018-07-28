#!/bin/sh

#Loosely based on https://45squared.com/setting-sftp-ubuntu-16-04

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

CONFIG_FILE="/etc/ssh/sshd_config"

echo Enter the username to create:
read USERNAME

echo Creating user ${USERNAME}...
adduser ${USERNAME}
usermod -aG www-data ${USERNAME}

echo Setting folder permissions...
mkdir -p /var/www/html/${USERNAME}
chown -R ${USERNAME}:www-data /var/www/html/${USERNAME}/

echo Editing config file ${CONFIG_FILE}...
echo ' ' | tee -a ${CONFIG_FILE}
echo '# Created by add_ftp_user.sh script on +%Y-%m-%d' | tee -a ${CONFIG_FILE}
echo Match User ${USERNAME} | tee -a ${CONFIG_FILE}
echo 'ChrootDirectory /var/www/html/'${USERNAME} | tee -a ${CONFIG_FILE}
echo 'X11Forwarding no' | tee -a ${CONFIG_FILE}
echo 'AllowTcpForwarding no' | tee -a ${CONFIG_FILE}
echo 'AllowAgentForwarding no' | tee -a ${CONFIG_FILE}
echo 'ForceCommand internal-sftp' | tee -a ${CONFIG_FILE}
echo 'PasswordAuthentication yes' | tee -a ${CONFIG_FILE}

echo Restarting sshd service...
service sshd restart

echo Done
