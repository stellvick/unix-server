#!/bin/bash

# Iniciar serviços críticos
service dbus start
service NetworkManager start

# Configurar ambiente para o usuário abc
export HOME=/home/abc
export XDG_RUNTIME_DIR=/tmp/runtime-abc
mkdir -p $XDG_RUNTIME_DIR
chown abc:abc $XDG_RUNTIME_DIR

# Iniciar NM Applet como usuário abc
sudo -u abc dbus-launch nm-applet --indicator &

# Configurar permissões para ícones na área de trabalho
chown abc:abc /config/Desktop/*.desktop
chmod +x /config/Desktop/*.desktop

# Iniciar o processo principal do Webtop
exec /init "$@"