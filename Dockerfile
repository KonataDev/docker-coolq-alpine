FROM i386/alpine:3.12
ARG COOLQ_VERSION

# docker image patch up
COPY docker_root /

# create user
RUN cd /home/coolq/ \
 && adduser -h /home/coolq/ -D coolq \
# install all dependencies
 && apk update \
 && apk add --no-cache \
    xvfb x11vnc \
    wine winetricks \
    curl openbox unzip rxvt-unicode nano htop \
# disable wget and force using curl
 && mv /usr/bin/wget /usr/bin/.wget \
# prepare coolq release
 && curl -L ${COOLQ_VERSION} --output .wine/drive_c/CQRelease/temp/coolq.zip \
 && unzip .wine/drive_c/CQRelease/temp/coolq.zip -d .wine/drive_c/CQRelease/temp/ \
 && mv .wine/drive_c/CQRelease/temp/*Air/* .wine/drive_c/CQRelease/ 2>/dev/null; exit 0 \
 && mv .wine/drive_c/CQRelease/temp/*Pro/* .wine/drive_c/CQRelease/ 2>/dev/null; exit 0 \
 && rm -rf .wine/drive_c/CQRelease/temp \
# prepare fonts
 && ln -s .wine/drive_c/windows/Fonts .fonts \
# prepare entry file
 && chmod +x docker-entry.sh \
# set owner
 && chown -R coolq:coolq /home/coolq/

USER coolq

# Refresh font cache
RUN fc-cache -f -v \
# configure wine via winetricks
 && winetricks win7 \
 && winetricks msscript \
 && winetricks winhttp \
 && rm -rf .cache/winetricks

ENTRYPOINT ["/home/coolq/docker-entry.sh"]
