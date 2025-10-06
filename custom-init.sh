#!/bin/bash

service dbus start
service NetworkManager start

export HOME=/home/abc
export XDG_RUNTIME_DIR=/tmp/runtime-abc
mkdir -p $XDG_RUNTIME_DIR
chown abc:abc $XDG_RUNTIME_DIR

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=/opt/android-sdk
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/27.1.12297006

sudo -u abc dbus-launch /usr/bin/nm-applet --indicator &

sudo npm i -g eas-cli

chown abc:abc /config/Desktop/*.desktop
chmod +x /config/Desktop/*.desktop

chown abc:abc $ANDROID_HOME
chmod +x $ANDROID_HOME

exec /init "$@"