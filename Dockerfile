FROM i386/alpine:3.12
ARG COOLQ_VERSION

# prepare repositories
RUN rm /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

# install all dependencies
RUN apk add --no-cache xvfb x11vnc wine wine_gecko winetricks curl openbox unzip xterm zenity nano htop

# disable wget and force using curl
RUN mv /usr/bin/wget /usr/bin/.wget

# create user
RUN adduser -h /home/coolq/ -D coolq

# prepare coolq release
WORKDIR /home/coolq/.wine/drive_c/
RUN curl -L ${COOLQ_VERSION} --output coolq.zip \
 && unzip coolq.zip
RUN mv *Air CQRelease 2>/dev/null; exit 0
RUN mv *Pro CQRelease 2>/dev/null; exit 0

RUN rm coolq.zip \
 && rm *.url \
 && rm !*

# prepare fonts
WORKDIR /home/coolq/.fonts
RUN mkdir -p .wine/drive_c/windows/
COPY fonts/* ./
RUN ln -s .wine/drive_c/windows/Fonts .fonts

# prepare openbox menu
WORKDIR /etc/xdg/openbox
RUN rm menu.xml
COPY configs/openbox/menu.xml ./

# prepare entry file
WORKDIR /home/coolq/
COPY docker-entry.sh ./docker-entry.sh
RUN chmod +x ./docker-entry.sh

# set owner
RUN chown -R coolq:coolq /home/coolq/

USER coolq
WORKDIR /home/coolq/
RUN fc-cache -f -v

# configure wine via winetricks
RUN winetricks -q win7
RUN winetricks -q msscript
RUN winetricks -q winhttp
#RUN winetricks gdiplus

RUN rm -rf .cache/winetricks/*

ENTRYPOINT ["./docker-entry.sh"]
