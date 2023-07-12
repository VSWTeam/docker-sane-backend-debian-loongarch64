FROM multiarch/qemu-user-static:x86_64-loongarch64 as qemu
FROM cr.loongnix.cn/library/debian:buster-slim
COPY --from=qemu /usr/bin/qemu-loongarch64-static /usr/bin

RUN apt update \
    && apt install -y libusb-1.0-0-dev build-essential libsane-dev \
	&& apt install -y libavahi-client-dev libavahi-glib-dev \
	&& apt install -y git-core openssh-server \
	&& apt install -y autoconf libtool \
	&& apt install -y python3-pip python3-setuptools \
	&& apt install -y lftp \
	&& rm -rf /var/lib/apt/lists/*

# Compile SANE Backend.
RUN cd root \
	&& git clone https://gitlab.com/sane-project/backends.git sane-backends \
	&& cd sane-backends \
	&& git checkout RELEASE_1_0_27 \
    && rm -rf .git \
	&& ./configure --build=loongarch64-unknown-linux-gnu --prefix=/usr --libdir=/usr/lib/loongarch64-linux-gnu --sysconfdir=/etc --localstatedir=/var  --enable-avahi BACKENDS="kodakaio test" \
	&& make

# Create a symbolic link for backend develop.
RUN cd /root/sane-backends/backend \
	&& mkdir project \
	&& ln -s /root/sane-backends/backend/project /root/project

# Enable remote debugging
RUN set -eu; \
    mkdir /var/run/sshd; \
    echo 'root:root' | chpasswd; \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;

# 22 for ssh server
EXPOSE 22

# Support Conan package
RUN set -eux; \
    $(which python3); \
    ln -sf $(which python3) /usr/bin/python; \
    ln -sf $(which pip3) /usr/bin/pip;

RUN pip config set global.extra-index-url https://pypi.org/simple \
    && pip config set global.index-url https://pypi.org/simple \
    && pip install --force-reinstall -v "conan==1.47.0" \
    && conan profile new default --detect \
    && conan profile update settings.arch=mips default

# Set environment variables.
ENV HOME /root

VOLUME "/root/project"

# Define working directory.
WORKDIR "/root/project"

CMD bash
