#!/bin/ash

rm /tmp/.X0-lock

export DISPLAY=:0 \
       LANG=zh_CN.UTF-8 \
       LC_ALL=zh_CN.UTF-8 \
       TZ=Asia/Shanghai

Xvfb :0 -screen 0 $DISPLAY_RESOLUTION \
  & x11vnc -display :0 -forever -bg

sleep 2

/usr/bin/openbox-session \
 & wine ~/.wine/drive_c/CQRelease/CQ*.exe
