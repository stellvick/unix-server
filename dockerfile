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
    gvfs \
    openjdk-21-jdk

RUN apt-get install -y libasound2t64 || apt-get install -y libasound2

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN wget -O /tmp/commandlinetools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    unzip /tmp/commandlinetools-linux.zip -d /opt/android-sdk/cmdline-tools && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    rm /tmp/commandlinetools-linux.zip

ENV JAVA_HOME /usr/lib/jvm/java-21-openjdk-amd64
ENV ANDROID_HOME /opt/android-sdk

RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

RUN wget -O /tmp/gitkraken.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb" && \
    dpkg -i /tmp/gitkraken.deb || apt-get install -f -y && \
    rm /tmp/gitkraken.deb

RUN wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" && \
    dpkg -i /tmp/vscode.deb || apt-get install -f -y && \
    rm /tmp/vscode.deb

RUN wget -O /tmp/postman.deb "https://dl.pstmn.io/download/latest/linux64" && \
    dpkg -i /tmp/postman.deb || apt-get install -f -y && \
    rm /tmp/postman.deb

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
    cp /usr/share/applications/nm-connection-editor.desktop /config/Desktop/

RUN which nm-connection-editor || echo "nm-connection-editor not found!" && \
    ln -s /usr/bin/nm-connection-editor /usr/local/bin/nm-connection-editor