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
echo "Customizing root"
echo root:$1 | chpasswd
wait
echo "Adding desktop shortcuts"
mkdir -p "/root/Desktop"
cp /usr/share/RenameMyTVSeries/RenameMyTVSeries.desktop "/root/Desktop/"
mkdir -p /var/run/sshd
echo -e "Init complete!\n"
supervisord -c /etc/supervisord.conf -n