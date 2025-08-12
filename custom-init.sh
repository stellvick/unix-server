#!/bin/bash

# Iniciar serviços críticos
service dbus start
service NetworkManager start

# Iniciar NM Applet
nm-applet --indicator &

# Iniciar o processo principal do Webtop
exec /init "$@"