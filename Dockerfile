FROM fedora:36

# DNF update, install kde-env and utilities

RUN dnf -y update

# extra repos
RUN rpm -Uhv https://mkvtoolnix.download/fedora/bunkus-org-repo-2-4.noarch.rpm && \
    dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm && \
    dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y install \
  @kde-desktop \
  xrdp \
  xorgxrdp \
  passwd \
  nano \
  ncurses \
  openssh-server \
  less \
  supervisor \
  aria2 \
  wget \
  trash-cli \
  htop \
  mediainfo \
  mediainfo-gui \
  patch \
  g++ \
  filezilla \
  ark \
  mkvtoolnix \
  mkvtoolnix-gui \
  fish \ 
  firefox \
  openssl-devel\ 
  zlib-devel \
  expat-devel \
  libcap-devel \
  libattr-devel \
  krename \ 
  python3-pip \
  ffmpeg \
  ffmpeg-libs \
  vlc \
  amule \
  qt5pas

RUN dnf -y remove akregator kmail kaddressbook korganizer kwalletmanager kmouth kmousetool kde-partitionmanager plasma-discover dnfdragora firewall-config qt5-qdbusviewer kcalc kde-print-manager kde-settings-pulseaudio plasma-thunderbolt bluez colord-kde spectacle kcharselect kf5-akonadi-server

RUN dnf -y autoremove && dnf clean all

# Youtube-DLP

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
  chmod a+rx /usr/local/bin/yt-dlp

# ADMVCP

WORKDIR /tmp

RUN FORCE_UNSAFE_CONFIGURE=1 && export FORCE_UNSAFE_CONFIGURE && curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o ./advcpmv/install.sh && (cd advcpmv && sh install.sh)

RUN mv ./advcpmv/advcp /usr/local/bin/cpg && mv ./advcpmv/advmv /usr/local/bin/mvg

# MNAMER

RUN pip3 install mnamer

# PySubs2

RUN pip3 install pysubs2

# Filebot

WORKDIR /tmp
RUN dnf config-manager --add-repo https://raw.githubusercontent.com/filebot/plugins/master/yum/main.repo && \
    dnf config-manager --set-enabled filebot --dump && \
    dnf install -y zenity filebot

# RenameMyTVSeries

WORKDIR /tmp
RUN wget https://www.tweaking4all.com/downloads/betas/RenameMyTVSeries-2.1.8-QT5-beta-Linux-64bit-shared-ffmpeg.tar.gz && \
  mkdir /usr/share/RenameMyTVSeries && \
  tar -zxvf RenameMyTVSeries-2.1.8-QT5-beta-Linux-64bit-shared-ffmpeg.tar.gz -C /usr/share/RenameMyTVSeries

# Fix for VLC as root

RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc 

# Post-install configuration

RUN rm /tmp/*

RUN bash -c 'echo PREFERRED=/usr/bin/startplasma-x11 > /etc/sysconfig/desktop'

ADD ./miscs/ect/ /etc

RUN chmod a+x /etc/xrdp/startwm.sh

COPY ./miscs/run.sh /

RUN chmod +x /run.sh

RUN ssh-keygen -A

EXPOSE 3389 22

ENTRYPOINT ["/run.sh"]

