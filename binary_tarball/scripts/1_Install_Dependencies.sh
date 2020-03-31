#!/bin/bash
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

set -e

# Setup Script Variables
# _DEPENDENCIES="mercurial wget git flatpak flatpak-builder";
_DEPENDENCIES="wget git xvfb \
 xz-utils \
 curl python3 libjack-dev \
        autotools-dev \
        autoconf2.13 \
        zip \
        libx11-dev \
        libx11-xcb-dev \
        libxt-dev \
        libxext-dev \
        libgtk2.0-dev  \
        libgtk-3-dev  \
        libglib2.0-dev  \
        libpango1.0-dev  \
        libfontconfig1-dev \
        libfreetype6-dev  \
        libstartup-notification0-dev \
        libasound2-dev \
        libcurl4-openssl-dev \
        libdbus-glib-1-dev \
        hardening-wrapper \
        lsb-release \
        libiw-dev \
        mesa-common-dev \
        libnotify-dev \
        libxrender-dev \
        libpulse-dev \
        yasm \
        unzip \
        dbus-x11 \
        python \
        cargo \
        rustc \
        nodejs-mozilla \
        nasm-mozilla \
        gcc-mozilla"

export DEBIAN_FRONTEND=noninteractive

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
apt-get -qq update;
apt-get -y -qq install $_DEPENDENCIES;

if [[ $CARCH == 'x86_64' ]];then
    # Installs (non-ancient) clang
    apt install -y software-properties-common apt-transport-https ca-certificates
    apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
    apt-get update
    apt-get -y install clang-9 libclang-9-dev
else
    apt-get -y install clang-8 libclang-8-dev
fi
