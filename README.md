# SANE Backend (with libusb1.0) build environment (Debian) Dockerfile

## Base Docker Image

* cr.loongnix.cn/library/debian:buster-slim

## Build

```bash
docker build --rm -t "vswteam/sane-backend-debian-loongarch64" .
```

## Download

```bash
docker pull vswteam/sane-backend-debian-loongarch64
```

## Usage

```bash
docker run -it -v <sane-backend-volume>:/root/project vswteam/sane-backend-debian-loongarch64 /bin/bash
```
