FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Instalar pacotes VPN
RUN apt-get update && \
    apt-get install -y \
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
    ca-certificates

# Instalar GitKraken
RUN wget -O /tmp/gitkraken.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb" && \
    dpkg -i /tmp/gitkraken.deb || apt-get install -f -y && \
    rm /tmp/gitkraken.deb

# Configurar Network Manager
RUN mkdir -p /var/run/dbus && \
    chown messagebus:messagebus /var/run/dbus && \
    dbus-uuidgen --ensure

# Configurar autostart
RUN mkdir -p /config/.config/autostart && \
    echo '[Desktop Entry]\nType=Application\nName=NetworkManager Applet\nExec=nm-applet --indicator\nComment=Manage network connections' > /config/.config/autostart/nm-applet.desktop

# Copiar e configurar script de inicialização
COPY custom-init.sh /custom-init.sh
RUN chmod +x /custom-init.sh

# Fixar permissões
RUN usermod -aG netdev abc

# Definir entrypoint personalizado
ENTRYPOINT ["/custom-init.sh"]