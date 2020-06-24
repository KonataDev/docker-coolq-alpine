#!/bin/ash

rm /tmp/.X0-lock

Xvfb :0 -screen 0 960x544x24 \
  & x11vnc -display :0 -forever -bg

sleep 2

DISPLAY=:0 /usr/bin/openbox-session \
 & DISPLAY=:0 wine ~/.wine/drive_c/CQAir/CQA.exe
