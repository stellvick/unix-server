FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Adicionar repositório multiverse para pacotes adicionais
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository multiverse

# Instalar dependências do sistema
RUN apt-get update && \
    apt-get install -y \
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
    gnome-keyring \
    policykit-1-gnome \
    xfce4-notifyd \
    xfce4-pulseaudio-plugin \
    libnss3 \
    libnss3-tools \
    gir1.2-appindicator3-0.1 \
    wget \
    dbus \
    dbus-x11 \
    sudo \
    libgtk-3-0 \
    libx11-xcb1 \
    libxss1 \
    libasound2 \
    libgbm1 \
    libreoffice \
    remmina \
    remmina-plugin-rdp \
    remmina-plugin-vnc \
    proot \
    gvfs

# Instalar Node.js via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Instalar GitKraken
RUN wget -O /tmp/gitkraken.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb" && \
    dpkg -i /tmp/gitkraken.deb || apt-get install -f -y && \
    rm /tmp/gitkraken.deb

# Instalar VS Code (usando .deb oficial)
RUN wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" && \
    dpkg -i /tmp/vscode.deb || apt-get install -f -y && \
    rm /tmp/vscode.deb

# Instalar Postman (usando .deb oficial)
RUN wget -O /tmp/postman.deb "https://dl.pstmn.io/download/latest/linux64" && \
    dpkg -i /tmp/postman.deb || apt-get install -f -y && \
    rm /tmp/postman.deb

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

# Criar ícones para o menu
RUN mkdir -p /usr/share/applications/

# Ícone do GitKraken
RUN cat > /usr/share/applications/gitkraken.desktop <<EOL
[Desktop Entry]
Name=GitKraken
Exec=/usr/bin/gitkraken
Icon=/opt/gitkraken/resources/app.asar.unpacked/src/static/linux/gitkraken.png
Terminal=false
Type=Application
Categories=Development;
EOL

# Ícone do VS Code
RUN cat > /usr/share/applications/code.desktop <<EOL
[Desktop Entry]
Name=VS Code
Exec=/usr/share/code/code
Icon=/usr/share/pixmaps/com.visualstudio.code.png
Terminal=false
Type=Application
Categories=Development;
EOL

# Ícone do Postman
RUN cat > /usr/share/applications/postman.desktop <<EOL
[Desktop Entry]
Name=Postman
Exec=/usr/bin/postman
Icon=/usr/share/postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

# Ícone do LibreOffice Writer
RUN cat > /usr/share/applications/libreoffice-writer.desktop <<EOL
[Desktop Entry]
Name=LibreOffice Writer
Exec=libreoffice --writer
Icon=libreoffice-writer
Terminal=false
Type=Application
Categories=Office;
EOL

# Ícone do Remmina
RUN cat > /usr/share/applications/remmina.desktop <<EOL
[Desktop Entry]
Name=Remmina
Exec=remmina
Icon=remmina
Terminal=false
Type=Application
Categories=Network;
EOL

# Ícone para configurar VPN
RUN cat > /usr/share/applications/nm-connection-editor.desktop <<EOL
[Desktop Entry]
Name=Network Connections
Exec=nm-connection-editor
Icon=nm-device-wireless
Terminal=false
Type=Application
Categories=System;
EOL

# Criar atalhos na área de trabalho
RUN mkdir -p /config/Desktop && \
    cp /usr/share/applications/gitkraken.desktop /config/Desktop/ && \
    cp /usr/share/applications/code.desktop /config/Desktop/ && \
    cp /usr/share/applications/postman.desktop /config/Desktop/ && \
    cp /usr/share/applications/nm-connection-editor.desktop /config/Desktop/