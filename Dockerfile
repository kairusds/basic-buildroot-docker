FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && \
    apt install -y \
        sudo \
        wget \
        nano \
        g++ \
        make \
        libncurses-dev \
        unzip \
        bc \
        bzip2 \
        libelf-dev \
        libssl-dev \
        file \
        cpio \
        rsync \
        dosfstools \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -aG sudo ubuntu && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/90-nopasswd && \
    mkdir /build && \
    chown ubuntu:ubuntu /build

WORKDIR /build

USER ubuntu

# 2025.02.x is the current LTS, check buildroot's download page to change this accordingly https://buildroot.org/download.html
RUN set -xe && \
    LTS_TAG=$(git ls-remote --tags https://gitlab.com/buildroot.org/buildroot.git | grep -E 'refs/tags/2025\.02\.[0-9]+$' | sed 's/.*refs\/tags\///' | sort -rV | head -n 1); \
    if [ -z "$LTS_TAG" ]; then echo "Target LTS tag not found!" && exit 1; fi; \
    wget -q "https://buildroot.org/downloads/buildroot-${LTS_TAG}.tar.gz" -O buildroot-lts.tar.gz && \
    mkdir -p /build/buildroot && \
    tar xzf buildroot-lts.tar.gz --strip-components=1 -C /build/buildroot && \
    rm buildroot-lts.tar.gz

WORKDIR /build/buildroot

CMD ["/bin/bash"]
