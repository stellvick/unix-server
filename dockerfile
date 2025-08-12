FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Instalar todos os pacotes necessários
RUN apt-get update && \
    apt-get install -y \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    libc6-dev \
    network-manager \
    openvpn \
    network-manager-openvpn \
    network-manager-openvpn-gnome \
    gnome-keyring \
    policykit-1-gnome \
    xfce4-notifyd \
    xfce4-pulseaudio-plugin \
    libnss3-tools \
    gir1.2-appindicator3-0.1 \
    wget \
    ca-certificates \
    dbus \
    dbus-x11 \
    sudo

# Instalar GitKraken
RUN wget -O /tmp/gitkraken.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb" && \
    dpkg -i /tmp/gitkraken.deb || apt-get install -f -y && \
    rm /tmp/gitkraken.deb

# Configurar Network Manager
RUN mkdir -p /var/run/dbus && \
    chown messagebus:messagebus /var/run/dbus && \
    dbus-uuidgen --ensure

# Configurar autostart do nm-applet
RUN mkdir -p /config/.config/autostart && \
    echo '[Desktop Entry]\nType=Application\nName=NetworkManager Applet\nExec=nm-applet --indicator\nComment=Manage network connections' > /config/.config/autostart/nm-applet.desktop

# Adicionar usuário aos grupos necessários
RUN usermod -aG netdev abc && \
    usermod -aG sudo abc

# Configurar npm global sem sudo
RUN mkdir -p /home/abc/.npm-global && \
    npm config set prefix '/home/abc/.npm-global' && \
    echo 'export PATH="/home/abc/.npm-global/bin:$PATH"' >> /home/abc/.bashrc

# Copiar script de inicialização para a pasta de init.d
COPY custom-init.sh /etc/cont-init.d/99-custom-init.sh
RUN chmod +x /etc/cont-init.d/99-custom-init.sh