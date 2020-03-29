#!/bin/bash
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

set -e

# Setup Script Variables
# _DEPENDENCIES="mercurial wget git flatpak flatpak-builder";
_DEPENDENCIES="wget git xvfb build-essential xz-utils curl python3 libjack-dev";
export DEBIAN_FRONTEND=noninteractive

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
apt-get -qq update;
apt-get -y -qq install $_DEPENDENCIES;

# Installs (non-ancient) clang
apt install -y software-properties-common apt-transport-https ca-certificates
apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
apt-get update
apt-get -y install clang-9 libclang-9-dev

# Installs (non-ancient) clang
curl -sL https://deb.nodesource.com/setup_13.x | bash -
apt-get install -y nodejs
