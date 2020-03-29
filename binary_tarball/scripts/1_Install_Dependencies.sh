#!/bin/bash
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

set -e

# Setup Script Variables
# _DEPENDENCIES="mercurial wget git flatpak flatpak-builder";
_DEPENDENCIES="wget git xvfb build-essential xz-utils curl python3";

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
DEBIAN_FRONTEND=noninteractive apt-get -qq update;
DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $_DEPENDENCIES;

# Installs (non-ancient) clang

DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main"
DEBIAN_FRONTEND=noninteractive wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install clang-9
