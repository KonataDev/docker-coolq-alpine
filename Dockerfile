FROM i386/alpine:3.12
ARG COOLQ_VERSION

# docker image patch up
COPY docker_root /

# create user
RUN adduser -h /home/coolq/ -D coolq \
 # delete all .gitkeep
 && rm /home/coolq/.wine/drive_c/windows/.gitkeep \
 && rm /home/coolq/.cqdata/temp/.gitkeep \
 && rm /usr/share/wine/gecko/.gitkeep \
 && rm /usr/share/wine/mono/.gitkeep \
# fix wine permissions
 && cd /home/coolq/ \
 && chown -R coolq .wine/ \
# install all dependencies
 && apk update \
 && apk add --no-cache \
    xvfb x11vnc \
    wine winetricks zenity \
    curl openbox unzip rxvt-unicode nano htop \
# disable wget and force using curl
 && mv /usr/bin/wget /usr/bin/.wget \
# prepare coolq release
 && curl -L ${COOLQ_VERSION} --output .cqdata/temp/coolq.zip \
 && unzip .cqdata/temp/coolq.zip -d .cqdata/temp/ \
 && mv .cqdata/temp/*Air/* .cqdata/ 2>/dev/null || : \
 && mv .cqdata/temp/*Pro/* .cqdata/ 2>/dev/null || : \
 && rm -rf .cqdata/temp \
# prepare wine gecko
 && curl -L https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.tar.bz2 --output wine-gecko-2.47.1-x86.tar.bz2 \
 && tar xvf wine-gecko-2.47.1-x86.tar.bz2 -C /usr/share/wine/gecko/ \
 && rm wine-gecko-2.47.1-x86.tar.bz2 \
# prepare wine mono
 && curl -L https://dl.winehq.org/wine/wine-mono/5.1.0/wine-mono-5.1.0-x86.tar.xz --output wine-mono-5.1.0-x86.tar.xz \
 && tar xvf wine-mono-5.1.0-x86.tar.xz -C /usr/share/wine/mono/ \
 && rm wine-mono-5.1.0-x86.tar.xz \
# prepare fonts
 && ln -s .wine/drive_c/windows/Fonts .fonts \
# prepare entry file
 && chmod +x .docker-entry.sh \
# set owner
 && chown -R coolq /home/coolq/

# switch to new user
USER coolq

# Refresh font cache
RUN fc-cache -f -v \
# configure wine via winetricks
 && winetricks win7 \
 && winetricks msscript \
 && winetricks winhttp \
 && rm -rf .cache/winetricks 2>/dev/null || :

ENTRYPOINT ["/home/coolq/.docker-entry.sh"]
