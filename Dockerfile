FROM i386/alpine:3.12
ARG COOLQ_VERSION

# docker image patch up
COPY docker_root /

# create user
RUN cd /home/coolq/ \
 && adduser -h /home/coolq/ -D coolq \
# fix permissions
 && chown -R coolq .wine/ \
 && chmod -R 777 .wine/ \
# install all dependencies
 && apk update \
 && apk add --no-cache \
    xvfb x11vnc \
    wine winetricks \
    curl openbox unzip rxvt-unicode nano htop \
# disable wget and force using curl
 && mv /usr/bin/wget /usr/bin/.wget \
# prepare coolq release
 && curl -L ${COOLQ_VERSION} --output cqdata/temp/coolq.zip \
 && unzip cqdata/temp/coolq.zip -d cqdata/temp/ \
 && mv cqdata/temp/*Air/* cqdata/temp/ 2>/dev/null; exit 0 \
 && mv cqdata/temp/*Pro/* cqdata/temp/ 2>/dev/null; exit 0 \
 && rm -rf cqdata/temp \
# prepare fonts
 && ln -s .wine/drive_c/windows/Fonts .fonts \
# prepare entry file
 && chmod +x docker-entry.sh \
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
 && rm -rf .cache/winetricks

ENTRYPOINT ["/home/coolq/docker-entry.sh"]
