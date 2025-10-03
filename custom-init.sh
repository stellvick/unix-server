#!/bin/bash

# Iniciar serviços críticos
service dbus start
service NetworkManager start

# Configurar ambiente para o usuário abc
export HOME=/home/abc
export XDG_RUNTIME_DIR=/tmp/runtime-abc
mkdir -p $XDG_RUNTIME_DIR
chown abc:abc $XDG_RUNTIME_DIR

# Adicionar caminhos importantes ao PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

# Configurar JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

# Configurar ANDROID_HOME
export ANDROID_HOME=/opt/android-sdk
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Iniciar NM Applet como usuário abc
sudo -u abc dbus-launch /usr/bin/nm-applet --indicator &

sudo npm i -g eas-cli

sudo sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"

# Configurar permissões para ícones na área de trabalho
chown abc:abc /config/Desktop/*.desktop
chmod +x /config/Desktop/*.desktop

# Iniciar o processo principal do Webtop
exec /init "$@"