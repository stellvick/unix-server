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

# Iniciar NM Applet como usuário abc
sudo -u abc dbus-launch /usr/bin/nm-applet --indicator &

# Configurar permissões para ícones na área de trabalho
chown abc:abc /config/Desktop/*.desktop
chmod +x /config/Desktop/*.desktop

# Iniciar o processo principal do Webtop
exec /init "$@"