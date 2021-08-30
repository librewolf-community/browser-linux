#!/bin/bash
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

set -e

# debuggery

printf '----- dbg: env'
env
printf '----- /dbg: env'

# Setup Script Variables
_DEPENDENCIES="wget git xvfb \
 xz-utils \
 gettext-base \
 curl python3 libjack-dev \
 python3-psutil python-psutil python3-dev python-dev \
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
        cargo \
        rustc \
        nasm-mozilla"

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
    apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-12 main"
    apt-get update
    apt-get -y install clang-12 libclang-12-dev
else
    apt install -y software-properties-common apt-transport-https ca-certificates
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
    apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main"
    apt-get update
    apt-get -y install clang-10 libclang-10-dev
fi

# we need a more recent rust
# curl https://sh.rustup.rs -o rustup.sh
# bash rustup.sh -y
# source /root/.cargo/env
