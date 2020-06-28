#!/bin/ash

export DISPLAY=:0 \
       LANG=zh_CN.UTF-8 \
       LC_ALL=zh_CN.UTF-8 \
       TZ=Asia/Shanghai \
       CQ_ROOT=~/cqdata \
       CQ_DATA=~/cqdata/data \
       CQ_APP=~/cqdata/app \
       CQ_CONF=~/cqdata/conf


# Start Xvfb and VNC
rm /tmp/.X0-lock
Xvfb :0 -screen 0 $DISPLAY_RESOLUTION \
  & x11vnc -display :0 -forever -bg

# Is first running
if [ -d "/home/coolq/.cqdata" ]
then
  # Delete another release if exists
  rm ~/cqdata/CQ*.exe || :

  # Move templary folder
  mv ~/.cqdata/* ~/cqdata
  rm -r ~/.cqdata
fi

sleep 2

# Start CoolQ
wine $CQ_ROOT/CQ*.exe

# Start Openbox session
/usr/bin/openbox-session
