#!/bin/bash
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

set -e

# Setup Script Variables
_DEPENDENCIES="wget git xvfb \
 xz-utils \
 gettext-base \
 curl python3 libjack-dev \
 python3-dev python-dev \
        gnupg \
        autotools-dev \
        autoconf2.13 \
        zip \
        libx11-dev \
        libx11-xcb-dev \
        libxt-dev \
        libxext-dev \
        libgtk-3-dev  \
        libglib2.0-dev  \
        libpango1.0-dev  \
        libfontconfig1-dev \
        libfreetype6-dev  \
        libstartup-notification0-dev \
        libasound2-dev \
        libcurl4-openssl-dev \
        libdbus-glib-1-dev \
        lsb-release \
        libiw-dev \
        mesa-common-dev \
        libnotify-dev \
        libxrender-dev \
        libpulse-dev \
        libssl-dev \
        yasm \
        unzip \
        dbus-x11 \
        python \
        libffi-dev \
        nodejs-mozilla \
        nasm-mozilla \
        locales"

        # cargo \
        # rustc \

export DEBIAN_FRONTEND=noninteractive

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
apt-get -qq update;
apt-get -y -qq install $_DEPENDENCIES;

if [[ $CARCH == 'x86_64' ]];then
    # Installs (non-ancient) clang
    apt install -y software-properties-common apt-transport-https ca-certificates
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
    apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-13 main"
    apt-get update
    apt-get -y install clang-13 libclang-13-dev
else
    # seems like we can use 13 here as well, finally?
    apt install -y software-properties-common apt-transport-https ca-certificates
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
    apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-13 main"
    apt-get update
    apt-get -y install clang-13 libclang-13-dev
fi

# avoid python parsing files as ascii instead of utf8 and complaining
locale-gen en_US.UTF-8

# we need a more recent rust
# …to test if a fix in 1.57 magically fixes aarch64 hanging
curl https://sh.rustup.rs -o rustup.sh
bash rustup.sh -y
source /root/.cargo/env
