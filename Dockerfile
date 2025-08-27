FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash","-eo","pipefail","-c"]

# UTF-8 minimal
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Setup ARM
    qemu-user \
    gdb-multiarch \
    libc6-armhf-cross \
    gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf \
    
    # Classic tools
    python3 python3-pip \
    vim \
    file git build-essential \
    ltrace strace \
    socat curl unzip netcat-openbsd \
    tmux patchelf \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/ld-linux.so.3
ENV LD_LIBRARY_PATH=/usr/arm-linux-gnueabihf/lib

# Pwn setup
RUN pip3 install --no-cache-dir pwntools
RUN curl -fsSL https://gef.blah.cat/sh | sh
RUN echo "source ~/.gef.rc" >> /root/.gdbinit

# Root-me structure
RUN mkdir -p /lib/arm/2.27/lib \
    && cp /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/arm/2.27/lib/ld-linux.so.3 \
    && cp -r /usr/arm-linux-gnueabihf/lib/* /lib/arm/2.27/lib/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
