FROM i386/alpine:3.12

# prepare repositories
RUN rm /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

# install all dependencies
RUN apk add --no-cache xvfb x11vnc wine wine_gecko winetricks curl openbox

# disable wget and force using curl
RUN mv /usr/bin/wget /usr/bin/.wget

# create user and switch to low authority
RUN adduser -h /home/coolq/ -D coolq
USER coolq
WORKDIR /home/coolq/

ENV DISPLAY=:0 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

# configure wine via winetricks
RUN winetricks win7
RUN winetricks msscript
RUN winetricks winhttp

# start vnc service
RUN Xvfb :0 -screen 0 960x544x24 \
  & x11vnc -display :0 -forever -bg

RUN winetricks vcrun2008 /q
RUN winetricks vcrun2010 /q /norestart
RUN winetricks vcrun2012 /q /norestart
RUN winetricks vcrun2013 /install /quiet
RUN winetricks vcrun2015 /install /quiet
RUN rm -rf /home/coolq/.cache/winetricks/*

#& sleep 5 \
#& /usr/bin/openbox-session
