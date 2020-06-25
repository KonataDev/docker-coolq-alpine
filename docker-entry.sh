#!/bin/ash

export DISPLAY=:0 \
       LANG=zh_CN.UTF-8 \
       LC_ALL=zh_CN.UTF-8 \
       TZ=Asia/Shanghai \
       CQ_ROOT=~/.wine/drive_c/CQRelease \
       CQ_DATA=~/.wine/drive_c/CQRelease/data \
       CQ_APP=~/.wine/drive_c/CQRelease/app

# Start Xvfb and VNC
rm /tmp/.X0-lock
Xvfb :0 -screen 0 $DISPLAY_RESOLUTION \
  & x11vnc -display :0 -forever -bg

sleep 2

# Install vcruntimes
winetricks -q vcrun2008
winetricks -q vcrun2010
winetricks -q vcrun2012
winetricks -q vcrun2013
winetricks -q vcrun2019

# Start CoolQ
wine $CQ_ROOT/CQ*.exe

# Start Openbox session
/usr/bin/openbox-session
