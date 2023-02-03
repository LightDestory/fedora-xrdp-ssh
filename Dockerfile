FROM fedora:latest

RUN dnf -y update \
    && dnf -y install glibc-locale-source \
    && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf

# extra repos
RUN dnf -y reinstall glibc-common && rpm -Uhv https://mkvtoolnix.download/fedora/bunkus-org-repo-2-4.noarch.rpm && dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y install \
    langpacks-it \
    adwaita-gtk2-theme \
    lightdm-gtk \
    thunar-archive-plugin \
    xdg-user-dirs-gtk \
    xfce4-appfinder \
    xfce4-session \
    xfce4-settings \
    xfce4-taskmanager \
    xfce4-terminal \
    xfdesktop \
    xfwm4 \
    nano-default-editor \
    xrdp \
    xorgxrdp \
    openssh-server \
    openssh-clients \
    passwd \
    ncurses \
    mousepad \
    supervisor \
    aria2 \
    wget \
    curl \ 
    mpv \
    trash-cli \
    mediainfo \
    mediainfo-gui \
    ffmpeg \
    ffmpeg-libs \
    ffmpeg-devel \
    yt-dlp \
    unrar \
    htop \
    amule \
    xarchiver \
    filezilla \
    mkvtoolnix \
    mkvtoolnix-gui \
    python3-pip \
    firefox \
    fish \
    exa \
    dnf-plugins-core \
    openssl-devel \
    clang \
    zlib-devel \
    expat-devel \
    libcap-devel \
    libattr-devel \
    qt5-qtbase-devel \
    qt5pas \
    rsync \
    util-linux-user \
    libogg-devel \
    qt5-qtmultimedia-devel \
    qt5-linguist \
    qt5-qtbase-devel \
    git

RUN dnf -y remove pipewire

RUN dnf -y autoremove && dnf clean all

# MNAMER & PySubs2

RUN pip3 install mnamer pysubs2

# Filebot

RUN dnf config-manager --add-repo https://raw.githubusercontent.com/filebot/plugins/master/yum/main.repo \
&&  dnf config-manager --set-enabled filebot \
&& dnf install -y zenity filebot

# RenameMyTVSeries

WORKDIR /tmp
RUN wget https://www.tweaking4all.com/downloads/betas/RenameMyTVSeries-2.1.7-GTK-beta-Linux-64bit-shared-ffmpeg.tar.gz && \
  mkdir /usr/share/RenameMyTVSeries && \
  tar -zxvf RenameMyTVSeries-2.1.7-GTK-beta-Linux-64bit-shared-ffmpeg.tar.gz -C /usr/share/RenameMyTVSeries

# MakeMKV

WORKDIR /tmp
RUN wget https://www.makemkv.com/download/makemkv-bin-1.17.3.tar.gz && \
  wget https://www.makemkv.com/download/makemkv-oss-1.17.3.tar.gz && \
  tar -xvf makemkv-bin-1.17.3.tar.gz && \
  tar -xvf makemkv-oss-1.17.3.tar.gz && \
  cd ./makemkv-oss-1.17.3 && \
  ./configure && \
  make && \
  make install && \
  cd ../makemkv-bin-1.17.3 && \
  mkdir -p "tmp" && \
  echo "accepted" >> "tmp/eula_accepted" && \
  make && \
  make install

# Post-install configuration

RUN rm -r /tmp/*

RUN bash -c 'echo PREFERRED=/usr/bin/xfce4-session > /etc/sysconfig/desktop'

ADD ./miscs/ect/ /etc

RUN chmod a+x /etc/xrdp/startwm.sh

COPY ./miscs/run.sh /

RUN chmod +x /run.sh

RUN rm /etc/xdg/autostart/xfce-polkit.desktop /etc/xdg/autostart/geoclue-demo-agent.desktop /etc/xdg/autostart/tracker-miner-rss-3.desktop

EXPOSE 3389 22

ENTRYPOINT ["/run.sh"]

