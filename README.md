# docker-coolq-alpine

[![Docker Compose](https://img.shields.io/github/workflow/status/thesnowfield/docker-coolq-alpine/Docker%20Compose)](#)
[![License](https://img.shields.io/github/license/thesnowfield/docker-coolq-alpine?color=blue)](https://github.com/TheSnowfield/docker-coolq-alpine/blob/master/LICENSE)
[![DockerPull](https://img.shields.io/docker/pulls/thesnowfield/coolq-alpine)](https://hub.docker.com/repository/docker/thesnowfield/coolq-alpine/general)

A lightweight coolq docker container based on Alpine Linux.

![Desktop](./images/desktop.png)

## Features
 - Simple way to deploy
 - Smaller image size and memory
 - Customized Openbox menu for CoolQ

## Get started
> **Hint:** Please make sure you have installed docker and docker-compose first.

> **Hint:** If you using docker-compose to build the image, You could set your own preferences _like access ports, CoolQ releases, persistent data locations_ by editing the `docker-compose.yml` file \_(:3) z)\_

### Using Docker Compose

```bash
  $ docker-compose build && \
    docker-compose up -d

  # Enjoy! (｡･∀･)ﾉﾞ
```

### Using Docker Image
```bash
  # Pull docker image
  $ docker pull thesnowfield/coolq-alpine:latest

  # run the image
  $ docker run \
    # container name
    --name coolq \
    # set display resolution to 960x544 24bit
    --env DISPLAY_RESOLUTION=960x544x24 \
    # save persistent data to ./cqdata
    --volume ./cqdata:/home/coolq/cqdata \
    # expose your vnc remote port at 2333
    --publish 2333:5900 \
    thesnowfield/coolq-alpine:latest

   # Enjoy! (｡･∀･)ﾉﾞ
```

## TODOs
- [ ] CoolQ reboot menu
- [ ] Fix remove CoolQ cache menu
- [ ] Chinese input built-in
- [ ] Replace x11vnc with noVNC
- [ ] Add vnc password support
- [x] Find the way to defaultly using original `winhttp.dll` for more compatible

## License
licensed under GPL-3.0 ❤
