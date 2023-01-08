#!/bin/bash

echo "Executing Entryponit script..."
echo
if [[ $# -eq 0 ]]; then
    echo "No input parameters provided. Exiting..."
    echo "The container requires 1 input parameters: <password>"
    exit
fi
if [[ $# -ne 1 ]]; then
    echo "incorrect input. exiting..."
    echo "The container requires 1 input parameters: <password>"
    exit
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ];then
    echo "No SSH keys found, generating..."
	ssh-keygen -A
fi
echo "Customizing root"
echo root:$1 | chpasswd
chsh -s /bin/fish root
wait
if [ ! -f "/root/Desktop/RenameMyTVSeries.desktop" ];then
    echo "Adding desktop shortcuts"
    mkdir -p "/root/Desktop"
    cp /usr/share/RenameMyTVSeries/RenameMyTVSeries.desktop "/root/Desktop/"
fi
mkdir -p /var/run/sshd
rm -rf /var/run/xrdp-sesman.pid
rm -rf /var/run/xrdp.pid
rm -rf /var/run/xrdp/xrdp-sesman.pid
rm -rf /var/run/xrdp/xrdp.pid
echo -e "Init complete!\n"
if [ -z ${LANGUAGE} ]; then 
    echo "No custom language set"
else
    echo "Custom language set" 
    echo "LANG=$LANGUAGE.UTF-8" > /etc/locale.conf
    localedef -c -i $LANGUAGE -f UTF-8 $LANGUAGE.UTF-8
fi
supervisord -c /etc/supervisord.conf -n