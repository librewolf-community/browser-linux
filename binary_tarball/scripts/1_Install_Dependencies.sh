#!/bin/sh
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

# Setup Script Variables
_DEPENDENCIES="mercurial wget git flatpak flatpak-builder";

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
DEBIAN_FRONTEND=noninteractive apt-get -qq update;
DEBIAN_FRONTEND=noninteractive apt-get -y -qq install $_DEPENDENCIES;
