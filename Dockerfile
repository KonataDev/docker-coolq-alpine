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
RUN apk add --no-cache xvfb x11vnc wine wine_gecko winetricks curl openbox zip

# disable wget and force using curl
RUN mv /usr/bin/wget /usr/bin/.wget

# create user
RUN adduser -h /home/coolq/ -D coolq

# prepare entry file
WORKDIR /home/coolq/
COPY docker-entry.sh ./docker-entry.sh
RUN chmod +x ./docker-entry.sh

# prepare coolqair
WORKDIR /home/coolq/.wine/drive_c/
COPY cqair.zip cqair.zip
RUN unzip cqair.zip

# prepare fonts
WORKDIR /home/coolq/.wine/drive_c/windows/Fonts/
COPY simsun.ttf simsun.ttf

# set owner
WORKDIR /home/coolq/
RUN chown -R coolq ./

# configure wine via winetricks
# RUN winetricks win7
# RUN winetricks msscript
# RUN winetricks winhttp
# RUN DISPLAY=:0 winetricks vcrun2008 /q
# RUN DISPLAY=:0 winetricks vcrun2010 /q /norestart
# RUN DISPLAY=:0 winetricks vcrun2012 /q /norestart
# RUN DISPLAY=:0 winetricks vcrun2013 /install /quiet
# RUN DISPLAY=:0 winetricks vcrun2015 /install /quiet
# RUN rm -rf ./.cache/winetricks/*

USER coolq

ENV DISPLAY=:0 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai

ENTRYPOINT ["./docker-entry.sh"]
