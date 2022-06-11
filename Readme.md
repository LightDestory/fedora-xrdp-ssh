# Fedora 36 Single User Remote Desktop and SSH Server

:warning: _This repository is related to something that I use on a private stuff, it is not aimed for a public usage. Use it at your risk!_

This dockerfile contains a Fedora 36 image with some tools needed for generic operations related to multimedia handling. It comes with mkvtoolnix, RenameMyTvSeries (beta), filebot, ffmpeg, KRename, aria2, vlc, mediainfo, filezilla and so on.

It is based on KDE and you can connect to it using SSH and any RDP client, thanks to xrdp.

:warning: _As said above, this dockerfile is for a very specific workload, it is not suited for common usage! Your are going to only use the root user. Use it at your risk!_
## :whale: Manual Deploying

First of all, build the image running:

```bash
docker build . --name fedora-xrdp-ssh
```

Then create a new container running (remove `ghcr.io/lightdestory/` if you want to use your local image):

```bash
docker run -d --name capybara --shm-size 1g -p 3389:3389 -p 2222:22 ghcr.io/lightdestory/fedora-xrdp-ssh:master <root-password>
```

**Notes:**

- It is important to use the `--shm-size 1g` or the web browsers will crash;
- If you are using a rdp server on `3389` change `-p <my-port>:3389`;
- If your `2222` is busy, change `-p <my-port>:22` for ssh access into the container;

## :satellite: Connecting to the container

You can connect to the container using a RDP client or SSH.

- By default, SSH is enabled on port `2222`, you can use any SSH client out of the web;
- By default, RDP is enabled on port `3389`, you can use all the clients supported by [XRDP](https://github.com/neutrinolabs/xrdp):
  
  - FreeRDP
  - rdesktop
  - KRDC
  - NeutrinoRDP
  - Windows MSTSC (Microsoft Terminal Services Client, aka mstsc.exe)
  - Microsoft Remote Desktop (found on Microsoft Store, which is distinct from MSTSC)

## :gear: Adding new services

Due to containerized nature, systemd is not usable. A workaround for this issue is supervisor.
Supervisor helps us to make sure that all needed services are up and running. This dockerfile contains the bare minium of supervisor settings, http server has been disabled.
To add a new service we need to creare a new configuration in `/etc/supervisord.d/`

**Example**: Adding `mysql` as a service

```bash
dnf install install mysql-server
echo "[program:mysqld] \
command= /usr/sbin/mysqld \
user=mysql \
autorestart=true \
priority=100" > /etc/supervisord.d/mysql.ini
supervisorctl update
```
