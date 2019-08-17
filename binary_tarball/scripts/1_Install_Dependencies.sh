#!/bin/sh
printf "\n\n-------------------------------------- DEPENDENCY INSTALLATION ---------------------------------------------\n";

# Setup Script Variables
_DEPENDENCIES="mercurial wget git";

# Installs Dependencies
printf "\nInstalling dependencies: $_DEPENDENCIES\n";
apt-get -qq update;
apt-get -qq install -y $_DEPENDENCIES;
