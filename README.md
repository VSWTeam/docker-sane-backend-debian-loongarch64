# SANE Backend (with libusb1.0) build environment (Debian) Dockerfile

## Base Docker Image

* [aoqi/debian-mips64el](https://hub.docker.com/r/aoqi/debian-mips64el)

## Build

```bash
docker build --rm -t "vswteam/sane-backend-debian-mips64el" .
```

## Download

```bash
docker pull vswteam/sane-backend-debian-mips64el
```

## Usage

```bash
docker run -it -v <sane-backend-volume>:/root/project vswteam/sane-backend-debian-mips64el /bin/bash
```
