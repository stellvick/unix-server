FROM lscr.io/linuxserver/webtop:ubuntu-xfce

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    add-apt-repository multiverse && \
    apt-get update

RUN apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    build-essential \
    libc6-dev \
    python3 \
    python3-pip \
    python3-venv \
    network-manager \
    openvpn \
    network-manager-openvpn \
    network-manager-openvpn-gnome \
    network-manager-gnome \
    gnome-keyring \
    policykit-1-gnome \
    xfce4-notifyd \
    xfce4-pulseaudio-plugin \
    libnss3 \
    libnss3-tools \
    gir1.2-appindicator3-0.1 \
    wget \
    unzip \
    dbus \
    dbus-x11 \
    sudo \
    libgtk-3-0 \
    libx11-xcb1 \
    libxss1 \
    libgbm1 \
    libreoffice \
    remmina \
    remmina-plugin-rdp \
    remmina-plugin-vnc \
    proot \
    gvfs

RUN apt-get install -y libasound2t64 || apt-get install -y libasound2

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN wget -O /tmp/gitkraken.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb" && \
    dpkg -i /tmp/gitkraken.deb || apt-get install -f -y && \
    rm /tmp/gitkraken.deb

RUN wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" && \
    dpkg -i /tmp/vscode.deb || apt-get install -f -y && \
    rm /tmp/vscode.deb

RUN wget -O /tmp/postman.deb "https://dl.pstmn.io/download/latest/linux64" && \
    dpkg -i /tmp/postman.deb || apt-get install -f -y && \
    rm /tmp/postman.deb

RUN wget -O /tmp/pycharm.tar.gz "https://download.jetbrains.com/python/pycharm-2025.2.4.tar.gz?_gl=1*rx0evi*_gcl_au*NzY0ODQ4OTUzLjE3NjQwMTM2Nzg.*FPAU*NzY0ODQ4OTUzLjE3NjQwMTM2Nzg.*_ga*ODA1NDU3NjYuMTc2NDAxMzY3OA..*_ga_9J976DJZ68*czE3NjQwMTM2NzYkbzEkZzEkdDE3NjQwMTM3NTUkajYwJGwwJGgw" && \
    tar -xzf /tmp/pycharm.tar.gz -C /opt/ && \
    rm /tmp/pycharm.tar.gz

RUN mkdir -p /var/run/dbus && \
    chown messagebus:messagebus /var/run/dbus && \
    dbus-uuidgen --ensure

RUN mkdir -p /config/.config/autostart && \
    echo '[Desktop Entry]\nType=Application\nName=NetworkManager Applet\nExec=nm-applet --indicator\nComment=Manage network connections' > /config/.config/autostart/nm-applet.desktop

RUN usermod -aG netdev abc && \
    usermod -aG sudo abc

RUN mkdir -p /home/abc/.npm-global && \
    npm config set prefix '/home/abc/.npm-global' && \
    echo 'export PATH="/home/abc/.npm-global/bin:$PATH"' >> /home/abc/.bashrc

COPY custom-init.sh /etc/cont-init.d/99-custom-init.sh
RUN chmod +x /etc/cont-init.d/99-custom-init.sh

RUN mkdir -p /usr/share/applications/

RUN cat > /usr/share/applications/gitkraken.desktop <<EOL
[Desktop Entry]
Name=GitKraken
Exec=/usr/bin/gitkraken
Icon=/opt/gitkraken/resources/app.asar.unpacked/src/static/linux/gitkraken.png
Terminal=false
Type=Application
Categories=Development;
EOL

RUN cat > /usr/share/applications/code.desktop <<EOL
[Desktop Entry]
Name=VS Code
Exec=/usr/share/code/code
Icon=/usr/share/pixmaps/com.visualstudio.code.png
Terminal=false
Type=Application
Categories=Development;
EOL

RUN cat > /usr/share/applications/postman.desktop <<EOL
[Desktop Entry]
Name=Postman
Exec=/usr/bin/postman
Icon=/usr/share/postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

RUN cat > /usr/share/applications/pycharm.desktop <<EOL
[Desktop Entry]
Name=PyCharm
Exec=/opt/pycharm-community-2023.3.4/bin/pycharm.sh
Icon=/opt/pycharm-community-2023.3.4/bin/pycharm.png
Terminal=false
Type=Application
Categories=Development;
EOL

RUN cat > /usr/share/applications/libreoffice-writer.desktop <<EOL
[Desktop Entry]
Name=LibreOffice Writer
Exec=libreoffice --writer
Icon=libreoffice-writer
Terminal=false
Type=Application
Categories=Office;
EOL

RUN cat > /usr/share/applications/remmina.desktop <<EOL
[Desktop Entry]
Name=Remmina
Exec=remmina
Icon=remmina
Terminal=false
Type=Application
Categories=Network;
EOL

RUN cat > /usr/share/applications/nm-connection-editor.desktop <<EOL
[Desktop Entry]
Name=Network Connections
Exec=/usr/bin/nm-connection-editor
Icon=nm-device-wireless
Terminal=false
Type=Application
Categories=System;
EOL

RUN mkdir -p /config/Desktop && \
    cp /usr/share/applications/gitkraken.desktop /config/Desktop/ && \
    cp /usr/share/applications/code.desktop /config/Desktop/ && \
    cp /usr/share/applications/postman.desktop /config/Desktop/ && \
    cp /usr/share/applications/pycharm.desktop /config/Desktop/ && \
    cp /usr/share/applications/nm-connection-editor.desktop /config/Desktop/

RUN which nm-connection-editor || echo "nm-connection-editor not found!" && \
    ln -s /usr/bin/nm-connection-editor /usr/local/bin/nm-connection-editor