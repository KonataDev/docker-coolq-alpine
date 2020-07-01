#!/bin/ash

export DISPLAY=:0 \
       LANG=zh_CN.UTF-8 \
       LC_ALL=zh_CN.UTF-8 \
       TZ=Asia/Shanghai \
       CQ_ROOT=~/cqdata \
       CQ_DATA=~/cqdata/data \
       CQ_APP=~/cqdata/app \
       CQ_CONF=~/cqdata/conf

# start Xvfb and VNC
rm /tmp/.X0-lock 2>/dev/null || :
Xvfb :0 -screen 0 $DISPLAY_RESOLUTION \
  & x11vnc -display :0 -forever -bg

# is first running
if [ -d "/home/coolq/cqdata/" ] && [ -z "$(ls -A /home/coolq/cqdata/)" ]; then
  # copy templary folder
  cp -r ~/.cqdata/* ~/cqdata
fi

# merge reg files
# I tried winetricks verb or wine command in the dockerfile but both failed
# winetricks only can change the value, delete or append will fail :think:
# so...maybe it's a bug from winetricks?
wine regedit ~/.wine/cq_winhttp.reg
wine regedit ~/.wine/cq_msscript.reg

sleep 2

# start CoolQ
wine $CQ_ROOT/CQ*.exe

# start Openbox session
/usr/bin/openbox-session
