FROM alpine:3.12

# prepare repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
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

# configure wine via winetricks
RUN winetricks -q win7
RUN winetricks -q msscript
RUN winetricks -q winhttp

# start vnc service
ENV DISPLAY=:0 \
    DISPLAY_INDEX=0\
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

RUN Xvfb $DISPLAY -screen $DISPLAY_INDEX $DISPLAY_RESOLUTION \
  & x11vnc -display $DISPLAY -forever -bg \
  & sleep 5 \
  & /usr/bin/openbox-session



